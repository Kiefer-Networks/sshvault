import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/core/constants/app_constants.dart';

void showAppAboutDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showAboutDialog(
    context: context,
    applicationName: AppConstants.appName,
    applicationVersion: 'v${AppConstants.appVersion}',
    applicationIcon: Icon(
      Icons.shield_outlined,
      size: 48,
      color: Theme.of(context).colorScheme.primary,
    ),
    applicationLegalese: l10n.settingsAboutLegalese,
    children: [
      const SizedBox(height: 16),
      Text(
        l10n.settingsAboutDescription,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(AppConstants.alpha179),
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
