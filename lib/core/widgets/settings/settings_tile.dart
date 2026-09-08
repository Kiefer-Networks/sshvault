import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/settings/settings_row.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitleText;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitleText,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: subtitleText != null ? '$title, $subtitleText' : title,
      button: onTap != null,
      child: SettingsRow(
        icon: icon,
        title: Text(title),
        subtitle:
            subtitle ?? (subtitleText != null ? Text(subtitleText!) : null),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
