import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/presentation/widgets/status_badge.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_chip.dart';

class ServerListTile extends StatelessWidget {
  final ServerEntity server;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback? onConnect;
  final VoidCallback? onDetail;

  const ServerListTile({
    super.key,
    required this.server,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    this.onConnect,
    this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onDuplicate(),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            icon: Icons.copy,
            label: 'Copy',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Color(server.color).withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            IconConstants.getIcon(server.iconName),
            color: Color(server.color),
            size: 22,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                server.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(isActive: server.isActive),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${server.username}@${server.hostname}:${server.port}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(153),
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (server.tags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: server.tags
                    .take(3)
                    .map((tag) => TagChip(tag: tag))
                    .toList(),
              ),
            ],
          ],
        ),
        isThreeLine: server.tags.isNotEmpty,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDetail != null)
              IconButton(
                icon: const Icon(Icons.info_outlined),
                onPressed: onDetail,
                tooltip: 'Details',
                visualDensity: VisualDensity.compact,
              ),
            if (onConnect != null)
              IconButton(
                icon: const Icon(Icons.terminal),
                onPressed: onConnect,
                tooltip: 'Connect',
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}
