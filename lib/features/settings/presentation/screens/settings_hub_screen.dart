import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/constants/app_colors.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/features/account/presentation/providers/account_providers.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class SettingsHubScreen extends ConsumerWidget {
  const SettingsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.value == AuthStatus.authenticated;

    return AdaptiveScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        padding: Spacing.paddingHorizontalLgVerticalSm,
        children: [
          // Account Header
          _AccountHeaderBuilder(
            isAuthenticated: isAuthenticated,
            onTap: () => context.push('/settings/account'),
          ),
          Spacing.verticalLg,

          // General
          SettingsGroupCard(
            children: [
              Semantics(
                button: true,
                label: l10n.settingsSectionAppearance,
                hint: l10n.settingsAppearanceSubtitle,
                child: SettingsCategoryTile(
                  icon: Icons.palette_outlined,
                  iconColor: colorScheme.primary,
                  title: l10n.settingsSectionAppearance,
                  subtitle: l10n.settingsAppearanceSubtitle,
                  onTap: () => context.push('/settings/appearance'),
                ),
              ),
              Semantics(
                button: true,
                label: l10n.settingsSectionSshDefaults,
                hint: l10n.settingsSshSubtitle,
                child: SettingsCategoryTile(
                  icon: Icons.terminal,
                  iconColor: AppColors.iconOrange,
                  title: l10n.settingsSectionSshDefaults,
                  subtitle: l10n.settingsSshSubtitle,
                  onTap: () => context.push('/settings/ssh'),
                ),
              ),
            ],
          ),
          Spacing.verticalMd,

          // Security & Data
          SettingsGroupCard(
            children: [
              Semantics(
                button: true,
                label: l10n.settingsSectionSecurity,
                hint: l10n.settingsSecuritySubtitle,
                child: SettingsCategoryTile(
                  icon: Icons.security,
                  iconColor: AppColors.iconRed,
                  title: l10n.settingsSectionSecurity,
                  subtitle: l10n.settingsSecuritySubtitle,
                  onTap: () => context.push('/settings/security'),
                ),
              ),
              Semantics(
                button: true,
                label: l10n.settingsSectionNetwork,
                hint: l10n.settingsNetworkSubtitle,
                child: SettingsCategoryTile(
                  icon: Icons.dns_outlined,
                  iconColor: AppColors.iconCyan,
                  title: l10n.settingsSectionNetwork,
                  subtitle: l10n.settingsNetworkSubtitle,
                  onTap: () => context.push('/settings/network'),
                ),
              ),
              Semantics(
                button: true,
                label: l10n.knownHostsTitle,
                hint: l10n.knownHostsSubtitle,
                child: SettingsCategoryTile(
                  icon: Icons.fingerprint,
                  iconColor: AppColors.iconGreen,
                  title: l10n.knownHostsTitle,
                  subtitle: l10n.knownHostsSubtitle,
                  onTap: () => context.push('/settings/known-hosts'),
                ),
              ),
              Semantics(
                button: true,
                label: l10n.settingsSectionExport,
                hint: l10n.settingsExportBackupSubtitle,
                child: SettingsCategoryTile(
                  icon: Icons.import_export,
                  iconColor: AppColors.iconDeepOrange,
                  title: l10n.settingsSectionExport,
                  subtitle: l10n.settingsExportBackupSubtitle,
                  onTap: () => context.push('/settings/export'),
                ),
              ),
            ],
          ),
          Spacing.verticalMd,

          // Info
          SettingsGroupCard(
            children: [
              Semantics(
                button: true,
                label: l10n.settingsSectionAbout,
                hint: l10n.settingsAboutSubtitle,
                child: SettingsCategoryTile(
                  icon: Icons.info_outline,
                  iconColor: colorScheme.secondary,
                  title: l10n.settingsSectionAbout,
                  subtitle: l10n.settingsAboutSubtitle,
                  onTap: () => context.push('/settings/about'),
                ),
              ),
            ],
          ),

          Spacing.verticalLg,
        ],
      ),
    );
  }
}

class _AccountHeaderBuilder extends ConsumerWidget {
  final bool isAuthenticated;
  final VoidCallback onTap;

  const _AccountHeaderBuilder({
    required this.isAuthenticated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (!isAuthenticated) {
      return AccountHeader(
        isAuthenticated: false,
        unauthenticatedLabel: l10n.settingsAccountSubtitleUnauth,
        authenticatedLabel: l10n.settingsAccountSubtitleAuth,
        onTap: onTap,
      );
    }

    final profileAsync = ref.watch(userProfileProvider);
    final user = profileAsync.value;

    return AccountHeader(
      isAuthenticated: true,
      email: user?.email,
      avatarBase64: user?.avatar,
      unauthenticatedLabel: l10n.settingsAccountSubtitleUnauth,
      authenticatedLabel: l10n.settingsAccountSubtitleAuth,
      onTap: onTap,
    );
  }
}
