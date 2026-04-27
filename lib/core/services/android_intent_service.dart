// Android URL-scheme + file-association bridge.
//
// Mirrors the macOS pattern in `AppDelegate.swift` (kAEGetURL +
// `application(_:open:)`). The native side
// (`android/app/src/main/kotlin/.../MainActivity.kt`) registers a method
// channel `de.kiefer_networks.sshvault/intent` and forwards every
// VIEW-intent URI through `openUrl(uriString)`. URLs delivered before
// the Flutter engine had a chance to wire the channel (cold launch via
// "Open With…" or a tapped ssh:// link) are buffered on the Kotlin side
// and replayed once `configureFlutterEngine` finishes.
//
// On the Dart side the service classifies each incoming URI into one of
// three buckets:
//
//   1. `ssh://` / `sftp://` — handed to [SshUrlHandler] which already
//      handles match-existing-server vs quick-connect-form.
//   2. `content://` / `file://` pointing at .pub / .pem / .ppk —
//      resolved through the Kotlin `resolveContentUri` method (so no
//      READ_EXTERNAL_STORAGE permission is needed) and routed through
//      [FileDropService.handleDroppedPaths] which already knows how to
//      classify SSH key / vault-export / ssh_config blobs.
//   3. `content://` / `file://` pointing at vault-export JSON — routed
//      to `/settings/export` after writing the bytes to a temp file so
//      the existing import screen can pick them up by path.
//
// On non-Android hosts every entry point is a guarded no-op so this
// service can be unconditionally wired from `main.dart`.

library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/services/file_drop_service.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/utils/ssh_url_handler.dart';
import 'package:sshvault/core/utils/ssh_url_parser.dart';

/// Method-channel name shared with `MainActivity.kt`. Centralised here so
/// a rename on either side is visible to grep.
const String kAndroidIntentChannel = 'de.kiefer_networks.sshvault/intent';

/// Maximum payload we'll round-trip from native — mirrors the 1 MiB cap
/// enforced on the Kotlin side and keeps the Dart classifier honest.
const int _maxResolvedBytes = 1 * 1024 * 1024;

/// File extensions we accept from the file-open intent. Case-insensitive
/// match; unrecognised extensions fall back to the content classifier in
/// [FileDropService].
const _kKeyExtensions = <String>{'.pub', '.pem', '.ppk', '.key'};

/// Result returned by the native `resolveContentUri` method.
@immutable
class _ResolvedContent {
  final Uint8List bytes;
  final String? displayName;
  const _ResolvedContent({required this.bytes, this.displayName});
}

/// Singleton bridge between the Android VIEW-intent layer and Flutter.
///
/// `init()` is idempotent and is wired from `main.dart` after `runApp` so
/// the navigator key and providers are available by the time the first
/// URL arrives. On non-Android hosts `init()` is a no-op.
class AndroidIntentService {
  AndroidIntentService._();
  static final AndroidIntentService instance = AndroidIntentService._();

  static const _tag = 'AndroidIntent';
  static const MethodChannel _defaultChannel = MethodChannel(
    kAndroidIntentChannel,
  );

  /// Channel reference — overridable so unit tests can inject a mock.
  MethodChannel _channel = _defaultChannel;

  ProviderContainer? _container;
  bool _initialized = false;

  /// Test seam — captures dispatched events without driving real
  /// navigation / Riverpod state. When set, `init()` skips the real
  /// channel registration too.
  @visibleForTesting
  void Function(AndroidIntentEvent event)? onEventForTest;

  /// Test-only override of the file-write step so unit tests can verify
  /// the export-import path without touching the disk.
  @visibleForTesting
  Future<String> Function(String name, Uint8List bytes)? writeTempFileForTest;

  void init(ProviderContainer container) {
    if (_initialized) return;
    if (!kIsWeb && !Platform.isAndroid) {
      _initialized = true;
      return;
    }
    _container = container;
    _channel.setMethodCallHandler(_handleCall);
    _initialized = true;
    LoggingService.instance.info(_tag, 'Android intent bridge ready');
  }

