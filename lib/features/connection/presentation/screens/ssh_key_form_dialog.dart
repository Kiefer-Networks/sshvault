import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/crypto/crypto_provider.dart';
import 'package:shellvault/core/crypto/ssh_key_type.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/ssh_key_providers.dart';

class SshKeyFormDialog extends ConsumerStatefulWidget {
  final SshKeyEntity? existingKey;

  const SshKeyFormDialog({super.key, this.existingKey});

  bool get isEditing => existingKey != null;

  static Future<bool?> show(
    BuildContext context, {
    SshKeyEntity? existingKey,
  }) {
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
  final _commentController = TextEditingController(text: 'shellvault-generated');
  final _privateKeyController = TextEditingController();
  final _passphraseController = TextEditingController();

  SshKeyType _selectedType = SshKeyType.ed25519;
  int _selectedBits = 0;
  bool _saving = false;
  String? _error;

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
      setState(() => _error = 'Name is required');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final sshKeyService = ref.read(sshKeyServiceProvider);
      final options = SshKeyOptions(
        type: _selectedType,
        bits: _selectedBits,
        comment: _commentController.text.trim().isEmpty
            ? 'shellvault-generated'
            : _commentController.text.trim(),
      );

      final genResult = await sshKeyService.generateKeyPair(options);
      if (!mounted) return;

      if (genResult.isFailure) {
        setState(() {
          _error = genResult.failure.message;
          _saving = false;
        });
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

      await ref.read(sshKeyListProvider.notifier).createSshKey(
            entity,
            privateKey: keyPair.privateKey,
          );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _saving = false;
        });
      }
    }
  }

  Future<void> _saveImport() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Name is required');
      return;
    }
    final privateKey = _privateKeyController.text.trim();
    if (privateKey.isEmpty) {
      setState(() => _error = 'Private key is required');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      // Detect key type from private key content
      SshKeyType keyType = SshKeyType.ed25519;
      if (privateKey.contains('RSA PRIVATE KEY') ||
          (privateKey.contains('BEGIN PRIVATE KEY') &&
              !privateKey.contains('EC PRIVATE KEY') &&
              !privateKey.contains('OPENSSH PRIVATE KEY'))) {
        keyType = SshKeyType.rsa;
      } else if (privateKey.contains('EC PRIVATE KEY')) {
        keyType = SshKeyType.ecdsa256; // Will be refined by extractPublicKey
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
      await ref.read(sshKeyListProvider.notifier).createSshKey(
            entity,
            privateKey: privateKey,
            passphrase: passphrase.isEmpty ? null : passphrase,
          );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _saving = false;
        });
      }
    }
  }

  Future<void> _saveEdit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Name is required');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final updated = widget.existingKey!.copyWith(
        name: name,
        comment: _commentController.text.trim(),
      );
      await ref.read(sshKeyListProvider.notifier).updateSshKey(updated);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isEditing) {
      return AlertDialog(
        title: const Text('Edit SSH Key'),
        content: SizedBox(
          width: 480,
          child: _buildEditForm(theme),
        ),
        actions: _buildActions(onSave: _saveEdit),
      );
    }

    return AlertDialog(
      title: const Text('Add SSH Key'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Generate'),
                Tab(text: 'Import'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 380,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGenerateForm(theme),
                  _buildImportForm(theme),
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
      ),
    );
  }

  Widget _buildGenerateForm(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Key Name',
              prefixIcon: Icon(Icons.label_outline),
              hintText: 'e.g. My Production Key',
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<SshKeyType>(
            initialValue: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Key Type',
              prefixIcon: Icon(Icons.vpn_key),
            ),
            items: SshKeyType.values
                .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.displayName),
                    ))
                .toList(),
            onChanged: _saving
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
          if (_selectedType.allowedBitLengths.isNotEmpty)
            DropdownButtonFormField<int>(
              initialValue: _selectedBits > 0
                  ? _selectedBits
                  : _selectedType.defaultBitLength,
              decoration: const InputDecoration(
                labelText: 'Key Size',
                prefixIcon: Icon(Icons.memory),
              ),
              items: _selectedType.allowedBitLengths
                  .map((b) => DropdownMenuItem(
                        value: b,
                        child: Text('$b bit'),
                      ))
                  .toList(),
              onChanged: _saving
                  ? null
                  : (bits) {
                      if (bits != null) setState(() => _selectedBits = bits);
                    },
            )
          else
            Row(
              children: [
                Icon(Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  _selectedType.keySizeLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Comment',
              prefixIcon: Icon(Icons.comment_outlined),
              hintText: 'user@host or description',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ],
      ),
    );
  }

  Widget _buildImportForm(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Key Name',
              prefixIcon: Icon(Icons.label_outline),
              hintText: 'e.g. My Production Key',
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _privateKeyController,
            decoration: const InputDecoration(
              labelText: 'Private Key',
              prefixIcon: Icon(Icons.vpn_key),
              hintText: 'Paste SSH private key...',
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passphraseController,
            decoration: const InputDecoration(
              labelText: 'Passphrase (optional)',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Comment (optional)',
              prefixIcon: Icon(Icons.comment_outlined),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ],
      ),
    );
  }

  Widget _buildEditForm(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Key Name',
            prefixIcon: Icon(Icons.label_outline),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _commentController,
          decoration: const InputDecoration(
            labelText: 'Comment',
            prefixIcon: Icon(Icons.comment_outlined),
          ),
        ),
        if (widget.existingKey != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.info_outline,
                  size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                '${widget.existingKey!.keyType.displayName}'
                '${widget.existingKey!.fingerprint.isNotEmpty ? ' · ${widget.existingKey!.fingerprint}' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
        ],
      ],
    );
  }

  List<Widget> _buildActions({required VoidCallback onSave}) {
    return [
      TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton.icon(
        onPressed: _saving ? null : onSave,
        icon: _saving
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save, size: 18),
        label: Text(_saving ? 'Saving...' : 'Save'),
      ),
    ];
  }
}
