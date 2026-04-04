import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

/// A reusable error state widget showing an error icon, message, and retry
/// button.  Used across list screens to replace duplicated error columns.
class ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          Spacing.verticalLg,
          Text(l10n.error(errorMessage(error))),
          Spacing.verticalLg,
          AdaptiveButton.filled(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
