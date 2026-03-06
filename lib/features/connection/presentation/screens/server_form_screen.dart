import 'package:flutter/material.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/constants/color_constants.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/constants/icon_constants.dart';
import 'package:sshvault/core/widgets/settings/section_card.dart';
import 'package:sshvault/core/crypto/crypto_provider.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/connection/presentation/widgets/key_generation_dialog.dart';
import 'package:sshvault/features/connection/domain/entities/server_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/folder_tree_picker.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/domain/entities/tag_entity.dart';
import 'package:sshvault/features/connection/presentation/widgets/color_picker_field.dart';
import 'package:sshvault/features/connection/presentation/widgets/icon_picker_field.dart';
import 'package:sshvault/features/connection/presentation/widgets/server_form_fields.dart';
import 'package:sshvault/features/connection/presentation/widgets/jump_host_selector.dart';
import 'package:sshvault/features/connection/presentation/widgets/tag_selector.dart';

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
  final String? jumpHostId;
  // Proxy
  final bool useGlobalProxy;
  final ProxyType proxyType;
  // VPN
  final bool requiresVpn;

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
    this.jumpHostId,
    this.useGlobalProxy = true,
    this.proxyType = ProxyType.none,
    this.requiresVpn = false,
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
    String? Function()? jumpHostId,
    bool? useGlobalProxy,
    ProxyType? proxyType,
    bool? requiresVpn,
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
      jumpHostId: jumpHostId != null ? jumpHostId() : this.jumpHostId,
      useGlobalProxy: useGlobalProxy ?? this.useGlobalProxy,
      proxyType: proxyType ?? this.proxyType,
      requiresVpn: requiresVpn ?? this.requiresVpn,
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
  final _proxyHostController = TextEditingController();
  final _proxyPortController = TextEditingController();
  final _proxyUsernameController = TextEditingController();
  final _proxyPasswordController = TextEditingController();
  final _postConnectController = TextEditingController();

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
    _proxyHostController.text = result.proxyHost;
    _proxyPortController.text = result.proxyPort.toString();
    _proxyUsernameController.text = result.proxyUsername ?? '';
    _postConnectController.text = result.postConnectCommands;
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
      jumpHostId: result.jumpHostId,
      useGlobalProxy: result.useGlobalProxy,
      proxyType: result.proxyType,
      requiresVpn: result.requiresVpn,
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
    _proxyHostController.dispose();
    _proxyPortController.dispose();
    _proxyUsernameController.dispose();
    _proxyPasswordController.dispose();
    _postConnectController.dispose();
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
    final foldersAsync = ref.watch(folderListProvider);
    final formState = ref.watch(_serverFormStateProvider);

    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold.withAppBar(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isEditing ? l10n.serverFormTitleEdit : l10n.serverFormTitleAdd,
        ),
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
          TextButton(
            onPressed: formState.saving ? null : _save,
            child: formState.saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                        ref.read(_serverFormStateProvider.notifier).state =
                            formState.copyWith(authMethod: m),
                    onGenerateKeyPair: _generateKeyPair,
                    onExtractPublicKey: _extractPublicKey,
                    useManagedKey: formState.useManagedKey,
                    onUseManagedKeyChanged: (v) =>
                        ref
                            .read(_serverFormStateProvider.notifier)
                            .state = formState.copyWith(
                          useManagedKey: v,
                          sshKeyId: v ? null : () => null,
                        ),
                    selectedSshKeyId: formState.sshKeyId,
                    onSshKeyChanged: (id) =>
                        ref.read(_serverFormStateProvider.notifier).state =
                            formState.copyWith(sshKeyId: () => id),
                  ),
                  const SizedBox(height: 16),
                  JumpHostSelector(
                    currentServerId: widget.serverId,
                    selectedJumpHostId: formState.jumpHostId,
                    onChanged: (id) =>
                        ref.read(_serverFormStateProvider.notifier).state =
                            formState.copyWith(jumpHostId: () => id),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SectionCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      final folderName = foldersAsync.whenOrNull(
                        data: (folders) => folders
                            .where((f) => f.id == formState.groupId)
                            .firstOrNull
                            ?.name,
                      );
                      return ListTile(
                        leading: const Icon(Icons.folder_outlined),
                        title: Text(folderName ?? l10n.serverNoFolder),
                        subtitle: Text(l10n.navFolders),
                        trailing: const Icon(Icons.chevron_right),
                        contentPadding: EdgeInsets.zero,
                        onTap: () async {
                          final result = await FolderTreePicker.show(
                            context,
                            selectedFolderId: formState.groupId,
                          );
                          if (result != formState.groupId) {
                            ref.read(_serverFormStateProvider.notifier).state =
                                formState.copyWith(groupId: () => result);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  TagSelector(
                    selectedTagIds: formState.selectedTagIds,
                    onChanged: (ids) =>
                        ref.read(_serverFormStateProvider.notifier).state =
                            formState.copyWith(selectedTagIds: ids),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Proxy Section
            SectionCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.proxySettings,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: Text(l10n.proxyUseGlobal),
                    value: formState.useGlobalProxy,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) =>
                        ref.read(_serverFormStateProvider.notifier).state =
                            formState.copyWith(useGlobalProxy: v),
                  ),
                  if (!formState.useGlobalProxy) ...[
                    const SizedBox(height: 8),
                    DropdownMenu<ProxyType>(
                      initialSelection: formState.proxyType,
                      label: Text(l10n.proxyType),
                      expandedInsets: EdgeInsets.zero,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: ProxyType.none,
                          label: l10n.proxyNone,
                        ),
                        DropdownMenuEntry(
                          value: ProxyType.socks5,
                          label: l10n.proxySocks5,
                        ),
                        DropdownMenuEntry(
                          value: ProxyType.httpConnect,
                          label: l10n.proxyHttpConnect,
                        ),
                      ],
                      onSelected: (v) =>
                          ref.read(_serverFormStateProvider.notifier).state =
                              formState.copyWith(proxyType: v),
                    ),
                    if (formState.proxyType != ProxyType.none) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _proxyHostController,
                        decoration: InputDecoration(
                          labelText: l10n.proxyHost,
                          hintText: '192.168.1.1',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _proxyPortController,
                        decoration: InputDecoration(
                          labelText: l10n.proxyPort,
                          hintText: '1080',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _proxyUsernameController,
                        decoration: InputDecoration(
                          labelText: l10n.proxyUsername,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _proxyPasswordController,
                        decoration: InputDecoration(
                          labelText: l10n.proxyPassword,
                        ),
                        obscureText: true,
                      ),
                    ],
                  ],
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: Text(l10n.vpnRequired),
                    subtitle: Text(l10n.vpnRequiredTooltip),
                    value: formState.requiresVpn,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) =>
                        ref.read(_serverFormStateProvider.notifier).state =
                            formState.copyWith(requiresVpn: v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Post-Connect Commands
            SectionCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.postConnectCommands,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.postConnectCommandsSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(AppConstants.alpha153),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _postConnectController,
                    decoration: InputDecoration(
                      hintText: l10n.postConnectCommandsHint,
                    ),
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SectionCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ColorPickerField(
                    selectedColor: formState.color,
                    onColorChanged: (c) =>
                        ref.read(_serverFormStateProvider.notifier).state =
                            formState.copyWith(color: c),
                  ),
                  const SizedBox(height: 16),

                  IconPickerField(
                    selectedIcon: formState.iconName,
                    onIconChanged: (i) =>
                        ref.read(_serverFormStateProvider.notifier).state =
                            formState.copyWith(iconName: i),
                    accentColor: formState.color,
                  ),
                ],
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
        jumpHostId: currentState.jumpHostId,
        useGlobalProxy: currentState.useGlobalProxy,
        proxyType: currentState.proxyType,
        proxyHost: _proxyHostController.text.trim(),
        proxyPort: int.tryParse(_proxyPortController.text.trim()) ?? 1080,
        proxyUsername: _proxyUsernameController.text.trim().isEmpty
            ? null
            : _proxyUsernameController.text.trim(),
        postConnectCommands: _postConnectController.text.trim(),
        requiresVpn: currentState.requiresVpn,
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
          message: AppLocalizations.of(context)!.error(errorMessage(e)),
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
