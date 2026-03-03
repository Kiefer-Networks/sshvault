import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:path/path.dart' as p;
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_entry.dart';

class SftpService {
  static const _chunkSize = 16384; // 16 KB

  Future<Result<List<SftpEntry>>> listDirectory(
    SftpClient client,
    String path,
  ) async {
    try {
      final items = await client.listdir(path);

      final entries = <SftpEntry>[];
      for (final item in items) {
        final name = item.filename;
        if (name == '.' || name == '..') continue;

        final attrs = item.attr;
        final isDir = attrs.isDirectory;
        final isLink = attrs.isSymbolicLink;

        entries.add(
          SftpEntry(
            name: name,
            path: p.posix.join(path, name),
            type: isLink
                ? SftpEntryType.link
                : isDir
                ? SftpEntryType.directory
                : SftpEntryType.file,
            size: attrs.size ?? 0,
            modified: attrs.modifyTime != null
                ? DateTime.fromMillisecondsSinceEpoch(attrs.modifyTime! * 1000)
                : DateTime.now(),
            permissions: attrs.mode?.value,
            owner: attrs.userID?.toString(),
            group: attrs.groupID?.toString(),
          ),
        );
      }

      return Success(entries);
    } catch (e) {
      return Err(SftpFailure('Failed to list directory: $path', cause: e));
    }
  }

  Future<Result<void>> createDirectory(SftpClient client, String path) async {
    try {
      await client.mkdir(path);
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to create directory: $path', cause: e));
    }
  }

  Future<Result<void>> deleteFile(SftpClient client, String path) async {
    try {
      await client.remove(path);
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to delete file: $path', cause: e));
    }
  }

  Future<Result<void>> deleteDirectory(SftpClient client, String path) async {
    try {
      await client.rmdir(path);
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to delete directory: $path', cause: e));
    }
  }

  Future<Result<void>> rename(
    SftpClient client,
    String oldPath,
    String newPath,
  ) async {
    try {
      await client.rename(oldPath, newPath);
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to rename: $oldPath', cause: e));
    }
  }

  Future<Result<void>> chmod(
    SftpClient client,
    String path,
    int permissions,
  ) async {
    try {
      await client.setStat(
        path,
        SftpFileAttrs(mode: SftpFileMode.value(permissions)),
      );
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to chmod: $path', cause: e));
    }
  }

  Future<Result<SftpEntry>> stat(SftpClient client, String path) async {
    try {
      final attrs = await client.stat(path);
      final name = p.posix.basename(path);
      final isDir = attrs.isDirectory;
      final isLink = attrs.isSymbolicLink;

      return Success(
        SftpEntry(
          name: name,
          path: path,
          type: isLink
              ? SftpEntryType.link
              : isDir
              ? SftpEntryType.directory
              : SftpEntryType.file,
          size: attrs.size ?? 0,
          modified: attrs.modifyTime != null
              ? DateTime.fromMillisecondsSinceEpoch(attrs.modifyTime! * 1000)
              : DateTime.now(),
          permissions: attrs.mode?.value,
          owner: attrs.userID?.toString(),
          group: attrs.groupID?.toString(),
        ),
      );
    } catch (e) {
      return Err(SftpFailure('Failed to stat: $path', cause: e));
    }
  }

  Future<Result<String>> readLink(SftpClient client, String path) async {
    try {
      final target = await client.readlink(path);
      return Success(target);
    } catch (e) {
      return Err(SftpFailure('Failed to read link: $path', cause: e));
    }
  }

  Future<Result<void>> createSymlink(
    SftpClient client,
    String target,
    String link,
  ) async {
    try {
      await client.link(link, target);
      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to create symlink: $link', cause: e));
    }
  }

  Future<Result<Uint8List>> readFilePreview(
    SftpClient client,
    String path, {
    int maxBytes = 65536,
  }) async {
    try {
      final file = await client.open(path);
      final data = await file.readBytes(length: maxBytes);
      await file.close();
      return Success(data);
    } catch (e) {
      return Err(SftpFailure('Failed to read file preview: $path', cause: e));
    }
  }

