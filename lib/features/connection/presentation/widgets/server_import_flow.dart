import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/color_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/crypto/ssh_key_type.dart';
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

final _sshConfigImportedProvider = StateProvider<bool>((ref) => false);

/// Add-host entry point shared by the mobile [ServerListScreen] and the
/// desktop Operations Console: on desktop with a readable `~/.ssh/config`
/// it offers to import first, otherwise it falls through to the manual
/// server form.
abstract final class ServerImportFlow {
  static bool get _isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  static void addServer(BuildContext context, WidgetRef ref) {
    if (!_isDesktop || !SshConfigParser.configExists) {
      context.push('/server/new');
      return;
    }

    final alreadyImported = ref.read(_sshConfigImportedProvider);
    if (alreadyImported) {
      _askReimportOrManual(context, ref);
    } else {
      _showSshConfigImportDialog(context, ref);
    }
  }

  static Future<void> _askReimportOrManual(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.sshConfigImportTitle),
        content: Text(l10n.sshConfigImportAgain),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.sshConfigAddManually),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.sshConfigImportButton),
          ),
        ],
      ),
    );

    if (!context.mounted) return;
    if (result == true) {
      _showSshConfigImportDialog(context, ref);
    } else {
      context.push('/server/new');
    }
  }

  static Future<void> _showSshConfigImportDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final entries = await SshConfigParser.parse();

    if (!context.mounted) return;

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
              FilledButton(
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

    // Check if any selected entries reference identity files. Multiple
    // server entries may share the same identity file — collapse them so
    // we never offer to import the same key file twice in the dialog.
    final entriesWithKeys = toImport
        .where((e) => e.identityFile != null)
        .toList();
    final uniqueKeyPaths = <String, SshConfigEntry>{};
    for (final e in entriesWithKeys) {
      uniqueKeyPaths.putIfAbsent(e.identityFile!, () => e);
    }
    var importKeys = false;
    if (uniqueKeyPaths.isNotEmpty && context.mounted) {
      importKeys =
          await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.sshConfigImportKeys),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final e in uniqueKeyPaths.values)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.vpn_key_outlined, size: 20),
                      title: Text(e.identityFile!),
                      subtitle: Text(e.name),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(l10n.sshConfigImportButton),
                ),
              ],
            ),
          ) ??
          false;
    }

    // Import SSH keys first so we can link them to servers. Pass the
    // deduplicated key list so each unique identity file is processed once.
    var keysImported = 0;
    final keyIdByPath = <String, String>{};
    if (importKeys) {
      final result = await _importSshKeys(ref, uniqueKeyPaths.values.toList());
      keysImported = result.newlyImported;
      keyIdByPath.addAll(result.idByPath);
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

    // Mark as imported and refresh providers
    ref.read(_sshConfigImportedProvider.notifier).state = true;
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

  /// Imports SSH keys, deduplicating against keys already in the vault.
  ///
  /// [entries] must already be deduplicated by `identityFile` so we only
  /// touch each on-disk file once.
  ///
  /// Existing keys are matched by their stored private-key content; an
  /// existing match means we reuse the existing id and do not create a
  /// duplicate row.
  static Future<({Map<String, String> idByPath, int newlyImported})>
  _importSshKeys(WidgetRef ref, List<SshConfigEntry> entries) async {
    final keyNotifier = ref.read(sshKeyListProvider.notifier);
    final useCases = ref.read(sshKeyUseCasesProvider);
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';

    // Build a content → existingKeyId index from the current vault.
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

    final idByPath = <String, String>{};
    var newlyImported = 0;

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
          // Already in vault — reuse it, do not create a duplicate.
          idByPath[originalPath] = existingId;
          continue;
        }

        final keyType = _detectKeyType(privateKey);
        final keyName = path.split(Platform.pathSeparator).last;
        final created = await keyNotifier.createSshKey(
          SshKeyEntity(
            id: '',
            name: keyName,
            keyType: keyType,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          privateKey: privateKey,
        );
        idByPath[originalPath] = created.id;
        existingByContent[privateKey] = created.id;
        newlyImported++;
      } catch (_) {
        // Skip keys that fail to read or import
      }
    }
    return (idByPath: idByPath, newlyImported: newlyImported);
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
