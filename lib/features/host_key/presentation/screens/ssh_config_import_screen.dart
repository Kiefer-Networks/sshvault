import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/domain/entities/server_credentials.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/host_key/data/services/ssh_config_parser.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class SshConfigImportScreen extends ConsumerStatefulWidget {
  const SshConfigImportScreen({super.key});

  @override
  ConsumerState<SshConfigImportScreen> createState() =>
      _SshConfigImportScreenState();
}

class _SshConfigImportScreenState extends ConsumerState<SshConfigImportScreen> {
  final _textController = TextEditingController();
  final _parser = SshConfigParser();
  List<SshConfigEntry> _entries = [];
  final Set<int> _selected = {};
  final Set<String> _existingHostKeys = {};
  bool _loading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AdaptiveScaffold(
      title: l10n.sshConfigImportTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.file_open),
                  label: Text(l10n.sshConfigImportPickFile),
                  onPressed: _pickFile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 6,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.sshConfigImportOrPaste,
            ),
            onChanged: (_) => _parseContent(),
          ),
          const SizedBox(height: 16),
          if (_entries.isNotEmpty) ...[
            Text(
              l10n.sshConfigImportParsed(_entries.length),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ..._buildEntryList(l10n),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download),
              label: Text(l10n.sshConfigImportButton),
              onPressed: _selected.isEmpty || _loading
                  ? null
                  : () => _import(l10n),
            ),
          ] else if (_textController.text.isNotEmpty) ...[
            Text(
              l10n.sshConfigImportNoHosts,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildEntryList(AppLocalizations l10n) {
    return List.generate(_entries.length, (i) {
      final entry = _entries[i];
      final hostKey = '${entry.hostName ?? entry.host}:${entry.port}';
      final isDuplicate = _existingHostKeys.contains(hostKey);

      return CheckboxListTile(
        value: _selected.contains(i),
        onChanged: (v) {
          setState(() {
            if (v == true) {
              _selected.add(i);
            } else {
              _selected.remove(i);
            }
          });
        },
        title: Text(entry.host),
        subtitle: Text(
          '${entry.hostName ?? entry.host}:${entry.port}'
          '${entry.user != null ? ' (${entry.user})' : ''}'
          '${isDuplicate ? ' — ${l10n.sshConfigImportDuplicate}' : ''}',
        ),
        secondary: isDuplicate
            ? Icon(
                Icons.warning_amber,
                color: Theme.of(context).colorScheme.error,
              )
            : const Icon(Icons.dns_outlined),
      );
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final bytes = result.files.first.bytes;
    if (bytes == null) return;
    final content = String.fromCharCodes(bytes);
    _textController.text = content;
    _parseContent();
  }

  void _parseContent() {
    final parsed = _parser.parse(_textController.text);
    _loadExistingHosts().then((_) {
      setState(() {
        _entries = parsed;
        _selected.clear();
        for (int i = 0; i < parsed.length; i++) {
          final e = parsed[i];
          final key = '${e.hostName ?? e.host}:${e.port}';
          if (!_existingHostKeys.contains(key)) {
            _selected.add(i);
          }
        }
      });
    });
  }

  Future<void> _loadExistingHosts() async {
    final useCases = ref.read(serverUseCasesProvider);
    final result = await useCases.getServers();
    result.fold(
      onSuccess: (servers) {
        _existingHostKeys.clear();
        for (final s in servers) {
          _existingHostKeys.add('${s.hostname}:${s.port}');
        }
      },
      onFailure: (_) {},
    );
  }

  Future<void> _import(AppLocalizations l10n) async {
    setState(() => _loading = true);
    const uuid = Uuid();
    final useCases = ref.read(serverUseCasesProvider);
    int imported = 0;

    for (final i in _selected) {
      final entry = _entries[i];
      final now = DateTime.now();
      final server = ServerEntity(
        id: uuid.v4(),
        name: entry.host,
        hostname: entry.hostName ?? entry.host,
        port: entry.port,
        username: entry.user ?? 'root',
        authMethod: entry.identityFile != null
            ? AuthMethod.key
            : AuthMethod.password,
        color: 0xFF6C63FF,
        createdAt: now,
        updatedAt: now,
      );

      final result = await useCases.createServer(
        server,
        const ServerCredentials(),
      );
      if (result.isSuccess) imported++;
    }

    setState(() => _loading = false);

    if (mounted) {
      ref.invalidate(serverListProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.sshConfigImportSuccess(imported))),
      );
      if (imported > 0) Navigator.of(context).pop();
    }
  }
}
