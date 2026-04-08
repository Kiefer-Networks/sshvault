import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/settings/circle_icon.dart';

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitleText;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitleText,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title, ${value ? 'enabled' : 'disabled'}',
      toggled: value,
      child: SwitchListTile(
        secondary: CircleIcon(icon: icon, color: iconColor),
        title: Text(title),
        subtitle: subtitleText != null
            ? Text(
                subtitleText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
