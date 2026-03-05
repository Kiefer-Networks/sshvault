import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AdaptiveScaffold(
      title: l10n.settingsSectionAbout,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 24),

          // App Icon + Name + Version
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'v${AppConstants.appVersion}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settingsAboutDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Links
          const SectionHeader(title: 'Links'),
          SettingsGroupCard(
            children: [
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: colorScheme.primary,
                title: l10n.aboutPrivacyPolicy,
                trailing: Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => _launchUrl('https://sshvault.app/privacy'),
              ),
              SettingsTile(
                icon: Icons.description_outlined,
                iconColor: colorScheme.tertiary,
                title: l10n.aboutTermsOfService,
                trailing: Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => _launchUrl('https://sshvault.app/terms'),
              ),
              SettingsTile(
                icon: Icons.source_outlined,
                iconColor: Colors.orange,
                title: l10n.aboutOpenSourceLicenses,
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: AppConstants.appName,
                  applicationVersion: 'v${AppConstants.appVersion}',
                  applicationIcon: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
              ),
              SettingsTile(
                icon: Icons.language,
                iconColor: Colors.blue,
                title: l10n.aboutWebsite,
                subtitleText: 'sshvault.app',
                trailing: Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => _launchUrl('https://sshvault.app'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Developer
          const SectionHeader(title: 'Developer'),
          SettingsGroupCard(
            children: [
              SettingsTile(
                icon: Icons.business_outlined,
                iconColor: colorScheme.secondary,
                title: l10n.aboutDeveloper,
                subtitleText: 'kiefer-network.de',
                trailing: Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => _launchUrl('https://kiefer-network.de'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Legal
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.settingsAboutLegalese,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
