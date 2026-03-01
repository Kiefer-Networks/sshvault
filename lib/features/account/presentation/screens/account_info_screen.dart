import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class AccountInfoScreen extends ConsumerWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);
    final billingAsync = ref.watch(billingStatusProvider);
    final devicesAsync = ref.watch(deviceListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: profileAsync.when(
                data: (user) => user == null
                    ? Text(l10n.accountNotLoggedIn)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Icon(Icons.person,
                                    color:
                                        theme.colorScheme.onPrimaryContainer),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.email,
                                        style:
                                            theme.textTheme.titleMedium),
                                    if (user.verified)
                                      Row(
                                        children: [
                                          Icon(Icons.verified,
                                              size: 16,
                                              color: Colors.green.shade600),
                                          const SizedBox(width: 4),
                                          Text(l10n.accountVerified,
                                              style:
                                                  theme.textTheme.bodySmall),
                                        ],
                                      ),
                                    if (user.createdAt != null)
                                      Text(
                                        '${l10n.accountMemberSince} ${_formatDate(user.createdAt!)}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(l10n.error(e.toString())),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Billing status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: billingAsync.when(
                data: (billing) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.accountPaymentStatus,
                        style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          billing.active
                              ? Icons.check_circle
                              : Icons.cancel_outlined,
                          color: billing.active ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(billing.active
                            ? l10n.accountPaymentActive
                            : l10n.accountPaymentInactive),
                      ],
                    ),
                    if (!billing.active) ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => _checkout(ref),
                        icon: const Icon(Icons.payment),
                        label: Text(l10n.accountUnlockSync),
                      ),
                    ],
                  ],
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(l10n.error(e.toString())),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Devices
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.accountDevices,
                      style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  devicesAsync.when(
                    data: (devices) => devices.isEmpty
                        ? Text(l10n.accountNoDevices)
                        : Column(
                            children: devices
                                .map((d) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(_platformIcon(d.platform)),
                                      title: Text(d.name),
                                      subtitle: d.lastSync != null
                                          ? Text(
                                              '${l10n.accountLastSync}: ${_formatDate(d.lastSync!)}')
                                          : null,
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline,
                                            size: 20),
                                        onPressed: () =>
                                            _deleteDevice(ref, d.id),
                                      ),
                                    ))
                                .toList(),
                          ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text(l10n.error(e.toString())),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Actions
          ListTile(
            leading: const Icon(Icons.lock_outlined),
            title: Text(l10n.accountChangePassword),
            onTap: () => _changePassword(context, ref, l10n),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever,
                color: theme.colorScheme.error),
            title: Text(l10n.accountDeleteAccount,
                style: TextStyle(color: theme.colorScheme.error)),
            onTap: () => _deleteAccount(context, ref, l10n),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.accountLogout),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/');
            },
          ),
        ],
      ),
    );
  }

  IconData _platformIcon(String platform) {
    return switch (platform.toLowerCase()) {
      'ios' => Icons.phone_iphone,
      'android' => Icons.phone_android,
      'macos' => Icons.laptop_mac,
      'windows' => Icons.laptop_windows,
      'linux' => Icons.computer,
      'web' => Icons.language,
      _ => Icons.devices,
    };
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }

  Future<void> _checkout(WidgetRef ref) async {
    final repo = ref.read(accountRepositoryProvider);
    final result = await repo.createCheckout();
    if (result.isSuccess && result.value.isNotEmpty) {
      final uri = Uri.tryParse(result.value);
      if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _deleteDevice(WidgetRef ref, String deviceId) async {
    final repo = ref.read(accountRepositoryProvider);
    await repo.deleteDevice(deviceId);
    ref.invalidate(deviceListProvider);
  }

  Future<void> _changePassword(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final oldPw = TextEditingController();
    final newPw = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.accountChangePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPw,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: l10n.accountOldPassword),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newPw,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: l10n.accountNewPassword),
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
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (result == true) {
      final repo = ref.read(accountRepositoryProvider);
      await repo.changePassword(oldPw.text, newPw.text);
    }
    oldPw.dispose();
    newPw.dispose();
  }

  Future<void> _deleteAccount(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.accountDeleteAccount),
        content: Text(l10n.accountDeleteWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final repo = ref.read(accountRepositoryProvider);
      await repo.deleteAccount();
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) context.go('/');
    }
  }
}
