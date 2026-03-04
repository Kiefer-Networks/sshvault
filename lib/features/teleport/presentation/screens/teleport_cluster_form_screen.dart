import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  List<int>? _identityBytes;
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
        _identityBytes = result.files.single.bytes!.toList();
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
      identity: _identityBytes != null
          ? base64Decode(base64Encode(_identityBytes!))
          : null,
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

    return Scaffold(
      appBar: AppBar(title: const Text('Add Teleport Cluster')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cluster Name',
                  hintText: 'e.g. Production',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _proxyAddrController,
                decoration: const InputDecoration(
                  labelText: 'Proxy Address',
                  hintText: 'e.g. teleport.example.com:443',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TeleportAuthMethod>(
                initialValue: _authMethod,
                decoration: const InputDecoration(labelText: 'Auth Method'),
                items: const [
                  DropdownMenuItem(
                    value: TeleportAuthMethod.identityFile,
                    child: Text('Identity File'),
                  ),
                  DropdownMenuItem(
                    value: TeleportAuthMethod.local,
                    child: Text('Local (User/Password)'),
                  ),
                  DropdownMenuItem(
                    value: TeleportAuthMethod.ssoOidc,
                    child: Text('SSO (OIDC)'),
                  ),
                  DropdownMenuItem(
                    value: TeleportAuthMethod.ssoSaml,
                    child: Text('SSO (SAML)'),
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
                  label: Text(_identityFileName ?? 'Select Identity File'),
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
                    : const Text('Add Cluster'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
