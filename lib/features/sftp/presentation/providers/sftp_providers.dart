import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/sftp/data/services/archive_service.dart';
import 'package:shellvault/features/sftp/data/services/local_file_service.dart';
import 'package:shellvault/features/sftp/data/services/sftp_connection_manager.dart';
import 'package:shellvault/features/sftp/data/services/sftp_service.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_entry.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_pane_state.dart';
import 'package:shellvault/features/sftp/domain/entities/transfer_item.dart';

// ---------------------------------------------------------------------------
// Service Providers
// ---------------------------------------------------------------------------

final sftpServiceProvider = Provider<SftpService>((ref) => SftpService());

final localFileServiceProvider = Provider<LocalFileService>(
  (ref) => LocalFileService(),
);

final archiveServiceProvider = Provider<ArchiveService>(
  (ref) => ArchiveService(),
);

final sftpConnectionManagerProvider = Provider<SftpConnectionManager>((ref) {
  final manager = SftpConnectionManager();
  ref.onDispose(() => manager.closeAll());
  return manager;
});

// ---------------------------------------------------------------------------
// Pane State
// ---------------------------------------------------------------------------

enum PaneSide { left, right }

final sftpPaneProvider =
    NotifierProvider.family<SftpPaneNotifier, SftpPaneState, PaneSide>(
      (side) => SftpPaneNotifier(side),
    );

class SftpPaneNotifier extends Notifier<SftpPaneState> {
  final PaneSide side;
  SftpPaneNotifier(this.side);

  // Preserve remote state across Android activity lifecycle rebuilds.
  // Static so it survives notifier re-creation.
  static final _preserved = <PaneSide, SftpPaneState>{};

  @override
  SftpPaneState build() {
    // Recover from Android activity lifecycle rebuild — if we had a remote
    // source before, restore it instead of resetting to local.
    final saved = _preserved[side];
    if (saved != null && saved.source is SftpPaneSourceRemote) {
      Future.microtask(() => _loadRemoteDirectory(saved.currentPath));
      return saved.copyWith(isLoading: true);
    }

    // Normal first-time initialization
    Future.microtask(() async {
      final localService = ref.read(localFileServiceProvider);
      final initialPath = await localService.getInitialPath();
      state = state.copyWith(currentPath: initialPath);
      await refresh();
    });
    return const SftpPaneState(
      source: SftpPaneSource.local(),
      currentPath: '/',
      isLoading: true,
    );
  }

  Future<void> setSource(SftpPaneSource source) async {
    // Clear preserved state when explicitly switching to local
    if (source is SftpPaneSourceLocal) {
      _preserved.remove(side);
    }
    state = state.copyWith(
      source: source,
      entries: [],
      selectedPaths: {},
      error: null,
    );

    switch (source) {
      case SftpPaneSourceLocal():
        final localService = ref.read(localFileServiceProvider);
        final initialPath = await localService.getInitialPath();
        state = state.copyWith(currentPath: initialPath);
        await refresh();
      case SftpPaneSourceRemote(:final serverId):
        state = state.copyWith(currentPath: '/', isLoading: true);
        try {
          final connMgr = ref.read(sftpConnectionManagerProvider);
          final result = await connMgr.getClient(serverId, ref.container);
          switch (result) {
            case Success():
              await _loadRemoteDirectory('/');
            case Err(:final error):
              state = state.copyWith(isLoading: false, error: error.message);
          }
        } catch (e) {
          state = state.copyWith(isLoading: false, error: errorMessage(e));
        }
    }
  }

  Future<void> navigateTo(String path) async {
    state = state.copyWith(selectedPaths: {}, error: null);
    switch (state.source) {
      case SftpPaneSourceLocal():
        state = state.copyWith(currentPath: path);
        await refresh();
      case SftpPaneSourceRemote():
        await _loadRemoteDirectory(path);
    }
  }

  Future<void> navigateUp() async {
    final parent = state.source is SftpPaneSourceLocal
        ? p.dirname(state.currentPath)
        : p.posix.dirname(state.currentPath);
    if (parent != state.currentPath) {
      await navigateTo(parent);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);

    switch (state.source) {
      case SftpPaneSourceLocal():
        final localService = ref.read(localFileServiceProvider);
        final result = await localService.listDirectory(state.currentPath);
        result.fold(
          onSuccess: (entries) {
            state = state.copyWith(
              entries: _sortAndFilter(entries),
              isLoading: false,
            );
          },
          onFailure: (f) {
            state = state.copyWith(isLoading: false, error: f.message);
          },
        );
      case SftpPaneSourceRemote():
        await _loadRemoteDirectory(state.currentPath);
    }
  }

