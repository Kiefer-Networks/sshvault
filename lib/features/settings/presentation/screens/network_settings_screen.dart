import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/security/doh_resolver_service.dart';
import 'package:sshvault/core/services/global_shortcut_service.dart';
import 'package:sshvault/core/services/windows_protocol_registrar.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/settings/presentation/providers/proxy_settings_provider.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class NetworkSettingsScreen extends ConsumerWidget {
  const NetworkSettingsScreen({super.key});

  static final _defaultServers = [
    DohProvider.quad9.url,
    DohProvider.cloudflare.url,
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
            padding: Spacing.paddingHorizontalLgVerticalSm,
            children: [
              Spacing.verticalSm,
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
              Spacing.verticalLg,

              // DNS Server list
              SettingsGroupCard(
                children: [
                  for (final url in servers)
                    Semantics(
                      label: url,
                      child: ListTile(
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
                        trailing: Tooltip(
                          message: l10n.settingsDnsRemoveServerTooltip,
                          child: IconButton(
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
                              AdaptiveNotification.show(
                                context,
                                message: l10n.settingsDnsServerRemoved,
                              );
                            },
                          ),
                        ),
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
              Spacing.verticalXxl,
              SectionHeader(title: l10n.proxyDefaultProxy),
              const _ProxySettingsSection(),
              Spacing.verticalLg,

              // --- Desktop integration (Linux/Windows) ---
              // Hidden on platforms where a tray icon makes no sense
              // (macOS uses the dock; iOS/Android have no tray concept).
              if (Platform.isLinux || Platform.isWindows) ...[
                Spacing.verticalLg,
                const SectionHeader(title: 'Desktop integration'),
                SettingsGroupCard(
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.dashboard_customize_outlined,
                      iconColor: theme.colorScheme.primary,
                      title: 'Show system tray icon',
                      subtitleText:
                          'Keep SSHVault accessible from the system tray '
                          'with quick access to favorites and active sessions.',
                      value: settings.showSystemTray,
                      onChanged: (v) {
                        ref
                            .read(settingsProvider.notifier)
                            .setShowSystemTray(v);
                        AdaptiveNotification.show(
                          context,
                          message: l10n.settingsUpdated,
                        );
                      },
                    ),
                    // Auto-start: Linux XDG `.desktop` entry, or Windows
                    // HKCU Run-key value. Same toggle, same label — the
                    // service dispatches by platform.
                    if (Platform.isLinux || Platform.isWindows)
                      SwitchListTile(
                        secondary: Icon(
                          Icons.power_settings_new,
                          color: theme.colorScheme.primary,
                        ),
                        title: const Text('Start SSHVault on login'),
                        subtitle: const Text('Boots minimized to system tray'),
                        value: settings.autoStartEnabled,
                        onChanged: (v) async {
                          await ref
                              .read(settingsProvider.notifier)
                              .setAutoStartEnabled(v);
                          if (context.mounted) {
                            AdaptiveNotification.show(
                              context,
                              message: l10n.settingsUpdated,
                            );
                          }
                        },
                      ),
                    // Close-to-tray (Linux/Windows). When on, hitting the
                    // [×] button hides the window into the tray instead of
                    // quitting the app. Only meaningful when the tray icon
                    // is enabled.
                    SwitchListTile(
                      secondary: Icon(
                        Icons.close_fullscreen_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: const Text('Close button minimizes to tray'),
                      subtitle: const Text(
                        'Clicking the window close button hides SSHVault '
                        'into the tray instead of quitting.',
                      ),
                      value: settings.closeToTray,
                      onChanged: (v) async {
                        await ref
                            .read(settingsProvider.notifier)
                            .setCloseToTray(v);
                        if (context.mounted) {
                          AdaptiveNotification.show(
                            context,
                            message: l10n.settingsUpdated,
                          );
                        }
                      },
                    ),
                    // Resume-on-login is only useful when the binary is
                    // booted minimized (autostart or `--minimized`); the
                    // service still gates on that flag at boot time.
                    SwitchListTile(
                      secondary: Icon(
                        Icons.history,
                        color: theme.colorScheme.primary,
                      ),
                      title: const Text('Resume sessions on login'),
                      subtitle: const Text(
                        'Reopen the hosts that were active before the last '
                        'quit when SSHVault is started minimized.',
                      ),
                      value: settings.resumeOnLogin,
                      onChanged: (v) async {
                        await ref
                            .read(settingsProvider.notifier)
                            .setResumeOnLogin(v);
                        if (context.mounted) {
                          AdaptiveNotification.show(
                            context,
                            message: l10n.settingsUpdated,
                          );
                        }
                      },
                    ),
                  ],
                ),
                if (Platform.isLinux) ...[
                  Spacing.verticalMd,
                  const _GlobalShortcutSection(),
                ],
                // Windows-only: surface the ssh:// / sftp:// + .pub/.pem/.ppk
                // handler state. Read-only status row plus a "Re-register"
                // action so the user can self-heal a broken / mismatched
                // registry (e.g. portable build moved between drives).
                if (Platform.isWindows) ...[
                  Spacing.verticalMd,
                  const _WindowsProtocolRegistrationSection(),
                ],
              ],

              // Reset button
              if (isCustom) ...[
                Spacing.verticalMd,
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      ref.read(settingsProvider.notifier).setDnsServers('');
                      AdaptiveNotification.show(
                        context,
                        message: l10n.settingsDnsResetSuccess,
                      );
                    },
                    icon: const Icon(Icons.restore, size: 18),
                    label: Text(l10n.settingsDnsResetDefaults),
                  ),
                ),
              ],
              Spacing.verticalLg,
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
          if (context.mounted) {
            AdaptiveNotification.show(
              context,
              message: l10n.settingsDnsServerAdded,
            );
          }
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
            padding: Spacing.paddingAllLg,
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
                  Spacing.verticalMd,
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
                  Spacing.verticalMd,
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
                  Spacing.verticalMd,
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: l10n.proxyUsername),
                    onChanged: (v) => ref
                        .read(settingsProvider.notifier)
                        .setGlobalProxyUsername(v.trim()),
                  ),
                  Spacing.verticalMd,
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: l10n.proxyPassword),
                    obscureText: true,
                    onChanged: (v) => saveGlobalProxyPassword(v),
                  ),
                  Spacing.verticalLg,
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

