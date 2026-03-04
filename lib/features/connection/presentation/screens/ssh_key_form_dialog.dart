import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/crypto/crypto_provider.dart';
import 'package:shellvault/core/crypto/ssh_key_type.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/ssh_key_providers.dart';

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

  const SshKeyFormDialog({super.key, this.existingKey});

  bool get isEditing => existingKey != null;

  static Future<bool?> show(
    BuildContext context, {
    SshKeyEntity? existingKey,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SshKeyFormDialog(existingKey: existingKey),
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
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _errorMessage(Object e) {
    if (e is DuplicateSshKeyFailure) {
      return AppLocalizations.of(context)!.sshKeyDuplicate(e.existingKeyName);
    }
    if (e is Failure) return e.message;
    return e.toString();
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

      if (mounted) Navigator.pop(context, true);
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
      if (privateKey.contains('RSA PRIVATE KEY') ||
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
        comment: _commentController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );

      final passphrase = _passphraseController.text.trim();
      await ref
          .read(sshKeyListProvider.notifier)
          .createSshKey(
            entity,
            privateKey: privateKey,
            passphrase: passphrase.isEmpty ? null : passphrase,
          );

      if (mounted) Navigator.pop(context, true);
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
      if (mounted) Navigator.pop(context, true);
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
          onPressed:
              formState.saving ? null : () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEditing
              ? l10n.sshKeyFormTitleEdit
              : l10n.sshKeyFormTitleAdd,
        ),
        actions: [
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
              padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.all(16),
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
        const SizedBox(height: 16),
        DropdownMenu<SshKeyType>(
          initialSelection: formState.selectedType,
          expandedInsets: EdgeInsets.zero,
          requestFocusOnTap: false,
          label: Text(l10n.sshKeyFormKeyType),
          leadingIcon: const Icon(Icons.vpn_key),
          dropdownMenuEntries: SshKeyType.values
              .map(
                (t) => DropdownMenuEntry(value: t, label: t.displayName),
              )
              .toList(),
          onSelected: formState.saving
              ? null
              : (type) {
                  if (type == null) return;
                  ref
                      .read(_sshKeyFormStateProvider.notifier)
                      .state = formState.copyWith(
                    selectedType: type,
                    selectedBits: type.defaultBitLength,
                  );
                },
        ),
        const SizedBox(height: 16),
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
              const SizedBox(width: 8),
              Text(
                formState.selectedType.keySizeLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
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
          const SizedBox(height: 16),
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
      final result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;

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

      if (!content.contains('-----BEGIN')) {
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

      _privateKeyController.text = content.trim();
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(error: () => null);
    } catch (e) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(
            error: () =>
                AppLocalizations.of(context)!.sshKeyFormFileError(errorMessage(e)),
          );
    }
  }

  Widget _buildImportForm(ThemeData theme, _SshKeyFormReactiveState formState) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
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
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: formState.saving ? null : _pickKeyFile,
          icon: const Icon(Icons.file_open),
          label: Text(l10n.sshKeyFormImportFromFile),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        TextFormField(
          controller: _passphraseController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormPassphraseLabel,
            prefixIcon: const Icon(Icons.lock_outline),
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormCommentOptional,
            prefixIcon: const Icon(Icons.comment_outlined),
          ),
          keyboardType: TextInputType.text,
        ),
        if (formState.error != null) ...[
          const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        TextFormField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: l10n.sshKeyFormCommentLabel,
            prefixIcon: const Icon(Icons.comment_outlined),
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 24),

        // Key type
        Row(
          children: [
            Icon(Icons.vpn_key, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              l10n.sshKeyFormKeyType,
              style: theme.textTheme.labelLarge,
            ),
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
          const SizedBox(height: 16),
          Text(
            l10n.sshKeyFingerprint,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          SelectableText(
            key.fingerprint,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: AppConstants.monospaceFontFamily,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],

        // Public key
        if (key.publicKey.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            l10n.sshKeyPublicKey,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
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

        if (formState.error != null) ...[
          const SizedBox(height: 16),
          Text(
            formState.error!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }
}