  Future<void> _loadRemoteDirectory(String path) async {
    state = state.copyWith(isLoading: true, currentPath: path, error: null);

    final source = state.source;
    if (source is! SftpPaneSourceRemote) return;

    try {
      final connMgr = ref.read(sftpConnectionManagerProvider);
      final clientResult = await connMgr.getClient(
        source.serverId,
        ref.container,
      );

      switch (clientResult) {
        case Success(:final data):
          final sftpService = ref.read(sftpServiceProvider);
          final result = await sftpService.listDirectory(data, path);
          result.fold(
            onSuccess: (entries) {
              state = state.copyWith(
                entries: _sortAndFilter(entries),
                isLoading: false,
              );
              // Preserve successful remote state for lifecycle recovery
              _preserved[side] = state;
            },
            onFailure: (f) {
              state = state.copyWith(isLoading: false, error: f.message);
            },
          );
        case Err(:final error):
          state = state.copyWith(isLoading: false, error: error.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: errorMessage(e));
    }
  }

  void toggleSelection(String path) {
    final selected = Set<String>.from(state.selectedPaths);
    if (selected.contains(path)) {
      selected.remove(path);
    } else {
      selected.add(path);
    }
    state = state.copyWith(selectedPaths: selected);
  }

  void selectAll() {
    state = state.copyWith(
      selectedPaths: state.entries.map((e) => e.path).toSet(),
    );
  }

  void clearSelection() {
    state = state.copyWith(selectedPaths: {});
  }

  void setSortField(SortField field) {
    if (state.sortField == field) {
      state = state.copyWith(sortAscending: !state.sortAscending);
    } else {
      state = state.copyWith(sortField: field, sortAscending: true);
    }
    state = state.copyWith(entries: _sortAndFilter(state.entries));
  }

  void toggleSortDirection() {
    state = state.copyWith(sortAscending: !state.sortAscending);
    state = state.copyWith(entries: _sortAndFilter(state.entries));
  }

  void toggleShowHidden() {
    state = state.copyWith(showHidden: !state.showHidden);
    refresh();
  }

  // File operations

  Future<void> deleteSelected() async {
    final source = state.source;
    final selectedPaths = state.selectedPaths.toList();
    if (selectedPaths.isEmpty) return;

    for (final path in selectedPaths) {
      final entry = state.entries.where((e) => e.path == path).firstOrNull;
      if (entry == null) continue;

      switch (source) {
        case SftpPaneSourceLocal():
          final localService = ref.read(localFileServiceProvider);
          if (entry.type == SftpEntryType.directory) {
            await localService.deleteDirectory(path);
          } else {
            await localService.deleteFile(path);
          }
        case SftpPaneSourceRemote(:final serverId):
          final connMgr = ref.read(sftpConnectionManagerProvider);
          final clientResult = await connMgr.getClient(serverId, ref.container);
          if (clientResult.isFailure) continue;
          final sftpService = ref.read(sftpServiceProvider);
          if (entry.type == SftpEntryType.directory) {
            await sftpService.deleteDirectory(clientResult.value, path);
          } else {
            await sftpService.deleteFile(clientResult.value, path);
          }
      }
    }

    state = state.copyWith(selectedPaths: {});
    await refresh();
  }

  Future<void> rename(String path, String newName) async {
    final source = state.source;
    final dirPath = state.source is SftpPaneSourceLocal
        ? p.dirname(path)
        : p.posix.dirname(path);
    final newPath = state.source is SftpPaneSourceLocal
        ? p.join(dirPath, newName)
        : p.posix.join(dirPath, newName);

    switch (source) {
      case SftpPaneSourceLocal():
        final localService = ref.read(localFileServiceProvider);
        await localService.rename(path, newPath);
      case SftpPaneSourceRemote(:final serverId):
        final connMgr = ref.read(sftpConnectionManagerProvider);
        final clientResult = await connMgr.getClient(serverId, ref.container);
        if (clientResult.isFailure) return;
        final sftpService = ref.read(sftpServiceProvider);
        await sftpService.rename(clientResult.value, path, newPath);
    }

    await refresh();
  }

  Future<void> createDirectory(String name) async {
    final source = state.source;
    final newPath = state.source is SftpPaneSourceLocal
        ? p.join(state.currentPath, name)
        : p.posix.join(state.currentPath, name);

    switch (source) {
      case SftpPaneSourceLocal():
        final localService = ref.read(localFileServiceProvider);
        await localService.createDirectory(newPath);
      case SftpPaneSourceRemote(:final serverId):
        final connMgr = ref.read(sftpConnectionManagerProvider);
        final clientResult = await connMgr.getClient(serverId, ref.container);
        if (clientResult.isFailure) return;
        final sftpService = ref.read(sftpServiceProvider);
        await sftpService.createDirectory(clientResult.value, newPath);
    }

    await refresh();
  }

  Future<void> chmod(String path, int permissions) async {
    final source = state.source;
    if (source is! SftpPaneSourceRemote) return;

    final connMgr = ref.read(sftpConnectionManagerProvider);
    final clientResult = await connMgr.getClient(
      source.serverId,
      ref.container,
    );
    if (clientResult.isFailure) return;

    final sftpService = ref.read(sftpServiceProvider);
    final result = await sftpService.chmod(
      clientResult.value,
      path,
      permissions,
    );
    if (result.isFailure) {
      state = state.copyWith(error: result.failure.message);
    }
    await refresh();
  }

  Future<void> createSymlink(String target, String linkName) async {
    final source = state.source;
    if (source is! SftpPaneSourceRemote) return;

    final linkPath = p.posix.join(state.currentPath, linkName);
    final connMgr = ref.read(sftpConnectionManagerProvider);
    final clientResult = await connMgr.getClient(
      source.serverId,
      ref.container,
    );
    if (clientResult.isFailure) return;

    final sftpService = ref.read(sftpServiceProvider);
    await sftpService.createSymlink(clientResult.value, target, linkPath);
    await refresh();
  }

  Future<Result<void>> extractArchive(String archivePath) async {
    final archiveService = ref.read(archiveServiceProvider);

    final Result<void> result;
    switch (state.source) {
      case SftpPaneSourceLocal():
        result = await archiveService.extractToLocal(
          archivePath,
          state.currentPath,
        );
      case SftpPaneSourceRemote(:final serverId):
        final connMgr = ref.read(sftpConnectionManagerProvider);
        final clientResult = await connMgr.getClient(serverId, ref.container);
        if (clientResult.isFailure) {
          return Err(clientResult.failure);
        }
        final sftpService = ref.read(sftpServiceProvider);
        result = await archiveService.extractToRemote(
          clientResult.value,
          sftpService,
          archivePath,
          state.currentPath,
        );
    }

    await refresh();
    return result;
  }

  /// Restores pane to a previously known source/path. Used after Android
  /// activity transitions (e.g. file picker) that may cause build() to
  /// re-fire and reset the pane state to local.
  Future<void> restoreTo(SftpPaneSource source, String path) async {
    if (state.source == source && state.currentPath == path) return;
    state = state.copyWith(
      source: source,
      currentPath: path,
      entries: [],
      selectedPaths: {},
      error: null,
      isLoading: true,
    );
    switch (source) {
      case SftpPaneSourceLocal():
        await refresh();
      case SftpPaneSourceRemote():
        await _loadRemoteDirectory(path);
    }
  }

  // Mobile download/upload

  Future<String?> downloadToLocal(SftpEntry entry) async {
    final source = state.source;
    if (source is! SftpPaneSourceRemote) return null;

    // Use temp directory — the share sheet lets the user decide where to save
    final tempDir = await getTemporaryDirectory();
    final sftpTemp = Directory(p.join(tempDir.path, 'sftp_downloads'));
    if (!await sftpTemp.exists()) {
      await sftpTemp.create(recursive: true);
    }
    final localPath = await _uniqueLocalPath(p.join(sftpTemp.path, entry.name));

    final transferManager = ref.read(transferManagerProvider.notifier);
    await transferManager.enqueueDownload(
      source,
      entry.path,
      localPath,
      totalBytes: entry.size,
    );

    return localPath;
  }

  Future<int> uploadFromPicker() async {
    final source = state.source;
    if (source is! SftpPaneSourceRemote) return 0;

    // Save state before opening file picker — on Android the picker opens
    // a new Activity, which can cause build() to re-fire and reset state
    // back to local source.
    final savedPath = state.currentPath;
    _preserved[side] = state;

    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    // Restore pane state if it was reset during Android activity lifecycle
    if (state.source is! SftpPaneSourceRemote) {
      await restoreTo(source, savedPath);
    }

    if (result == null || result.files.isEmpty) return 0;

    final transferManager = ref.read(transferManagerProvider.notifier);
    int count = 0;

    for (final file in result.files) {
      final localPath = file.path;
      if (localPath == null) continue;

      final remotePath = p.posix.join(savedPath, file.name);
      await transferManager.enqueueUpload(
        localPath,
        source,
        remotePath,
        totalBytes: file.size,
      );
      count++;
    }

    return count;
  }

  Future<String> _uniqueLocalPath(String path) async {
    if (!await File(path).exists()) return path;

    final dir = p.dirname(path);
    final ext = p.extension(path);
    final base = p.basenameWithoutExtension(path);

    for (var i = 1; ; i++) {
      final candidate = p.join(dir, '$base ($i)$ext');
      if (!await File(candidate).exists()) return candidate;
    }
  }

  // Sorting & filtering

  List<SftpEntry> _sortAndFilter(List<SftpEntry> entries) {
    var filtered = entries.toList();

    if (!state.showHidden) {
      filtered = filtered.where((e) => !e.name.startsWith('.')).toList();
    }

    filtered.sort((a, b) {
      if (a.type == SftpEntryType.directory &&
          b.type != SftpEntryType.directory) {
        return -1;
      }
      if (a.type != SftpEntryType.directory &&
          b.type == SftpEntryType.directory) {
        return 1;
      }

      int cmp;
      switch (state.sortField) {
        case SortField.name:
          cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case SortField.size:
          cmp = a.size.compareTo(b.size);
        case SortField.modified:
          cmp = a.modified.compareTo(b.modified);
        case SortField.type:
          cmp = a.type.index.compareTo(b.type.index);
      }

      return state.sortAscending ? cmp : -cmp;
    });

    return filtered;
  }
}

// ---------------------------------------------------------------------------
// Transfer Manager
// ---------------------------------------------------------------------------

final transferManagerProvider =
    NotifierProvider<TransferManagerNotifier, List<TransferItem>>(
      TransferManagerNotifier.new,
    );

class TransferManagerNotifier extends Notifier<List<TransferItem>> {
  static const _uuid = Uuid();
  static const _maxConcurrent = 2;
  final Map<String, Completer<void>> _cancelTokens = {};
  int _activeCount = 0;

