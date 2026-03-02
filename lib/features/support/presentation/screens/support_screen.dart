import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/features/support/presentation/providers/support_providers.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final status = ref.watch(supportPurchaseStatusProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportProjectTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite_outlined,
                          color: theme.colorScheme.onPrimaryContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.supportProjectTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.supportProjectDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status banner
          if (status == SupportPurchaseStatus.success)
            _StatusBanner(
              message: l10n.supportProjectThankYou,
              color: Colors.green,
              icon: Icons.check_circle_outline,
            ),
          if (status == SupportPurchaseStatus.error)
            _StatusBanner(
              message: l10n.supportProjectError,
              color: theme.colorScheme.error,
              icon: Icons.error_outline,
            ),

          // IAP buttons or fallback
          if (isNativeIapPlatform)
            _NativeIapSection(l10n: l10n)
          else
            _FallbackSection(l10n: l10n),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;

  const _StatusBanner({
    required this.message,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(message, style: TextStyle(color: color)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NativeIapSection extends ConsumerWidget {
  final AppLocalizations l10n;

  const _NativeIapSection({required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeAsync = ref.watch(supportStoreProvider);

    return storeAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return _FallbackSection(l10n: l10n);
        }
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: products.map((product) {
            return FilledButton.tonal(
              onPressed: () {
                ref.read(supportStoreProvider.notifier).buyProduct(product);
              },
              child: Text(product.price),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _FallbackSection(l10n: l10n),
    );
  }
}

class _FallbackSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _FallbackSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.supportProjectNotAvailable),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final uri = Uri.parse(kStripeSupportUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          icon: const Icon(Icons.open_in_new, size: 18),
          label: Text(l10n.supportProjectStripeLink),
        ),
      ],
    );
  }
}
