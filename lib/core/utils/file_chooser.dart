// ignore_for_file: avoid_classes_with_only_static_members
//
// Centralized file chooser wrapper.
//
// Linux desktops mix two file-chooser stacks:
//   * GTK FileChooserNative (used by `file_picker` by default).
//   * The XDG Desktop Portal (`org.freedesktop.portal.FileChooser`), which
//     under KDE Plasma is implemented by `xdg-desktop-portal-kde` and shows
//     the native KDE dialog. Under Flatpak the portal is the only allowed
//     route. Under GNOME / generic GTK desktops the GTK chooser already
//     looks native.
//
// `file_picker` >= 10.x dispatches to the portal on Linux when the
// `XDG_CURRENT_DESKTOP` matches a portal-aware desktop or when running
// under Flatpak. Older betas required setting an env hint. To make the
// behavior deterministic we centralize all chooser calls through this
// wrapper: it picks the right route, applies MIME-type filtering, and
// always passes a localized `dialogTitle`.

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// Coarse description of the chosen Linux backend.
///
/// Exposed for tests and diagnostics — the wrapper consults this to
/// decide which `file_picker` flags to pass.
enum FileChooserBackend {
  /// XDG Desktop Portal — the only choice under Flatpak, and the
  /// preferred choice under KDE Plasma so the dialog is rendered by
  /// `xdg-desktop-portal-kde` (native KDE look).
  xdgPortal,

  /// GTK `FileChooserNative` — the default for GNOME and generic
  /// freedesktop sessions where it already matches the system theme.
  gtkNative,

  /// Non-Linux platforms — the wrapper just delegates to `file_picker`'s
  /// platform default (Cocoa / Win32 / Android / iOS).
  platformDefault,
}

/// Cross-platform MIME type filter.
///
/// Pass a list of MIME types (e.g. `application/x-pem-file`,
/// `text/plain`). The wrapper translates them to the platform's
/// preferred filter shape:
///
///   * Linux portal / GTK: MIME types are passed through directly.
///   * Win32 / macOS / mobile: `file_picker` does not consume MIME
///     types, so each filter contributes its `extensions` to the
///     `allowedExtensions` list and the picker is opened with
///     `FileType.custom`.
@immutable
class FileTypeFilter {
  /// MIME type, e.g. `application/x-pem-file`. Used by the XDG portal
  /// and GTK chooser.
  final String mime;

  /// File extensions (without the leading `.`) associated with [mime].
  /// Used as a fallback on platforms whose pickers do not understand
  /// MIME types (Windows, macOS, Android, iOS).
  final List<String> extensions;

  const FileTypeFilter(this.mime, {this.extensions = const []});

  /// Common: any file.
  static const FileTypeFilter any = FileTypeFilter(
    '*/*',
    extensions: <String>[],
  );

  /// Common: PEM-encoded SSH private/public keys.
  static const FileTypeFilter pem = FileTypeFilter(
    'application/x-pem-file',
    extensions: <String>['pem', 'key', 'pub'],
  );

  /// Common: plain text (used for SSH `config`).
  static const FileTypeFilter plainText = FileTypeFilter(
    'text/plain',
    extensions: <String>['txt', 'conf', 'config'],
  );

  /// Common: JSON.
  static const FileTypeFilter json = FileTypeFilter(
    'application/json',
    extensions: <String>['json'],
  );

  /// Common: ZIP archives (used for encrypted SSHVault exports).
  static const FileTypeFilter zip = FileTypeFilter(
    'application/zip',
    extensions: <String>['zip'],
  );
}

/// Reads an environment variable. Defaults to [Platform.environment]; tests
/// inject a synthetic map by replacing [FileChooser.environmentReader].
typedef EnvironmentReader = String? Function(String key);

/// Reports whether a path exists. Defaults to a real [File.existsSync];
/// tests inject a stub via [FileChooser.fileExistsReader].
typedef FileExistsReader = bool Function(String path);

/// Wrapper around `file_picker` that:
///   * detects the active Linux backend (Plasma / Flatpak / GNOME / other),
///   * routes to the portal whenever Plasma or Flatpak is active so the
///     native KDE / sandbox dialog is used,
///   * accepts MIME type filters and translates them per-platform,
///   * requires a localized [dialogTitle] for every call.
class FileChooser {
  FileChooser._();

  /// Overridable for tests. Defaults to the real process environment.
  @visibleForTesting
  static EnvironmentReader environmentReader = _defaultEnvReader;

  /// Overridable for tests. Defaults to [File.existsSync].
  @visibleForTesting
  static FileExistsReader fileExistsReader = _defaultExistsReader;

  /// Overridable for tests. Defaults to [defaultTargetPlatform].
  @visibleForTesting
  static TargetPlatform Function() platformReader = _defaultPlatformReader;

  /// Overridable for tests. Defaults to the real `FilePicker.platform`.
  ///
  /// Resolved lazily on first access so unit tests that swap the override
  /// in `setUp()` are not racing the field initializer (which would
  /// otherwise throw `LateInitializationError` if no platform plugin is
  /// registered when the test isolate boots).
  @visibleForTesting
  static FilePicker? pickerOverride;

  static FilePicker get picker => pickerOverride ?? FilePicker.platform;

  /// Resets all overrides to their production defaults.
  @visibleForTesting
  static void resetForTesting() {
    environmentReader = _defaultEnvReader;
    fileExistsReader = _defaultExistsReader;
    platformReader = _defaultPlatformReader;
    pickerOverride = null;
  }

  static String? _defaultEnvReader(String key) => Platform.environment[key];
  static bool _defaultExistsReader(String path) => File(path).existsSync();
  static TargetPlatform _defaultPlatformReader() => defaultTargetPlatform;