  @override
  List<TransferItem> build() => [];

  Future<void> enqueueDownload(
    SftpPaneSource source,
    String remotePath,
    String localPath, {
    int totalBytes = 0,
  }) async {
    final serverId = source is SftpPaneSourceRemote ? source.serverId : null;

    final item = TransferItem(
      id: _uuid.v4(),
      sourcePath: remotePath,
      destinationPath: localPath,
      direction: TransferDirection.download,
      status: TransferStatus.queued,
      totalBytes: totalBytes,
      sourceServerId: serverId,
    );

    state = [...state, item];
    _processQueue();
  }

  Future<void> enqueueUpload(
    String localPath,
    SftpPaneSource destination,
    String remotePath, {
    int totalBytes = 0,
  }) async {
    final serverId = destination is SftpPaneSourceRemote
        ? destination.serverId
        : null;

    final item = TransferItem(
      id: _uuid.v4(),
      sourcePath: localPath,
      destinationPath: remotePath,
      direction: TransferDirection.upload,
      status: TransferStatus.queued,
      totalBytes: totalBytes,
      destinationServerId: serverId,
    );

    state = [...state, item];
    _processQueue();
  }

  Future<void> enqueueHostToHost(
    SftpPaneSource source,
    String sourcePath,
    SftpPaneSource dest,
    String destPath, {
    int totalBytes = 0,
  }) async {
    final srcId = source is SftpPaneSourceRemote ? source.serverId : null;
    final dstId = dest is SftpPaneSourceRemote ? dest.serverId : null;

    final item = TransferItem(
      id: _uuid.v4(),
      sourcePath: sourcePath,
      destinationPath: destPath,
      direction: TransferDirection.hostToHost,
      status: TransferStatus.queued,
      totalBytes: totalBytes,
      sourceServerId: srcId,
      destinationServerId: dstId,
    );

    state = [...state, item];
    _processQueue();
  }

