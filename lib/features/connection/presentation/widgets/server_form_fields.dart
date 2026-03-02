import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n.serverFormNameLabel,
            prefixIcon: const Icon(Icons.label_outline),
          ),
          keyboardType: TextInputType.text,
          validator: Validators.serverNameValidator(l10n),
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
                decoration: InputDecoration(
                  labelText: l10n.serverFormHostnameLabel,
                  prefixIcon: const Icon(Icons.dns_outlined),
                ),
                keyboardType: TextInputType.url,
                validator: Validators.hostnameValidator(l10n),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: portController,
                decoration: InputDecoration(
                  labelText: l10n.serverFormPortLabel,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validators.portValidator(l10n),
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: l10n.serverFormUsernameLabel,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          keyboardType: TextInputType.text,
          validator: Validators.usernameValidator(l10n),
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
              decoration: InputDecoration(
                labelText: l10n.serverFormPasswordLabel,
                prefixIcon: const Icon(Icons.password),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
          if (authMethod == AuthMethod.key ||
              authMethod == AuthMethod.both) ...[
            const SizedBox(height: 16),
            if (onUseManagedKeyChanged != null)
              SwitchListTile(
                title: Text(l10n.serverFormUseManagedKey),
                subtitle: Text(
                  useManagedKey
                      ? l10n.serverFormManagedKeySubtitle
                      : l10n.serverFormDirectKeySubtitle,
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
                    label: Text(l10n.serverFormGenerateKey),
                  ),
                ),
              TextFormField(
                controller: privateKeyController,
                decoration: InputDecoration(
                  labelText: l10n.serverFormPrivateKeyLabel,
                  prefixIcon: const Icon(Icons.vpn_key),
                  hintText: l10n.serverFormPrivateKeyHint,
                  suffixIcon:
                      onExtractPublicKey != null &&
                          privateKeyController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.key, size: 20),
                          tooltip: l10n.serverFormExtractPublicKey,
                          onPressed: onExtractPublicKey,
                        )
                      : null,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: useManagedKey
                    ? null
                    : Validators.sshKeyValidator(l10n),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: publicKeyController,
                decoration: InputDecoration(
                  labelText: l10n.serverFormPublicKeyLabel,
                  prefixIcon: const Icon(Icons.key),
                  hintText: l10n.serverFormPublicKeyHint,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                readOnly: false,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passphraseController,
                decoration: InputDecoration(
                  labelText: l10n.serverFormPassphraseLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
            ],
          ],
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: notesController,
          decoration: InputDecoration(
            labelText: l10n.serverFormNotesLabel,
            prefixIcon: const Icon(Icons.notes),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
        ),
      ],
    );
  }
}
