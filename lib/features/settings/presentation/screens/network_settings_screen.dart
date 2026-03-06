import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/security/doh_resolver_service.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/settings/presentation/providers/proxy_settings_provider.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

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
              SectionHeader(title: l10n.sectionDnsOverHttps),

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

              // --- Default Proxy ---
              const SizedBox(height: 24),
              SectionHeader(title: l10n.proxyDefaultProxy),
              const _ProxySettingsSection(),
              const SizedBox(height: 16),

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

  static Future<void> _testProxy(
    BuildContext context,
    AppLocalizations l10n,
    ProxyConfig proxy,
  ) async {
    try {
      final socket = await Socket.connect(
        proxy.host,
        proxy.port,
        timeout: const Duration(seconds: 5),
      );
      await socket.close();
      if (context.mounted) {
        AdaptiveNotification.show(context, message: l10n.proxyTestSuccess);
      }
    } catch (_) {
      if (context.mounted) {
        AdaptiveNotification.show(context, message: l10n.proxyTestFailed);
      }
    }
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
              hintText: l10n.hintExampleDohUrl,
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

class _ProxySettingsSection extends ConsumerStatefulWidget {
  const _ProxySettingsSection();

  @override
  ConsumerState<_ProxySettingsSection> createState() =>
      _ProxySettingsSectionState();
}

class _ProxySettingsSectionState extends ConsumerState<_ProxySettingsSection> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    return settingsAsync.when(
      data: (settings) {
        if (!_initialized) {
          _hostController.text = settings.globalProxyHost;
          _portController.text = settings.globalProxyPort.toString();
          _usernameController.text = settings.globalProxyUsername;
          // Load password from secure storage
          ref.read(globalProxyCredentialsProvider.future).then((creds) {
            if (mounted) {
              _passwordController.text = creds.password ?? '';
            }
          });
          _initialized = true;
        }

        final proxyType = ProxyType.values.firstWhere(
          (e) => e.name == settings.globalProxyType,
          orElse: () => ProxyType.none,
        );

        return SectionCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownMenu<ProxyType>(
                  initialSelection: proxyType,
                  label: Text(l10n.proxyType),
                  expandedInsets: EdgeInsets.zero,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                      value: ProxyType.none,
                      label: l10n.proxyNone,
                    ),
                    DropdownMenuEntry(
                      value: ProxyType.socks5,
                      label: l10n.proxySocks5,
                    ),
                    DropdownMenuEntry(
                      value: ProxyType.httpConnect,
                      label: l10n.proxyHttpConnect,
                    ),
                  ],
                  onSelected: (v) {
                    if (v != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setGlobalProxyType(v.name);
                    }
                  },
                ),
                if (proxyType != ProxyType.none) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _hostController,
                    decoration: InputDecoration(
                      labelText: l10n.proxyHost,
                      hintText: l10n.hintExampleProxyHost,
                    ),
                    onChanged: (v) => ref
                        .read(settingsProvider.notifier)
                        .setGlobalProxyHost(v.trim()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _portController,
                    decoration: InputDecoration(
                      labelText: l10n.proxyPort,
                      hintText: l10n.hintExampleProxyPort,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final port = int.tryParse(v.trim());
                      if (port != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setGlobalProxyPort(port);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: l10n.proxyUsername),
                    onChanged: (v) => ref
                        .read(settingsProvider.notifier)
                        .setGlobalProxyUsername(v.trim()),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: l10n.proxyPassword),
                    obscureText: true,
                    onChanged: (v) => saveGlobalProxyPassword(v),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        final proxy = ProxyConfig(
                          type: proxyType,
                          host: _hostController.text.trim(),
                          port:
                              int.tryParse(_portController.text.trim()) ?? 1080,
                        );
                        NetworkSettingsScreen._testProxy(context, l10n, proxy);
                      },
                      icon: const Icon(Icons.network_check, size: 18),
                      label: Text(l10n.proxyTestConnection),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
