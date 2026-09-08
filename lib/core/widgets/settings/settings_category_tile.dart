import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/settings/settings_row.dart';

class SettingsCategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const SettingsCategoryTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: subtitle != null ? '$title, $subtitle' : title,
      button: true,
      child: SettingsRow(
        icon: icon,
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: Icon(
          Icons.chevron_right,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
