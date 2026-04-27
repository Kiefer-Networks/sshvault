// Linux drag-and-drop bridge.
//
// The C++ side (`linux/runner/my_application.cc`) registers the toplevel GTK
// window as a drop target for `text/uri-list` and forwards three events on
// the `de.kiefer_networks.sshvault/drop` MethodChannel:
//
//   - `dropFiles(List<String> paths)` — file(s) released onto the window
//   - `dragEnter()`                   — pointer entered while dragging
//   - `dragLeave()`                   — pointer left without dropping
//
// This service wires those events into the rest of the app:
//
//   - dropped private/public SSH keys open the SSH-key import dialog with the
//     contents pre-filled,
//   - dropped vault export JSON ("sshvault_export_v1") jumps to the
//     export/import settings screen,
//   - dropped ssh_config files jump to the existing config-import screen,
//   - drag enter/leave drive the [dragInProgressProvider] used by the visual
//     overlay in `lib/app.dart`.
//
// The classifier is intentionally heuristic — it inspects the first few KB of
// the file rather than relying on extensions, which most SSH key files lack.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as p;
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/presentation/screens/ssh_key_form_dialog.dart';

/// Maximum file size we'll read off disk for a dropped file. SSH keys, ssh
/// configs, and vault export JSON are all comfortably under this; anything
/// larger is almost certainly the wrong kind of file (binary blob, log dump).
const int _maxDropFileBytes = 100 * 1024;

/// Riverpod state — `true` while a drag is hovering over the window. Consumed
/// by the top-level overlay in `lib/app.dart`.
final dragInProgressProvider = StateProvider<bool>((_) => false);

/// Last vault-export path the user dropped, parked here so the
/// `/settings/export` screen can pick it up if/when it grows that hook. Today
/// we only navigate to the screen; tomorrow we can auto-trigger the import.
final droppedVaultExportPathProvider = StateProvider<String?>((_) => null);

/// Same idea for ssh_config drops feeding the existing config-import screen.
final droppedSshConfigPathProvider = StateProvider<String?>((_) => null);

/// Classification result for a dropped file. The router/dispatcher decides
/// what UI to surface based on this.
@visibleForTesting
enum DroppedFileKind {
  privateKey,
  publicKey,
  vaultExportJson,
  sshConfig,
  unsupported,
}

@visibleForTesting
class ClassifiedDrop {
  final DroppedFileKind kind;
  final String path;
  final String? content;

  const ClassifiedDrop({required this.kind, required this.path, this.content});
}

/// Singleton bridge between the C++ DnD layer and the Flutter app.
///
/// `init()` is idempotent and is wired from `main.dart` after `runApp` so the
/// navigator key and providers are available by the time the first drop event
/// arrives. On non-Linux platforms `init()` is a no-op.
class FileDropService {
  FileDropService._();
  static final FileDropService instance = FileDropService._();

  static const _tag = 'FileDrop';
  static const _channel = MethodChannel('de.kiefer_networks.sshvault/drop');

  GlobalKey<NavigatorState>? _navigatorKey;
  ProviderContainer? _container;
  bool _initialized = false;

  /// File-reader hook so tests can feed synthetic content without touching the
  /// disk. Production code uses [_defaultReadFile] which honours the size cap.
  @visibleForTesting
  Future<String?> Function(String path) readFile = _defaultReadFile;

  /// Disposable handler used by tests to capture routing decisions without a
  /// real Navigator/MaterialApp. When null we go through the navigator.
  @visibleForTesting
  void Function(ClassifiedDrop drop)? onDropForTest;

  void init(
    GlobalKey<NavigatorState> navigatorKey, {
    ProviderContainer? container,
  }) {
    if (_initialized) return;
    if (!kIsWeb && !Platform.isLinux) return;
    _navigatorKey = navigatorKey;
    _container = container;
    _channel.setMethodCallHandler(_handleCall);
    _initialized = true;
    LoggingService.instance.info(_tag, 'Linux drag-and-drop bridge ready');
  }

