import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sshvault/core/constants/app_colors.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/services/package_info_provider.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final packageInfo = ref.watch(packageInfoProvider);
    final version =
        packageInfo.whenOrNull(
          data: (info) => 'v${info.version} (${info.buildNumber})',
        ) ??
        'v${AppConstants.appVersion}';

    return AdaptiveScaffold(
      title: l10n.settingsSectionAbout,
      body: ListView(
        padding: Spacing.paddingHorizontalLgVerticalSm,
        children: [
          Spacing.verticalXxl,

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
                Spacing.verticalLg,
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacing.verticalXxs,
                Text(
                  version,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Spacing.verticalXxs,
                Text(
                  l10n.settingsAboutDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Spacing.verticalXxxl,

          // Links
          SectionHeader(title: l10n.sectionLinks),
          SettingsGroupCard(
            children: [
              SettingsTile(
                icon: Icons.language,
                iconColor: AppColors.iconBlue,
                title: l10n.aboutWebsite,
                subtitleText: 'kiefer-networks.de',
                trailing: Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => _launchUrl('https://kiefer-networks.de'),
              ),
              SettingsTile(
                icon: Icons.favorite_outline,
                iconColor: AppColors.iconOrange,
                title: l10n.aboutDonate,
                subtitleText: 'Liberapay',
                trailing: Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => _launchUrl('https://de.liberapay.com/beli3ver'),
              ),
              SettingsTile(
                icon: Icons.source_outlined,
                iconColor: colorScheme.tertiary,
                title: l10n.aboutOpenSourceLicenses,
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: AppConstants.appName,
                  applicationVersion: version,
                  applicationIcon: Padding(
                    padding: Spacing.paddingAllSm,
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacing.verticalLg,

          // Developer
          SectionHeader(title: l10n.sectionDeveloper),
          SettingsGroupCard(
            children: [
              SettingsTile(
                icon: Icons.business_outlined,
                iconColor: colorScheme.secondary,
                title: l10n.aboutDeveloper,
                subtitleText: 'kiefer-networks.de',
                trailing: Icon(
                  Icons.open_in_new,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => _launchUrl('https://kiefer-networks.de'),
              ),
            ],
          ),
          Spacing.verticalLg,

          // Legal
          Center(
            child: Padding(
              padding: Spacing.paddingAllLg,
              child: Text(
                l10n.settingsAboutLegalese,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Spacing.verticalLg,
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
