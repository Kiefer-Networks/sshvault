// Dart-side companion to the Windows crash-dump handler in
// `windows/runner/crash_handler.cpp`.
//
// The native handler writes minidumps to:
//
//     %LOCALAPPDATA%\SSHVault\crashes\sshvault-<timestamp>.dmp
//
// This service exposes that folder to the UI:
//
//   - [listDumps]      → enumerate the existing .dmp files (newest first).
//   - [totalSizeBytes] → sum of file sizes, for the "X dumps · Y MB" label.
//   - [deleteAll]      → wipe the folder contents (best-effort).
//   - [openFolder]     → reveal the folder in Explorer.
//   - [crashFolderPath]→ resolved folder path, useful for tooltips/tests.
//
// Privacy: the folder is per-user under %LOCALAPPDATA%. Nothing is ever
// auto-uploaded; the user must consciously ZIP and email a dump if they
// want to share it. The README and the Settings → About → Crash dumps
// section both call this out explicitly.
//
// Platform scoping: dumps are only produced on Windows, but the API is
// safe to call on every platform. On non-Windows platforms [listDumps]
// returns an empty list and the mutating methods are no-ops, so callers
// don't need to wrap each invocation in `Platform.isWindows`.
//
// Tests can substitute the LOCALAPPDATA root by passing
// [CrashDumpService.forTest] a custom resolver — see
// `test/core/services/crash_dump_service_test.dart`.

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show visibleForTesting;

import 'package:sshvault/core/services/logging_service.dart';

/// Resolves the LOCALAPPDATA root used to host the crash folder. Returning
/// `null` means "we couldn't figure out a sensible location" and the service
/// behaves as if there are no dumps. Tests inject their own resolver to
/// redirect writes into a temporary directory.
typedef LocalAppDataResolver = String? Function();

/// Hook for the "open folder in file explorer" action. Production wires this
/// to `Process.run`; tests can capture the call without spawning a child
/// process.
typedef ExplorerLauncher = Future<void> Function(String path);

/// Service that exposes the per-user Windows crash-dump folder to the UI.
class CrashDumpService {
  CrashDumpService._({
    required LocalAppDataResolver resolveLocalAppData,
    required ExplorerLauncher launchExplorer,
  }) : _resolveLocalAppData = resolveLocalAppData,
       _launchExplorer = launchExplorer;

  /// Production constructor — uses the real `LOCALAPPDATA` env var and
  /// `Process.run('explorer.exe', ...)`.
  factory CrashDumpService() {
    return CrashDumpService._(
      resolveLocalAppData: _defaultResolveLocalAppData,
      launchExplorer: _defaultLaunchExplorer,
    );
  }

  /// Test-only constructor. Both hooks are required so the unit test can
  /// drive the service without touching the real filesystem root or
  /// spawning Explorer.
  @visibleForTesting
  factory CrashDumpService.forTest({
    required LocalAppDataResolver resolveLocalAppData,
    ExplorerLauncher? launchExplorer,
  }) {
    return CrashDumpService._(
      resolveLocalAppData: resolveLocalAppData,
      launchExplorer: launchExplorer ?? ((_) async {}),
    );
  }

  /// Singleton used by the production UI. The state is intentionally
  /// minimal (no caching) so we always reflect what's on disk.
  static final CrashDumpService instance = CrashDumpService();

  final LocalAppDataResolver _resolveLocalAppData;
  final ExplorerLauncher _launchExplorer;

  /// Folder name under LOCALAPPDATA — kept in sync with `kAppFolderName`
  /// in `windows/runner/crash_handler.cpp`.
  static const String _appFolderName = 'SSHVault';

  /// Subfolder name under the app folder — kept in sync with
  /// `kCrashSubfolder` in `windows/runner/crash_handler.cpp`.
  static const String _crashSubfolder = 'crashes';

  /// Filename prefix the native handler uses; we use it as a safety filter
  /// when listing/deleting so we never touch unrelated files a user might
  /// have parked in the folder by mistake.
  static const String _dumpFilenamePrefix = 'sshvault-';

  /// Filename extension we accept (lowercase compare).
  static const String _dumpFilenameExt = '.dmp';

