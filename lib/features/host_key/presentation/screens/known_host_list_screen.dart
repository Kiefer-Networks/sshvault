import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/host_key/domain/entities/known_host_entity.dart';
import 'package:sshvault/features/host_key/presentation/providers/known_host_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class KnownHostListScreen extends ConsumerWidget {
  const KnownHostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hostsAsync = ref.watch(knownHostListProvider);

    return AdaptiveScaffold(
      title: l10n.knownHostsTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep),
          tooltip: l10n.hostKeyDeleteAll,
          onPressed: () => _confirmDeleteAll(context, ref, l10n),
        ),
      ],
      body: hostsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.error(errorMessage(e)))),
        data: (hosts) {
          if (hosts.isEmpty) {
            return _EmptyState(l10n: l10n);
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: hosts.length,
            itemBuilder: (context, index) {
              final host = hosts[index];
              return _KnownHostTile(
                host: host,
                onDelete: () => _deleteHost(ref, host.id),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDeleteAll(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.hostKeyDeleteAll),
        content: Text(l10n.hostKeyDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final repo = ref.read(knownHostRepositoryProvider);
      await repo.deleteAll();
      ref.invalidate(knownHostListProvider);
    }
  }

  void _deleteHost(WidgetRef ref, String id) {
    final repo = ref.read(knownHostRepositoryProvider);
    repo.delete(id);
    ref.invalidate(knownHostListProvider);
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fingerprint,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.hostKeyEmpty,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.hostKeyEmptySubtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _KnownHostTile extends StatelessWidget {
  final KnownHostEntity host;
  final VoidCallback onDelete;

  const _KnownHostTile({required this.host, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final fp = _formatFingerprint(host.fingerprint);
    final truncatedFp = fp.length > 24 ? '${fp.substring(0, 24)}...' : fp;

    return Dismissible(
      key: ValueKey(host.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: colorScheme.error,
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: const Icon(Icons.fingerprint),
        title: Text(
          AppLocalizations.of(context)!.hostPortLabel(host.hostname, host.port),
        ),
        subtitle: Text(
          '${host.keyType}  $truncatedFp',
          style: textTheme.bodySmall?.copyWith(
            fontFamily: AppConstants.monospaceFontFamily,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }

  static String _formatFingerprint(String hex) {
    if (hex.contains(':')) return hex;
    final buf = StringBuffer();
    for (int i = 0; i < hex.length; i += 2) {
      if (i > 0) buf.write(':');
      buf.write(hex.substring(i, (i + 2).clamp(0, hex.length)));
    }
    return buf.toString();
  }
}
