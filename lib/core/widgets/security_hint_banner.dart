import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';

class SecurityHintBanner extends ConsumerStatefulWidget {
  final Widget child;

  const SecurityHintBanner({super.key, required this.child});

  @override
  ConsumerState<SecurityHintBanner> createState() =>
      _SecurityHintBannerState();
}

class _SecurityHintBannerState extends ConsumerState<SecurityHintBanner> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull;

    if (settings != null &&
        !settings.hasAnyLock &&
        !settings.dismissedSecurityHint &&
        !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSecurityDialog(context);
      });
    }

    return widget.child;
  }

  Future<void> _showSecurityDialog(BuildContext context) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    final goToSettings = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.shield_outlined, color: Colors.orange, size: 40),
        title: Text(l10n.securityBannerDismiss.contains('Later')
            ? 'Security'
            : l10n.settingsSectionSecurity),
        content: Text(l10n.securityBannerMessage),
        actions: [
          TextButton(
            onPressed: () {
              ref
                  .read(settingsProvider.notifier)
                  .setDismissedSecurityHint(true);
              Navigator.pop(ctx, false);
            },
            child: Text(l10n.securityBannerDismiss),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(settingsProvider.notifier)
                  .setDismissedSecurityHint(true);
              Navigator.pop(ctx, true);
            },
            child: Text(l10n.navSettings),
          ),
        ],
      ),
    );

    if (goToSettings == true && context.mounted) {
      context.push('/settings');
    }
  }
}