  /// Resolved absolute path of the crash folder, or `null` on platforms /
  /// environments where we can't determine LOCALAPPDATA. The folder may not
  /// yet exist — callers that need it materialized should call [listDumps]
  /// first (which is a no-op if the folder is missing) or create it
  /// themselves before writing.
  String? get crashFolderPath {
    final root = _resolveLocalAppData();
    if (root == null || root.isEmpty) return null;
    // We deliberately don't use `package:path` here to keep this file
    // dependency-light; LOCALAPPDATA is always a Windows-style path with
    // backslash separators, so a literal join is fine.
    return '$root\\$_appFolderName\\$_crashSubfolder';
  }

  /// Enumerates `.dmp` files in the crash folder, newest first.
  ///
  /// Returns an empty list if the folder doesn't exist, can't be resolved,
  /// or contains no matching files. Failures during enumeration are logged
  /// and swallowed — this method must never throw because it's invoked from
  /// the Settings UI build path.
  Future<List<File>> listDumps() async {
    final folder = crashFolderPath;
    if (folder == null) return const [];

    final dir = Directory(folder);
    if (!await dir.exists()) return const [];

    try {
      final entries = await dir.list(followLinks: false).toList();
      final dumps = <File>[];
      for (final entry in entries) {
        if (entry is! File) continue;
        final name = entry.uri.pathSegments.isNotEmpty
            ? entry.uri.pathSegments.last
            : entry.path.split(RegExp(r'[\\/]')).last;
        final lower = name.toLowerCase();
        if (!lower.startsWith(_dumpFilenamePrefix)) continue;
        if (!lower.endsWith(_dumpFilenameExt)) continue;
        dumps.add(entry);
      }

      // Newest first: `sshvault-YYYYMMDD-HHMMSS.dmp` sorts
      // chronologically by string, so a reverse compare is sufficient and
      // avoids a (potentially racy) stat per file.
      dumps.sort((a, b) => b.path.compareTo(a.path));
      return dumps;
    } on FileSystemException catch (e) {
      LoggingService.instance.warning(
        'CrashDumpService',
        'listDumps failed: $e',
      );
      return const [];
    }
  }

  /// Sum of the byte size of every dump returned by [listDumps]. Used by
  /// the UI to render a "X dumps · Y MB" label. Returns 0 if there are no
  /// dumps or any size lookup fails.
  Future<int> totalSizeBytes() async {
    final dumps = await listDumps();
    var total = 0;
    for (final dump in dumps) {
      try {
        total += await dump.length();
      } on FileSystemException {
        // Skip files that vanished between list and stat — best-effort.
      }
    }
    return total;
  }

  /// Deletes every `.dmp` file in the crash folder. Non-matching files are
  /// left untouched. Returns the number of files actually removed.
  Future<int> deleteAll() async {
    final dumps = await listDumps();
    var removed = 0;
    for (final dump in dumps) {
      try {
        await dump.delete();
        removed++;
      } on FileSystemException catch (e) {
        LoggingService.instance.warning(
          'CrashDumpService',
          'deleteAll: failed to remove ${dump.path}: $e',
        );
      }
    }
    return removed;
  }

  /// Reveals the crash folder in the OS file manager. Currently only wired
  /// for Windows (Explorer); on other platforms this is a no-op.
  ///
  /// We CreateDirectory first so the launcher always sees an existing
  /// folder, even if the app has never crashed (otherwise Explorer pops a
  /// "folder doesn't exist" dialog).
  Future<void> openFolder() async {
    final folder = crashFolderPath;
    if (folder == null) return;
    try {
      await Directory(folder).create(recursive: true);
    } on FileSystemException catch (e) {
      LoggingService.instance.warning(
        'CrashDumpService',
        'openFolder: cannot create $folder: $e',
      );
      return;
    }
    await _launchExplorer(folder);
  }
}

/// Default LOCALAPPDATA resolver: reads the env var on Windows, returns
/// `null` everywhere else so the service degrades gracefully.
String? _defaultResolveLocalAppData() {
  if (!Platform.isWindows) return null;
  final value = Platform.environment['LOCALAPPDATA'];
  if (value == null || value.isEmpty) return null;
  return value;
}

/// Default Explorer launcher: shells out to `explorer.exe <path>` on
/// Windows. Failures are logged and swallowed — the worst case is the user
/// not seeing a window pop up; nothing else in the app depends on it.
Future<void> _defaultLaunchExplorer(String path) async {
  if (!Platform.isWindows) return;
  try {
    await Process.run('explorer.exe', [path]);
  } on ProcessException catch (e) {
    LoggingService.instance.warning(
      'CrashDumpService',
      'openFolder: explorer.exe failed: $e',
    );
  }
}
