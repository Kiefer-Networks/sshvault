import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/utils/date_formatter.dart';
import 'package:shellvault/features/account/domain/entities/audit_log_entity.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  String? _selectedCategory;
  int _offset = 0;

  static const _categories = [
    null,
    'AUTH',
    'VAULT',
    'BILLING',
    'DEVICE',
    'USER',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final params = (category: _selectedCategory, offset: _offset);
    final logsAsync = ref.watch(auditLogsProvider(params));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.auditLogTitle)),
      body: Column(
        children: [
          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat ?? l10n.auditLogAll),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = cat;
                        _offset = 0;
                      });
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
                              onPressed: _offset > 0
                                  ? () => setState(() {
                                      _offset = (_offset - result.limit).clamp(
                                        0,
                                        result.total,
                                      );
                                    })
                                  : null,
                            ),
                            Text(
                              '${_offset + 1}–${(_offset + result.logs.length).clamp(0, result.total)} / ${result.total}',
                              style: theme.textTheme.bodySmall,
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: _offset + result.limit < result.total
                                  ? () => setState(() {
                                      _offset += result.limit;
                                    })
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l10n.error(e.toString()))),
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
      leading: _levelIcon(entry.level),
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

  Widget _levelIcon(String level) {
    return switch (level) {
      'warn' => const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
      'error' => const Icon(Icons.error_outline, color: Colors.red, size: 20),
      _ => const Icon(Icons.info_outline, color: Colors.blue, size: 20),
    };
  }
}
