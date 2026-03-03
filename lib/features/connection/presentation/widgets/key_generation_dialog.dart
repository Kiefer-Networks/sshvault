import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/crypto/ssh_key_service.dart';
import 'package:shellvault/core/crypto/ssh_key_type.dart';

class _KeyGenReactiveState {
  final SshKeyType selectedType;
  final int selectedBits;
  final bool generating;
  final SshKeyPair? result;
  final String? error;

  const _KeyGenReactiveState({
    this.selectedType = SshKeyType.ed25519,
    this.selectedBits = 0,
    this.generating = false,
    this.result,
    this.error,
  });

  _KeyGenReactiveState copyWith({
    SshKeyType? selectedType,
    int? selectedBits,
    bool? generating,
    SshKeyPair? Function()? result,
    String? Function()? error,
  }) {
    return _KeyGenReactiveState(
      selectedType: selectedType ?? this.selectedType,
      selectedBits: selectedBits ?? this.selectedBits,
      generating: generating ?? this.generating,
      result: result != null ? result() : this.result,
      error: error != null ? error() : this.error,
    );
  }
}

final _keyGenStateProvider = StateProvider.autoDispose<_KeyGenReactiveState>(
  (ref) => const _KeyGenReactiveState(),
);

class KeyGenerationDialog extends ConsumerStatefulWidget {
  final SshKeyService sshKeyService;

  const KeyGenerationDialog({super.key, required this.sshKeyService});

  static Future<SshKeyPair?> show(
    BuildContext context,
    SshKeyService sshKeyService,
  ) {
    return showDialog<SshKeyPair>(
      context: context,
      builder: (_) => KeyGenerationDialog(sshKeyService: sshKeyService),
    );
  }

  @override
  ConsumerState<KeyGenerationDialog> createState() =>
      _KeyGenerationDialogState();
}

class _KeyGenerationDialogState extends ConsumerState<KeyGenerationDialog> {
  final _commentController = TextEditingController(
    text: 'shellvault-generated',
  );

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final genState = ref.read(_keyGenStateProvider);
    ref.read(_keyGenStateProvider.notifier).state = genState.copyWith(
      generating: true,
      error: () => null,
      result: () => null,
    );

    final options = SshKeyOptions(
      type: ref.read(_keyGenStateProvider).selectedType,
      bits: ref.read(_keyGenStateProvider).selectedBits,
      comment: _commentController.text.trim().isEmpty
          ? 'shellvault-generated'
          : _commentController.text.trim(),
    );

    final result = await widget.sshKeyService.generateKeyPair(options);
    if (!mounted) return;

    result.fold(
      onSuccess: (keyPair) {
        ref.read(_keyGenStateProvider.notifier).state = ref
            .read(_keyGenStateProvider)
            .copyWith(result: () => keyPair, generating: false);
      },
      onFailure: (failure) {
        ref.read(_keyGenStateProvider.notifier).state = ref
            .read(_keyGenStateProvider)
            .copyWith(error: () => failure.message, generating: false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final genState = ref.watch(_keyGenStateProvider);

    if (genState.result != null) {
      return _buildResultView(theme, l10n, genState);
    }

    return AlertDialog(
      title: Text(l10n.keyGenTitle),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.keyGenKeyType, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            DropdownButtonFormField<SshKeyType>(
              initialValue: genState.selectedType,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                isDense: true,
              ),
              items: SshKeyType.values
                  .map(
                    (t) =>
                        DropdownMenuItem(value: t, child: Text(t.displayName)),
                  )
                  .toList(),
              onChanged: genState.generating
                  ? null
                  : (type) {
                      if (type == null) return;
                      ref.read(_keyGenStateProvider.notifier).state = genState
                          .copyWith(
                            selectedType: type,
                            selectedBits: type.defaultBitLength,
                          );
                    },
            ),
            const SizedBox(height: 16),

            if (genState.selectedType.allowedBitLengths.isNotEmpty) ...[
              Text(l10n.keyGenKeySize, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: genState.selectedBits > 0
                    ? genState.selectedBits
                    : genState.selectedType.defaultBitLength,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.memory),
                  isDense: true,
                ),
                items: genState.selectedType.allowedBitLengths
                    .map(
                      (b) => DropdownMenuItem(
                        value: b,
                        child: Text(l10n.keyGenKeySizeBit(b)),
                      ),
                    )
                    .toList(),
                onChanged: genState.generating
                    ? null
                    : (bits) {
                        if (bits != null) {
                          ref.read(_keyGenStateProvider.notifier).state =
                              genState.copyWith(selectedBits: bits);
                        }
                      },
              ),
              const SizedBox(height: 16),
            ],

            if (genState.selectedType.allowedBitLengths.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      genState.selectedType.keySizeLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

            Text(l10n.keyGenComment, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _commentController,
              enabled: !genState.generating,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.comment_outlined),
                hintText: l10n.keyGenCommentHint,
                isDense: true,
              ),
              keyboardType: TextInputType.text,
            ),

            if (genState.error != null) ...[
              const SizedBox(height: 16),
              Text(
                genState.error!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: genState.generating ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: genState.generating ? null : _generate,
          icon: genState.generating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_fix_high, size: 18),
          label: Text(
            genState.generating ? l10n.keyGenGenerating : l10n.keyGenGenerate,
          ),
        ),
      ],
    );
  }

  Widget _buildResultView(
    ThemeData theme,
    AppLocalizations l10n,
    _KeyGenReactiveState genState,
  ) {
    final result = genState.result!;
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.keyGenResultTitle(result.type.displayName),
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _KeyPreviewCard(
              label: l10n.keyGenPublicKey,
              value: result.publicKey,
              icon: Icons.key,
              theme: theme,
            ),
            const SizedBox(height: 12),

            _KeyPreviewCard(
              label: l10n.keyGenPrivateKey,
              value: result.privateKey,
              icon: Icons.vpn_key,
              theme: theme,
              isPrivate: true,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.keyGenCommentInfo(result.comment),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(_keyGenStateProvider.notifier).state = ref
                .read(_keyGenStateProvider)
                .copyWith(result: () => null, error: () => null);
          },
          child: Text(l10n.keyGenAnother),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, result),
          child: Text(l10n.keyGenUseThisKey),
        ),
      ],
    );
  }
}

class _KeyPreviewCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;
  final bool isPrivate;

  const _KeyPreviewCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
    this.isPrivate = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = isPrivate
        ? '${value.split('\n').first}\n... (${value.split('\n').length} lines)'
        : value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(label, style: theme.textTheme.labelLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  tooltip: AppLocalizations.of(context)!.keyGenCopyTooltip,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    AdaptiveNotification.show(
                      context,
                      message: AppLocalizations.of(
                        context,
                      )!.keyGenCopied(label),
                    );
                  },
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              displayValue,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: AppConstants.monospaceFontFamily,
                fontSize: 11,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
