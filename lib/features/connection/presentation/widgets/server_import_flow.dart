import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/color_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/crypto/ssh_key_type.dart';
import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/utils/ssh_config_parser.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/server_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

/// Add-host entry point shared by the mobile [ServerListScreen] and the
/// desktop Command Palette: on desktop with a readable `~/.ssh/config` it
/// offers to import first, otherwise it falls through to the manual server
/// form.
abstract final class ServerImportFlow {
  static bool get _isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  static void addServer(BuildContext context, WidgetRef ref) {
    // `context` may belong to a caller that closes itself right after
    // invoking this (the Command Palette pops before running its command).
    // Route everything through the app's root navigator context instead,
    // which stays valid for the life of the window — reusing the caller's
    // context across the awaits below threw "No GoRouter found in context"
    // once the palette's own route had finished tearing down.
    final rootContext = rootNavigatorKey.currentContext;
    if (rootContext == null) return;

    if (!_isDesktop || !SshConfigParser.configExists) {
      rootContext.push('/server/new');
      return;
    }

    _showSshConfigImportDialog(rootContext, ref);
  }

  /// True when [entry] already corresponds to a saved server (same
  /// hostname/port/username). Comparing against the real server list —
  /// instead of an in-memory "did we show this dialog before" flag — is
  /// what stops the dialog from re-proposing hosts on every single call,
  /// including after an app restart.
  static bool _hasMatchingServer(
    SshConfigEntry entry,
    List<ServerEntity> servers,
  ) => servers.any(
    (s) =>
        s.hostname.toLowerCase() == entry.hostname.toLowerCase() &&
        s.port == entry.port &&
        s.username.toLowerCase() == entry.username.toLowerCase(),
  );

  static Future<void> _showSshConfigImportDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final parsed = await SshConfigParser.parse();
    if (!context.mounted) return;

    final existingServers = await ref.read(serverListProvider.future);
    if (!context.mounted) return;

    final entries = parsed
        .where((e) => !_hasMatchingServer(e, existingServers))
        .toList();
    if (entries.isEmpty) {
      context.push('/server/new');
      return;
    }

