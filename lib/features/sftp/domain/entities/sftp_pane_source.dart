import 'package:freezed_annotation/freezed_annotation.dart';

part 'sftp_pane_source.freezed.dart';

@freezed
sealed class SftpPaneSource with _$SftpPaneSource {
  const factory SftpPaneSource.local() = SftpPaneSourceLocal;
  const factory SftpPaneSource.remote({
    required String serverId,
    required String serverName,
  }) = SftpPaneSourceRemote;
}
