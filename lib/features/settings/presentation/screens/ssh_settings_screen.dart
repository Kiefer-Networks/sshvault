import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/widgets/settings/settings.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SshSettingsScreen extends ConsumerWidget {
  const SshSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      title: l10n.settingsSectionSshDefaults,
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Connection section
            const SizedBox(height: 8),
            SectionHeader(title: l10n.settingsSectionConnection),
            SettingsGroupCard(
              children: [
                SettingsTile(
                  icon: Icons.numbers,
                  iconColor: Colors.orange,
                  title: l10n.settingsDefaultPort,
                  subtitleText: settings.defaultSshPort.toString(),
                  onTap: () =>
                      _editPort(context, ref, l10n, settings.defaultSshPort),
                ),
                SettingsTile(
                  icon: Icons.person_outline,
                  iconColor: Colors.blue,
                  title: l10n.settingsDefaultUsername,
                  subtitleText: settings.defaultUsername,
                  onTap: () => _editUsername(
                    context,
                    ref,
                    l10n,
                    settings.defaultUsername,
                  ),
                ),
                SettingsTile(
                  icon: Icons.key_outlined,
                  iconColor: Colors.green,
                  title: l10n.settingsDefaultAuthMethod,
                  trailing: DropdownMenu<String>(
                    initialSelection: settings.defaultAuthMethod,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'password',
                        label: l10n.settingsAuthPassword,
                      ),
                      DropdownMenuEntry(
                        value: 'key',
                        label: l10n.settingsAuthKey,
                      ),
                    ],
                    onSelected: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setDefaultAuthMethod(v);
                      }
                    },
                  ),
                ),
                SettingsTile(
                  icon: Icons.timer_outlined,
                  iconColor: Colors.red,
                  title: l10n.settingsConnectionTimeout,
                  subtitleText: l10n.settingsConnectionTimeoutValue(
                    settings.connectionTimeoutSecs,
                  ),
                  onTap: () => _editTimeout(
                    context,
                    ref,
                    l10n,
                    settings.connectionTimeoutSecs,
                  ),
                ),
                SettingsTile(
                  icon: Icons.favorite_border,
                  iconColor: Colors.pink,
                  title: l10n.settingsKeepaliveInterval,
                  subtitleText: l10n.settingsKeepaliveIntervalValue(
                    settings.keepaliveIntervalSecs,
                  ),
                  onTap: () => _editKeepalive(
                    context,
                    ref,
                    l10n,
                    settings.keepaliveIntervalSecs,
                  ),
                ),
              ],
            ),

            // Terminal section
            const SizedBox(height: 16),
            SectionHeader(title: l10n.settingsSectionTerminal),
            SettingsGroupCard(
              children: [
                SettingsSwitchTile(
                  icon: Icons.compress,
                  iconColor: Colors.teal,
                  title: l10n.settingsCompression,
                  subtitleText: l10n.settingsCompressionDescription,
                  value: settings.sshCompression,
                  onChanged: (v) {
                    ref.read(settingsProvider.notifier).setSshCompression(v);
                  },
                ),
                SettingsTile(
                  icon: Icons.terminal,
                  iconColor: Colors.deepPurple,
                  title: l10n.settingsTerminalType,
                  trailing: DropdownMenu<String>(
                    initialSelection: settings.defaultTerminalType,
                    requestFocusOnTap: false,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(
                        value: 'xterm-256color',
                        label: 'xterm-256color',
                      ),
                      DropdownMenuEntry(value: 'xterm', label: 'xterm'),
                      DropdownMenuEntry(value: 'vt100', label: 'vt100'),
                    ],
                    onSelected: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setDefaultTerminalType(v);
                      }
                    },
                  ),
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

  Future<void> _editPort(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    int currentPort,
  ) async {
    final controller = TextEditingController(text: currentPort.toString());
    try {
      final result = await showAdaptiveFormDialog<String>(
        context,
        title: l10n.settingsDefaultPortDialog,
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.settingsPortLabel,
              hintText: l10n.settingsPortHint,
            ),
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
      if (result != null) {
        final port = int.tryParse(result);
        if (port != null && port > 0 && port <= 65535) {
          ref.read(settingsProvider.notifier).setDefaultSshPort(port);
        }
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    }
  }

  Future<void> _editUsername(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String currentUsername,
  ) async {
    final controller = TextEditingController(text: currentUsername);
    try {
      final result = await showAdaptiveFormDialog<String>(
        context,
        title: l10n.settingsDefaultUsernameDialog,
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: l10n.settingsUsernameLabel,
              hintText: l10n.settingsUsernameHint,
            ),
            keyboardType: TextInputType.text,
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
        ref.read(settingsProvider.notifier).setDefaultUsername(result.trim());
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    }
  }

  Future<void> _editTimeout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    int currentTimeout,
  ) async {
    final controller = TextEditingController(text: currentTimeout.toString());
    try {
      final result = await showAdaptiveFormDialog<String>(
        context,
        title: l10n.settingsConnectionTimeout,
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Seconds',
              hintText: '30',
            ),
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
      if (result != null) {
        final secs = int.tryParse(result);
        if (secs != null && secs > 0 && secs <= 300) {
          ref.read(settingsProvider.notifier).setConnectionTimeout(secs);
        }
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    }
  }

  Future<void> _editKeepalive(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    int currentInterval,
  ) async {
    final controller = TextEditingController(text: currentInterval.toString());
    try {
      final result = await showAdaptiveFormDialog<String>(
        context,
        title: l10n.settingsKeepaliveInterval,
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Seconds',
              hintText: '15',
            ),
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
      if (result != null) {
        final secs = int.tryParse(result);
        if (secs != null && secs >= 0 && secs <= 300) {
          ref.read(settingsProvider.notifier).setKeepaliveInterval(secs);
        }
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    }
  }
}
