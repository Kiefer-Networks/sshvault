import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/settings.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/core/constants/app_colors.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

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
                  iconColor: AppColors.iconOrange,
                  title: l10n.settingsDefaultPort,
                  subtitleText: settings.defaultSshPort.toString(),
                  onTap: () =>
                      _editPort(context, ref, l10n, settings.defaultSshPort),
                ),
                SettingsTile(
                  icon: Icons.person_outline,
                  iconColor: AppColors.iconBlue,
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
                  iconColor: AppColors.iconGreen,
                  title: l10n.settingsDefaultAuthMethod,
                  subtitleText: settings.defaultAuthMethod == 'key'
                      ? l10n.settingsAuthKey
                      : l10n.settingsAuthPassword,
                  onTap: () async {
                    final v = await showSettingsSelectionDialog<String>(
                      context: context,
                      title: l10n.settingsDefaultAuthMethod,
                      currentValue: settings.defaultAuthMethod,
                      options: [
                        SelectionOption(
                          value: 'password',
                          label: l10n.settingsAuthPassword,
                        ),
                        SelectionOption(
                          value: 'key',
                          label: l10n.settingsAuthKey,
                        ),
                      ],
                    );
                    if (v != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setDefaultAuthMethod(v);
                    }
                  },
                ),
                SettingsTile(
                  icon: Icons.timer_outlined,
                  iconColor: AppColors.iconRed,
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
                  iconColor: AppColors.iconPink,
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
                  iconColor: AppColors.iconTeal,
                  title: l10n.settingsCompression,
                  subtitleText: l10n.settingsCompressionDescription,
                  value: settings.sshCompression,
                  onChanged: (v) {
                    ref.read(settingsProvider.notifier).setSshCompression(v);
                  },
                ),
                SettingsTile(
                  icon: Icons.terminal,
                  iconColor: AppColors.iconDeepPurple,
                  title: l10n.settingsTerminalType,
                  subtitleText: settings.defaultTerminalType,
                  onTap: () async {
                    final v = await showSettingsSelectionDialog<String>(
                      context: context,
                      title: l10n.settingsTerminalType,
                      currentValue: settings.defaultTerminalType,
                      options: const [
                        SelectionOption(
                          value: 'xterm-256color',
                          label: 'xterm-256color',
                        ),
                        SelectionOption(value: 'xterm', label: 'xterm'),
                        SelectionOption(value: 'vt100', label: 'vt100'),
                      ],
                    );
                    if (v != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setDefaultTerminalType(v);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            Center(child: Text(l10n.error(errorMessage(error)))),
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
            decoration: InputDecoration(
              labelText: l10n.seconds,
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
            decoration: InputDecoration(
              labelText: l10n.seconds,
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
