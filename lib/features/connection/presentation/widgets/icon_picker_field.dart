import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/core/constants/icon_constants.dart';

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
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: IconConstants.serverIcons.map((si) {
            final isSelected = si.name == selectedIcon;
            return GestureDetector(
              onTap: () => onIconChanged(si.name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(accentColor).withAlpha(AppConstants.alpha51)
                      : Colors.white.withAlpha(AppConstants.alpha8),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: Color(accentColor), width: 2)
                      : Border.all(color: Colors.white.withAlpha(AppConstants.alpha13)),
                ),
                child: Icon(
                  si.icon,
                  size: 20,
                  color: isSelected
                      ? Color(accentColor)
                      : theme.colorScheme.onSurface.withAlpha(AppConstants.alpha128),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
