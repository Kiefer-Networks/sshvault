import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/sftp/data/services/sftp_service.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_pane_source.dart';
import 'package:sshvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:sshvault/features/sftp/presentation/services/sftp_connection_manager.dart';

class _Client extends Mock implements SftpClient {}

class _File extends Mock implements SftpFile {}

class _Connections extends SftpConnectionManager {
  final client = _Client();
  @override
  Future<Result<SftpClient>> getClient(
    String serverId,
    ProviderContainer container,
  ) async => Success(client);
}

class _ControlledTransfer extends SftpService {
  int starts = 0;
  final started = Completer<void>();
  final finish = Completer<void>();
  @override
  Future<Result<void>> downloadFile(
    SftpClient client,
    String remotePath,
    String localPath, {
    void Function(int, int)? onProgress,
    Completer<void>? cancelToken,
    Future<void> Function()? waitUntilResumed,
  }) async {
    starts++;
    if (!started.isCompleted) started.complete();
    await finish.future;
    await waitUntilResumed?.call();
    return const Success(null);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'download stops between chunks while paused and resumes at its offset',
    () async {
      final client = _Client();
      final file = _File();
      final directory = await Directory.systemTemp.createTemp(
        'sshvault-pause-test-',
      );
      addTearDown(() => directory.delete(recursive: true));
      when(
        () => client.stat('/file'),
      ).thenAnswer((_) async => SftpFileAttrs(size: 4));
      when(() => client.open('/file')).thenAnswer((_) async => file);
      when(() => file.close()).thenAnswer((_) async {});
      var reads = 0;
      when(
        () => file.readBytes(
          length: any(named: 'length'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((invocation) async {
        reads++;
        final offset = invocation.namedArguments[#offset] as int;
        return Uint8List.fromList(switch (offset) {
          0 => [1, 2],
          2 => [3, 4],
          _ => [],
        });
      });
      final firstChunk = Completer<void>();
      final resume = Completer<void>();
      final service = SftpService();
      final Future<Result<void>> transfer = service.downloadFile(
        client,
        '/file',
        '${directory.path}/download',
        onProgress: (int transferred, int total) {
          if (transferred == 2 && !firstChunk.isCompleted) {
            firstChunk.complete();
          }
        },
        waitUntilResumed: () async {
          if (reads == 1) await resume.future;
        },
      );
      await firstChunk.future;
      await Future<void>.delayed(Duration.zero);
      expect(reads, 1);
      resume.complete();
      expect((await transfer).isSuccess, true);
      expect(await File('${directory.path}/download').readAsBytes(), [
        1,
        2,
        3,
        4,
      ]);
    },
  );
  test(
    'pause/resume keeps one active transfer and completes the same job',
    () async {
      final service = _ControlledTransfer();
      final container = ProviderContainer(
        overrides: [
          sftpServiceProvider.overrideWithValue(service),
          sftpConnectionManagerProvider.overrideWithValue(_Connections()),
        ],
      );
      addTearDown(container.dispose);
      final manager = container.read(transferManagerProvider.notifier);
      await manager.enqueueDownload(
        const SftpPaneSource.remote(serverId: 'host', serverName: 'Host'),
        '/file',
        '/local',
      );
      await service.started.future;
      final id = container.read(transferManagerProvider).single.id;
      manager.pauseTransfer(id);
      manager.resumeTransfer(id);
      await Future<void>.delayed(Duration.zero);
      expect(
        service.starts,
        1,
        reason: 'Resume must not start a duplicate writer',
      );
      service.finish.complete();
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(transferManagerProvider).single.status.name,
        'completed',
      );
    },
  );
}
