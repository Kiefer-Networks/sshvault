import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/core/theme/glassmorphism.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/presentation/widgets/status_badge.dart';

class ServerGridCard extends StatelessWidget {
  final ServerEntity server;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;

  const ServerGridCard({
    super.key,
    required this.server,
    required this.onTap,
    required this.onLongPress,
    this.onDetail,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: GlassmorphicContainer(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Color(server.color).withAlpha(AppConstants.alpha26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    IconConstants.getIcon(server.iconName),
                    color: Color(server.color),
                    size: 20,
                  ),
                ),
                const Spacer(),
                StatusBadge(isActive: server.isActive),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              server.name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${server.username}@${server.hostname}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  AppConstants.alpha128,
                ),
                fontFamily: AppConstants.monospaceFontFamily,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (server.tags.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 2,
                children: server.tags.take(2).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Color(tag.color).withAlpha(AppConstants.alpha26),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag.name,
                      style: TextStyle(fontSize: 10, color: Color(tag.color)),
                    ),
                  );
                }).toList(),
              ),
            if (onDetail != null || onEdit != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onDetail != null)
                    IconButton(
                      icon: Icon(
                        Icons.info_outlined,
                        size: 18,
                        color: theme.colorScheme.onSurface.withAlpha(
                          AppConstants.alpha153,
                        ),
                      ),
                      onPressed: onDetail,
                      tooltip: l10n.serverDetails,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  if (onEdit != null)
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: theme.colorScheme.onSurface.withAlpha(
                          AppConstants.alpha153,
                        ),
                      ),
                      onPressed: onEdit,
                      tooltip: l10n.edit,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
