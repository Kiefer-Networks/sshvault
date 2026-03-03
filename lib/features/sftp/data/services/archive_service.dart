import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:path/path.dart' as p;

import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/sftp/data/services/sftp_service.dart';

class ArchiveService {
  static const supportedExtensions = {
    'zip',
    'tar',
    'gz',
    'tgz',
    'bz2',
    'tbz2',
    '7z',
  };

  static bool isArchive(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.tar.gz') || lower.endsWith('.tar.bz2')) return true;
    final ext = lower.split('.').last;
    return supportedExtensions.contains(ext);
  }

  Future<Result<void>> extractToLocal(
    String archivePath,
    String targetDir,
  ) async {
    try {
      final file = File(archivePath);
      if (!await file.exists()) {
        return const Err(SftpFailure('Archive file not found'));
      }

      final bytes = await file.readAsBytes();
      final archive = _decode(archivePath, bytes);
      if (archive == null) {
        return const Err(SftpFailure('Unsupported archive format'));
      }

      for (final entry in archive) {
        final outPath = p.join(targetDir, entry.name);
        if (entry.isDirectory) {
          await Directory(outPath).create(recursive: true);
        } else if (entry.isFile) {
          final parent = Directory(p.dirname(outPath));
          if (!await parent.exists()) {
            await parent.create(recursive: true);
          }
          final content = entry.readBytes();
          if (content != null) {
            await File(outPath).writeAsBytes(content);
          }
        }
      }

      return const Success(null);
    } catch (e) {
      return Err(SftpFailure('Failed to extract archive', cause: e));
    }
  }

  Future<Result<void>> extractToRemote(
    SftpClient client,
    SftpService sftpService,
    String remotePath,
    String remoteTargetDir,
  ) async {
    final tempDir = await Directory.systemTemp.createTemp(
      'shellvault_extract_',
    );
    try {
      // Download archive to temp
      final localArchive = p.join(tempDir.path, p.posix.basename(remotePath));
      final downloadResult = await sftpService.downloadFile(
        client,
        remotePath,
        localArchive,
      );
      if (downloadResult.isFailure) {
        await tempDir.delete(recursive: true);
        return Err(downloadResult.failure);
      }

      // Extract locally into temp
      final extractDir = p.join(tempDir.path, 'extracted');
      await Directory(extractDir).create();

      final bytes = await File(localArchive).readAsBytes();
      final archive = _decode(remotePath, bytes);
      if (archive == null) {
        await tempDir.delete(recursive: true);
        return const Err(SftpFailure('Unsupported archive format'));
      }

      for (final entry in archive) {
        final outPath = p.join(extractDir, entry.name);
        if (entry.isDirectory) {
          await Directory(outPath).create(recursive: true);
        } else if (entry.isFile) {
          final parent = Directory(p.dirname(outPath));
          if (!await parent.exists()) {
            await parent.create(recursive: true);
          }
          final content = entry.readBytes();
          if (content != null) {
            await File(outPath).writeAsBytes(content);
          }
        }
      }

      // Upload extracted files to remote
      final uploadResult = await _uploadDirectoryRecursive(
        client,
        sftpService,
        extractDir,
        remoteTargetDir,
      );
      if (uploadResult.isFailure) {
        await tempDir.delete(recursive: true);
        return uploadResult;
      }

      await tempDir.delete(recursive: true);
      return const Success(null);
    } catch (e) {
      try {
        await tempDir.delete(recursive: true);
      } catch (_) {}
      return Err(SftpFailure('Failed to extract remote archive', cause: e));
    }
  }

  Archive? _decode(String filePath, Uint8List bytes) {
    final lower = filePath.toLowerCase();

    if (lower.endsWith('.tar.gz') || lower.endsWith('.tgz')) {
      final decompressed = const GZipDecoder().decodeBytes(bytes);
      return TarDecoder().decodeBytes(decompressed);
    }
    if (lower.endsWith('.tar.bz2') || lower.endsWith('.tbz2')) {
      final decompressed = BZip2Decoder().decodeBytes(bytes);
      return TarDecoder().decodeBytes(decompressed);
    }

    final ext = lower.split('.').last;
    return switch (ext) {
      'zip' => ZipDecoder().decodeBytes(bytes),
      'tar' => TarDecoder().decodeBytes(bytes),
      'gz' => _tryGzipTar(bytes),
      'bz2' => _tryBzip2Tar(bytes),
      '7z' => _try7z(bytes),
      _ => null,
    };
  }

  Archive? _tryGzipTar(Uint8List bytes) {
    try {
      final decompressed = const GZipDecoder().decodeBytes(bytes);
      return TarDecoder().decodeBytes(decompressed);
    } catch (_) {
      return null;
    }
  }

  Archive? _tryBzip2Tar(Uint8List bytes) {
    try {
      final decompressed = BZip2Decoder().decodeBytes(bytes);
      return TarDecoder().decodeBytes(decompressed);
    } catch (_) {
      return null;
    }
  }

  Archive? _try7z(Uint8List bytes) {
    try {
      return ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      return null;
    }
  }

  Future<Result<void>> _uploadDirectoryRecursive(
    SftpClient client,
    SftpService sftpService,
    String localDir,
    String remoteDir,
  ) async {
    final dir = Directory(localDir);
    await for (final entity in dir.list(recursive: false, followLinks: false)) {
      final name = p.basename(entity.path);
      final remotePath = p.posix.join(remoteDir, name);

      if (entity is Directory) {
        // Create remote directory, ignore if exists
        await sftpService.createDirectory(client, remotePath);
        final result = await _uploadDirectoryRecursive(
          client,
          sftpService,
          entity.path,
          remotePath,
        );
        if (result.isFailure) return result;
      } else if (entity is File) {
        final result = await sftpService.uploadFile(
          client,
          entity.path,
          remotePath,
        );
        if (result.isFailure) return result;
      }
    }
    return const Success(null);
  }
}