  Future<Result<void>> downloadFile(
    SftpClient client,
    String remotePath,
    String localPath, {
    void Function(int transferred, int total)? onProgress,
    Completer<void>? cancelToken,
  }) async {
    try {
      final attrs = await client.stat(remotePath);
      final totalBytes = attrs.size ?? 0;

      final file = await client.open(remotePath);
      final localFile = File(localPath);
      final sink = localFile.openWrite();

      var transferred = 0;
      var offset = 0;

      try {
        while (true) {
          if (cancelToken?.isCompleted ?? false) {
            await sink.close();
            await file.close();
            if (await localFile.exists()) await localFile.delete();
            return const Success(null);
          }

          final chunk = await file.readBytes(
            length: _chunkSize,
            offset: offset,
          );
          if (chunk.isEmpty) break;

          sink.add(chunk);
          offset += chunk.length;
          transferred += chunk.length;
          onProgress?.call(transferred, totalBytes);
        }

        await sink.flush();
        await sink.close();
        await file.close();
        return const Success(null);
      } catch (e) {
        await sink.close();
        await file.close();
        if (await localFile.exists()) await localFile.delete();
        rethrow;
      }
    } catch (e) {
      return Err(SftpFailure('Failed to download: $remotePath', cause: e));
    }
  }

  Future<Result<void>> uploadFile(
    SftpClient client,
    String localPath,
    String remotePath, {
    void Function(int transferred, int total)? onProgress,
    Completer<void>? cancelToken,
  }) async {
    try {
      final localFile = File(localPath);
      final totalBytes = await localFile.length();

      final file = await client.open(
        remotePath,
        mode:
            SftpFileOpenMode.write |
            SftpFileOpenMode.create |
            SftpFileOpenMode.truncate,
      );

      final stream = localFile.openRead();
      var transferred = 0;
      var offset = 0;

      try {
        await for (final chunk in stream) {
          if (cancelToken?.isCompleted ?? false) {
            await file.close();
            return const Success(null);
          }

          await file.writeBytes(Uint8List.fromList(chunk), offset: offset);
          offset += chunk.length;
          transferred += chunk.length;
          onProgress?.call(transferred, totalBytes);
        }

        await file.close();
        return const Success(null);
      } catch (e) {
        await file.close();
        rethrow;
      }
    } catch (e) {
      return Err(SftpFailure('Failed to upload: $localPath', cause: e));
    }
  }

  Future<Result<void>> transferHostToHost(
    SftpClient source,
    String sourcePath,
    SftpClient destination,
    String destPath, {
    void Function(int transferred, int total)? onProgress,
    Completer<void>? cancelToken,
  }) async {
    try {
      final attrs = await source.stat(sourcePath);
      final totalBytes = attrs.size ?? 0;

      final srcFile = await source.open(sourcePath);
      final dstFile = await destination.open(
        destPath,
        mode:
            SftpFileOpenMode.write |
            SftpFileOpenMode.create |
            SftpFileOpenMode.truncate,
      );

      var transferred = 0;
      var offset = 0;

      try {
        while (true) {
          if (cancelToken?.isCompleted ?? false) {
            await srcFile.close();
            await dstFile.close();
            return const Success(null);
          }

          final chunk = await srcFile.readBytes(
            length: _chunkSize,
            offset: offset,
          );
          if (chunk.isEmpty) break;

          await dstFile.writeBytes(chunk, offset: offset);
          offset += chunk.length;
          transferred += chunk.length;
          onProgress?.call(transferred, totalBytes);
        }

        await srcFile.close();
        await dstFile.close();
        return const Success(null);
      } catch (e) {
        await srcFile.close();
        await dstFile.close();
        rethrow;
      }
    } catch (e) {
      return Err(
        SftpFailure('Failed to transfer: $sourcePath -> $destPath', cause: e),
      );
    }
  }
}