  /// Test-only reset so each test gets a clean slate. Only touches the
  /// MethodChannel handler if the bridge was actually `init()`-ed; tests that
  /// stay in pure-Dart classifier mode never need the binding.
  @visibleForTesting
  void resetForTest() {
    if (_initialized) {
      _channel.setMethodCallHandler(null);
    }
    _initialized = false;
    _navigatorKey = null;
    _container = null;
    onDropForTest = null;
    readFile = _defaultReadFile;
  }

  Future<dynamic> _handleCall(MethodCall call) async {
    switch (call.method) {
      case 'dragEnter':
        _setDragInProgress(true);
        return null;
      case 'dragLeave':
        _setDragInProgress(false);
        return null;
      case 'dropFiles':
        _setDragInProgress(false);
        final args = call.arguments;
        final paths = <String>[
          if (args is List)
            for (final v in args)
              if (v is String) v,
        ];
        await handleDroppedPaths(paths);
        return null;
      default:
        return null;
    }
  }

  void _setDragInProgress(bool value) {
    final container = _container;
    if (container == null) return;
    try {
      container.read(dragInProgressProvider.notifier).state = value;
    } catch (e) {
      LoggingService.instance.warning(_tag, 'dragInProgress update failed: $e');
    }
  }

  /// Public for tests. Reads, classifies, and dispatches a list of file paths.
  @visibleForTesting
  Future<void> handleDroppedPaths(List<String> paths) async {
    if (paths.isEmpty) return;

    final classified = <ClassifiedDrop>[];
    var unsupported = 0;
    for (final path in paths) {
      final drop = await _classify(path);
      if (drop.kind == DroppedFileKind.unsupported) {
        unsupported++;
      }
      classified.add(drop);
    }

    final supported = classified
        .where((d) => d.kind != DroppedFileKind.unsupported)
        .toList();

    // Only the first supported file actually drives a navigation — opening
    // multiple import dialogs at once would just stack on top of each other.
    if (supported.isNotEmpty) {
      _dispatch(supported.first);
    }

    _showFeedback(supported.length, unsupported);
  }

  Future<ClassifiedDrop> _classify(String path) async {
    final content = await readFile(path);
    if (content == null) {
      return ClassifiedDrop(kind: DroppedFileKind.unsupported, path: path);
    }
    return ClassifiedDrop(
      kind: classifyContent(content),
      path: path,
      content: content,
    );
  }

