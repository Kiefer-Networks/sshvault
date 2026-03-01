import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SyncSettingsScreen extends ConsumerWidget {
  const SyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final syncState = ref.watch(syncProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull;
    final isSyncing =
        syncState.valueOrNull == SyncStatus.syncing || syncState.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncSettingsTitle)),
      body: ListView(
        children: [
          // Auto-Sync toggle
          SwitchListTile(
            secondary: const Icon(Icons.sync),
            title: Text(l10n.syncAutoSync),
            subtitle: Text(l10n.syncAutoSyncDescription),
            value: settings?.autoSync ?? true,
            onChanged: (v) {
              ref.read(settingsProvider.notifier).setAutoSync(v);
            },
          ),
          const Divider(),

          // Manual sync
          ListTile(
            leading: isSyncing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_sync_outlined),
            title: Text(l10n.syncNow),
            subtitle: _buildSyncStatus(context, l10n, syncState),
            onTap: isSyncing
                ? null
                : () => ref.read(syncProvider.notifier).sync(),
          ),
          const Divider(),

          // Vault version
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(l10n.syncVaultVersion),
            subtitle: Text('v${settings?.localVaultVersion ?? 0}'),
          ),
        ],
      ),
    );
  }

  Widget? _buildSyncStatus(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<SyncStatus> syncState,
  ) {
    if (syncState.hasError) {
      return Text(
        '${l10n.syncError}: ${syncState.error}',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    }
    return switch (syncState.valueOrNull) {
      SyncStatus.syncing => Text(l10n.syncSyncing),
      SyncStatus.success => Text(l10n.syncSuccess),
      _ => Text(l10n.syncNeverSynced),
    };
  }
}
