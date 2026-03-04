import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/utils/date_formatter.dart';
import 'package:shellvault/core/widgets/info_row.dart';
import 'package:shellvault/core/widgets/settings/section_card.dart';
import 'package:shellvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_chip.dart';
import 'package:shellvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:shellvault/features/snippet/presentation/widgets/variable_fill_dialog.dart';

class SnippetDetailScreen extends ConsumerWidget {
  final String snippetId;

  const SnippetDetailScreen({super.key, required this.snippetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final snippetAsync = ref.watch(snippetDetailProvider(snippetId));
    final theme = Theme.of(context);

    return AdaptiveScaffold(
      title: l10n.snippetDetailTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => context.push('/snippet/$snippetId/edit'),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: theme.colorScheme.error),
          onPressed: () async {
            final confirmed = await ConfirmDialog.show(
              context,
              title: l10n.snippetDetailDeleteTitle,
              message: l10n.snippetDetailDeleteMessage,
            );
            if (confirmed == true && context.mounted) {
              await ref
                  .read(snippetListProvider.notifier)
                  .deleteSnippet(snippetId);
              if (context.mounted) context.pop();
            }
          },
        ),
      ],
      body: snippetAsync.when(
        data: (snippet) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                SectionCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(
                            AppConstants.alpha38,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.code,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snippet.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                snippet.language,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Content
                SectionCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.snippetDetailContent,
                            style: theme.textTheme.titleSmall,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (snippet.variables.isNotEmpty)
                                AdaptiveButton.textIcon(
                                  onPressed: () =>
                                      VariableFillDialog.show(context, snippet),
                                  icon: const Icon(Icons.tune, size: 18),
                                  label: Text(l10n.snippetDetailFillVariables),
                                ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: snippet.content),
                                  );
                                  AdaptiveNotification.show(
                                    context,
                                    message: l10n.copiedToClipboard,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          snippet.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: AppConstants.monospaceFontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                if (snippet.description.isNotEmpty) ...[
                  SectionCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.snippetDetailDescription,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snippet.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(
                              AppConstants.alpha179,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Variables
                if (snippet.variables.isNotEmpty) ...[
                  SectionCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.snippetDetailVariables,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        ...snippet.variables.map(
                          (v) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Text(
                                  '{{${v.name}}}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily:
                                        AppConstants.monospaceFontFamily,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                if (v.defaultValue.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '= ${v.defaultValue}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(AppConstants.alpha128),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Tags
                if (snippet.tags.isNotEmpty) ...[
                  SectionCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.snippetDetailTags,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: snippet.tags
                              .map((tag) => TagChip(tag: tag))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Metadata
                SectionCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.snippetDetailInfo,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      InfoRow(
                        icon: Icons.calendar_today,
                        label: l10n.snippetDetailCreated,
                        value: formatDate(snippet.createdAt),
                      ),
                      InfoRow(
                        icon: Icons.update,
                        label: l10n.snippetDetailUpdated,
                        value: formatDate(snippet.updatedAt),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            Center(child: Text(l10n.error(errorMessage(error)))),
      ),
    );
  }
}
