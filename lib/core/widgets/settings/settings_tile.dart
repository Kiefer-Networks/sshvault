import 'package:flutter/material.dart';
import 'package:shellvault/core/widgets/settings/circle_icon.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitleText;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitleText,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleIcon(icon: icon, color: iconColor),
      title: Text(title),
      subtitle:
          subtitle ??
          (subtitleText != null
              ? Text(
                  subtitleText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              : null),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