  void pauseTransfer(String id) {
    _updateItem(id, (item) => item.copyWith(status: TransferStatus.paused));
  }

  void resumeTransfer(String id) {
    _updateItem(id, (item) => item.copyWith(status: TransferStatus.queued));
    _processQueue();
  }

  void cancelTransfer(String id) {
    _cancelTokens[id]?.complete();
    _cancelTokens.remove(id);
    _updateItem(id, (item) => item.copyWith(status: TransferStatus.cancelled));
  }

  void clearCompleted() {
    state = state
        .where(
          (item) =>
              item.status != TransferStatus.completed &&
              item.status != TransferStatus.failed &&
              item.status != TransferStatus.cancelled,
        )
        .toList();
  }

  void _processQueue() {
    if (_activeCount >= _maxConcurrent) return;

    final queued = state.where((i) => i.status == TransferStatus.queued);
    for (final item in queued) {
      if (_activeCount >= _maxConcurrent) break;
      _activeCount++;
      _executeTransfer(item);
    }
  }

  Future<void> _executeTransfer(TransferItem item) async {
    final cancelToken = Completer<void>();
    _cancelTokens[item.id] = cancelToken;

    _updateItem(
      item.id,
      (i) =>
          i.copyWith(status: TransferStatus.active, startedAt: DateTime.now()),
    );

    final sftpService = ref.read(sftpServiceProvider);
    final connMgr = ref.read(sftpConnectionManagerProvider);

    try {
      switch (item.direction) {
        case TransferDirection.download:
          if (item.sourceServerId == null) break;
          final clientResult = await connMgr.getClient(
            item.sourceServerId!,
            ref.container,
          );
          if (clientResult.isFailure) throw clientResult.failure;

          final result = await sftpService.downloadFile(
            clientResult.value,
            item.sourcePath,
            item.destinationPath,
            onProgress: (transferred, total) {
              _updateItem(
                item.id,
                (i) => i.copyWith(
                  transferredBytes: transferred,
                  totalBytes: total > 0 ? total : i.totalBytes,
                ),
              );
            },
            cancelToken: cancelToken,
          );
          if (result.isFailure) throw result.failure;

        case TransferDirection.upload:
          if (item.destinationServerId == null) break;
          final clientResult = await connMgr.getClient(
            item.destinationServerId!,
            ref.container,
          );
          if (clientResult.isFailure) throw clientResult.failure;

          final result = await sftpService.uploadFile(
            clientResult.value,
            item.sourcePath,
            item.destinationPath,
            onProgress: (transferred, total) {
              _updateItem(
                item.id,
                (i) => i.copyWith(
                  transferredBytes: transferred,
                  totalBytes: total > 0 ? total : i.totalBytes,
                ),
              );
            },
            cancelToken: cancelToken,
          );
          if (result.isFailure) throw result.failure;

        case TransferDirection.hostToHost:
          if (item.sourceServerId == null || item.destinationServerId == null) {
            break;
          }
          final srcResult = await connMgr.getClient(
            item.sourceServerId!,
            ref.container,
          );
          final dstResult = await connMgr.getClient(
            item.destinationServerId!,
            ref.container,
          );
          if (srcResult.isFailure) throw srcResult.failure;
          if (dstResult.isFailure) throw dstResult.failure;

          final result = await sftpService.transferHostToHost(
            srcResult.value,
            item.sourcePath,
            dstResult.value,
            item.destinationPath,
            onProgress: (transferred, total) {
              _updateItem(
                item.id,
                (i) => i.copyWith(
                  transferredBytes: transferred,
                  totalBytes: total > 0 ? total : i.totalBytes,
                ),
              );
            },
            cancelToken: cancelToken,
          );
          if (result.isFailure) throw result.failure;
      }

      final current = state.where((i) => i.id == item.id).firstOrNull;
      if (current != null && current.status == TransferStatus.active) {
        _updateItem(
          item.id,
          (i) => i.copyWith(
            status: TransferStatus.completed,
            completedAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      final current = state.where((i) => i.id == item.id).firstOrNull;
      if (current != null && current.status != TransferStatus.cancelled) {
        _updateItem(
          item.id,
          (i) =>
              i.copyWith(status: TransferStatus.failed, error: errorMessage(e)),
        );
      }
    } finally {
      _cancelTokens.remove(item.id);
      _activeCount--;
      _processQueue();
    }
  }

  void _updateItem(String id, TransferItem Function(TransferItem) updater) {
    state = [
      for (final item in state)
        if (item.id == id) updater(item) else item,
    ];
  }
}
