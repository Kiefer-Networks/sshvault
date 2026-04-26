import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/core/utils/validators.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_agent_provider.dart';
import 'package:sshvault/features/connection/presentation/widgets/auth_method_selector.dart';
import 'package:sshvault/features/connection/presentation/widgets/ssh_key_selector.dart';

/// Sentinel `sshKeyId` value used to represent "use key from ssh-agent"
/// without having to extend the persisted server entity. When the form
/// stores this id the runtime auth path should source the key from the
/// running agent rather than from the SSHVault key vault.
const String kSshAgentSentinelKeyId = '__ssh_agent__';

class ServerFormFields extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController hostnameController;
  final TextEditingController portController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController notesController;
  final AuthMethod authMethod;
  final ValueChanged<AuthMethod> onAuthMethodChanged;
  final bool showCredentials;
  final String? selectedSshKeyId;
  final ValueChanged<String?>? onSshKeyChanged;

  const ServerFormFields({
    super.key,
    required this.nameController,
    required this.hostnameController,
    required this.portController,
    required this.usernameController,
    required this.passwordController,
    required this.notesController,
    required this.authMethod,
    required this.onAuthMethodChanged,
    this.showCredentials = true,
    this.selectedSshKeyId,
    this.onSshKeyChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final agentAvailable =
        ref.watch(sshAgentAvailableProvider).asData?.value ?? false;
    final usingAgent = selectedSshKeyId == kSshAgentSentinelKeyId;
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
        Spacing.verticalLg,
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
            Spacing.horizontalMd,
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
        Spacing.verticalLg,
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
        Spacing.verticalXl,
        AuthMethodSelector(
          selected: authMethod,
          onChanged: onAuthMethodChanged,
        ),
        if (showCredentials) ...[
          Spacing.verticalLg,
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
            Spacing.verticalLg,
            if (onSshKeyChanged != null) ...[
              if (agentAvailable)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Use key from ssh-agent'),
                  subtitle: const Text(
                    r'Auth uses keys currently loaded in $SSH_AUTH_SOCK',
                  ),
                  value: usingAgent,
                  onChanged: (v) =>
                      onSshKeyChanged!(v ? kSshAgentSentinelKeyId : null),
                ),
              if (!usingAgent)
                SshKeySelector(
                  selectedKeyId: selectedSshKeyId,
                  onChanged: onSshKeyChanged!,
                ),
            ],
          ],
        ],
        Spacing.verticalLg,
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
