import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_entry.dart';

class LocalFileService {
  Future<Result<List<SftpEntry>>> listDirectory(String path) async {
    try {
      final dir = Directory(path);
      if (!await dir.exists()) {
        return Err(SftpFailure('Directory does not exist: $path'));
      }

      final entries = <SftpEntry>[];
      await for (final entity in dir.list(followLinks: false)) {
        final stat = await entity.stat();
        final name = p.basename(entity.path);

        SftpEntryType type;
        if (entity is Link) {
          type = SftpEntryType.link;
        } else if (entity is Directory) {
          type = SftpEntryType.directory;
        } else {
          type = SftpEntryType.file;
        }

        String? linkTarget;
        if (entity is Link) {
          try {
            linkTarget = await entity.target();
          } catch (_) {}
        }

        entries.add(
          SftpEntry(
            name: name,
            path: entity.path,
            type: type,
            size: stat.size,
            modified: stat.modified,
            permissions: stat.mode,
            linkTarget: linkTarget,
          ),
        );
      }

      return Success(entries);
    } catch (e) {
      return Err(SftpFailure('Failed to list directory: $path', cause: e));
    }
  }

  Future<Result<void>> createDirectory(String path) async {
    try {
      await Directory(path).create(recursive: true);
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to create directory: $path', cause: e));
    }
  }

  Future<Result<void>> deleteFile(String path) async {
    try {
      await File(path).delete();
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to delete file: $path', cause: e));
    }
  }

  Future<Result<void>> deleteDirectory(String path) async {
    try {
      await Directory(path).delete(recursive: true);
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to delete directory: $path', cause: e));
    }
  }

  Future<Result<void>> rename(String oldPath, String newPath) async {
    try {
      final entity = FileSystemEntity.typeSync(oldPath);
      if (entity == FileSystemEntityType.directory) {
        await Directory(oldPath).rename(newPath);
      } else {
        await File(oldPath).rename(newPath);
      }
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to rename: $oldPath', cause: e));
    }
  }

  Future<bool> exists(String path) async {
    final type = await FileSystemEntity.type(path, followLinks: false);
    return type != FileSystemEntityType.notFound;
  }

  Future<Directory> getDownloadDirectory() async {
    Directory dir;
    if (Platform.isAndroid) {
      final dl = await getDownloadsDirectory();
      dir = Directory(p.join(dl?.path ?? '/storage/emulated/0/Download', 'ShellVault'));
    } else if (Platform.isIOS) {
      final docs = await getApplicationDocumentsDirectory();
      dir = Directory(p.join(docs.path, 'ShellVault'));
    } else {
      final dl = await getDownloadsDirectory();
      dir = Directory(p.join(dl?.path ?? '.', 'ShellVault'));
    }
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<String> getInitialPath() async {
    if (Platform.isAndroid) {
      // /storage/emulated/0 is the user-accessible shared storage
      const sdcard = '/storage/emulated/0';
      if (await Directory(sdcard).exists()) return sdcard;
      // Fallback to app-specific external storage
      final extDir = await getExternalStorageDirectory();
      if (extDir != null) return extDir.path;
      final appDir = await getApplicationDocumentsDirectory();
      return appDir.path;
    }

    if (Platform.isIOS) {
      final appDir = await getApplicationDocumentsDirectory();
      return appDir.path;
    }

    // macOS, Linux, Windows — use home directory
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'];
    if (home != null && await Directory(home).exists()) return home;

    // Final fallback
    final appDir = await getApplicationDocumentsDirectory();
    return appDir.path;
  }
}
