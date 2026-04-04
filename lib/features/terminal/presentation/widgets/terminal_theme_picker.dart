import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/features/terminal/presentation/models/terminal_theme_data.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

class TerminalThemePicker extends ConsumerWidget {
  const TerminalThemePicker({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const TerminalThemePicker(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeKeyAsync = ref.watch(terminalThemeKeyProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.terminalThemePickerTitle),
      content: SizedBox(
        width: 340,
        child: themeKeyAsync.when(
          data: (currentKey) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: TerminalThemeKey.values.length,
              separatorBuilder: (_, _) => Spacing.verticalXxs,
              itemBuilder: (context, index) {
                final key = TerminalThemeKey.values[index];
                final brightness = Theme.of(context).brightness;
              final preset = TerminalThemePresets.getTheme(
                key,
                brightness: brightness,
              );
                final isSelected = key == currentKey;

                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected
                        ? BorderSide(color: theme.colorScheme.primary, width: 2)
                        : BorderSide.none,
                  ),
                  tileColor: isSelected
                      ? theme.colorScheme.primaryContainer.withAlpha(
                          AppConstants.alpha51,
                        )
                      : null,
                  leading: _ColorSwatchPreview(
                    background: preset.background,
                    foreground: preset.foreground,
                    red: preset.red,
                    green: preset.green,
                    blue: preset.blue,
                    yellow: preset.yellow,
                  ),
                  title: Text(key.displayName),
                  trailing: isSelected
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
                  onTap: () {
                    ref.read(terminalThemeKeyProvider.notifier).setTheme(key);
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (e, _) => Text(l10n.error(e.toString())),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}

class _ColorSwatchPreview extends StatelessWidget {
  final Color background;
  final Color foreground;
  final Color red;
  final Color green;
  final Color blue;
  final Color yellow;

  const _ColorSwatchPreview({
    required this.background,
    required this.foreground,
    required this.red,
    required this.green,
    required this.blue,
    required this.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 32,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(Spacing.xxs),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_dot(foreground), _dot(red), _dot(green)],
          ),
          const SizedBox(height: Spacing.xxxs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _dot(blue),
              _dot(yellow),
              _dot(foreground.withAlpha(AppConstants.alpha102)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
