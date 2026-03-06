import 'package:flutter/material.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

/// Severity level for security warnings.
enum SecuritySeverity { warning, critical }

/// Callback for security warning actions.
typedef SecurityAction = void Function();

/// A fullscreen, non-dismissable security warning displayed when a
/// security violation is detected (e.g., DNS divergence, certificate
/// mismatch, attestation failure).
///
/// - [SecuritySeverity.critical]: Only "Disconnect" and "Report & Disconnect"
///   buttons. No way to continue.
/// - [SecuritySeverity.warning]: Shows "Continue Anyway" in addition.
class SecurityWarningDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? details;
  final SecuritySeverity severity;
  final SecurityAction onDisconnect;
  final SecurityAction? onReport;
  final SecurityAction? onContinue;

  const SecurityWarningDialog({
    super.key,
    required this.title,
    required this.message,
    this.details,
    this.severity = SecuritySeverity.critical,
    required this.onDisconnect,
    this.onReport,
    this.onContinue,
  });

  /// Shows the warning as a fullscreen dialog that cannot be dismissed
  /// by tapping outside or pressing back.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? details,
    SecuritySeverity severity = SecuritySeverity.critical,
    required SecurityAction onDisconnect,
    SecurityAction? onReport,
    SecurityAction? onContinue,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => PopScope(
        canPop: false,
        child: SecurityWarningDialog(
          title: title,
          message: message,
          details: details,
          severity: severity,
          onDisconnect: onDisconnect,
          onReport: onReport,
          onContinue: onContinue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isCritical = severity == SecuritySeverity.critical;

    return Scaffold(
      backgroundColor: isCritical
          ? colorScheme.errorContainer
          : colorScheme.tertiaryContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isCritical ? Icons.gpp_bad : Icons.warning_amber,
                size: 80,
                color: isCritical
                    ? colorScheme.onErrorContainer
                    : colorScheme.onTertiaryContainer,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: isCritical
                      ? colorScheme.onErrorContainer
                      : colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isCritical
                      ? colorScheme.onErrorContainer
                      : colorScheme.onTertiaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              if (details != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withAlpha(80),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    details!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: isCritical
                          ? colorScheme.onErrorContainer
                          : colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onDisconnect,
                icon: const Icon(Icons.power_settings_new),
                label: Text(l10n.disconnect),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              if (onReport != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onReport,
                  icon: const Icon(Icons.flag),
                  label: Text(l10n.reportAndDisconnect),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isCritical
                        ? colorScheme.onErrorContainer
                        : colorScheme.onTertiaryContainer,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
              // Only show "Continue" for non-critical warnings
              if (!isCritical && onContinue != null) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onContinue,
                  child: Text(
                    l10n.continueAnyway,
                    style: TextStyle(
                      color: colorScheme.onTertiaryContainer.withAlpha(180),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
