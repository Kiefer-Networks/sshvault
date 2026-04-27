import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import 'package:sshvault/core/utils/file_chooser.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/server_credentials.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/host_key/domain/services/ssh_config_parser.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

final _importEntriesProvider = StateProvider.autoDispose<List<SshConfigEntry>>(
  (ref) => [],
);
final _importSelectedProvider = StateProvider.autoDispose<Set<int>>(
  (ref) => {},
);
final _importLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final _existingHostKeysProvider = StateProvider.autoDispose<Set<String>>(
  (ref) => {},
);

class SshConfigImportScreen extends ConsumerStatefulWidget {
  const SshConfigImportScreen({super.key});

  @override
  ConsumerState<SshConfigImportScreen> createState() =>
      _SshConfigImportScreenState();
}

class _SshConfigImportScreenState extends ConsumerState<SshConfigImportScreen> {
  final _textController = TextEditingController();
  final _parser = SshConfigParser();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = ref.watch(_importEntriesProvider);
    final selected = ref.watch(_importSelectedProvider);
    final loading = ref.watch(_importLoadingProvider);

    return AdaptiveScaffold(
      title: l10n.sshConfigImportTitle,
      body: ListView(
        padding: Spacing.paddingAllLg,
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
          Spacing.verticalLg,
          TextField(
            controller: _textController,
            maxLines: 6,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.sshConfigImportOrPaste,
            ),
            onChanged: (_) => _parseContent(),
          ),
          Spacing.verticalLg,
          if (entries.isNotEmpty) ...[
            Text(
              l10n.sshConfigImportParsed(entries.length),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Spacing.verticalSm,
            ..._buildEntryList(l10n, entries, selected),
            Spacing.verticalLg,
            FilledButton.icon(
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download),
              label: Text(l10n.sshConfigImportButton),
              onPressed: selected.isEmpty || loading
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

  List<Widget> _buildEntryList(
    AppLocalizations l10n,
    List<SshConfigEntry> entries,
    Set<int> selected,
  ) {
    final existingKeys = ref.read(_existingHostKeysProvider);
    return List.generate(entries.length, (i) {
      final entry = entries[i];
      final hostKey = '${entry.hostName ?? entry.host}:${entry.port}';
      final isDuplicate = existingKeys.contains(hostKey);

      return CheckboxListTile(
        value: selected.contains(i),
        onChanged: (v) {
          final current = Set<int>.from(ref.read(_importSelectedProvider));
          if (v == true) {
            current.add(i);
          } else {
            current.remove(i);
          }
          ref.read(_importSelectedProvider.notifier).state = current;
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
    final result = await FileChooser.openFile(
      dialogTitle: AppLocalizations.of(context)!.fileChooserImportSshConfig,
      filters: const [FileTypeFilter.plainText],
      withData: true,
    );
    if (result == null) return;
    final bytes = result.bytes;
    if (bytes == null) return;
    final content = String.fromCharCodes(bytes);
    _textController.text = content;
    _parseContent();
  }

  void _parseContent() {
    final parsed = _parser.parse(_textController.text);
    _loadExistingHosts().then((_) {
      final existingKeys = ref.read(_existingHostKeysProvider);
      final selected = <int>{};
      for (int i = 0; i < parsed.length; i++) {
        final e = parsed[i];
        final key = '${e.hostName ?? e.host}:${e.port}';
        if (!existingKeys.contains(key)) {
          selected.add(i);
        }
      }
      ref.read(_importEntriesProvider.notifier).state = parsed;
      ref.read(_importSelectedProvider.notifier).state = selected;
    });
  }

  Future<void> _loadExistingHosts() async {
    final useCases = ref.read(serverUseCasesProvider);
    final result = await useCases.getServers();
    result.fold(
      onSuccess: (servers) {
        final keys = <String>{};
        for (final s in servers) {
          keys.add('${s.hostname}:${s.port}');
        }
        ref.read(_existingHostKeysProvider.notifier).state = keys;
      },
      onFailure: (f) {
        LoggingService.instance.error(
          'SshConfigImport',
          'SSH config import failed: $f',
        );
      },
    );
  }

  Future<void> _import(AppLocalizations l10n) async {
    ref.read(_importLoadingProvider.notifier).state = true;
    const uuid = Uuid();
    final useCases = ref.read(serverUseCasesProvider);
    final entries = ref.read(_importEntriesProvider);
    final selected = ref.read(_importSelectedProvider);
    int imported = 0;

    for (final i in selected) {
      final entry = entries[i];
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

    ref.read(_importLoadingProvider.notifier).state = false;

    if (mounted) {
      ref.invalidate(serverListProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.sshConfigImportSuccess(imported))),
      );
      if (imported > 0) Navigator.of(context).pop();
    }
  }
}
