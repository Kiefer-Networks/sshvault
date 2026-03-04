import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_search_provider.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SettingsHubScreen extends ConsumerStatefulWidget {
  const SettingsHubScreen({super.key});

  @override
  ConsumerState<SettingsHubScreen> createState() => _SettingsHubScreenState();
}

class _SettingsHubScreenState extends ConsumerState<SettingsHubScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.value == AuthStatus.authenticated;
    final query = ref.watch(settingsSearchQueryProvider);
    final searchResults = ref.watch(settingsSearchResultsProvider);

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
          const SizedBox(height: 12),

          // Search Bar
          SettingsSearchBar(
            controller: _searchController,
            hintText: l10n.settingsSearchHint,
            onChanged: (value) {
              ref.read(settingsSearchQueryProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 16),

          // Search Results or Category Tiles
          if (query.isNotEmpty) ...[
            if (searchResults.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    l10n.settingsSearchNoResults,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              SettingsGroupCard(
                children: [
                  for (final item in searchResults)
                    SettingsTile(
                      icon: item.icon,
                      iconColor: item.iconColor,
                      title: item.title,
                      subtitleText: item.category,
                      trailing: Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onTap: () {
                        _searchController.clear();
                        ref.read(settingsSearchQueryProvider.notifier).state =
                            '';
                        context.push(item.route);
                      },
                    ),
                ],
              ),
          ] else ...[
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
                  icon: Icons.support_outlined,
                  iconColor: Colors.pink,
                  title: l10n.settingsSectionSupport,
                  subtitle: l10n.settingsSupportSubtitle,
                  onTap: () => context.push('/settings/support'),
                ),
                SettingsCategoryTile(
                  icon: Icons.info_outline,
                  iconColor: colorScheme.secondary,
                  title: l10n.settingsSectionAbout,
                  subtitle: l10n.settingsAboutSubtitle,
                  onTap: () => context.push('/settings/about'),
                ),
              ],
            ),
          ],

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

    return FutureBuilder<String>(
      future: _getUserEmail(ref),
      builder: (_, snap) => AccountHeader(
        isAuthenticated: true,
        email: snap.data,
        unauthenticatedLabel: l10n.settingsAccountSubtitleUnauth,
        authenticatedLabel: l10n.settingsAccountSubtitleAuth,
        onTap: onTap,
      ),
    );
  }

  Future<String> _getUserEmail(WidgetRef ref) async {
    final storage = ref.read(secureStorageProvider);
    final result = await storage.getUserEmail();
    return result.isSuccess ? (result.value ?? '') : '';
  }
}
