import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:sshvault/core/constants/icon_constants.dart';

class IconPickerField extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconChanged;
  final int accentColor;

  const IconPickerField({
    super.key,
    required this.selectedIcon,
    required this.onIconChanged,
    this.accentColor = 0xFF6C63FF,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.iconPickerLabel,
          style: theme.textTheme.titleSmall,
        ),
        Spacing.verticalSm,
        Wrap(
          spacing: Spacing.xs,
          runSpacing: Spacing.xs,
          children: IconConstants.serverIcons.map((si) {
            final isSelected = si.name == selectedIcon;
            return Material(
              color: isSelected
                  ? Color(accentColor).withAlpha(AppConstants.alpha51)
                  : theme.colorScheme.surfaceContainerHighest.withAlpha(
                      AppConstants.alpha77,
                    ),
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onIconChanged(si.name),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(color: Color(accentColor), width: 2)
                        : Border.all(
                            color: theme.colorScheme.outlineVariant.withAlpha(
                              AppConstants.alpha77,
                            ),
                          ),
                  ),
                  child: Icon(
                    si.icon,
                    size: 20,
                    color: isSelected
                        ? Color(accentColor)
                        : theme.colorScheme.onSurface.withAlpha(
                            AppConstants.alpha128,
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
