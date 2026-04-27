import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sshvault/core/constants/app_colors.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/services/crash_dump_service.dart';
import 'package:sshvault/core/services/package_info_provider.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

/// Snapshot of the crash-dump folder rendered in the "Crash dumps" tile.
/// Kept private to this file because nothing else needs to know about it.
class _CrashDumpsSummary {
  const _CrashDumpsSummary({required this.count, required this.bytes});
  final int count;
  final int bytes;
}

/// Async-loaded crash-dump summary used by the About screen. Returns a
/// (0, 0) summary on platforms where the service can't resolve a folder
/// (i.e. anything but Windows in production), which is what makes the
/// section degrade gracefully without a `Platform.isWindows` guard in the
/// widget.
final _crashDumpsSummaryProvider =
    FutureProvider.autoDispose<_CrashDumpsSummary>((ref) async {
      final service = CrashDumpService.instance;
      final dumps = await service.listDumps();
      final size = await service.totalSizeBytes();
      return _CrashDumpsSummary(count: dumps.length, bytes: size);
    });

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}

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

          // Crash dumps — Windows only in practice. The provider returns a
          // (0, 0) summary on other platforms so the section is harmless to
          // render anywhere; we still hide it outside Windows to keep the
          // About screen uncluttered for the vast majority of users.
          if (Platform.isWindows) ...[
            const SectionHeader(title: 'Crash dumps'),
            SettingsGroupCard(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final asyncSummary = ref.watch(_crashDumpsSummaryProvider);
                    final summary = asyncSummary.maybeWhen(
                      data: (s) => s,
                      orElse: () =>
                          const _CrashDumpsSummary(count: 0, bytes: 0),
                    );
                    final subtitle = summary.count == 0
                        ? 'No crash dumps recorded'
                        : '${summary.count} '
                              '${summary.count == 1 ? "dump" : "dumps"} '
                              '· ${_formatBytes(summary.bytes)}';
                    return SettingsTile(
                      icon: Icons.bug_report_outlined,
                      iconColor: colorScheme.error,
                      title: 'Crash dumps',
                      subtitleText: subtitle,
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.folder_open_outlined,
                  iconColor: AppColors.iconBlue,
                  title: 'Open folder',
                  onTap: () async {
                    await CrashDumpService.instance.openFolder();
                  },
                ),
                SettingsTile(
                  icon: Icons.delete_outline,
                  iconColor: colorScheme.error,
                  title: 'Delete all',
                  onTap: () async {
                    await CrashDumpService.instance.deleteAll();
                    // Force the summary tile to refresh its count/size.
                    // ignore: unused_result
                    ref.refresh(_crashDumpsSummaryProvider);
                  },
                ),
              ],
            ),
            // One-line privacy note — explicit so users know dumps stay
            // local until they choose to share them.
            Padding(
              padding: Spacing.paddingHorizontalLg,
              child: Text(
                'Crash dumps are stored locally on this PC and never '
                'uploaded automatically.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Spacing.verticalLg,
          ],

          // iPadOS keyboard shortcuts info — shown only when running on
          // iPad. The bindings are static (Dart-level Shortcuts widget,
          // wired in `IosKeyboardShortcuts`); this tile is purely
          // informational so users know which combos work with an attached
          // Magic Keyboard or other Bluetooth keyboard.
          if (Platform.isIOS) ...[
            const SectionHeader(title: 'Keyboard'),
            const SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.keyboard_outlined,
                  iconColor: AppColors.iconBlue,
                  title: 'Keyboard shortcuts available',
                  subtitleText:
                      'Cmd-N new host  ·  Cmd-W close tab  ·  Cmd-T new tab  ·  '
                      'Cmd-, settings  ·  Cmd-F search  ·  Ctrl-Tab switch tab',
                ),
              ],
            ),
            Spacing.verticalLg,
          ],

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
