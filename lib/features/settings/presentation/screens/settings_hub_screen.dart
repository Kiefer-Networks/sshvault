import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Account Header
          _AccountHeaderBuilder(
            isAuthenticated: isAuthenticated,
            onTap: () => context.push('/settings/account'),
          ),
          const SizedBox(height: 16),

          // General
          SettingsGroupCard(
            children: [
              SettingsCategoryTile(
                icon: Icons.palette_outlined,
                iconColor: colorScheme.primary,
                title: l10n.settingsSectionAppearance,
                subtitle: l10n.settingsAppearanceSubtitle,
                onTap: () => context.push('/settings/appearance'),
              ),
              SettingsCategoryTile(
                icon: Icons.terminal,
                iconColor: Colors.orange,
                title: l10n.settingsSectionSshDefaults,
                subtitle: l10n.settingsSshSubtitle,
                onTap: () => context.push('/settings/ssh'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Security & Data
          SettingsGroupCard(
            children: [
              SettingsCategoryTile(
                icon: Icons.security,
                iconColor: Colors.red,
                title: l10n.settingsSectionSecurity,
                subtitle: l10n.settingsSecuritySubtitle,
                onTap: () => context.push('/settings/security'),
              ),
              SettingsCategoryTile(
                icon: Icons.dns_outlined,
                iconColor: Colors.cyan,
                title: l10n.settingsSectionNetwork,
                subtitle: l10n.settingsNetworkSubtitle,
                onTap: () => context.push('/settings/network'),
              ),
              SettingsCategoryTile(
                icon: Icons.import_export,
                iconColor: Colors.deepOrange,
                title: l10n.settingsSectionExport,
                subtitle: l10n.settingsExportBackupSubtitle,
                onTap: () => context.push('/settings/export'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Info
          SettingsGroupCard(
            children: [
              SettingsCategoryTile(
                icon: Icons.info_outline,
                iconColor: colorScheme.secondary,
                title: l10n.settingsSectionAbout,
                subtitle: l10n.settingsAboutSubtitle,
                onTap: () => context.push('/settings/about'),
              ),
            ],
          ),

          const SizedBox(height: 16),
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
