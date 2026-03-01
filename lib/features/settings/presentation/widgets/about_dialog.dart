import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';

void showAppAboutDialog(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: AppConstants.appName,
    applicationVersion: 'v${AppConstants.appVersion}',
    applicationIcon: Icon(
      Icons.shield_outlined,
      size: 48,
      color: Theme.of(context).colorScheme.primary,
    ),
    applicationLegalese: 'by Kiefer Networks',
    children: [
      const SizedBox(height: 16),
      Text(
        'Secure, Self-Hosted SSH Client',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
            ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
