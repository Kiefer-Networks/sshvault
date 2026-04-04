import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sshvault/core/constants/app_colors.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/utils/date_formatter.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/features/account/presentation/providers/account_providers.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

final _currentDeviceIdProvider = FutureProvider<String?>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  final result = await storage.getDeviceId();
  return result.isSuccess ? result.value : null;
});

class AccountSyncScreen extends ConsumerStatefulWidget {
  const AccountSyncScreen({super.key});

  @override
  ConsumerState<AccountSyncScreen> createState() => _AccountSyncScreenState();
}

class _AccountSyncScreenState extends ConsumerState<AccountSyncScreen> {
  late final AppLifecycleListener _lifecycleListener;
  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        ref.invalidate(serverReachableProvider);
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
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
      title: l10n.settingsAccountAndSync,
      body: ListView(
        padding: Spacing.paddingHorizontalLgVerticalSm,
        children: [
          // Server Reachability Banner
          if (isAuthenticated) ...[
            Builder(
              builder: (context) {
                final reachable = ref.watch(serverReachableProvider);
                if (reachable.value == false || reachable.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.lg),
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
                          Spacing.verticalXxs,
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

          // Login Card for unauthenticated users
          if (!isAuthenticated) ...[
            SectionCard(
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_sync_outlined,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  Spacing.verticalLg,
                  Text(
                    l10n.authWhyLogin,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Spacing.verticalLg,
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final serverUrl =
                            ref.read(settingsProvider).value?.serverUrl ?? '';
                        if (serverUrl.isEmpty) {
                          await context.push('/server-config');
                          if (!context.mounted) return;
                          final updatedUrl =
                              ref.read(settingsProvider).value?.serverUrl ?? '';
                          if (updatedUrl.isEmpty) return;
                        }
                        if (context.mounted) context.push('/login');
                      },
                      icon: const Icon(Icons.login),
                      label: Text(l10n.authLogin),
                    ),
                  ),
                  Spacing.verticalSm,
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final serverUrl =
                            ref.read(settingsProvider).value?.serverUrl ?? '';
                        if (serverUrl.isEmpty) {
                          await context.push('/server-config');
                          if (!context.mounted) return;
                          final updatedUrl =
                              ref.read(settingsProvider).value?.serverUrl ?? '';
                          if (updatedUrl.isEmpty) return;
                        }
                        if (context.mounted) context.push('/register');
                      },
                      icon: const Icon(Icons.person_add_outlined),
                      label: Text(l10n.authRegister),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.verticalLg,
          ],

          // User Card
          if (isAuthenticated) ...[
            SectionHeader(title: l10n.accountTitle),
            SectionCard(child: _buildUserCard(l10n, theme)),
            Spacing.verticalLg,
          ],

          // Sync Controls
          if (isAuthenticated) ...[
            SectionHeader(title: l10n.syncTitle),
            SettingsGroupCard(
              children: [
                SettingsSwitchTile(
                  icon: Icons.sync,
                  iconColor: AppColors.iconLightBlue,
                  title: l10n.syncAutoSync,
                  subtitleText: l10n.syncAutoSyncDescription,
                  value: settings?.autoSync ?? true,
                  onChanged: (v) {
                    ref.read(settingsProvider.notifier).setAutoSync(v);
                  },
                ),
                if (settings?.autoSync ?? false)
                  Builder(
                    builder: (context) {
                      final interval = settings?.autoSyncIntervalMinutes ?? 5;
                      return SettingsTile(
                        icon: Icons.timer_outlined,
                        iconColor: AppColors.iconTeal,
                        title: l10n.autoSyncInterval,
                        subtitleText: l10n.autoSyncIntervalValue(interval),
                        onTap: () => _showIntervalPicker(l10n, interval),
                      );
                    },
                  ),
                SettingsTile(
                  icon: isSyncing
                      ? Icons.hourglass_top
                      : Icons.cloud_sync_outlined,
                  iconColor: AppColors.iconBlue,
                  title: l10n.syncNow,
                  subtitle: _buildSyncStatus(l10n, syncState),
                  onTap: isSyncing
                      ? null
                      : () => ref.read(syncProvider.notifier).sync(),
                ),
                SettingsTile(
                  icon: Icons.history,
                  iconColor: AppColors.iconGrey,
                  title: l10n.syncVaultVersion,
                  subtitleText: 'v${settings?.localVaultVersion ?? 0}',
                ),
              ],
            ),
          ],

          // Devices Card
          if (isAuthenticated) ...[
            Spacing.verticalLg,
            SectionHeader(title: l10n.accountDevices),
            SectionCard(child: _buildDevicesCard(l10n, theme)),
          ],

          // Account Actions
          if (isAuthenticated) ...[
            Spacing.verticalLg,
            SectionHeader(title: l10n.accountTitle),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.history_outlined,
                  iconColor: AppColors.iconBlueGrey,
                  title: l10n.auditLogTitle,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onTap: () => context.push('/audit-log'),
                ),
                SettingsTile(
                  icon: Icons.lock_outlined,
                  iconColor: AppColors.iconIndigo,
                  title: l10n.accountChangePassword,
                  onTap: () => _changePassword(l10n),
                ),
                SettingsTile(
                  icon: Icons.vpn_key_outlined,
                  iconColor: AppColors.iconTeal,
                  title: l10n.changeEncryptionPassword,
                  onTap: () => _changeEncryptionPassword(l10n),
                ),
                SettingsTile(
                  icon: Icons.devices_other,
                  iconColor: AppColors.iconOrange,
                  title: l10n.logoutAllDevices,
                  onTap: () => _logoutAllDevices(l10n),
                ),
                SettingsTile(
                  icon: Icons.delete_forever,
                  iconColor: theme.colorScheme.error,
                  title: l10n.accountDeleteAccount,
                  onTap: () => _deleteAccount(l10n),
                ),
              ],
            ),
            Spacing.verticalSm,
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.logout,
                  iconColor: theme.colorScheme.error,
                  title: l10n.accountLogout,
                  onTap: () => _showLogoutSheet(l10n, theme),
                ),
              ],
            ),
          ],

          // Server Configuration
          Spacing.verticalLg,
          SectionHeader(title: l10n.serverConfigTitle),
          SettingsGroupCard(
            children: [
              if (settings?.serverUrl.isNotEmpty ?? false) ...[
                SettingsTile(
                  icon: Icons.cloud_outlined,
                  iconColor: AppColors.iconBlueGrey,
                  title: l10n.serverConfigUrlLabel,
                  subtitleText: settings!.serverUrl,
                ),
                SettingsTile(
                  icon: Icons.swap_horiz,
                  iconColor: theme.colorScheme.error,
                  title: l10n.settingsChangeServer,
                  onTap: () => _changeServer(l10n),
                ),
              ] else
                SettingsTile(
                  icon: Icons.cloud_off_outlined,
                  iconColor: AppColors.iconBlueGrey,
                  title: l10n.settingsServerNotConfigured,
                  subtitleText: l10n.settingsSetupSync,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onTap: () => context.push('/server-config'),
                ),
            ],
          ),
          Spacing.verticalLg,
        ],
      ),
    );
  }

  Widget _buildUserCard(AppLocalizations l10n, ThemeData theme) {
    final profileAsync = ref.watch(userProfileProvider);
    return profileAsync.when(
      data: (user) => user == null
          ? Text(l10n.accountNotLoggedIn)
          : Row(
              children: [
                GestureDetector(
                  onTap: () => _showAvatarOptions(l10n, user.avatar),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    backgroundImage: user.avatar.isNotEmpty
                        ? MemoryImage(base64Decode(user.avatar))
                        : null,
                    child: user.avatar.isEmpty
                        ? Icon(
                            Icons.person,
                            color: theme.colorScheme.onPrimaryContainer,
                          )
                        : null,
                  ),
                ),
                Spacing.horizontalLg,
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
                            Spacing.horizontalXxs,
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

  Future<void> _showAvatarOptions(
    AppLocalizations l10n,
    String currentAvatar,
  ) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.changeAvatar),
              onTap: () => Navigator.pop(ctx, 'pick'),
            ),
            if (currentAvatar.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.removeAvatar),
                onTap: () => Navigator.pop(ctx, 'remove'),
              ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;

    if (result == 'remove') {
      await _deleteAvatar(l10n);
    } else if (result == 'pick') {
      await _pickAndUploadAvatar(l10n);
    }
  }

  Future<void> _pickAndUploadAvatar(AppLocalizations l10n) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
      imageQuality: 80,
    );
    if (picked == null || !mounted) return;

    final bytes = await picked.readAsBytes();
    if (bytes.length > 384 * 1024) {
      if (mounted) {
        AdaptiveNotification.show(context, message: l10n.avatarTooLarge);
      }
      return;
    }

    try {
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.uploadAvatar(bytes);
      result.fold(
        onSuccess: (_) {
          if (mounted) ref.invalidate(userProfileProvider);
        },
        onFailure: (f) {
          if (mounted) {
            AdaptiveNotification.show(
              context,
              message: l10n.avatarUploadFailed,
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        AdaptiveNotification.show(context, message: l10n.avatarUploadFailed);
      }
    }
  }

  Future<void> _deleteAvatar(AppLocalizations l10n) async {
    try {
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.deleteAvatar();
      result.fold(
        onSuccess: (_) {
          if (mounted) ref.invalidate(userProfileProvider);
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

  Widget _buildDevicesCard(AppLocalizations l10n, ThemeData theme) {
    final devicesAsync = ref.watch(deviceListProvider);
    final currentDeviceIdAsync = ref.watch(_currentDeviceIdProvider);
    final currentDeviceId = currentDeviceIdAsync.value;

    return devicesAsync.when(
      data: (devices) => devices.isEmpty
          ? Text(l10n.accountNoDevices)
          : Column(
              children: devices.map((d) {
                final isCurrentDevice =
                    currentDeviceId != null && d.id == currentDeviceId;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(_platformIcon(d.platform)),
                  title: Row(
                    children: [
                      Flexible(child: Text(d.name)),
                      if (isCurrentDevice) ...[
                        Spacing.horizontalSm,
                        Chip(
                          label: Text(
                            l10n.thisDevice,
                            style: theme.textTheme.labelSmall,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (d.lastSync != null)
                        Text(
                          '${l10n.accountLastSync}: ${formatDate(d.lastSync!)}',
                        ),
                      if (d.lastSeen != null)
                        Text(
                          '${l10n.deviceLastSeen}: ${formatDate(d.lastSeen!)}',
                        ),
                      if (d.lastIp != null && d.lastIp!.isNotEmpty)
                        Text('${l10n.deviceIpAddress}: ${d.lastIp}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () =>
                        _confirmDeleteDevice(d.id, d.name, isCurrentDevice),
                  ),
                );
              }).toList(),
            ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) => Text(l10n.error(errorMessage(e))),
    );
  }

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

  Future<void> _confirmDeleteDevice(
    String deviceId,
    String deviceName,
    bool isCurrentDevice,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.deviceDeleteConfirmTitle,
      message: isCurrentDevice
          ? l10n.deviceDeleteCurrentConfirmMessage
          : l10n.deviceDeleteConfirmMessage(deviceName),
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDestructive: true,
    );
    if (confirmed != true || !mounted) return;

    try {
      final repo = ref.read(accountRepositoryProvider);
      await repo.deleteDevice(deviceId);

      if (!mounted) return;

      if (isCurrentDevice) {
        final router = GoRouter.of(context);
        AdaptiveNotification.show(
          context,
          message: l10n.deviceDeletedCurrentLogout,
        );
        await ref.read(authProvider.notifier).logout(deleteLocalData: true);
        if (mounted) router.go('/');
      } else {
        ref.invalidate(deviceListProvider);
        AdaptiveNotification.show(context, message: l10n.deviceDeleteSuccess);
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

  Future<void> _changePassword(AppLocalizations l10n) async {
    final oldPw = TextEditingController();
    final newPw = TextEditingController();
    final formContent = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: oldPw,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.accountOldPassword),
          ),
          Spacing.verticalSm,
          TextField(
            controller: newPw,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.accountNewPassword),
          ),
        ],
      ),
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
    final encFormContent = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.changeEncryptionWarning,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          Spacing.verticalLg,
          TextField(
            controller: oldPw,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.changeEncryptionOldPassword,
            ),
          ),
          Spacing.verticalSm,
          TextField(
            controller: newPw,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.changeEncryptionNewPassword,
            ),
          ),
          Spacing.verticalSm,
          TextField(
            controller: confirmPw,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.authConfirmPasswordLabel,
            ),
          ),
        ],
      ),
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
              if (!mounted) return;
              final router = GoRouter.of(context);
              AdaptiveNotification.show(
                context,
                message: l10n.changeEncryptionSuccess,
              );
              await ref
                  .read(authProvider.notifier)
                  .logout(deleteLocalData: true);
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
          onSuccess: (revokedCount) async {
            if (!mounted) return;
            final router = GoRouter.of(context);
            AdaptiveNotification.show(
              context,
              message: l10n.logoutAllDevicesSuccessCount(revokedCount),
            );
            await ref.read(authProvider.notifier).logout(deleteLocalData: true);
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

  Future<void> _showLogoutSheet(AppLocalizations l10n, ThemeData theme) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Spacing.xxl, Spacing.xxl, Spacing.xxl, Spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.logoutDialogTitle, style: theme.textTheme.titleLarge),
              Spacing.verticalMd,
              Text(l10n.logoutDialogMessage, style: theme.textTheme.bodyMedium),
              Spacing.verticalXxl,
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.logoutAndDelete),
              ),
              Spacing.verticalSm,
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.logoutOnly),
              ),
            ],
          ),
        ),
      ),
    );
    if (result == null || !mounted) return;
    final router = GoRouter.of(context);
    await ref.read(authProvider.notifier).logout(deleteLocalData: result);
    if (mounted) router.go('/');
  }

  void _showIntervalPicker(AppLocalizations l10n, int current) {
    const options = [1, 3, 5, 10, 15];
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: Spacing.paddingAllLg,
              child: Text(
                l10n.autoSyncInterval,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            for (final minutes in options)
              ListTile(
                leading: minutes == current
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : const SizedBox(width: 24),
                title: Text(l10n.autoSyncIntervalValue(minutes)),
                onTap: () {
                  Navigator.pop(ctx);
                  ref
                      .read(settingsProvider.notifier)
                      .setAutoSyncInterval(minutes);
                },
              ),
          ],
        ),
      ),
    );
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
    if (confirmed == true && mounted) {
      try {
        final router = GoRouter.of(context);
        final repo = ref.read(accountRepositoryProvider);
        await repo.deleteAccount();
        await ref.read(authProvider.notifier).logout(deleteLocalData: true);
        if (mounted) router.go('/');
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

  Future<void> _changeServer(AppLocalizations l10n) async {
    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.settingsChangeServer,
      message: l10n.settingsChangeServerConfirm,
      confirmLabel: l10n.settingsChangeServer,
      cancelLabel: l10n.cancel,
      isDestructive: true,
    );
    if (confirmed != true || !mounted) return;
    final router = GoRouter.of(context);
    await ref.read(authProvider.notifier).logout(deleteLocalData: false);
    await ref.read(settingsProvider.notifier).setServerUrl('');
    if (mounted) router.go('/server-config');
  }
}
