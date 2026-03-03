import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/core/crypto/ssh_key_service.dart';
import 'package:shellvault/core/crypto/ssh_key_type.dart';

class KeyGenerationDialog extends StatefulWidget {
  final SshKeyService sshKeyService;

  const KeyGenerationDialog({super.key, required this.sshKeyService});

  /// Show the dialog and return a [SshKeyPair] or null if cancelled.
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
  State<KeyGenerationDialog> createState() => _KeyGenerationDialogState();
}

class _KeyGenerationDialogState extends State<KeyGenerationDialog> {
  SshKeyType _selectedType = SshKeyType.ed25519;
  int _selectedBits = 0;
  final _commentController = TextEditingController(
    text: 'shellvault-generated',
  );

  bool _generating = false;
  SshKeyPair? _result;
  String? _error;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() {
      _generating = true;
      _error = null;
      _result = null;
    });

    final options = SshKeyOptions(
      type: _selectedType,
      bits: _selectedBits,
      comment: _commentController.text.trim().isEmpty
          ? 'shellvault-generated'
          : _commentController.text.trim(),
    );

    final result = await widget.sshKeyService.generateKeyPair(options);
    if (!mounted) return;

    result.fold(
      onSuccess: (keyPair) {
        setState(() {
          _result = keyPair;
          _generating = false;
        });
      },
      onFailure: (failure) {
        setState(() {
          _error = failure.message;
          _generating = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (_result != null) {
      return _buildResultView(theme, l10n);
    }

    return AlertDialog(
      title: Text(l10n.keyGenTitle),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Key Type
            Text(l10n.keyGenKeyType, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            DropdownButtonFormField<SshKeyType>(
              initialValue: _selectedType,
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
              onChanged: _generating
                  ? null
                  : (type) {
                      if (type == null) return;
                      setState(() {
                        _selectedType = type;
                        _selectedBits = type.defaultBitLength;
                      });
                    },
            ),
            const SizedBox(height: 16),

            // Key Size (only for RSA)
            if (_selectedType.allowedBitLengths.isNotEmpty) ...[
              Text(l10n.keyGenKeySize, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _selectedBits > 0
                    ? _selectedBits
                    : _selectedType.defaultBitLength,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.memory),
                  isDense: true,
                ),
                items: _selectedType.allowedBitLengths
                    .map(
                      (b) => DropdownMenuItem(
                        value: b,
                        child: Text(l10n.keyGenKeySizeBit(b)),
                      ),
                    )
                    .toList(),
                onChanged: _generating
                    ? null
                    : (bits) {
                        if (bits != null) setState(() => _selectedBits = bits);
                      },
              ),
              const SizedBox(height: 16),
            ],

            // Key size info for fixed-size types
            if (_selectedType.allowedBitLengths.isEmpty)
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
                      _selectedType.keySizeLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

            // Comment
            Text(l10n.keyGenComment, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _commentController,
              enabled: !_generating,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.comment_outlined),
                hintText: l10n.keyGenCommentHint,
                isDense: true,
              ),
              keyboardType: TextInputType.text,
            ),

            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _generating ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: _generating ? null : _generate,
          icon: _generating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_fix_high, size: 18),
          label: Text(
            _generating ? l10n.keyGenGenerating : l10n.keyGenGenerate,
          ),
        ),
      ],
    );
  }

  Widget _buildResultView(ThemeData theme, AppLocalizations l10n) {
    final result = _result!;
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
            // Public Key
            _KeyPreviewCard(
              label: l10n.keyGenPublicKey,
              value: result.publicKey,
              icon: Icons.key,
              theme: theme,
            ),
            const SizedBox(height: 12),

            // Private Key
            _KeyPreviewCard(
              label: l10n.keyGenPrivateKey,
              value: result.privateKey,
              icon: Icons.vpn_key,
              theme: theme,
              isPrivate: true,
            ),
            const SizedBox(height: 12),

            // Info
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
            setState(() {
              _result = null;
              _error = null;
            });
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
                      message: AppLocalizations.of(context)!.keyGenCopied(label),
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
