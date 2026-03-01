import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/settings/presentation/widgets/about_dialog.dart'
    as app;
import 'package:shellvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:shellvault/features/terminal/presentation/widgets/terminal_theme_picker.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            children: [
              // Appearance
              const _SectionHeader(title: 'Appearance'),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme'),
                subtitle: Text(_themeLabel(settings.themeMode)),
                trailing: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.settings_suggest, size: 18),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode, size: 18),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode, size: 18),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (modes) {
                    ref
                        .read(settingsProvider.notifier)
                        .setThemeMode(modes.first);
                  },
                ),
              ),
              const Divider(),

              // Terminal
              const _SectionHeader(title: 'Terminal'),
              Builder(builder: (context) {
                final themeKeyAsync = ref.watch(terminalThemeKeyProvider);
                return ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text('Terminal Theme'),
                  subtitle: Text(themeKeyAsync.when(
                    data: (key) => key.displayName,
                    loading: () => '...',
                    error: (_, _) => 'Default Dark',
                  )),
                  onTap: () => TerminalThemePicker.show(context),
                );
              }),
              Builder(builder: (context) {
                final fontSizeAsync = ref.watch(terminalFontSizeProvider);
                final fontSize = fontSizeAsync.valueOrNull ?? 14.0;
                return ListTile(
                  leading: const Icon(Icons.text_fields_outlined),
                  title: const Text('Font Size'),
                  subtitle: Text('${fontSize.toInt()} px'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: fontSize <= 8
                            ? null
                            : () => ref
                                .read(terminalFontSizeProvider.notifier)
                                .decrease(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: fontSize >= 24
                            ? null
                            : () => ref
                                .read(terminalFontSizeProvider.notifier)
                                .increase(),
                      ),
                    ],
                  ),
                );
              }),
              const Divider(),

              // SSH Defaults
              const _SectionHeader(title: 'SSH Defaults'),
              ListTile(
                leading: const Icon(Icons.numbers),
                title: const Text('Default Port'),
                subtitle: Text(settings.defaultSshPort.toString()),
                onTap: () => _editPort(settings.defaultSshPort),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Default Username'),
                subtitle: Text(settings.defaultUsername),
                onTap: () => _editUsername(settings.defaultUsername),
              ),
              const Divider(),

              // Security
              const _SectionHeader(title: 'Security'),
              ListTile(
                leading: const Icon(Icons.lock_clock_outlined),
                title: const Text('Auto-Lock Timeout'),
                subtitle: Text(settings.autoLockMinutes == 0
                    ? 'Disabled'
                    : '${settings.autoLockMinutes} minutes'),
                trailing: DropdownButton<int>(
                  value: settings.autoLockMinutes,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Off')),
                    DropdownMenuItem(value: 1, child: Text('1 min')),
                    DropdownMenuItem(value: 5, child: Text('5 min')),
                    DropdownMenuItem(value: 15, child: Text('15 min')),
                    DropdownMenuItem(value: 30, child: Text('30 min')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setAutoLockMinutes(v);
                    }
                  },
                ),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.fingerprint),
                title: const Text('Biometric Unlock'),
                value: settings.biometricUnlock,
                onChanged: (v) {
                  ref.read(settingsProvider.notifier).setBiometricUnlock(v);
                },
              ),
              const Divider(),

              // Export
              const _SectionHeader(title: 'Export'),
              SwitchListTile(
                secondary: const Icon(Icons.enhanced_encryption_outlined),
                title: const Text('Encrypt Exports by Default'),
                value: settings.encryptExportByDefault,
                onChanged: (v) {
                  ref
                      .read(settingsProvider.notifier)
                      .setEncryptExportByDefault(v);
                },
              ),
              const Divider(),

              // About
              const _SectionHeader(title: 'About'),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About ShellVault'),
                onTap: () => app.showAppAboutDialog(context),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'System',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
    };
  }

  Future<void> _editPort(int currentPort) async {
    final controller =
        TextEditingController(text: currentPort.toString());
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default SSH Port'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Port',
            hintText: '22',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) {
      final port = int.tryParse(result);
      if (port != null && port > 0 && port <= 65535) {
        ref.read(settingsProvider.notifier).setDefaultSshPort(port);
      }
    }
  }

  Future<void> _editUsername(String currentUsername) async {
    final controller = TextEditingController(text: currentUsername);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'root',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && result.trim().isNotEmpty) {
      ref
          .read(settingsProvider.notifier)
          .setDefaultUsername(result.trim());
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