  /// Heuristic content classifier. Public/visible for tests; the rules are:
  ///
  ///   1. PEM private-key markers win first (they appear in the file body
  ///      regardless of extension).
  ///   2. SSH public keys start with one of the known algorithm tokens and
  ///      live on a single line.
  ///   3. Vault exports are JSON with the `sshvault_export_v1` magic field.
  ///   4. ssh_config detection is keyword-based — no formal grammar — and is
  ///      checked last because the markers are very loose.
  @visibleForTesting
  static DroppedFileKind classifyContent(String content) {
    final trimmed = content.trimLeft();

    // 1) Private key (any flavour we support).
    if (trimmed.contains('BEGIN OPENSSH PRIVATE KEY') ||
        trimmed.contains('BEGIN RSA PRIVATE KEY') ||
        trimmed.contains('BEGIN EC PRIVATE KEY') ||
        trimmed.contains('BEGIN DSA PRIVATE KEY') ||
        trimmed.contains('BEGIN PRIVATE KEY')) {
      return DroppedFileKind.privateKey;
    }

    // 2) Public key — first non-empty line starts with the algorithm name.
    final firstLine = trimmed.split('\n').first.trim();
    const pubPrefixes = [
      'ssh-ed25519 ',
      'ssh-rsa ',
      'ssh-dss ',
      'ecdsa-sha2-nistp256 ',
      'ecdsa-sha2-nistp384 ',
      'ecdsa-sha2-nistp521 ',
      'sk-ssh-ed25519@openssh.com ',
      'sk-ecdsa-sha2-nistp256@openssh.com ',
    ];
    for (final prefix in pubPrefixes) {
      if (firstLine.startsWith(prefix)) return DroppedFileKind.publicKey;
    }

    // 3) Vault export JSON. Be cheap: look for the magic before parsing.
    if (trimmed.startsWith('{') && trimmed.contains('"sshvault_export_v1"')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map && decoded.containsKey('sshvault_export_v1')) {
          return DroppedFileKind.vaultExportJson;
        }
      } catch (_) {
        // Fall through — malformed JSON shouldn't masquerade as an export.
      }
    }

    // 4) ssh_config heuristics. These keywords are case-insensitive in the
    // real format but every common writer uses TitleCase, so a couple of
    // anchors are enough to distinguish from a random text file.
    final lower = trimmed.toLowerCase();
    if (lower.startsWith('host ') ||
        lower.startsWith('match ') ||
        lower.contains('\nhost ') ||
        lower.contains('serveraliveinterval') ||
        lower.contains('identityfile ')) {
      return DroppedFileKind.sshConfig;
    }

    return DroppedFileKind.unsupported;
  }

  void _dispatch(ClassifiedDrop drop) {
    if (onDropForTest != null) {
      onDropForTest!(drop);
      return;
    }

    final navState = _navigatorKey?.currentState;
    final navContext = _navigatorKey?.currentContext;
    if (navState == null || navContext == null) {
      LoggingService.instance.warning(
        _tag,
        'Navigator not ready, drop ignored',
      );
      return;
    }

    switch (drop.kind) {
      case DroppedFileKind.privateKey:
        SshKeyFormDialog.show(
          navContext,
          prefillPrivateKey: drop.content,
          prefillName: _suggestKeyName(drop.path),
        );
        break;
      case DroppedFileKind.publicKey:
        SshKeyFormDialog.show(
          navContext,
          prefillPublicKey: drop.content,
          prefillName: _suggestKeyName(drop.path),
        );
        break;
      case DroppedFileKind.vaultExportJson:
        _container?.read(droppedVaultExportPathProvider.notifier).state =
            drop.path;
        navState.pushNamed('/settings/export');
        break;
      case DroppedFileKind.sshConfig:
        _container?.read(droppedSshConfigPathProvider.notifier).state =
            drop.path;
        navState.pushNamed('/settings/import-ssh-config');
        break;
      case DroppedFileKind.unsupported:
        break;
    }
  }

  /// Strip the extension and `id_` prefix to derive a sensible default name
  /// (e.g. `~/.ssh/id_ed25519.pub` -> `ed25519`). Falls back to the bare
  /// basename if nothing matches.
  String _suggestKeyName(String path) {
    final base = p.basenameWithoutExtension(path);
    if (base.startsWith('id_')) {
      final stripped = base.substring(3);
      if (stripped.isNotEmpty) return stripped;
    }
    return base;
  }

  void _showFeedback(int supported, int unsupported) {
    final ctx = _navigatorKey?.currentContext;
    if (ctx == null) return;
    final messenger = ScaffoldMessenger.maybeOf(ctx);
    if (messenger == null) return;

    String? message;
    if (supported > 0 && unsupported == 0) {
      message = supported == 1
          ? '1 file dropped — opening import…'
          : '$supported files dropped — opening import…';
    } else if (supported > 0 && unsupported > 0) {
      message =
          '$supported file(s) dropped — opening import… $unsupported unsupported';
    } else if (supported == 0 && unsupported > 0) {
      message = unsupported == 1
          ? '1 file unsupported'
          : '$unsupported files unsupported';
    }

    if (message == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

Future<String?> _defaultReadFile(String path) async {
  try {
    final file = File(path);
    if (!await file.exists()) return null;
    final stat = await file.stat();
    if (stat.size > _maxDropFileBytes) {
      LoggingService.instance.warning(
        'FileDrop',
        'Rejecting $path: ${stat.size} bytes exceeds $_maxDropFileBytes',
      );
      return null;
    }
    return await file.readAsString();
  } catch (e) {
    LoggingService.instance.warning('FileDrop', 'Failed to read $path: $e');
    return null;
  }
}