    final selected = List<bool>.filled(entries.length, true);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final selectedCount = selected.where((s) => s).length;
          return AlertDialog(
            title: Text(l10n.sshConfigImportTitle),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.sshConfigImportMessage(entries.length)),
                  Spacing.verticalLg,
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: entries.length,
                      itemBuilder: (_, i) {
                        final e = entries[i];
                        return CheckboxListTile(
                          value: selected[i],
                          onChanged: (v) =>
                              setDialogState(() => selected[i] = v ?? false),
                          title: Text(e.name),
                          subtitle: Text(
                            '${e.username}@${e.hostname}:${e.port}'
                            '${e.identityFile != null ? '  🔑' : ''}',
                          ),
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx, false);
                  context.push('/server/new');
                },
                child: Text(l10n.sshConfigAddManually),
              ),
              // Autofocused so the dialog is keyboard-usable the instant it
              // opens: Enter imports the (default all-checked) selection
              // immediately, and Tab/Shift+Tab from here reaches the
              // individual checkboxes. Without an explicit autofocus target,
              // nothing owns primary focus on open and Enter has nothing to
              // activate.
              FilledButton(
                autofocus: true,
                onPressed: selectedCount > 0
                    ? () => Navigator.pop(ctx, true)
                    : null,
                child: Text(l10n.sshConfigImportButton),
              ),
            ],
          );
        },
      ),
    );

    if (result != true || !context.mounted) return;

    final toImport = <SshConfigEntry>[];
    for (var i = 0; i < entries.length; i++) {
      if (selected[i]) toImport.add(entries[i]);
    }

    // Multiple server entries may share the same identity file — collapse
    // them so we never touch the same key file twice.
    final entriesWithKeys = toImport
        .where((e) => e.identityFile != null)
        .toList();
    final uniqueKeyPaths = <String, SshConfigEntry>{};
    for (final e in entriesWithKeys) {
      uniqueKeyPaths.putIfAbsent(e.identityFile!, () => e);
    }

    // Resolve every identity file against the vault *before* asking
    // anything: keys that already exist are linked silently, and only
    // genuinely new keys are ever shown in a confirmation dialog. Keys
    // that already exist are no longer offered as if they were new, and —
    // unlike before — declining the "import new keys" prompt no longer
    // throws away the link to keys that were already in the vault.
    final keyIdByPath = <String, String>{};
    var keysImported = 0;
    if (uniqueKeyPaths.isNotEmpty) {
      final resolved = await _resolveKeyImports(
        ref,
        uniqueKeyPaths.values.toList(),
      );
      keyIdByPath.addAll(resolved.existingIdByPath);

      if (resolved.newKeys.isNotEmpty && context.mounted) {
        final confirmed =
            await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(l10n.sshConfigImportKeys),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final k in resolved.newKeys)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.vpn_key_outlined, size: 20),
                        title: Text(k.originalPath),
                        subtitle: Text(k.entryName),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(l10n.cancel),
                  ),
                  FilledButton(
                    autofocus: true,
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(l10n.sshConfigImportButton),
                  ),
                ],
              ),
            ) ??
            false;

        if (confirmed) {
          final persisted = await _persistNewKeys(ref, resolved.newKeys);
          keyIdByPath.addAll(persisted.idByPath);
          keysImported = persisted.count;
        }
      }
    }

    var importedCount = 0;
    final serverNotifier = ref.read(serverListProvider.notifier);
    for (final entry in toImport) {
      try {
        final sshKeyId = entry.identityFile != null
            ? keyIdByPath[entry.identityFile]
            : null;
        if (entry.identityFile != null && sshKeyId == null) {
          // Never create a key-auth server without the imported key actually
          // being persisted and linked; it would only fail later at SSH auth.
          continue;
        }
        final server = ServerEntity(
          id: '',
          name: entry.name,
          hostname: entry.hostname,
          port: entry.port,
          username: entry.username,
          authMethod: entry.identityFile != null
              ? AuthMethod.key
              : AuthMethod.password,
          sshKeyId: sshKeyId,
          color: ColorConstants.defaultServerColor,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await serverNotifier.createServer(server, const ServerCredentials());
        importedCount++;
      } catch (_) {
        // Skip entries that fail
      }
    }

    ref.invalidate(serverListProvider);
    ref.invalidate(folderGroupedServersProvider);

    if (context.mounted) {
      final messages = <String>[];
      if (importedCount > 0) {
        messages.add(l10n.sshConfigImportSuccess(importedCount));
      }
      if (keysImported > 0) {
        messages.add(l10n.sshConfigKeysImported(keysImported));
      }
      if (messages.isNotEmpty) {
        AdaptiveNotification.show(context, message: messages.join('. '));
      }
    }
  }

  /// Reads each identity file and matches it against the vault by private-
  /// key content, without writing anything. [entries] must already be
  /// deduplicated by `identityFile`.
  static Future<
    ({Map<String, String> existingIdByPath, List<_NewKeyImport> newKeys})
  >
  _resolveKeyImports(WidgetRef ref, List<SshConfigEntry> entries) async {
    final useCases = ref.read(sshKeyUseCasesProvider);
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';

    final existingByContent = <String, String>{};
    final existingResult = await useCases.getAllSshKeys();
    final existingKeys = existingResult.fold(
      onSuccess: (k) => k,
      onFailure: (_) => <SshKeyEntity>[],
    );
    for (final k in existingKeys) {
      final pkResult = await useCases.getSshKeyPrivateKey(k.id);
      pkResult.fold(
        onSuccess: (priv) {
          if (priv != null && priv.isNotEmpty) {
            existingByContent[priv.trim()] = k.id;
          }
        },
        onFailure: (_) {},
      );
    }

    final existingIdByPath = <String, String>{};
    final newKeys = <_NewKeyImport>[];

    for (final entry in entries) {
      try {
        final originalPath = entry.identityFile!;
        var path = originalPath;
        if (path.startsWith('~/')) {
          path = '$home${path.substring(1)}';
        }
        final keyFile = File(path);
        if (!keyFile.existsSync()) continue;

        final privateKey = (await keyFile.readAsString()).trim();
        final existingId = existingByContent[privateKey];
        if (existingId != null) {
          existingIdByPath[originalPath] = existingId;
          continue;
        }

        newKeys.add(
          _NewKeyImport(
            originalPath: originalPath,
            entryName: entry.name,
            privateKey: privateKey,
            keyType: _detectKeyType(privateKey),
            keyName: path.split(Platform.pathSeparator).last,
          ),
        );
      } catch (_) {
        // Skip keys that fail to read
      }
    }
    return (existingIdByPath: existingIdByPath, newKeys: newKeys);
  }

  /// Writes the given (already vault-checked, genuinely new) keys.
  static Future<({Map<String, String> idByPath, int count})> _persistNewKeys(
    WidgetRef ref,
    List<_NewKeyImport> newKeys,
  ) async {
    final keyNotifier = ref.read(sshKeyListProvider.notifier);
    final idByPath = <String, String>{};
    var count = 0;
    for (final key in newKeys) {
      try {
        final created = await keyNotifier.createSshKey(
          SshKeyEntity(
            id: '',
            name: key.keyName,
            keyType: key.keyType,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          privateKey: key.privateKey,
        );
        idByPath[key.originalPath] = created.id;
        count++;
      } catch (_) {
        // Skip keys that fail to import
      }
    }
    return (idByPath: idByPath, count: count);
  }

  static SshKeyType _detectKeyType(String privateKey) {
    if (privateKey.contains('BEGIN OPENSSH PRIVATE KEY')) {
      // Heuristic: check the key data for type hints
      if (privateKey.contains('ssh-ed25519')) return SshKeyType.ed25519;
      if (privateKey.contains('ecdsa-sha2')) return SshKeyType.ecdsa256;
      return SshKeyType.ed25519; // Modern default
    }
    if (privateKey.contains('BEGIN RSA PRIVATE KEY') ||
        privateKey.contains('BEGIN PRIVATE KEY')) {
      return SshKeyType.rsa;
    }
    if (privateKey.contains('BEGIN EC PRIVATE KEY')) {
      return SshKeyType.ecdsa256;
    }
    return SshKeyType.ed25519;
  }
}

/// An identity file confirmed (by content) to not already exist in the
/// vault, and thus a genuine candidate for import.
class _NewKeyImport {
  final String originalPath;
  final String entryName;
  final String privateKey;
  final SshKeyType keyType;
  final String keyName;

  _NewKeyImport({
    required this.originalPath,
    required this.entryName,
    required this.privateKey,
    required this.keyType,
    required this.keyName,
  });
}
