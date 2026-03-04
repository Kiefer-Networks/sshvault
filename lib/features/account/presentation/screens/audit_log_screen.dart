import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/utils/date_formatter.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/features/account/domain/entities/audit_log_entity.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

final _auditCategoryProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final _auditOffsetProvider = StateProvider.autoDispose<int>((ref) => 0);

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  static const _categories = [
    null,
    'AUTH',
    'VAULT',
    'BILLING',
    'DEVICE',
    'USER',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(_auditCategoryProvider);
    final offset = ref.watch(_auditOffsetProvider);
    final params = (category: selectedCategory, offset: offset);
    final logsAsync = ref.watch(auditLogsProvider(params));

    return AdaptiveScaffold(
      title: l10n.auditLogTitle,
      body: Column(
        children: [
          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat ?? l10n.auditLogAll),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(_auditCategoryProvider.notifier).state = cat;
                      ref.read(_auditOffsetProvider.notifier).state = 0;
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Log list
          Expanded(
            child: logsAsync.when(
              data: (result) {
                if (result.logs.isEmpty) {
                  return Center(child: Text(l10n.auditLogEmpty));
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: result.logs.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return _AuditLogTile(entry: result.logs[index]);
                        },
                      ),
                    ),
                    // Pagination
                    if (result.total > result.limit)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: offset > 0
                                  ? () {
                                      ref
                                          .read(_auditOffsetProvider.notifier)
                                          .state = (offset - result.limit)
                                          .clamp(0, result.total);
                                    }
                                  : null,
                            ),
                            Text(
                              '${offset + 1}–${(offset + result.logs.length).clamp(0, result.total)} / ${result.total}',
                              style: theme.textTheme.bodySmall,
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: offset + result.limit < result.total
                                  ? () {
                                      ref
                                              .read(
                                                _auditOffsetProvider.notifier,
                                              )
                                              .state =
                                          offset + result.limit;
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (e, _) => Center(child: Text(l10n.error(errorMessage(e)))),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditLogTile extends StatelessWidget {
  final AuditLogEntity entry;

  const _AuditLogTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: _levelIcon(context, entry.level),
      title: Text(
        '${entry.category} / ${entry.action}',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatDate(entry.timestamp), style: theme.textTheme.bodySmall),
          if (entry.ipAddress.isNotEmpty)
            Text(
              entry.ipAddress,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      trailing: entry.resourceType.isNotEmpty
          ? Chip(
              label: Text(
                entry.resourceType,
                style: theme.textTheme.labelSmall,
              ),
              visualDensity: VisualDensity.compact,
            )
          : null,
    );
  }

  Widget _levelIcon(BuildContext context, String level) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (level) {
      'warn' => Icon(
        Icons.warning_amber,
        color: colorScheme.tertiary,
        size: 20,
      ),
      'error' => Icon(Icons.error_outline, color: colorScheme.error, size: 20),
      _ => Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
    };
  }
}
