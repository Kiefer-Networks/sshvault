// Unit tests for [CrashDumpService].
//
// We never touch the real `%LOCALAPPDATA%`. Instead we point the service at
// a `Directory.systemTemp` subtree for the duration of each test and inject
// a no-op explorer launcher so no Explorer window is ever spawned. The
// service's filename filter is exercised with a mix of real-looking dumps
// and decoy files (wrong prefix, wrong extension, subdirectory) to make
// sure deleteAll/listDumps stay scoped to actual `.dmp` artifacts.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/crash_dump_service.dart';

void main() {
  group('CrashDumpService', () {
    late Directory tempRoot;
    late String crashFolderPath;
    late CrashDumpService service;
    late List<String> launcherCalls;

    setUp(() async {
      // Temp root stands in for LOCALAPPDATA. The service composes
      // `<root>\SSHVault\crashes` on top of whatever the resolver returns.
      tempRoot = await Directory.systemTemp.createTemp('sshvault_crash_test_');
      // Service joins with a backslash on every platform; we mirror that
      // here so the file paths we create line up with what the service
      // looks for. Linux test runners happily accept backslashes in
      // filenames as plain characters, but for cross-platform sanity we
      // operate inside the resolved path the service computes.
      launcherCalls = <String>[];
      service = CrashDumpService.forTest(
        resolveLocalAppData: () => tempRoot.path,
        launchExplorer: (path) async {
          launcherCalls.add(path);
        },
      );
      crashFolderPath = service.crashFolderPath!;
    });

    tearDown(() async {
      if (await tempRoot.exists()) {
        await tempRoot.delete(recursive: true);
      }
    });

    Future<File> writeDump(String name, {int bytes = 32}) async {
      // Recreate the folder using the literal path the service computes so
      // that listDumps reads the same directory we wrote to.
      final dir = Directory(crashFolderPath);
      await dir.create(recursive: true);
      final file = File('${dir.path}${Platform.pathSeparator}$name');
      await file.writeAsBytes(List<int>.filled(bytes, 0x42));
      return file;
    }

    test('listDumps returns empty list when folder is missing', () async {
      final dumps = await service.listDumps();
      expect(dumps, isEmpty);
    });

    test('listDumps ignores non-dump files', () async {
      await writeDump('sshvault-20260101-101010.dmp');
      await writeDump('readme.txt');
      await writeDump('not-ours-20260101.dmp'); // wrong prefix
      await writeDump('sshvault-broken.txt'); // wrong extension

      final dumps = await service.listDumps();
      expect(dumps.length, 1);
      expect(dumps.single.path, endsWith('sshvault-20260101-101010.dmp'));
    });

    test('listDumps returns newest first by filename', () async {
      await writeDump('sshvault-20240101-000000.dmp');
      await writeDump('sshvault-20260426-120000.dmp');
      await writeDump('sshvault-20251231-235959.dmp');

      final dumps = await service.listDumps();
      expect(dumps.map((f) => f.path.split(Platform.pathSeparator).last), [
        'sshvault-20260426-120000.dmp',
        'sshvault-20251231-235959.dmp',
        'sshvault-20240101-000000.dmp',
      ]);
    });

    test('totalSizeBytes sums only real dumps', () async {
      await writeDump('sshvault-a.dmp', bytes: 100);
      await writeDump('sshvault-b.dmp', bytes: 200);
      await writeDump('readme.txt', bytes: 999); // ignored

      expect(await service.totalSizeBytes(), 300);
    });

    test('deleteAll removes all .dmp files and reports the count', () async {
      await writeDump('sshvault-a.dmp');
      await writeDump('sshvault-b.dmp');
      await writeDump('sshvault-c.dmp');
      final keep = await writeDump('readme.txt');

      final removed = await service.deleteAll();
      expect(removed, 3);

      final remaining = await Directory(crashFolderPath).list().toList();
      // The non-dump file must survive — we never touch unrelated files.
      expect(remaining.length, 1);
      expect(remaining.single.path, keep.path);

      // A second call against an empty folder must succeed and report 0.
      expect(await service.deleteAll(), 0);
    });

    test('crashFolderPath is null when LOCALAPPDATA cannot be resolved', () {
      final unresolved = CrashDumpService.forTest(
        resolveLocalAppData: () => null,
      );
      expect(unresolved.crashFolderPath, isNull);
      expect(unresolved.listDumps(), completion(isEmpty));
    });

    test('openFolder creates the folder and invokes the launcher', () async {
      // Folder doesn't exist yet — openFolder must still succeed.
      expect(await Directory(crashFolderPath).exists(), isFalse);

      await service.openFolder();

      expect(await Directory(crashFolderPath).exists(), isTrue);
      expect(launcherCalls, [crashFolderPath]);
    });
  });
}
