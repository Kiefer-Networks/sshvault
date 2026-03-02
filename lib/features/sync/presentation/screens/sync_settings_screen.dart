import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shellvault/core/utils/date_formatter.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:shellvault/core/storage/secure_storage_provider.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SyncSettingsScreen extends ConsumerStatefulWidget {
  const SyncSettingsScreen({super.key});

  @override
  ConsumerState<SyncSettingsScreen> createState() => _SyncSettingsScreenState();
}

class _SyncSettingsScreenState extends ConsumerState<SyncSettingsScreen> {
  late final AppLifecycleListener _lifecycleListener;
  Timer? _billingPollTimer;
  bool _pollTimedOut = false;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        ref.invalidate(billingStatusProvider);
      },
    );
  }

  @override
  void dispose() {
    _billingPollTimer?.cancel();
    _lifecycleListener.dispose();
    super.dispose();
  }

  void _startBillingPoll() {
    _billingPollTimer?.cancel();
    setState(() => _pollTimedOut = false);
    var attempts = 0;
    _billingPollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      attempts++;
      ref.invalidate(billingStatusProvider);
      final billing = ref.read(billingStatusProvider).valueOrNull;
      if (billing?.active ?? false) {
        timer.cancel();
        _billingPollTimer = null;
      } else if (attempts >= 60) {
        // Stop after 5 minutes (60 × 5s), show manual refresh
        timer.cancel();
        _billingPollTimer = null;
        if (mounted) setState(() => _pollTimedOut = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.valueOrNull == AuthStatus.authenticated;
    final syncState = ref.watch(syncProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull;
    final isSyncing =
        syncState.valueOrNull == SyncStatus.syncing || syncState.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 1. USER CARD ──
          if (isAuthenticated) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildUserCard(l10n, theme),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── 2. BILLING CARD ──
          if (isAuthenticated) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildBillingCard(l10n, theme),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── 3. SYNC CONTROLS ──
          Builder(
            builder: (context) {
              final billingActive =
                  ref.watch(billingStatusProvider).valueOrNull?.active ?? false;
              return SwitchListTile(
                secondary: const Icon(Icons.sync),
                title: Text(l10n.syncAutoSync),
                subtitle: Text(l10n.syncAutoSyncDescription),
                value: billingActive && (settings?.autoSync ?? true),
                onChanged: billingActive
                    ? (v) {
                        ref.read(settingsProvider.notifier).setAutoSync(v);
                      }
                    : null,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: isSyncing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_sync_outlined),
            title: Text(l10n.syncNow),
            subtitle: _buildSyncStatus(l10n, syncState),
            onTap: isSyncing
                ? null
                : () => ref.read(syncProvider.notifier).sync(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(l10n.syncVaultVersion),
            subtitle: Text('v${settings?.localVaultVersion ?? 0}'),
          ),

          // ── 4. DEVICES CARD ──
          if (isAuthenticated) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildDevicesCard(l10n, theme),
              ),
            ),
          ],

          // ── 5. ACCOUNT ACTIONS ──
          if (isAuthenticated) ...[
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.lock_outlined),
              title: Text(l10n.accountChangePassword),
              onTap: () => _changePassword(l10n),
            ),
            ListTile(
              leading: const Icon(Icons.vpn_key_outlined),
              title: Text(l10n.changeEncryptionPassword),
              onTap: () => _changeEncryptionPassword(l10n),
            ),
            ListTile(
              leading: const Icon(Icons.devices_other),
              title: Text(l10n.logoutAllDevices),
              onTap: () => _logoutAllDevices(l10n),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_forever,
                color: theme.colorScheme.error,
              ),
              title: Text(
                l10n.accountDeleteAccount,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: () => _deleteAccount(l10n),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.accountLogout),
              onTap: () async {
                final router = GoRouter.of(context);
                await ref.read(authProvider.notifier).logout();
                if (mounted) router.go('/');
              },
            ),
          ],
        ],
      ),
    );
  }

  // ── USER CARD ──────────────────────────────────────────────────────────────

  Widget _buildUserCard(AppLocalizations l10n, ThemeData theme) {
    final profileAsync = ref.watch(userProfileProvider);
    return profileAsync.when(
      data: (user) => user == null
          ? Text(l10n.accountNotLoggedIn)
          : Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email, style: theme.textTheme.titleMedium),
                      if (user.verified)
                        Row(
                          children: [
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.accountVerified,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      if (user.createdAt != null)
                        Text(
                          '${l10n.accountMemberSince} ${formatDate(user.createdAt!)}',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text(l10n.error(e.toString())),
    );
  }

  // ── BILLING CARD ───────────────────────────────────────────────────────────

  Widget _buildBillingCard(AppLocalizations l10n, ThemeData theme) {
    final billingAsync = ref.watch(billingStatusProvider);
    return billingAsync.when(
      data: (billing) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.accountPaymentStatus, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                billing.active ? Icons.check_circle : Icons.cancel_outlined,
                color: billing.active ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  billing.active
                      ? l10n.accountPaymentActive
                      : l10n.accountPaymentInactive,
                ),
              ),
              if (!billing.active && _pollTimedOut)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: l10n.syncNow,
                  onPressed: () {
                    setState(() => _pollTimedOut = false);
                    ref.invalidate(billingStatusProvider);
                  },
                ),
            ],
          ),
          if (!billing.active) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _checkout,
                icon: const Icon(Icons.payment),
                label: Text(
                  l10n.accountActivateSyncPrice(
                    isNativeIapPlatform ? '€12.99' : '€9.99',
                  ),
                ),
              ),
            ),
            if (isNativeIapPlatform) ...[
              const SizedBox(height: 8),
              Text(
                l10n.accountStoreFeeNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
          if (billing.active) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openSubscriptionManagement,
                icon: Icon(
                  isNativeIapPlatform
                      ? Icons.store_outlined
                      : Icons.receipt_long_outlined,
                ),
                label: Text(l10n.accountManageSubscription),
              ),
            ),
          ],
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text(l10n.error(e.toString())),
    );
  }

  // ── DEVICES CARD ───────────────────────────────────────────────────────────

  Widget _buildDevicesCard(AppLocalizations l10n, ThemeData theme) {
    final devicesAsync = ref.watch(deviceListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.accountDevices, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        devicesAsync.when(
          data: (devices) => devices.isEmpty
              ? Text(l10n.accountNoDevices)
              : Column(
                  children: devices
                      .map(
                        (d) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(_platformIcon(d.platform)),
                          title: Text(d.name),
                          subtitle: d.lastSync != null
                              ? Text(
                                  '${l10n.accountLastSync}: ${formatDate(d.lastSync!)}',
                                )
                              : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () => _deleteDevice(d.id),
                          ),
                        ),
                      )
                      .toList(),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(l10n.error(e.toString())),
        ),
      ],
    );
  }

  // ── SYNC STATUS ────────────────────────────────────────────────────────────

  Widget? _buildSyncStatus(
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

  // ── HELPERS ────────────────────────────────────────────────────────────────

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

  Future<void> _checkout() async {
    try {
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.createCheckout();
      if (result.isSuccess && result.value.isNotEmpty) {
        final uri = Uri.tryParse(result.value);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          _startBillingPoll();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error(e.toString())),
          ),
        );
      }
    }
  }

  Future<void> _openSubscriptionManagement() async {
    if (isNativeIapPlatform) {
      // Open the respective store's subscription management
      final Uri storeUri;
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        storeUri = Uri.parse(
          'https://play.google.com/store/account/subscriptions',
        );
      } else {
        // iOS + macOS → Apple App Store
        storeUri = Uri.parse('https://apps.apple.com/account/subscriptions');
      }
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
      return;
    }

    // Desktop / Web → Stripe Billing Portal
    try {
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.createPortal();
      if (result.isSuccess && result.value.isNotEmpty) {
        final uri = Uri.tryParse(result.value);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error(e.toString())),
          ),
        );
      }
    }
  }

  Future<void> _deleteDevice(String deviceId) async {
    try {
      final repo = ref.read(accountRepositoryProvider);
      await repo.deleteDevice(deviceId);
      ref.invalidate(deviceListProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error(e.toString())),
          ),
        );
      }
    }
  }

  Future<void> _changePassword(AppLocalizations l10n) async {
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
              decoration: InputDecoration(labelText: l10n.accountOldPassword),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newPw,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.accountNewPassword),
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
      if (oldPw.text.isEmpty || newPw.text.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.error(l10n.validatorPasswordRequired))),
          );
        }
        oldPw.dispose();
        newPw.dispose();
        return;
      }
      try {
        final repo = ref.read(accountRepositoryProvider);
        await repo.changePassword(oldPw.text, newPw.text);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.accountChangePassword)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
        }
      }
    }
    oldPw.dispose();
    newPw.dispose();
  }

  Future<void> _changeEncryptionPassword(AppLocalizations l10n) async {
    final oldPw = TextEditingController();
    final newPw = TextEditingController();
    final confirmPw = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.changeEncryptionPassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.changeEncryptionWarning,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: oldPw,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.changeEncryptionOldPassword,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: newPw,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.changeEncryptionNewPassword,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: confirmPw,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.authConfirmPasswordLabel,
              ),
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
      if (oldPw.text.isEmpty || newPw.text.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.error(l10n.validatorPasswordRequired))),
          );
        }
      } else if (newPw.text != confirmPw.text) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.authPasswordMismatch)));
        }
      } else if (newPw.text.length < 8) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.error('Password must be at least 8 characters'),
              ),
            ),
          );
        }
      } else {
        try {
          final useCases = ref.read(syncUseCasesProvider);
          final changeResult = await useCases.changeEncryptionPassword(
            oldPw.text,
            newPw.text,
          );
          changeResult.fold(
            onSuccess: (_) async {
              // Save new password in secure storage
              final storage = ref.read(secureStorageProvider);
              await storage.saveSyncPassword(newPw.text);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.changeEncryptionSuccess)),
                );
              }
            },
            onFailure: (f) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.error(f.toString()))),
                );
              }
            },
          );
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
          }
        }
      }
    }
    oldPw.dispose();
    newPw.dispose();
    confirmPw.dispose();
  }

  Future<void> _logoutAllDevices(AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logoutAllDevices),
        content: Text(l10n.logoutAllDevicesConfirm),
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
            child: Text(l10n.logoutAllDevices),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        final repo = ref.read(accountRepositoryProvider);
        final result = await repo.logoutAllDevices();
        result.fold(
          onSuccess: (_) async {
            if (!mounted) return;
            final messenger = ScaffoldMessenger.of(context);
            final router = GoRouter.of(context);
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.logoutAllDevicesSuccess)),
            );
            // Logout locally as well
            await ref.read(authProvider.notifier).logout();
            if (mounted) router.go('/');
          },
          onFailure: (f) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.error(f.toString()))));
            }
          },
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
        }
      }
    }
  }

  Future<void> _deleteAccount(AppLocalizations l10n) async {
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
      try {
        final repo = ref.read(accountRepositoryProvider);
        await repo.deleteAccount();
        await ref.read(authProvider.notifier).logout();
        if (mounted) context.go('/');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
        }
      }
    }
  }
}