  /// Test-only reset so each test gets a clean slate. Detaches the
  /// channel handler if init() ran, then forgets all state.
  @visibleForTesting
  void resetForTest() {
    if (_initialized) {
      _channel.setMethodCallHandler(null);
    }
    _channel = _defaultChannel;
    _initialized = false;
    _container = null;
    onEventForTest = null;
    writeTempFileForTest = null;
  }

  /// Test-only seam — installs an alternate channel (typically built from
  /// `TestDefaultBinaryMessengerBinding`) and pretends we're on Android
  /// so the dispatcher actually runs.
  @visibleForTesting
  void initForTest(MethodChannel channel, {ProviderContainer? container}) {
    if (_initialized) return;
    _channel = channel;
    _container = container;
    _channel.setMethodCallHandler(_handleCall);
    _initialized = true;
  }

  Future<dynamic> _handleCall(MethodCall call) async {
    switch (call.method) {
      case 'openUrl':
        final raw = call.arguments;
        if (raw is! String || raw.isEmpty) return null;
        await handleUri(raw);
        return null;
      default:
        return null;
    }
  }

  /// Public for tests. Classifies a single URI string and dispatches it
  /// to the right downstream handler. Never throws — every error path
  /// logs and short-circuits so a malformed Open-With… intent can't
  /// crash the app.
  @visibleForTesting
  Future<void> handleUri(String raw) async {
    final Uri uri;
    try {
      uri = Uri.parse(raw);
    } catch (e) {
      LoggingService.instance.warning(_tag, 'Unparseable URI: $raw ($e)');
      return;
    }

    final scheme = uri.scheme.toLowerCase();

    // 1) ssh:// / sftp:// — straight through the existing handler.
    if (scheme == 'ssh' || scheme == 'sftp') {
      _emit(AndroidIntentEvent.sshUrl(raw));
      final container = _container;
      if (container == null) {
        LoggingService.instance.warning(
          _tag,
          'ssh:// URL arrived without a container',
        );
        return;
      }
      final parsed = SshUrl.parse(raw);
      if (parsed == null) {
        LoggingService.instance.warning(_tag, 'Invalid ssh:// URL: $raw');
        return;
      }
      await SshUrlHandler.handle(container, parsed);
      return;
    }

    // 2) content:// or file:// — pull the bytes via ContentResolver and
    // route through the FileDropService classifier. We cannot path-poke
    // a content:// URI because every authority maps differently; the
    // simplest stable approach is to materialise the bytes into a temp
    // file and feed that path through the existing classifier.
    if (scheme == 'content' || scheme == 'file') {
      _emit(AndroidIntentEvent.fileUri(raw));
      await _handleFileLikeUri(uri);
      return;
    }

    LoggingService.instance.info(_tag, 'Ignoring URI with scheme "$scheme"');
  }

  Future<void> _handleFileLikeUri(Uri uri) async {
    final resolved = await _resolve(uri);
    if (resolved == null) return;

    // Best-effort filename — fall back to the URI's last path segment.
    final fallback = uri.pathSegments.isEmpty
        ? 'sshvault_intent.bin'
        : uri.pathSegments.last;
    final name =
        (resolved.displayName != null && resolved.displayName!.isNotEmpty)
        ? resolved.displayName!
        : fallback;

    final ext = p.extension(name).toLowerCase();
    final isKnown = _kKeyExtensions.contains(ext) || ext == '.json';
    if (!isKnown) {
      // Still classify content — the JSON / PEM body wins regardless of
      // extension. Everything else gets a debug log and a drop.
      LoggingService.instance.info(
        _tag,
        'Unrecognised extension "$ext" — falling through to content classifier',
      );
    }

    final tempPath = await _writeTempFile(name, resolved.bytes);
    if (tempPath == null) return;

    // Route through the existing drop classifier so the user gets the
    // same UI whether the file came from drag-and-drop or Open With….
    await FileDropService.instance.handleDroppedPaths(<String>[tempPath]);
  }

