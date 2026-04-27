// Thin wrapper around `share_plus` for invoking the platform share sheet
// (UIActivityViewController on iOS — which surfaces AirDrop natively — and
// the Android Intent chooser). We never call `share_plus` directly from
// widgets so tests can swap in an in-memory recorder via [shareInvoker].
//
// The share-sheet flow is the only place SSHVault hands raw key material
// (or a `.pub` filename) to another app, so the helpers here keep the
// payload to **public** material only:
//   - `sharePublicKey` writes a single-line OpenSSH public key + comment
//     to a temp `.pub` file. No private-key bytes are ever touched.
//   - `shareVaultExport` re-uses an existing on-disk export — typically the
//     plain JSON or encrypted ZIP produced by ExportImportRepository — and
//     just hands its path to the share sheet.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';

/// Signature for the function that actually invokes `share_plus`. Tests
/// replace this with a recorder so we never hit the platform channel.
typedef ShareInvoker = Future<ShareResult> Function(ShareParams params);

/// Default invoker — routes to the real `share_plus` plugin.
Future<ShareResult> _defaultInvoker(ShareParams params) =>
    SharePlus.instance.share(params);

/// Signature for the function that returns the temp directory. Tests
/// replace this so we don't depend on `path_provider` plugin registration.
typedef TempDirProvider = Future<Directory> Function();

Future<Directory> _defaultTempDir() => getTemporaryDirectory();

/// Static facade so the call sites read like `ShareSheet.sharePublicKey(k)`.
class ShareSheet {
  ShareSheet._();

  /// Test seam — assign a recorder before exercising [sharePublicKey] /
  /// [shareVaultExport] in unit tests, then call [resetForTesting] in
  /// `tearDown`.
  @visibleForTesting
  static ShareInvoker shareInvoker = _defaultInvoker;

  /// Test seam — see [shareInvoker].
  @visibleForTesting
  static TempDirProvider tempDirProvider = _defaultTempDir;

  /// Restores the production invoker / temp-dir provider.
  @visibleForTesting
  static void resetForTesting() {
    shareInvoker = _defaultInvoker;
    tempDirProvider = _defaultTempDir;
  }

  /// Builds a temporary `<key.name>.pub` file containing the OpenSSH
  /// authorized_keys-style line and routes it through the platform share
  /// sheet. On iOS this opens UIActivityViewController which surfaces
  /// AirDrop alongside Mail / Messages / etc.
  ///
  /// No-ops silently when the key has no public material to share — keys
  /// imported from a private blob may not have computed the public side
  /// yet and there's nothing useful to hand off.
  static Future<void> sharePublicKey(SshKeyEntity key) async {
    if (key.publicKey.trim().isEmpty) return;

    final fileName = _sanitizeFileName(
      key.name.isEmpty ? 'sshvault_key' : key.name,
    );
    final dir = await tempDirProvider();
    final tmpPath = p.join(dir.path, '$fileName.pub');

    final body = _composePublicKeyContent(key);
    await File(tmpPath).writeAsString(body, flush: true);

    await shareInvoker(
      ShareParams(
        files: [XFile(tmpPath, mimeType: 'text/plain', name: '$fileName.pub')],
        subject: key.name,
      ),
    );
  }

  /// Hands an existing on-disk vault-export (`.json` plain or `.zip`
  /// encrypted) to the platform share sheet. The file must already exist —
  /// this is the same hand-off the export-import screen uses post-export.
  static Future<void> shareVaultExport(File path) async {
    final fileName = p.basename(path.path);
    await shareInvoker(
      ShareParams(
        files: [XFile(path.path, name: fileName)],
        subject: fileName,
      ),
    );
  }

  /// Compose the OpenSSH single-line representation including the optional
  /// comment. If the stored public key already carries a comment we trust
  /// it; otherwise we append `key.comment` so the recipient knows where
  /// the key came from. The OpenSSH public-key format is:
  ///   `<algo> <base64-blob> [comment]`
  static String _composePublicKeyContent(SshKeyEntity key) {
    final line = key.publicKey.trim();
    final hasInlineComment = line.split(RegExp(r'\s+')).length >= 3;
    if (hasInlineComment || key.comment.trim().isEmpty) {
      return '$line\n';
    }
    return '$line ${key.comment.trim()}\n';
  }

  /// Strip path-traversal / shell-special characters so the temp filename
  /// is safe regardless of the user-provided key name.
  static String _sanitizeFileName(String name) {
    final cleaned = name.replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_');
    final trimmed = cleaned.replaceAll(RegExp(r'^[._]+|[._]+$'), '');
    return trimmed.isEmpty ? 'sshvault_key' : trimmed;
  }
}

/// Convenience top-level wrapper matching the spec — delegates to
/// [ShareSheet.sharePublicKey].
Future<void> sharePublicKey(SshKeyEntity key) => ShareSheet.sharePublicKey(key);

/// Convenience top-level wrapper matching the spec — delegates to
/// [ShareSheet.shareVaultExport].
Future<void> shareVaultExport(File path) => ShareSheet.shareVaultExport(path);
