import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/utils/file_chooser.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/crypto/crypto_provider.dart';
import 'package:sshvault/core/crypto/ssh_key_type.dart';
import 'package:sshvault/core/ssh/ppk_parser.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/confirm_dialog.dart';

class _SshKeyFormReactiveState {
  final SshKeyType selectedType;
  final int selectedBits;
  final bool saving;
  final String? error;

  const _SshKeyFormReactiveState({
    this.selectedType = SshKeyType.ed25519,
    this.selectedBits = 0,
    this.saving = false,
    this.error,
  });

  _SshKeyFormReactiveState copyWith({
    SshKeyType? selectedType,
    int? selectedBits,
    bool? saving,
    String? Function()? error,
  }) {
    return _SshKeyFormReactiveState(
      selectedType: selectedType ?? this.selectedType,
      selectedBits: selectedBits ?? this.selectedBits,
      saving: saving ?? this.saving,
      error: error != null ? error() : this.error,
    );
  }
}

final _sshKeyFormStateProvider =
    StateProvider.autoDispose<_SshKeyFormReactiveState>(
      (ref) => const _SshKeyFormReactiveState(),
    );

class SshKeyFormDialog extends ConsumerStatefulWidget {
  final SshKeyEntity? existingKey;

  /// When provided, pre-fills the import tab's private-key field. Used by the
  /// Linux drag-and-drop file import flow.
  final String? prefillPrivateKey;

  /// When provided, pre-fills the import tab's name/comment fields with the
  /// public-key contents. Used by the Linux drag-and-drop file import flow
  /// when only the `.pub` half is dropped.
  final String? prefillPublicKey;

  /// Optional default name for new keys. Typically derived from the dropped
  /// file's basename (e.g. `id_ed25519`).
  final String? prefillName;

  const SshKeyFormDialog({
    super.key,
    this.existingKey,
    this.prefillPrivateKey,
    this.prefillPublicKey,
    this.prefillName,
  });

  bool get isEditing => existingKey != null;

  static Future<bool?> show(
    BuildContext context, {
    SshKeyEntity? existingKey,
    String? prefillPrivateKey,
    String? prefillPublicKey,
    String? prefillName,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SshKeyFormDialog(
          existingKey: existingKey,
          prefillPrivateKey: prefillPrivateKey,
          prefillPublicKey: prefillPublicKey,
          prefillName: prefillName,
        ),
      ),
    );
  }

  @override
  ConsumerState<SshKeyFormDialog> createState() => _SshKeyFormDialogState();
}

