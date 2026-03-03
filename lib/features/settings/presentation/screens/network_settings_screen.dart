import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class NetworkSettingsScreen extends ConsumerWidget {
  const NetworkSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      title: l10n.settingsSectionNetwork,
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            const SizedBox(height: 8),
            SectionHeader(title: l10n.settingsSectionNetwork),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.dns_outlined,
                  iconColor: Colors.cyan,
                  title: l10n.settingsDnsServers,
                  subtitleText: settings.dnsServers.isEmpty
                      ? l10n.settingsDnsDefault
                      : settings.dnsServers,
                  onTap: () =>
                      _editDnsServers(context, ref, l10n, settings.dnsServers),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Center(child: Text(l10n.error(error.toString()))),
      ),
    );
  }

  Future<void> _editDnsServers(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String current,
  ) async {
    final controller = TextEditingController(text: current);
    final result = await showAdaptiveFormDialog<String>(
      context,
      title: l10n.settingsDnsServers,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsDnsHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.settingsDnsLabel,
              hintText:
                  'https://cloudflare-dns.com/dns-query,\nhttps://dns.google/resolve',
            ),
            keyboardType: TextInputType.url,
          ),
        ],
      ),
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, ''),
          child: Text(l10n.settingsDnsReset),
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
          onPressed: () => Navigator.pop(context, ''),
          child: Text(l10n.settingsDnsReset),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(l10n.save),
        ),
      ],
    );
    controller.dispose();
    if (result != null) {
      ref.read(settingsProvider.notifier).setDnsServers(result);
    }
  }
}
