import 'package:flutter/material.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_node_entity.dart';

class TeleportNodeTile extends StatelessWidget {
  final TeleportNodeEntity node;
  final VoidCallback? onTap;

  const TeleportNodeTile({super.key, required this.node, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final osIcon = _osIcon(node.osType);

    return ListTile(
      leading: Icon(osIcon, color: theme.colorScheme.primary),
      title: Text(node.hostname),
      subtitle: Text(node.addr, style: theme.textTheme.bodySmall),
      trailing: node.labels.isNotEmpty
          ? Wrap(
              spacing: 4,
              children: node.labels.entries
                  .take(2)
                  .map((e) => Chip(
                        label: Text(
                          '${e.key}: ${e.value}',
                          style: theme.textTheme.labelSmall,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            )
          : null,
      onTap: onTap,
    );
  }

  IconData _osIcon(String osType) {
    return switch (osType.toLowerCase()) {
      'linux' => Icons.terminal,
      'windows' => Icons.window,
      'darwin' || 'macos' => Icons.laptop_mac,
      _ => Icons.dns,
    };
  }
}
