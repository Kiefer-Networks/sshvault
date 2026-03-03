import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/constants/color_constants.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/core/constants/icon_constants.dart';
import 'package:shellvault/core/crypto/crypto_provider.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/presentation/widgets/key_generation_dialog.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/group_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/presentation/widgets/color_picker_field.dart';
import 'package:shellvault/features/connection/presentation/widgets/icon_picker_field.dart';
import 'package:shellvault/features/connection/presentation/widgets/server_form_fields.dart';
import 'package:shellvault/features/connection/presentation/widgets/tag_selector.dart';

class _ServerFormReactiveState {
  final AuthMethod authMethod;
  final int color;
  final String iconName;
  final String? groupId;
  final String? sshKeyId;
  final bool useManagedKey;
  final List<String> selectedTagIds;
  final bool isActive;
  final bool saving;

  const _ServerFormReactiveState({
    this.authMethod = AuthMethod.password,
    this.color = ColorConstants.defaultServerColor,
    this.iconName = IconConstants.defaultIconName,
    this.groupId,
    this.sshKeyId,
    this.useManagedKey = false,
    this.selectedTagIds = const [],
    this.isActive = true,
    this.saving = false,
  });

  _ServerFormReactiveState copyWith({
    AuthMethod? authMethod,
    int? color,
    String? iconName,
    String? Function()? groupId,
    String? Function()? sshKeyId,
    bool? useManagedKey,
    List<String>? selectedTagIds,
    bool? isActive,
    bool? saving,
  }) {
    return _ServerFormReactiveState(
      authMethod: authMethod ?? this.authMethod,
      color: color ?? this.color,
      iconName: iconName ?? this.iconName,
      groupId: groupId != null ? groupId() : this.groupId,
      sshKeyId: sshKeyId != null ? sshKeyId() : this.sshKeyId,
      useManagedKey: useManagedKey ?? this.useManagedKey,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      isActive: isActive ?? this.isActive,
      saving: saving ?? this.saving,
    );
  }
}

final _serverFormStateProvider =
    StateProvider.autoDispose<_ServerFormReactiveState>(
      (ref) => const _ServerFormReactiveState(),
    );

class ServerFormScreen extends ConsumerStatefulWidget {
  final String? serverId;

  const ServerFormScreen({super.key, this.serverId});

  bool get isEditing => serverId != null;

  @override
  ConsumerState<ServerFormScreen> createState() => _ServerFormScreenState();
}

