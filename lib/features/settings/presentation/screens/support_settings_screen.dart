import 'dart:io' show File;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/services/logging_provider.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SupportSettingsScreen extends ConsumerWidget {
  const SupportSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      title: l10n.settingsSectionSupport,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 8),
          SectionHeader(title: l10n.settingsSectionSupport),
          SettingsGroupCard(
            children: [
              SettingsTile(
                icon: Icons.download_outlined,
                iconColor: Colors.brown,
                title: l10n.settingsDownloadLogs,
                onTap: () => _downloadLogs(context, ref, l10n),
              ),
              SettingsTile(
                icon: Icons.email_outlined,
                iconColor: Colors.pink,
                title: l10n.settingsSendLogs,
                onTap: () => _sendLogsToSupport(context, ref, l10n),
              ),
              SettingsTile(
                icon: Icons.favorite_outlined,
                iconColor: Colors.red,
                title: l10n.supportProjectTitle,
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => context.push('/support'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _downloadLogs(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final logger = ref.read(loggingServiceProvider);

    if (logger.isEmpty) {
      if (!context.mounted) return;
      AdaptiveNotification.show(context, message: l10n.settingsLogsEmpty);
      return;
    }

    final filePath = await logger.exportToFile();
    if (filePath == null || !context.mounted) return;

    if (isDesktopPlatform) {
      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: l10n.settingsDownloadLogs,
        fileName: 'shellvault_logs.txt',
      );
      if (savePath == null || !context.mounted) return;
      await File(filePath).copy(savePath);
    } else {
      await SharePlus.instance.share(ShareParams(files: [XFile(filePath)]));
    }

    if (!context.mounted) return;
    AdaptiveNotification.show(context, message: l10n.settingsLogsSaved);
  }

  Future<void> _sendLogsToSupport(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final logger = ref.read(loggingServiceProvider);

    String platform;
    if (kIsWeb) {
      platform = 'Web';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      platform = 'iOS';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      platform = 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      platform = 'macOS';
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      platform = 'Windows';
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      platform = 'Linux';
    } else {
      platform = 'Unknown';
    }

    if (!logger.isEmpty && !isDesktopPlatform) {
      final filePath = await logger.exportToFile();
      if (filePath != null && context.mounted) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath)],
            subject: 'SSH Vault Support Request',
            text:
                'Please describe your issue:\n\n'
                '---\n'
                'App Version: ${AppConstants.appVersion}\n'
                'Platform: $platform\n'
                '---\n',
          ),
        );
        return;
      }
    }

    final mailUri = Uri(
      scheme: 'mailto',
      path: 'support@sshvault.app',
      queryParameters: {
        'subject': 'SSH Vault Support Request',
        'body':
            'Please describe your issue:\n\n'
            '---\n'
            'App Version: ${AppConstants.appVersion}\n'
            'Platform: $platform\n'
            '---\n',
      },
    );

    if (await canLaunchUrl(mailUri)) {
      await launchUrl(mailUri);
    }
  }
}
