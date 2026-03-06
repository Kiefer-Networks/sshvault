import 'package:freezed_annotation/freezed_annotation.dart';

part 'sftp_entry.freezed.dart';

enum SftpEntryType { file, directory, link }

@freezed
abstract class SftpEntry with _$SftpEntry {
  const SftpEntry._();

  const factory SftpEntry({
    required String name,
    required String path,
    required SftpEntryType type,
    required int size,
    required DateTime modified,
    int? permissions,
    String? owner,
    String? group,
    String? linkTarget,
  }) = _SftpEntry;

  static const _archiveExtensions = {
    'zip', 'tar', 'gz', 'tgz', 'bz2', 'tbz2', '7z',
  };

  bool get isArchive {
    final lower = name.toLowerCase();
    if (lower.endsWith('.tar.gz') || lower.endsWith('.tar.bz2')) return true;
    final ext = lower.split('.').last;
    return _archiveExtensions.contains(ext);
  }
}