class _ServerFormScreenState extends ConsumerState<ServerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hostnameController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _passphraseController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _portController.text = AppConstants.defaultSshPort.toString();
    _usernameController.text = AppConstants.defaultUsername;

    if (widget.isEditing) {
      _loadServer();
    }
  }

  Future<void> _loadServer() async {
    final result = await ref.read(
      serverDetailProvider(widget.serverId!).future,
    );
    if (!mounted) return;
    _nameController.text = result.name;
    _hostnameController.text = result.hostname;
    _portController.text = result.port.toString();
    _usernameController.text = result.username;
    _notesController.text = result.notes;
    ref
        .read(_serverFormStateProvider.notifier)
        .state = _ServerFormReactiveState(
      authMethod: result.authMethod,
      color: result.color,
      iconName: result.iconName,
      groupId: result.groupId,
      sshKeyId: result.sshKeyId,
      useManagedKey: result.sshKeyId != null,
      selectedTagIds: result.tags.map((t) => t.id).toList(),
      isActive: result.isActive,
    );

    final creds = await ref.read(
      serverCredentialsProvider(widget.serverId!).future,
    );
    if (!mounted) return;
    _passwordController.text = creds.password ?? '';
    _privateKeyController.text = creds.privateKey ?? '';
    _publicKeyController.text = creds.publicKey ?? '';
    _passphraseController.text = creds.passphrase ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostnameController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _privateKeyController.dispose();
    _publicKeyController.dispose();
    _passphraseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _generateKeyPair() async {
    final sshKeyService = ref.read(sshKeyServiceProvider);
    final result = await KeyGenerationDialog.show(context, sshKeyService);
    if (result != null && mounted) {
      _privateKeyController.text = result.privateKey;
      _publicKeyController.text = result.publicKey;
      AdaptiveNotification.show(
        context,
        message: AppLocalizations.of(
          context,
        )!.serverFormKeyGenerated(result.type.displayName),
      );
    }
  }

  Future<void> _extractPublicKey() async {
    final privateKey = _privateKeyController.text.trim();
    if (privateKey.isEmpty) return;

    final sshKeyService = ref.read(sshKeyServiceProvider);
    final result = await sshKeyService.extractPublicKey(privateKey);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    result.fold(
      onSuccess: (publicKey) {
        _publicKeyController.text = publicKey;
        AdaptiveNotification.show(
          context,
          message: l10n.serverFormPublicKeyExtracted,
        );
      },
      onFailure: (failure) {
        AdaptiveNotification.show(
          context,
          message: l10n.serverFormPublicKeyError(failure.message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupListProvider);
    final formState = ref.watch(_serverFormStateProvider);

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      title: widget.isEditing
          ? l10n.serverFormTitleEdit
          : l10n.serverFormTitleAdd,
      actions: [
        if (widget.isEditing)
          Row(
            children: [
              Text(l10n.serverActive),
              Switch(
                value: formState.isActive,
                onChanged: (v) =>
                    ref.read(_serverFormStateProvider.notifier).state =
                        formState.copyWith(isActive: v),
              ),
            ],
          ),
      ],
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ServerFormFields(
              nameController: _nameController,
              hostnameController: _hostnameController,
              portController: _portController,
              usernameController: _usernameController,
              passwordController: _passwordController,
              privateKeyController: _privateKeyController,
              publicKeyController: _publicKeyController,
              passphraseController: _passphraseController,
              notesController: _notesController,
              authMethod: formState.authMethod,
              onAuthMethodChanged: (m) =>
                  ref.read(_serverFormStateProvider.notifier).state = formState
                      .copyWith(authMethod: m),
              onGenerateKeyPair: _generateKeyPair,
              onExtractPublicKey: _extractPublicKey,
              useManagedKey: formState.useManagedKey,
              onUseManagedKeyChanged: (v) =>
                  ref.read(_serverFormStateProvider.notifier).state = formState
                      .copyWith(
                        useManagedKey: v,
                        sshKeyId: v ? null : () => null,
                      ),
              selectedSshKeyId: formState.sshKeyId,
              onSshKeyChanged: (id) =>
                  ref.read(_serverFormStateProvider.notifier).state = formState
                      .copyWith(sshKeyId: () => id),
            ),
            const SizedBox(height: 24),

            groupsAsync.when(
              data: (groups) {
                if (groups.isEmpty) return const SizedBox.shrink();
                return DropdownButtonFormField<String?>(
                  initialValue: formState.groupId,
                  decoration: InputDecoration(
                    labelText: l10n.navGroups,
                    prefixIcon: const Icon(Icons.folder_outlined),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.serverNoGroup),
                    ),
                    ...groups.map(
                      (g) => DropdownMenuItem(value: g.id, child: Text(g.name)),
                    ),
                  ],
                  onChanged: (v) =>
                      ref.read(_serverFormStateProvider.notifier).state =
                          formState.copyWith(groupId: () => v),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            TagSelector(
              selectedTagIds: formState.selectedTagIds,
              onChanged: (ids) =>
                  ref.read(_serverFormStateProvider.notifier).state = formState
                      .copyWith(selectedTagIds: ids),
            ),
            const SizedBox(height: 24),

            ColorPickerField(
              selectedColor: formState.color,
              onColorChanged: (c) =>
                  ref.read(_serverFormStateProvider.notifier).state = formState
                      .copyWith(color: c),
            ),
            const SizedBox(height: 24),

            IconPickerField(
              selectedIcon: formState.iconName,
              onIconChanged: (i) =>
                  ref.read(_serverFormStateProvider.notifier).state = formState
                      .copyWith(iconName: i),
              accentColor: formState.color,
            ),
            const SizedBox(height: 32),

            AdaptiveButton.filledIcon(
              onPressed: formState.saving ? null : _save,
              icon: formState.saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(
                widget.isEditing
                    ? l10n.serverFormUpdateButton
                    : l10n.serverFormAddButton,
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final notifierState = ref.read(_serverFormStateProvider.notifier);
    final formState = ref.read(_serverFormStateProvider);
    notifierState.state = formState.copyWith(saving: true);

    try {
      final now = DateTime.now();
      final now0 = DateTime.fromMillisecondsSinceEpoch(0);
      final currentState = ref.read(_serverFormStateProvider);
      final tags = currentState.selectedTagIds
          .map(
            (id) =>
                TagEntity(id: id, name: '', createdAt: now0, updatedAt: now0),
          )
          .toList();

      final server = ServerEntity(
        id: widget.serverId ?? '',
        name: _nameController.text.trim(),
        hostname: _hostnameController.text.trim(),
        port: int.parse(_portController.text.trim()),
        username: _usernameController.text.trim(),
        authMethod: currentState.authMethod,
        notes: _notesController.text.trim(),
        color: currentState.color,
        iconName: currentState.iconName,
        isActive: currentState.isActive,
        groupId: currentState.groupId,
        sshKeyId: currentState.useManagedKey ? currentState.sshKeyId : null,
        tags: tags,
        createdAt: now,
        updatedAt: now,
      );

      final credentials = ServerCredentials(
        password: _passwordController.text.isEmpty
            ? null
            : _passwordController.text,
        privateKey: _privateKeyController.text.isEmpty
            ? null
            : _privateKeyController.text,
        publicKey: _publicKeyController.text.isEmpty
            ? null
            : _publicKeyController.text,
        passphrase: _passphraseController.text.isEmpty
            ? null
            : _passphraseController.text,
      );

      final notifier = ref.read(serverListProvider.notifier);
      if (widget.isEditing) {
        await notifier.updateServer(server, credentials);
      } else {
        await notifier.createServer(server, credentials);
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AdaptiveNotification.show(
          context,
          message: AppLocalizations.of(context)!.error(e.toString()),
        );
      }
    } finally {
      if (mounted) {
        ref.read(_serverFormStateProvider.notifier).state = ref
            .read(_serverFormStateProvider)
            .copyWith(saving: false);
      }
    }
  }
}