  /// Returns the backend the wrapper will use for the current process.
  ///
  /// Detection order:
  ///   1. Non-Linux  → [FileChooserBackend.platformDefault].
  ///   2. Flatpak (`/.flatpak-info` exists) → [FileChooserBackend.xdgPortal].
  ///   3. KDE Plasma (`KDE_FULL_SESSION=true` or
  ///      `XDG_CURRENT_DESKTOP` contains `KDE`) → [FileChooserBackend.xdgPortal].
  ///   4. Otherwise → [FileChooserBackend.gtkNative].
  static FileChooserBackend detectBackend() {
    if (kIsWeb) return FileChooserBackend.platformDefault;
    if (platformReader() != TargetPlatform.linux) {
      return FileChooserBackend.platformDefault;
    }
    if (fileExistsReader('/.flatpak-info')) {
      return FileChooserBackend.xdgPortal;
    }
    final kdeFullSession = environmentReader('KDE_FULL_SESSION');
    if (kdeFullSession != null && kdeFullSession.toLowerCase() == 'true') {
      return FileChooserBackend.xdgPortal;
    }
    final xdgDesktop = environmentReader('XDG_CURRENT_DESKTOP') ?? '';
    final tokens = xdgDesktop
        .toUpperCase()
        .split(':')
        .where((t) => t.isNotEmpty);
    if (tokens.contains('KDE')) {
      return FileChooserBackend.xdgPortal;
    }
    return FileChooserBackend.gtkNative;
  }

  /// Opens a file selection dialog.
  ///
  /// [dialogTitle] must come from `AppLocalizations` (l10n).
  /// [filters] is the cross-platform MIME-type filter list. Pass
  /// `[FileTypeFilter.any]` (or omit) to accept any file.
  /// [withData] forces the picker to return the file's bytes — used
  /// when the host shell does not give us a stable path (sandbox).
  static Future<FileChooserResult?> openFile({
    required String dialogTitle,
    List<FileTypeFilter> filters = const <FileTypeFilter>[FileTypeFilter.any],
    bool withData = false,
  }) async {
    final result = await picker.pickFiles(
      dialogTitle: dialogTitle,
      type: _resolveFileType(filters),
      allowedExtensions: _resolveAllowedExtensions(filters),
      withData: withData,
    );
    if (result == null || result.files.isEmpty) return null;
    final f = result.files.first;
    return FileChooserResult(
      name: f.name,
      path: f.path,
      bytes: f.bytes,
      size: f.size,
    );
  }

  /// Opens a multi-file selection dialog. Returns the empty list when
  /// the user cancels.
  static Future<List<FileChooserResult>> openFiles({
    required String dialogTitle,
    List<FileTypeFilter> filters = const <FileTypeFilter>[FileTypeFilter.any],
    bool withData = false,
  }) async {
    final result = await picker.pickFiles(
      dialogTitle: dialogTitle,
      type: _resolveFileType(filters),
      allowedExtensions: _resolveAllowedExtensions(filters),
      withData: withData,
      allowMultiple: true,
    );
    if (result == null) return const <FileChooserResult>[];
    return result.files
        .map(
          (f) => FileChooserResult(
            name: f.name,
            path: f.path,
            bytes: f.bytes,
            size: f.size,
          ),
        )
        .toList(growable: false);
  }

  /// Opens a save-as dialog.
  ///
  /// On Android / iOS the bytes parameter is required by `file_picker`,
  /// so callers must pass [bytes]. On desktop [bytes] is optional and
  /// the returned path can be written to by the caller.
  static Future<String?> saveFile({
    required String dialogTitle,
    required String fileName,
    Uint8List? bytes,
    List<FileTypeFilter> filters = const <FileTypeFilter>[FileTypeFilter.any],
  }) {
    return picker.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      bytes: bytes,
      type: _resolveFileType(filters),
      allowedExtensions: _resolveAllowedExtensions(filters),
    );
  }

  /// Opens a directory selection dialog.
  static Future<String?> openDir({required String dialogTitle}) {
    return picker.getDirectoryPath(dialogTitle: dialogTitle);
  }

  /// `file_picker` requires `FileType.custom` whenever
  /// [allowedExtensions] is non-empty, otherwise `FileType.any`.
  static FileType _resolveFileType(List<FileTypeFilter> filters) {
    final exts = _resolveAllowedExtensions(filters);
    return exts == null ? FileType.any : FileType.custom;
  }

  /// Aggregates extensions from all filters. Returns `null` when no
  /// concrete extensions are configured (i.e. the caller wants any
  /// file), which signals `FileType.any` to `file_picker`.
  static List<String>? _resolveAllowedExtensions(List<FileTypeFilter> filters) {
    if (filters.isEmpty) return null;
    final combined = <String>{};
    var sawWildcard = false;
    for (final f in filters) {
      if (f.extensions.isEmpty) {
        sawWildcard = true;
      } else {
        combined.addAll(f.extensions);
      }
    }
    if (sawWildcard && combined.isEmpty) return null;
    if (combined.isEmpty) return null;
    return combined.toList(growable: false);
  }
}

/// Result of [FileChooser.openFile] / [FileChooser.openFiles]. Either
/// [path] or [bytes] is populated; under sandboxed runtimes the path
/// may be null and callers must use [bytes].
@immutable
class FileChooserResult {
  final String name;
  final String? path;
  final Uint8List? bytes;

  /// File size in bytes, as reported by the underlying picker. Useful
  /// for transfer-progress tracking.
  final int size;

  const FileChooserResult({
    required this.name,
    this.path,
    this.bytes,
    this.size = 0,
  });
}