  Future<_ResolvedContent?> _resolve(Uri uri) async {
    if (uri.scheme == 'file') {
      // file:// URIs map directly onto the local FS; skip the round-trip
      // and read with dart:io. Still cap at the 1 MiB ceiling.
      try {
        final f = File.fromUri(uri);
        if (!await f.exists()) {
          LoggingService.instance.warning(_tag, 'file:// not found: $uri');
          return null;
        }
        final stat = await f.stat();
        if (stat.size > _maxResolvedBytes) {
          LoggingService.instance.warning(
            _tag,
            'file:// too large (${stat.size} > $_maxResolvedBytes): $uri',
          );
          return null;
        }
        final bytes = await f.readAsBytes();
        return _ResolvedContent(bytes: bytes, displayName: p.basename(f.path));
      } catch (e) {
        LoggingService.instance.warning(_tag, 'file:// read failed: $e');
        return null;
      }
    }

    // content:// — go through the native ContentResolver bridge.
    try {
      final raw = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'resolveContentUri',
        uri.toString(),
      );
      if (raw == null) return null;
      final bytes = raw['bytes'];
      final name = raw['name'];
      if (bytes is! Uint8List) {
        LoggingService.instance.warning(
          _tag,
          'resolveContentUri returned non-bytes payload',
        );
        return null;
      }
      return _ResolvedContent(
        bytes: bytes,
        displayName: name is String ? name : null,
      );
    } on PlatformException catch (e) {
      LoggingService.instance.warning(
        _tag,
        'resolveContentUri failed: ${e.code} ${e.message}',
      );
      return null;
    } on MissingPluginException {
      LoggingService.instance.warning(
        _tag,
        'resolveContentUri unavailable — wrong host?',
      );
      return null;
    }
  }

  Future<String?> _writeTempFile(String name, Uint8List bytes) async {
    final hook = writeTempFileForTest;
    if (hook != null) return hook(name, bytes);
    try {
      final dir = await getTemporaryDirectory();
      // Disambiguate by timestamp so consecutive opens of the same name
      // never clobber each other before the import flow consumed them.
      final stamp = DateTime.now().microsecondsSinceEpoch.toString();
      final safe = p.basename(name).isEmpty
          ? 'sshvault_intent'
          : p.basename(name);
      final path = p.join(dir.path, 'intent_${stamp}_$safe');
      final f = File(path);
      await f.writeAsBytes(bytes, flush: true);
      return path;
    } catch (e) {
      LoggingService.instance.warning(_tag, 'temp write failed: $e');
      return null;
    }
  }

  void _emit(AndroidIntentEvent event) {
    final hook = onEventForTest;
    if (hook != null) hook(event);
  }
}

/// Test-visible event surface. Production code does not look at this; it
/// exists purely so unit tests can assert on the dispatch decision
/// without driving a real Navigator/Riverpod tree.
@immutable
class AndroidIntentEvent {
  final String kind; // 'ssh' | 'file'
  final String raw;

  const AndroidIntentEvent._(this.kind, this.raw);

  factory AndroidIntentEvent.sshUrl(String raw) =>
      AndroidIntentEvent._('ssh', raw);
  factory AndroidIntentEvent.fileUri(String raw) =>
      AndroidIntentEvent._('file', raw);

  @override
  bool operator ==(Object other) =>
      other is AndroidIntentEvent && other.kind == kind && other.raw == raw;

  @override
  int get hashCode => Object.hash(kind, raw);

  @override
  String toString() => 'AndroidIntentEvent($kind, $raw)';
}

// Used to silence "unused import" if the router import ever becomes
// transitively unused — kept for forward compatibility.
// ignore: unused_element
void _routerKeepAlive() => AppRouter.router.toString();
