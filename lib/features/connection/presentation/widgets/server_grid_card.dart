import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/core/widgets/settings/section_card.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/presentation/widgets/status_badge.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_chip.dart';

class ServerGridCard extends StatelessWidget {
  final ServerEntity server;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onFavoriteToggle;

  const ServerGridCard({
    super.key,
    required this.server,
    required this.onTap,
    required this.onLongPress,
    this.onDetail,
    this.onEdit,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SectionCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Color(
                        server.color,
                      ).withAlpha(AppConstants.alpha26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      IconConstants.getIcon(server.iconName),
                      color: Color(server.color),
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  if (onFavoriteToggle != null)
                    GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Icon(
                        server.isFavorite ? Icons.star : Icons.star_border,
                        size: 18,
                        color: server.isFavorite
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(AppConstants.alpha102),
                      ),
                    ),
                  const SizedBox(width: 4),
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
                    return TagChip(
                      tag: tag,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
      ),
    );
  }
}
