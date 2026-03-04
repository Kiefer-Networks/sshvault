import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/features/teleport/domain/entities/teleport_cluster_entity.dart';
import 'package:shellvault/features/teleport/presentation/providers/teleport_providers.dart';

class TeleportClusterFormScreen extends ConsumerStatefulWidget {
  const TeleportClusterFormScreen({super.key});

  @override
  ConsumerState<TeleportClusterFormScreen> createState() =>
      _TeleportClusterFormScreenState();
}

class _TeleportClusterFormScreenState
    extends ConsumerState<TeleportClusterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _proxyAddrController = TextEditingController();
  TeleportAuthMethod _authMethod = TeleportAuthMethod.identityFile;
  String? _identityFileName;
  Uint8List? _identityBytes;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _proxyAddrController.dispose();
    super.dispose();
  }

  Future<void> _pickIdentityFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _identityFileName = result.files.single.name;
        _identityBytes = result.files.single.bytes!;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final repo = ref.read(teleportRepositoryProvider);
    final result = await repo.registerCluster(
      name: _nameController.text.trim(),
      proxyAddr: _proxyAddrController.text.trim(),
      authMethod: _authMethodToString(_authMethod),
      identity: _identityBytes,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    result.fold(
      onSuccess: (cluster) async {
        await repo.saveClusterLocally(cluster);
        if (mounted) context.pop();
      },
      onFailure: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
    );
  }

  String _authMethodToString(TeleportAuthMethod m) {
    return switch (m) {
      TeleportAuthMethod.local => 'local',
      TeleportAuthMethod.ssoOidc => 'sso_oidc',
      TeleportAuthMethod.ssoSaml => 'sso_saml',
      TeleportAuthMethod.identityFile => 'identity_file',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.teleportClusterFormTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.teleportClusterNameLabel,
                  hintText: l10n.teleportClusterNameHint,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.teleportFieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _proxyAddrController,
                decoration: InputDecoration(
                  labelText: l10n.teleportProxyAddrLabel,
                  hintText: l10n.teleportProxyAddrHint,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.teleportFieldRequired : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TeleportAuthMethod>(
                initialValue: _authMethod,
                decoration: InputDecoration(labelText: l10n.teleportAuthMethodLabel),
                items: [
                  DropdownMenuItem(
                    value: TeleportAuthMethod.identityFile,
                    child: Text(l10n.teleportAuthIdentityFile),
                  ),
                  DropdownMenuItem(
                    value: TeleportAuthMethod.local,
                    child: Text(l10n.teleportAuthLocal),
                  ),
                  DropdownMenuItem(
                    value: TeleportAuthMethod.ssoOidc,
                    child: Text(l10n.teleportAuthSsoOidc),
                  ),
                  DropdownMenuItem(
                    value: TeleportAuthMethod.ssoSaml,
                    child: Text(l10n.teleportAuthSsoSaml),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _authMethod = v);
                },
              ),
              if (_authMethod == TeleportAuthMethod.identityFile) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _pickIdentityFile,
                  icon: const Icon(Icons.upload_file),
                  label: Text(_identityFileName ?? l10n.teleportSelectIdentityFile),
                ),
                if (_identityFileName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _identityFileName!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
              ],
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.teleportAddCluster),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
