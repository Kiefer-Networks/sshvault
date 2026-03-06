import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:path/path.dart' as p;

import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/features/sftp/data/services/sftp_service.dart';

class ArchiveService {
  static final _log = LoggingService.instance;
  static const _tag = 'ArchiveService';

  /// Maximum archive file size before extraction (500 MB).
  static const _maxArchiveSize = 500 * 1024 * 1024;

  /// Maximum total extracted size (2 GB).
  static const _maxExtractedSize = 2 * 1024 * 1024 * 1024;

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

      final fileSize = await file.length();
      if (fileSize > _maxArchiveSize) {
        return const Err(SftpFailure('Archive exceeds maximum size limit'));
      }

      final bytes = await file.readAsBytes();
      final archive = _decode(archivePath, bytes);
      if (archive == null) {
        return const Err(SftpFailure('Unsupported archive format'));
      }

      final resolvedTarget = p.normalize(p.absolute(targetDir));
      var totalExtracted = 0;

      for (final entry in archive) {
        final outPath = p.join(targetDir, entry.name);
        final resolved = p.normalize(p.absolute(outPath));
        if (!resolved.startsWith(resolvedTarget + p.separator) &&
            resolved != resolvedTarget) {
          _log.warning(_tag, 'Skipping path traversal entry: ${entry.name}');
          continue;
        }

        if (entry.isDirectory) {
          await Directory(resolved).create(recursive: true);
        } else if (entry.isFile) {
          final parent = Directory(p.dirname(resolved));
          if (!await parent.exists()) {
            await parent.create(recursive: true);
          }
          final content = entry.readBytes();
          if (content != null) {
            totalExtracted += content.length;
            if (totalExtracted > _maxExtractedSize) {
              _log.error(_tag, 'Archive extraction exceeded maximum size');
              return const Err(
                SftpFailure('Archive extraction exceeded maximum size'),
              );
            }
            await File(resolved).writeAsBytes(content);
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

      // Check archive file size before extraction
      final archiveFile = File(localArchive);
      final fileSize = await archiveFile.length();
      if (fileSize > _maxArchiveSize) {
        await tempDir.delete(recursive: true);
        return const Err(SftpFailure('Archive exceeds maximum size limit'));
      }

      // Extract locally into temp
      final extractDir = p.join(tempDir.path, 'extracted');
      await Directory(extractDir).create();

      final bytes = await archiveFile.readAsBytes();
      final archive = _decode(remotePath, bytes);
      if (archive == null) {
        await tempDir.delete(recursive: true);
        return const Err(SftpFailure('Unsupported archive format'));
      }

      final resolvedExtractDir = p.normalize(p.absolute(extractDir));
      var totalExtracted = 0;

      for (final entry in archive) {
        final outPath = p.join(extractDir, entry.name);
        final resolved = p.normalize(p.absolute(outPath));
        if (!resolved.startsWith(resolvedExtractDir + p.separator) &&
            resolved != resolvedExtractDir) {
          _log.warning(_tag, 'Skipping path traversal entry: ${entry.name}');
          continue;
        }

        if (entry.isDirectory) {
          await Directory(resolved).create(recursive: true);
        } else if (entry.isFile) {
          final parent = Directory(p.dirname(resolved));
          if (!await parent.exists()) {
            await parent.create(recursive: true);
          }
          final content = entry.readBytes();
          if (content != null) {
            totalExtracted += content.length;
            if (totalExtracted > _maxExtractedSize) {
              _log.error(_tag, 'Archive extraction exceeded maximum size');
              await tempDir.delete(recursive: true);
              return const Err(
                SftpFailure('Archive extraction exceeded maximum size'),
              );
            }
            await File(resolved).writeAsBytes(content);
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
