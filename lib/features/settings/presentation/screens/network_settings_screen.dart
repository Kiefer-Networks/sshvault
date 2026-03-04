import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/security/doh_resolver_service.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class NetworkSettingsScreen extends ConsumerWidget {
  const NetworkSettingsScreen({super.key});

  static final _defaultServers = [
    DohProvider.quad9.url,
    DohProvider.mullvad.url,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AdaptiveScaffold(
      title: l10n.settingsSectionNetwork,
      body: settingsAsync.when(
        data: (settings) {
          final servers = settings.dnsServerList.isEmpty
              ? List<String>.from(_defaultServers)
              : settings.dnsServerList;
          final isCustom = settings.dnsServers.isNotEmpty;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              const SizedBox(height: 8),
              const SectionHeader(title: 'DNS-over-HTTPS'),

              // Description card
              SectionCard(
                child: Text(
                  l10n.settingsDohDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // DNS Server list
              SettingsGroupCard(
                children: [
                  for (final url in servers)
                    ListTile(
                      leading: Icon(
                        Icons.dns_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        url,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: _defaultServers.contains(url)
                          ? Text(
                              l10n.settingsDnsDefaultBadge,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : null,
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          final newList = servers
                              .where((s) => s != url)
                              .toList();
                          ref
                              .read(settingsProvider.notifier)
                              .setDnsServers(newList.join(','));
                        },
                      ),
                    ),
                  ListTile(
                    leading: Icon(Icons.add, color: theme.colorScheme.primary),
                    title: Text(
                      l10n.settingsDnsAddServer,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    onTap: () => _addDnsServer(context, ref, l10n, servers),
                  ),
                ],
              ),

              // Reset button
              if (isCustom) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      ref.read(settingsProvider.notifier).setDnsServers('');
                    },
                    icon: const Icon(Icons.restore, size: 18),
                    label: Text(l10n.settingsDnsResetDefaults),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            Center(child: Text(l10n.error(errorMessage(error)))),
      ),
    );
  }

  Future<void> _addDnsServer(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<String> currentServers,
  ) async {
    final controller = TextEditingController();
    try {
      final result = await showAdaptiveFormDialog<String>(
        context,
        title: l10n.settingsDnsAddServer,
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: l10n.settingsDnsServerUrl,
              hintText: 'https://dns.example.com/dns-query',
            ),
            keyboardType: TextInputType.url,
            autofocus: true,
          ),
        ),
        materialActions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.save),
          ),
        ],
        cupertinoActions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.save),
          ),
        ],
      );
      if (result != null && result.trim().isNotEmpty) {
        final url = result.trim();
        if (url.startsWith('https://')) {
          final newList = [...currentServers, url];
          ref.read(settingsProvider.notifier).setDnsServers(newList.join(','));
        } else if (context.mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.settingsDnsInvalidUrl,
          );
        }
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    }
  }
}
