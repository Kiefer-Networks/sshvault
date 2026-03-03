import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';
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

final _sshKeyFormStateProvider = StateProvider.autoDispose<_SshKeyFormReactiveState>(
  (ref) => const _SshKeyFormReactiveState(),
);

class SshKeyFormDialog extends ConsumerStatefulWidget {
  final SshKeyEntity? existingKey;

  const SshKeyFormDialog({super.key, this.existingKey});

  bool get isEditing => existingKey != null;

  static Future<bool?> show(BuildContext context, {SshKeyEntity? existingKey}) {
    return showDialog<bool>(
      context: context,
      builder: (_) => SshKeyFormDialog(existingKey: existingKey),
    );
  }

  @override
  ConsumerState<SshKeyFormDialog> createState() => _SshKeyFormDialogState();
}

class _SshKeyFormDialogState extends ConsumerState<SshKeyFormDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameController = TextEditingController();
  final _commentController = TextEditingController(
    text: 'shellvault-generated',
  );
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

  Future<void> _saveGenerate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(error: () => AppLocalizations.of(context)!.sshKeyFormNameRequired);
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
        comment: _commentController.text.trim().isEmpty
            ? 'shellvault-generated'
            : _commentController.text.trim(),
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
            .copyWith(error: () => e.toString(), saving: false);
      }
    }
  }

  Future<void> _saveImport() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(error: () => AppLocalizations.of(context)!.sshKeyFormNameRequired);
      return;
    }
    final privateKey = _privateKeyController.text.trim();
    if (privateKey.isEmpty) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(
            error: () => AppLocalizations.of(context)!.sshKeyFormPrivateKeyRequired,
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
            .copyWith(error: () => e.toString(), saving: false);
      }
    }
  }

  Future<void> _saveEdit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ref.read(_sshKeyFormStateProvider.notifier).state = ref
          .read(_sshKeyFormStateProvider)
          .copyWith(error: () => AppLocalizations.of(context)!.sshKeyFormNameRequired);
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
            .copyWith(error: () => e.toString(), saving: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(_sshKeyFormStateProvider);

    final l10n = AppLocalizations.of(context)!;

    if (widget.isEditing) {
      return AlertDialog(
        title: Text(l10n.sshKeyFormTitleEdit),
        content: SizedBox(width: 480, child: _buildEditForm(theme, formState)),
        actions: _buildActions(onSave: _saveEdit, formState: formState),
      );
    }

    return AlertDialog(
      title: Text(l10n.sshKeyFormTitleAdd),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: l10n.sshKeyFormTabGenerate),
                Tab(text: l10n.sshKeyFormTabImport),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 380,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGenerateForm(theme, formState),
                  _buildImportForm(theme, formState),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: _buildActions(
        onSave: () {
          if (_tabController.index == 0) {
            _saveGenerate();
          } else {
            _saveImport();
          }
        },
        formState: formState,
      ),
    );
  }

  Widget _buildGenerateForm(ThemeData theme, _SshKeyFormReactiveState formState) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          DropdownButtonFormField<SshKeyType>(
            initialValue: formState.selectedType,
            decoration: InputDecoration(
              labelText: l10n.sshKeyFormKeyType,
              prefixIcon: const Icon(Icons.vpn_key),
            ),
            items: SshKeyType.values
                .map(
                  (t) => DropdownMenuItem(value: t, child: Text(t.displayName)),
                )
                .toList(),
            onChanged: formState.saving
                ? null
                : (type) {
                    if (type == null) return;
                    ref.read(_sshKeyFormStateProvider.notifier).state =
                        formState.copyWith(
                      selectedType: type,
                      selectedBits: type.defaultBitLength,
                    );
                  },
          ),
          const SizedBox(height: 16),
          if (formState.selectedType.allowedBitLengths.isNotEmpty)
            DropdownButtonFormField<int>(
              initialValue: formState.selectedBits > 0
                  ? formState.selectedBits
                  : formState.selectedType.defaultBitLength,
              decoration: InputDecoration(
                labelText: l10n.sshKeyFormKeySize,
                prefixIcon: const Icon(Icons.memory),
              ),
              items: formState.selectedType.allowedBitLengths
                  .map(
                    (b) => DropdownMenuItem(
                      value: b,
                      child: Text(l10n.sshKeyFormKeySizeBit(b)),
                    ),
                  )
                  .toList(),
              onChanged: formState.saving
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
            Text(formState.error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ],
      ),
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
            .copyWith(error: () => AppLocalizations.of(context)!.sshKeyFormFileReadError);
        return;
      }

      if (!content.contains('-----BEGIN')) {
        ref.read(_sshKeyFormStateProvider.notifier).state = ref
            .read(_sshKeyFormStateProvider)
            .copyWith(error: () => AppLocalizations.of(context)!.sshKeyFormInvalidFormat);
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
            error: () => AppLocalizations.of(context)!.sshKeyFormFileError(e.toString()),
          );
    }
  }

  Widget _buildImportForm(ThemeData theme, _SshKeyFormReactiveState formState) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Text(formState.error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ],
      ),
    );
  }

  Widget _buildEditForm(ThemeData theme, _SshKeyFormReactiveState formState) {
    final l10n = AppLocalizations.of(context)!;
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
        if (widget.existingKey != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.existingKey!.keyType.displayName}'
                  '${widget.existingKey!.fingerprint.isNotEmpty ? ' · ${widget.existingKey!.fingerprint}' : ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: AppConstants.monospaceFontFamily,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (formState.error != null) ...[
          const SizedBox(height: 16),
          Text(formState.error!, style: TextStyle(color: theme.colorScheme.error)),
        ],
      ],
    );
  }

  List<Widget> _buildActions({
    required VoidCallback onSave,
    required _SshKeyFormReactiveState formState,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return [
      TextButton(
        onPressed: formState.saving ? null : () => Navigator.pop(context),
        child: Text(l10n.cancel),
      ),
      FilledButton.icon(
        onPressed: formState.saving ? null : onSave,
        icon: formState.saving
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save, size: 18),
        label: Text(formState.saving ? l10n.sshKeyFormSaving : l10n.save),
      ),
    ];
  }
}