class _SshKeyFormDialogState extends ConsumerState<SshKeyFormDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _passphraseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.isEditing ? 1 : 2,
      vsync: this,
    );
    if (widget.isEditing) {
      _nameController.text = widget.existingKey!.name;
      _commentController.text = widget.existingKey!.comment;
    } else {
      // Drag-and-drop prefill: jump to the import tab and seed the form so the
      // user only has to confirm. Using `addPostFrameCallback` because the
      // TabController must be attached before we change its index.
      if (widget.prefillName != null && widget.prefillName!.isNotEmpty) {
        _nameController.text = widget.prefillName!;
      }
      if (widget.prefillPrivateKey != null) {
        _privateKeyController.text = widget.prefillPrivateKey!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _tabController.animateTo(1);
        });
      } else if (widget.prefillPublicKey != null) {
        // Public-half drops can't be imported as private keys; we still pre-fill
        // the comment so the user has the original metadata at hand and steer
        // them to the import tab.
        _commentController.text = widget.prefillPublicKey!.trim();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _tabController.animateTo(1);
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _commentController.dispose();
    _privateKeyController.dispose();
    _passphraseController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String _errorMessage(Object e) {
    if (e is DuplicateSshKeyFailure) {
      return AppLocalizations.of(context)!.sshKeyDuplicate(e.existingKeyName);
    }
    if (e is Failure) return e.message;
    return e.toString();
  }

  Future<void> _onDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final key = widget.existingKey!;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.sshKeyDeleteTitle,
      message: l10n.sshKeyDeleteMessage(key.name),
    );
    if (confirmed == true && mounted) {
      try {
        await ref.read(sshKeyListProvider.notifier).deleteSshKey(key.id);
        if (mounted) {
          AdaptiveNotification.show(
            context,
            message: l10n.sshKeyDeletedSuccess,
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) _showError(_errorMessage(e));
      }
    }
  }

  void _onSave() {
    if (widget.isEditing) {
      _saveEdit();
    } else if (_tabController.index == 0) {
      _saveGenerate();
    } else {
      _saveImport();
    }
  }

  Future<void> _saveGenerate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(
            error: () => AppLocalizations.of(context)!.sshKeyFormNameRequired,
          );
      return;
    }

    ref.read(_sshKeyFormStateProvider.notifier).state = ref
        .read(_sshKeyFormStateProvider)
        .copyWith(saving: true, error: () => null);

    try {
      final sshKeyService = ref.read(sshKeyServiceProvider);
      final formState = ref.read(_sshKeyFormStateProvider);
      final options = SshKeyOptions(
        type: formState.selectedType,
        bits: formState.selectedBits,
        comment: _commentController.text.trim(),
      );

      final genResult = await sshKeyService.generateKeyPair(options);
      if (!mounted) return;

      if (genResult.isFailure) {
        ref.read(_sshKeyFormStateProvider.notifier).state = ref
            .read(_sshKeyFormStateProvider)
            .copyWith(error: () => genResult.failure.message, saving: false);
        return;
      }

      final keyPair = genResult.value;
      final now = DateTime.now();
      final entity = SshKeyEntity(
        id: '',
        name: name,
        keyType: keyPair.type,
        publicKey: keyPair.publicKey,
        comment: keyPair.comment,
        createdAt: now,
        updatedAt: now,
      );

      await ref
          .read(sshKeyListProvider.notifier)
          .createSshKey(entity, privateKey: keyPair.privateKey);

      if (mounted) {
        AdaptiveNotification.show(
          context,
          message: AppLocalizations.of(context)!.sshKeySavedSuccess,
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ref.read(_sshKeyFormStateProvider.notifier).state = ref
            .read(_sshKeyFormStateProvider)
            .copyWith(saving: false);
        _showError(_errorMessage(e));
      }
    }
  }

  Future<void> _saveImport() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(
            error: () => AppLocalizations.of(context)!.sshKeyFormNameRequired,
          );
      return;
    }
    final privateKey = _privateKeyController.text.trim();
    if (privateKey.isEmpty) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(
            error: () =>
                AppLocalizations.of(context)!.sshKeyFormPrivateKeyRequired,
          );
      return;
    }

    ref.read(_sshKeyFormStateProvider.notifier).state = ref
        .read(_sshKeyFormStateProvider)
        .copyWith(saving: true, error: () => null);

    try {
      SshKeyType keyType = SshKeyType.ed25519;
      String effectivePrivateKey = privateKey;
      String effectiveComment = _commentController.text.trim();
      String? effectivePassphrase = _passphraseController.text.trim().isEmpty
          ? null
          : _passphraseController.text.trim();

      if (PpkParser.looksLikePpk(privateKey)) {
        // PuTTY .ppk import: parse + convert to OpenSSH so the rest of
        // SSHVault stores/uses the key identically to a native key. The
        // stored private key is unencrypted OpenSSH; the original
        // passphrase only protected transport (the file at rest), and
        // SSHVault's vault layer re-encrypts on save.
        final parsed = await PpkParser.parse(
          privateKey,
          passphrase: effectivePassphrase,
        );
        keyType = parsed.type;
        effectivePrivateKey = parsed.openSshPrivateKey;
        if (effectiveComment.isEmpty &&
            parsed.comment != null &&
            parsed.comment!.isNotEmpty) {
          effectiveComment = parsed.comment!;
        }
        // The OpenSSH private key produced by PpkParser is unencrypted.
        effectivePassphrase = null;
      } else if (privateKey.contains('RSA PRIVATE KEY') ||
          (privateKey.contains('BEGIN PRIVATE KEY') &&
              !privateKey.contains('EC PRIVATE KEY') &&
              !privateKey.contains('OPENSSH PRIVATE KEY'))) {
        keyType = SshKeyType.rsa;
      } else if (privateKey.contains('EC PRIVATE KEY')) {
        keyType = SshKeyType.ecdsa256;
      }

      final now = DateTime.now();
      final entity = SshKeyEntity(
        id: '',
        name: name,
        keyType: keyType,
        comment: effectiveComment,
        createdAt: now,
        updatedAt: now,
      );

      await ref
          .read(sshKeyListProvider.notifier)
          .createSshKey(
            entity,
            privateKey: effectivePrivateKey,
            passphrase: effectivePassphrase,
          );

      if (mounted) {
        AdaptiveNotification.show(
          context,
          message: AppLocalizations.of(context)!.sshKeySavedSuccess,
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ref.read(_sshKeyFormStateProvider.notifier).state = ref
            .read(_sshKeyFormStateProvider)
            .copyWith(saving: false);
        _showError(_errorMessage(e));
      }
    }
  }

  Future<void> _saveEdit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(
            error: () => AppLocalizations.of(context)!.sshKeyFormNameRequired,
          );
      return;
    }

    ref.read(_sshKeyFormStateProvider.notifier).state = ref
        .read(_sshKeyFormStateProvider)
        .copyWith(saving: true, error: () => null);

    try {
      final updated = widget.existingKey!.copyWith(
        name: name,
        comment: _commentController.text.trim(),
      );
      await ref.read(sshKeyListProvider.notifier).updateSshKey(updated);
      if (mounted) {
        AdaptiveNotification.show(
          context,
          message: AppLocalizations.of(context)!.sshKeySavedSuccess,
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ref.read(_sshKeyFormStateProvider.notifier).state = ref
            .read(_sshKeyFormStateProvider)
            .copyWith(saving: false);
        _showError(_errorMessage(e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(_sshKeyFormStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.close,
          onPressed: formState.saving ? null : () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEditing ? l10n.sshKeyFormTitleEdit : l10n.sshKeyFormTitleAdd,
        ),
        actions: [
          if (widget.isEditing)
            _DeleteKeyButton(
              keyId: widget.existingKey!.id,
              onDelete: formState.saving ? null : _onDelete,
            ),
          TextButton(
            onPressed: formState.saving ? null : _onSave,
            child: formState.saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
        ],
        bottom: widget.isEditing
            ? null
            : TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: l10n.sshKeyFormTabGenerate),
                  Tab(text: l10n.sshKeyFormTabImport),
                ],
              ),
      ),
      body: widget.isEditing
          ? ListView(
              padding: Spacing.paddingAllLg,
              children: [_buildEditForm(theme, formState)],
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildGenerateForm(theme, formState),
                _buildImportForm(theme, formState),
              ],
            ),
    );
  }

  Widget _buildGenerateForm(
    ThemeData theme,
    _SshKeyFormReactiveState formState,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: Spacing.paddingAllLg,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormNameLabel,
            prefixIcon: const Icon(Icons.label_outline),
            hintText: l10n.sshKeyFormNameHint,
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        Spacing.verticalLg,
        DropdownMenu<SshKeyType>(
          initialSelection: formState.selectedType,
          expandedInsets: EdgeInsets.zero,
          requestFocusOnTap: false,
          label: Text(l10n.sshKeyFormKeyType),
          leadingIcon: const Icon(Icons.vpn_key),
          dropdownMenuEntries: SshKeyType.values
              .map((t) => DropdownMenuEntry(value: t, label: t.displayName))
              .toList(),
          onSelected: formState.saving
              ? null
              : (type) {
                  if (type == null) return;
                  ref.read(_sshKeyFormStateProvider.notifier).state = formState
                      .copyWith(
                        selectedType: type,
                        selectedBits: type.defaultBitLength,
                      );
                },
        ),
        Spacing.verticalLg,
        if (formState.selectedType.allowedBitLengths.isNotEmpty)
          DropdownMenu<int>(
            initialSelection: formState.selectedBits > 0
                ? formState.selectedBits
                : formState.selectedType.defaultBitLength,
            expandedInsets: EdgeInsets.zero,
            requestFocusOnTap: false,
            label: Text(l10n.sshKeyFormKeySize),
            leadingIcon: const Icon(Icons.memory),
            dropdownMenuEntries: formState.selectedType.allowedBitLengths
                .map(
                  (b) => DropdownMenuEntry(
                    value: b,
                    label: l10n.sshKeyFormKeySizeBit(b),
                  ),
                )
                .toList(),
            onSelected: formState.saving
                ? null
                : (bits) {
                    if (bits != null) {
                      ref.read(_sshKeyFormStateProvider.notifier).state =
                          formState.copyWith(selectedBits: bits);
                    }
                  },
          )
        else
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              Spacing.horizontalSm,
              Text(
                formState.selectedType.keySizeLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        Spacing.verticalLg,
        TextFormField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormCommentLabel,
            prefixIcon: const Icon(Icons.comment_outlined),
            hintText: l10n.sshKeyFormCommentHint,
          ),
          keyboardType: TextInputType.text,
        ),
        if (formState.error != null) ...[
          Spacing.verticalLg,
          Text(
            formState.error!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }

  Future<void> _pickKeyFile() async {
    try {
      final result = await FileChooser.openFile(
        dialogTitle: AppLocalizations.of(context)!.fileChooserPickKeyFile,
        filters: const [FileTypeFilter.pem, FileTypeFilter.plainText],
      );
      if (result == null) return;

      final file = result;

      String content;
      if (file.bytes != null) {
        content = utf8.decode(file.bytes!, allowMalformed: true);
      } else if (file.path != null) {
        content = await File(file.path!).readAsString();
      } else {
        ref.read(_sshKeyFormStateProvider.notifier).state = ref
            .read(_sshKeyFormStateProvider)
            .copyWith(
              error: () =>
                  AppLocalizations.of(context)!.sshKeyFormFileReadError,
            );
        return;
      }

      // Accept either standard PEM-wrapped keys or PuTTY's line-based .ppk
      // format. .ppk files start with `PuTTY-User-Key-File-2:` or `-3:`.
      if (!content.contains('-----BEGIN') && !PpkParser.looksLikePpk(content)) {
        ref.read(_sshKeyFormStateProvider.notifier).state = ref
            .read(_sshKeyFormStateProvider)
            .copyWith(
              error: () =>
                  AppLocalizations.of(context)!.sshKeyFormInvalidFormat,
            );
        return;
      }

      if (_nameController.text.trim().isEmpty && file.name.isNotEmpty) {
        _nameController.text = file.name.replaceAll(RegExp(r'\.[^.]+$'), '');
      }

      if (PpkParser.looksLikePpk(content)) {
        // For .ppk we can read the comment line directly (without needing
        // the passphrase) — extracting the actual public key requires
        // decryption, which we defer to the save step.
        final commentLine = content
            .split('\n')
            .map((l) => l.trim())
            .firstWhere((l) => l.startsWith('Comment:'), orElse: () => '');
        if (commentLine.isNotEmpty && _commentController.text.trim().isEmpty) {
          _commentController.text = commentLine.substring(8).trim();
        }
      } else {
        final keyService = ref.read(sshKeyServiceProvider);
        final infoResult = await keyService.extractKeyInfo(content.trim());
        if (infoResult.isSuccess) {
          final info = infoResult.value;
          if (info.comment != null &&
              info.comment!.isNotEmpty &&
              _commentController.text.trim().isEmpty) {
            _commentController.text = info.comment!;
          }
        }
      }

      _privateKeyController.text = content.trim();
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(error: () => null);
    } catch (e) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(
            error: () => AppLocalizations.of(
              context,
            )!.sshKeyFormFileError(errorMessage(e)),
          );
    }
  }

  Widget _buildImportForm(ThemeData theme, _SshKeyFormReactiveState formState) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: Spacing.paddingAllLg,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormNameLabel,
            prefixIcon: const Icon(Icons.label_outline),
            hintText: l10n.sshKeyFormNameHint,
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        Spacing.verticalLg,
        OutlinedButton.icon(
          onPressed: formState.saving ? null : _pickKeyFile,
          icon: const Icon(Icons.file_open),
          label: Text(l10n.sshKeyFormImportFromFile),
        ),
        Spacing.verticalLg,
        TextFormField(
          controller: _privateKeyController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormPrivateKeyLabel,
            prefixIcon: const Icon(Icons.vpn_key),
            hintText: l10n.sshKeyFormPrivateKeyHint,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 5,
        ),
        Spacing.verticalLg,
        TextFormField(
          controller: _passphraseController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormPassphraseLabel,
            prefixIcon: const Icon(Icons.lock_outline),
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
        ),
        Spacing.verticalLg,
        TextFormField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormCommentOptional,
            prefixIcon: const Icon(Icons.comment_outlined),
          ),
          keyboardType: TextInputType.text,
        ),
        if (formState.error != null) ...[
          Spacing.verticalLg,
          Text(
            formState.error!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }

  Widget _buildEditForm(ThemeData theme, _SshKeyFormReactiveState formState) {
    final l10n = AppLocalizations.of(context)!;
    final key = widget.existingKey!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormNameLabel,
            prefixIcon: const Icon(Icons.label_outline),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        Spacing.verticalLg,
        TextFormField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormCommentLabel,
            prefixIcon: const Icon(Icons.comment_outlined),
          ),
          keyboardType: TextInputType.text,
        ),
        Spacing.verticalXxl,

        // Key type
        Row(
          children: [
            Icon(Icons.vpn_key, size: 18, color: theme.colorScheme.primary),
            Spacing.horizontalSm,
            Text(l10n.sshKeyFormKeyType, style: theme.textTheme.labelLarge),
            const Spacer(),
            Text(
              key.keyType.displayName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: AppConstants.monospaceFontFamily,
              ),
            ),
          ],
        ),

        // Fingerprint
        if (key.fingerprint.isNotEmpty) ...[
          Spacing.verticalLg,
          Text(l10n.sshKeyFingerprint, style: theme.textTheme.labelLarge),
          Spacing.verticalXxs,
          Semantics(
            label: '${l10n.sshKeyFingerprint}: ${key.fingerprint}',
            child: SelectableText(
              key.fingerprint,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: AppConstants.monospaceFontFamily,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],

        // Public key
        if (key.publicKey.isNotEmpty) ...[
          Spacing.verticalLg,
          Text(l10n.sshKeyPublicKey, style: theme.textTheme.labelLarge),
          Spacing.verticalXxs,
          Container(
            width: double.infinity,
            padding: Spacing.paddingAllMd,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              key.publicKey,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: AppConstants.monospaceFontFamily,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],

        // Linked servers
        _LinkedServersList(keyId: key.id),

        if (formState.error != null) ...[
          Spacing.verticalLg,
          Text(
            formState.error!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class _DeleteKeyButton extends ConsumerWidget {
  final String keyId;
  final VoidCallback? onDelete;

  const _DeleteKeyButton({required this.keyId, this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkedServers = ref.watch(serversLinkedToKeyProvider(keyId));
    final canDelete = (linkedServers.value ?? []).isEmpty;
    if (!canDelete) return const SizedBox.shrink();
    return IconButton(
      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
      tooltip: AppLocalizations.of(context)!.delete,
      onPressed: onDelete,
    );
  }
}

class _LinkedServersList extends ConsumerWidget {
  final String keyId;

  const _LinkedServersList({required this.keyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final linkedServers = ref.watch(serversLinkedToKeyProvider(keyId));
    final servers = linkedServers.value ?? [];

    if (servers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.verticalXxl,
        Text(
          l10n.sshKeyTileLinkedServers(servers.length),
          style: theme.textTheme.labelLarge,
        ),
        Spacing.verticalSm,
        for (final server in servers)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.dns_outlined,
              size: 20,
              color: Color(server.color),
            ),
            title: Text(server.name),
            subtitle: Text(
              '${server.username}@${server.hostname}:${server.port}',
            ),
          ),
      ],
    );
  }
}
