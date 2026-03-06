import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/utils/date_formatter.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/features/account/domain/entities/billing_status.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/features/account/presentation/providers/subscription_purchase_provider.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:shellvault/core/storage/secure_storage_provider.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

final _pollTimedOutProvider = StateProvider.autoDispose<bool>((ref) => false);

class SyncSettingsScreen extends ConsumerStatefulWidget {
  const SyncSettingsScreen({super.key});

  @override
  ConsumerState<SyncSettingsScreen> createState() => _SyncSettingsScreenState();
}

class _SyncSettingsScreenState extends ConsumerState<SyncSettingsScreen> {
  late final AppLifecycleListener _lifecycleListener;
  Timer? _billingPollTimer;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        ref.invalidate(billingStatusProvider);
        ref.invalidate(serverReachableProvider);
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
    ref.read(_pollTimedOutProvider.notifier).state = false;
    var attempts = 0;
    _billingPollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      attempts++;
      ref.invalidate(billingStatusProvider);
      final billing = ref.read(billingStatusProvider).value;
      if (billing?.active ?? false) {
        timer.cancel();
        _billingPollTimer = null;
      } else if (attempts >= 60) {
        timer.cancel();
        _billingPollTimer = null;
        if (mounted) {
          ref.read(_pollTimedOutProvider.notifier).state = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.value == AuthStatus.authenticated;
    final syncState = ref.watch(syncProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.value;
    final isSyncing =
        syncState.value == SyncStatus.syncing || syncState.isLoading;

    return AdaptiveScaffold(
      title: l10n.syncTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 0. SERVER REACHABILITY BANNER ──
          if (isAuthenticated) ...[
            Builder(
              builder: (context) {
                final reachable = ref.watch(serverReachableProvider);
                if (reachable.value == false || reachable.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MaterialBanner(
                      leading: Icon(
                        Icons.cloud_off,
                        color: theme.colorScheme.error,
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.syncServerUnreachable,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.syncServerUnreachableHint,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      backgroundColor: theme.colorScheme.errorContainer
                          .withAlpha(77),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(serverReachableProvider),
                          child: Text(l10n.serverConfigTest),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],

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
                  ref.watch(billingStatusProvider).value?.active ?? false;
              return AdaptiveSwitchTile(
                secondary: const Icon(Icons.sync),
                title: l10n.syncAutoSync,
                subtitle: l10n.syncAutoSyncDescription,
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
              leading: const Icon(Icons.history_outlined),
              title: Text(l10n.auditLogTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/audit-log'),
            ),
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
                              color: theme.colorScheme.tertiary,
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
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) => Text(l10n.error(errorMessage(e))),
    );
  }

  // ── BILLING CARD ───────────────────────────────────────────────────────────

  Widget _buildBillingCard(AppLocalizations l10n, ThemeData theme) {
    final billingAsync = ref.watch(billingStatusProvider);
    final pollTimedOut = ref.watch(_pollTimedOutProvider);
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
                color: billing.active
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  billing.active
                      ? l10n.accountPaymentActive
                      : l10n.accountPaymentInactive,
                ),
              ),
              if (!billing.active && pollTimedOut)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: l10n.syncNow,
                  onPressed: () {
                    ref.read(_pollTimedOutProvider.notifier).state = false;
                    ref.invalidate(billingStatusProvider);
                  },
                ),
            ],
          ),
          if (!billing.active) ...[
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                final iapProduct = isNativeIapPlatform
                    ? ref.watch(subscriptionStoreProvider).value
                    : null;
                final purchaseStatus = ref.watch(
                  subscriptionPurchaseStatusProvider,
                );
                final isWorking =
                    purchaseStatus == SubscriptionPurchaseStatus.purchasing ||
                    purchaseStatus == SubscriptionPurchaseStatus.verifying;

                final priceLabel = iapProduct?.price ?? '\u20AC9.99';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isWorking ? null : _checkout,
                        icon: isWorking
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.payment),
                        label: Text(l10n.accountActivateSyncPrice(priceLabel)),
                      ),
                    ),
                    if (purchaseStatus == SubscriptionPurchaseStatus.error) ...[
                      const SizedBox(height: 8),
                      Text(
                        ref.watch(subscriptionPurchaseErrorProvider) ??
                            l10n.purchaseFailed,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
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
                );
              },
            ),
          ],
          if (billing.active) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openSubscriptionManagement(billing),
                icon: Icon(
                  billing.provider == 'apple' || billing.provider == 'google'
                      ? Icons.store_outlined
                      : Icons.receipt_long_outlined,
                ),
                label: Text(l10n.accountManageSubscription),
              ),
            ),
          ],
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) => Text(l10n.error(errorMessage(e))),
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
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (e, _) => Text(l10n.error(errorMessage(e))),
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
      final error = syncState.error;
      final String message;
      if (error is NetworkFailure) {
        message = l10n.syncNetworkError;
      } else {
        message = '${l10n.syncError}: $error';
      }
      return Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    }
    return switch (syncState.value) {
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
    if (isNativeIapPlatform) {
      final store = ref.read(subscriptionStoreProvider.notifier);
      await store.subscribe();
      _startBillingPoll();
      return;
    }

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
        AdaptiveNotification.show(
          context,
          message: AppLocalizations.of(context)!.error(errorMessage(e)),
        );
      }
    }
  }

  Future<void> _openSubscriptionManagement(BillingStatus billing) async {
    switch (billing.provider) {
      case 'apple':
        await launchUrl(
          Uri.parse('https://apps.apple.com/account/subscriptions'),
          mode: LaunchMode.externalApplication,
        );
        return;
      case 'google':
        await launchUrl(
          Uri.parse('https://play.google.com/store/account/subscriptions'),
          mode: LaunchMode.externalApplication,
        );
        return;
    }

    // Stripe (or unknown) → Stripe Billing Portal
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
        AdaptiveNotification.show(
          context,
          message: AppLocalizations.of(context)!.error(errorMessage(e)),
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
        AdaptiveNotification.show(
          context,
          message: AppLocalizations.of(context)!.error(errorMessage(e)),
        );
      }
    }
  }

  Future<void> _changePassword(AppLocalizations l10n) async {
    final oldPw = TextEditingController();
    final newPw = TextEditingController();
    final formContent = Column(
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
    );
    final result = await showAdaptiveFormDialog<bool>(
      context,
      title: l10n.accountChangePassword,
      content: formContent,
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.save),
        ),
      ],
    );
    if (result == true) {
      if (oldPw.text.isEmpty || newPw.text.isEmpty) {
        if (mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.error(l10n.validatorPasswordRequired),
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
          AdaptiveNotification.show(
            context,
            message: l10n.accountChangePassword,
          );
        }
      } catch (e) {
        if (mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.error(errorMessage(e)),
          );
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
    final encFormContent = Column(
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
          decoration: InputDecoration(labelText: l10n.authConfirmPasswordLabel),
        ),
      ],
    );
    final result = await showAdaptiveFormDialog<bool>(
      context,
      title: l10n.changeEncryptionPassword,
      content: encFormContent,
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.save),
        ),
      ],
    );
    if (result == true) {
      if (oldPw.text.isEmpty || newPw.text.isEmpty) {
        if (mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.error(l10n.validatorPasswordRequired),
          );
        }
      } else if (newPw.text != confirmPw.text) {
        if (mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.authPasswordMismatch,
          );
        }
      } else if (newPw.text.length < 8) {
        if (mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.error('Password must be at least 8 characters'),
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
                AdaptiveNotification.show(
                  context,
                  message: l10n.changeEncryptionSuccess,
                );
              }
            },
            onFailure: (f) {
              if (mounted) {
                AdaptiveNotification.show(
                  context,
                  message: l10n.error(f.toString()),
                );
              }
            },
          );
        } catch (e) {
          if (mounted) {
            AdaptiveNotification.show(
              context,
              message: l10n.error(errorMessage(e)),
            );
          }
        }
      }
    }
    oldPw.dispose();
    newPw.dispose();
    confirmPw.dispose();
  }

  Future<void> _logoutAllDevices(AppLocalizations l10n) async {
    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.logoutAllDevices,
      message: l10n.logoutAllDevicesConfirm,
      confirmLabel: l10n.logoutAllDevices,
      cancelLabel: l10n.cancel,
      isDestructive: true,
    );
    if (confirmed == true) {
      try {
        final repo = ref.read(accountRepositoryProvider);
        final result = await repo.logoutAllDevices();
        result.fold(
          onSuccess: (_) async {
            if (!mounted) return;
            final router = GoRouter.of(context);
            AdaptiveNotification.show(
              context,
              message: l10n.logoutAllDevicesSuccess,
            );
            // Logout locally as well
            await ref.read(authProvider.notifier).logout();
            if (mounted) router.go('/');
          },
          onFailure: (f) {
            if (mounted) {
              AdaptiveNotification.show(
                context,
                message: l10n.error(f.toString()),
              );
            }
          },
        );
      } catch (e) {
        if (mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.error(errorMessage(e)),
          );
        }
      }
    }
  }

  Future<void> _deleteAccount(AppLocalizations l10n) async {
    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.accountDeleteAccount,
      message: l10n.accountDeleteWarning,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDestructive: true,
    );
    if (confirmed == true) {
      try {
        final repo = ref.read(accountRepositoryProvider);
        await repo.deleteAccount();
        await ref.read(authProvider.notifier).logout();
        if (mounted) context.go('/');
      } catch (e) {
        if (mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.error(errorMessage(e)),
          );
        }
      }
    }
  }
}