/// Linux-only "Global shortcut" panel. Shown alongside the system-tray /
/// auto-start tiles. Reads [globalShortcutStatusProvider] to render either
/// the bound state ("Super+Shift+S — Re-bind") or the dbus-send fallback
/// instructions for desktops without the GlobalShortcuts portal.
class _GlobalShortcutSection extends ConsumerWidget {
  const _GlobalShortcutSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final status = ref.watch(globalShortcutStatusProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Global shortcut'),
        SettingsGroupCard(
          children: [
            SwitchListTile(
              secondary: Icon(
                Icons.keyboard_command_key,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Enable global shortcut'),
              subtitle: Text(
                status.bound
                    ? 'Press ${_humanTrigger(status.trigger)} from anywhere '
                          'to open Quick connect.'
                    : status.portalAvailable
                    ? 'Click "Re-bind" to confirm the trigger.'
                    : 'Your desktop does not expose the GlobalShortcuts '
                          'portal — see the manual binding instructions below.',
              ),
              value: status.bound,
              onChanged: status.portalAvailable
                  ? (v) async {
                      final container = ProviderScope.containerOf(
                        context,
                        listen: false,
                      );
                      final svc = ref.read(globalShortcutServiceProvider);
                      if (v) {
                        await svc.register(container: container);
                      } else {
                        await svc.dispose();
                        ref
                            .read(globalShortcutStatusProvider.notifier)
                            .state = GlobalShortcutStatus.unavailable.copyWith(
                          portalAvailable: status.portalAvailable,
                        );
                      }
                    }
                  : null,
            ),
            if (status.portalAvailable)
              ListTile(
                leading: Icon(Icons.refresh, color: theme.colorScheme.primary),
                title: const Text('Re-bind'),
                subtitle: Text(
                  status.trigger != null
                      ? 'Current trigger: ${_humanTrigger(status.trigger)}'
                      : 'Pick a new trigger via the desktop dialog.',
                ),
                onTap: () async {
                  final container = ProviderScope.containerOf(
                    context,
                    listen: false,
                  );
                  await ref
                      .read(globalShortcutServiceProvider)
                      .rebind(container: container);
                  if (context.mounted) {
                    AdaptiveNotification.show(
                      context,
                      message: 'Asked the desktop to re-bind the shortcut.',
                    );
                  }
                },
              ),
          ],
        ),
        if (!status.portalAvailable) ...[
          Spacing.verticalSm,
          SectionCard(
            child: Padding(
              padding: Spacing.paddingAllLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manual binding (XFCE / older desktops)',
                    style: theme.textTheme.titleSmall,
                  ),
                  Spacing.verticalXs,
                  Text(
                    'Open Settings → Keyboard → Application Shortcuts and '
                    'bind any key combination to:',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Spacing.verticalSm,
                  SelectableText(
                    kFallbackDbusSendCommand,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Renders the portal trigger string ("SUPER+SHIFT+s") in a slightly more
  /// human form ("Super+Shift+S"). Pure formatting — does not validate.
  String _humanTrigger(String? raw) {
    if (raw == null || raw.isEmpty) return 'Super+Shift+S';
    return raw
        .split('+')
        .map(
          (p) => p.isEmpty
              ? p
              : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}',
        )
        .join('+');
  }
}

/// Windows-only: shows whether SSHVault is registered as the system handler
/// for ssh:// / sftp:// URLs and .pub / .pem / .ppk files, with a button to
/// (re-)write the HKCU keys. Always renders as a no-op on other platforms;
/// the parent screen guards on [Platform.isWindows] before mounting this
/// widget anyway.
class _WindowsProtocolRegistrationSection extends ConsumerStatefulWidget {
  const _WindowsProtocolRegistrationSection();

  @override
  ConsumerState<_WindowsProtocolRegistrationSection> createState() =>
      _WindowsProtocolRegistrationSectionState();
}

class _WindowsProtocolRegistrationSectionState
    extends ConsumerState<_WindowsProtocolRegistrationSection> {
  static const _registrar = WindowsProtocolRegistrar();
  bool? _isRegistered;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final registered = await _registrar.isRegistered();
      if (!mounted) return;
      setState(() => _isRegistered = registered);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isRegistered = false);
    }
  }

  Future<void> _reregister() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await _registrar.register();
      await ref
          .read(settingsProvider.notifier)
          .setWindowsProtocolRegistered(true);
      await _refresh();
      if (!mounted) return;
      AdaptiveNotification.show(
        context,
        message: 'SSHVault re-registered as ssh:// handler.',
      );
    } catch (e) {
      if (!mounted) return;
      AdaptiveNotification.show(context, message: 'Re-registration failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registered = _isRegistered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'URL handlers & file associations'),
        SettingsGroupCard(
          children: [
            ListTile(
              leading: Icon(
                registered == true
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                color: registered == true
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
              title: const Text('Registered as ssh:// handler'),
              subtitle: Text(
                registered == null
                    ? 'Checking registry…'
                    : registered
                    ? 'ssh://, sftp:// and .pub/.pem/.ppk files open '
                          'with SSHVault.'
                    : 'Not currently registered. Click "Re-register" '
                          'to write the HKCU keys.',
              ),
              trailing: registered == null
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    )
                  : Icon(
                      registered
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
            ),
            ListTile(
              leading: Icon(Icons.refresh, color: theme.colorScheme.primary),
              title: const Text('Re-register'),
              subtitle: const Text(
                'Rewrite the HKCU keys for ssh://, sftp:// and the SSH key '
                'file types. Useful after moving a portable build.',
              ),
              onTap: _busy ? null : _reregister,
              trailing: _busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
