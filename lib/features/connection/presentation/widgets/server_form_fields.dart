import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/core/utils/validators.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/presentation/widgets/auth_method_selector.dart';
import 'package:shellvault/features/connection/presentation/widgets/ssh_key_selector.dart';

class ServerFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController hostnameController;
  final TextEditingController portController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController privateKeyController;
  final TextEditingController publicKeyController;
  final TextEditingController passphraseController;
  final TextEditingController notesController;
  final AuthMethod authMethod;
  final ValueChanged<AuthMethod> onAuthMethodChanged;
  final bool showCredentials;
  final VoidCallback? onGenerateKeyPair;
  final VoidCallback? onExtractPublicKey;
  final bool useManagedKey;
  final ValueChanged<bool>? onUseManagedKeyChanged;
  final String? selectedSshKeyId;
  final ValueChanged<String?>? onSshKeyChanged;

  const ServerFormFields({
    super.key,
    required this.nameController,
    required this.hostnameController,
    required this.portController,
    required this.usernameController,
    required this.passwordController,
    required this.privateKeyController,
    required this.publicKeyController,
    required this.passphraseController,
    required this.notesController,
    required this.authMethod,
    required this.onAuthMethodChanged,
    this.showCredentials = true,
    this.onGenerateKeyPair,
    this.onExtractPublicKey,
    this.useManagedKey = false,
    this.onUseManagedKeyChanged,
    this.selectedSshKeyId,
    this.onSshKeyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Server Name',
            prefixIcon: Icon(Icons.label_outline),
          ),
          validator: Validators.validateServerName,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: hostnameController,
                decoration: const InputDecoration(
                  labelText: 'Hostname / IP',
                  prefixIcon: Icon(Icons.dns_outlined),
                ),
                validator: Validators.validateHostname,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validators.validatePort,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: Validators.validateUsername,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        AuthMethodSelector(
          selected: authMethod,
          onChanged: onAuthMethodChanged,
        ),
        if (showCredentials) ...[
          const SizedBox(height: 16),
          if (authMethod == AuthMethod.password ||
              authMethod == AuthMethod.both)
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.password),
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
          if (authMethod == AuthMethod.key ||
              authMethod == AuthMethod.both) ...[
            const SizedBox(height: 16),
            if (onUseManagedKeyChanged != null)
              SwitchListTile(
                title: const Text('Use Managed Key'),
                subtitle: Text(
                  useManagedKey
                      ? 'Select from centrally managed SSH keys'
                      : 'Paste key directly into this server',
                ),
                value: useManagedKey,
                onChanged: onUseManagedKeyChanged,
                contentPadding: EdgeInsets.zero,
              ),
            if (useManagedKey && onSshKeyChanged != null) ...[
              const SizedBox(height: 8),
              SshKeySelector(
                selectedKeyId: selectedSshKeyId,
                onChanged: onSshKeyChanged!,
              ),
            ],
            if (!useManagedKey) ...[
              if (onGenerateKeyPair != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OutlinedButton.icon(
                    onPressed: onGenerateKeyPair,
                    icon: const Icon(Icons.auto_fix_high, size: 18),
                    label: const Text('Generate SSH Key Pair'),
                  ),
                ),
              TextFormField(
                controller: privateKeyController,
                decoration: InputDecoration(
                  labelText: 'Private Key',
                  prefixIcon: const Icon(Icons.vpn_key),
                  hintText: 'Paste SSH private key...',
                  suffixIcon: onExtractPublicKey != null &&
                          privateKeyController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.key, size: 20),
                          tooltip: 'Extract Public Key',
                          onPressed: onExtractPublicKey,
                        )
                      : null,
                ),
                maxLines: 3,
                validator: useManagedKey ? null : Validators.validateSshKey,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: publicKeyController,
                decoration: const InputDecoration(
                  labelText: 'Public Key',
                  prefixIcon: Icon(Icons.key),
                  hintText: 'Auto-generated from private key if empty',
                ),
                maxLines: 2,
                readOnly: false,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passphraseController,
                decoration: const InputDecoration(
                  labelText: 'Key Passphrase (optional)',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
            ],
          ],
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: notesController,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            prefixIcon: Icon(Icons.notes),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
