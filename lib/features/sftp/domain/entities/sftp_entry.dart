import 'package:freezed_annotation/freezed_annotation.dart';

part 'sftp_entry.freezed.dart';

enum SftpEntryType { file, directory, link }

@freezed
abstract class SftpEntry with _$SftpEntry {
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
}
