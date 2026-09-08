import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/settings/settings_row.dart';

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitleText;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
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
      child: SettingsRow(
        icon: icon,
        title: Text(title),
        subtitle: subtitleText != null ? Text(subtitleText!) : null,
        // The row itself toggles on tap/Enter/Space — same target as the
        // switch, just larger, so a keyboard user tabbing to this row and
        // pressing Enter doesn't need to land exactly on the tiny switch.
        onTap: onChanged == null ? null : () => onChanged!(!value),
        trailing: IgnorePointer(
          child: Switch(value: value, onChanged: onChanged),
        ),
      ),
    );
  }
}
