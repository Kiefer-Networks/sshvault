import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:flutter/services.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/utils/date_formatter.dart';
import 'package:sshvault/core/widgets/info_row.dart';
import 'package:sshvault/core/widgets/settings/section_card.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';
import 'package:sshvault/features/connection/presentation/widgets/tag_chip.dart';
import 'package:sshvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:sshvault/features/snippet/presentation/widgets/variable_fill_dialog.dart';

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
            padding: Spacing.paddingAllLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                SectionCard(
                  padding: Spacing.paddingAllXl,
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(
                            AppConstants.alpha38,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.code,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      Spacing.horizontalLg,
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
                            Spacing.verticalXxs,
                            Chip(
                              label: Text(snippet.language),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.verticalLg,

                // Content
                SectionCard(
                  padding: Spacing.paddingAllLg,
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
                      Spacing.verticalSm,
                      Container(
                        width: double.infinity,
                        padding: Spacing.paddingAllMd,
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
                Spacing.verticalLg,

                // Description
                if (snippet.description.isNotEmpty) ...[
                  SectionCard(
                    padding: Spacing.paddingAllLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.snippetDetailDescription,
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacing.verticalSm,
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
                  Spacing.verticalLg,
                ],

                // Variables
                if (snippet.variables.isNotEmpty) ...[
                  SectionCard(
                    padding: Spacing.paddingAllLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.snippetDetailVariables,
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacing.verticalSm,
                        ...snippet.variables.map(
                          (v) => Padding(
                            padding: const EdgeInsets.only(bottom: Spacing.xxs),
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
                                  Spacing.horizontalSm,
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
                  Spacing.verticalLg,
                ],

                // Tags
                if (snippet.tags.isNotEmpty) ...[
                  SectionCard(
                    padding: Spacing.paddingAllLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.snippetDetailTags,
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacing.verticalSm,
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
                  Spacing.verticalLg,
                ],

                // Metadata
                SectionCard(
                  padding: Spacing.paddingAllLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.snippetDetailInfo,
                        style: theme.textTheme.titleSmall,
                      ),
                      Spacing.verticalMd,
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
