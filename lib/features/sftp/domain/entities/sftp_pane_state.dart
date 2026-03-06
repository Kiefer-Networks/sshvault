import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:sshvault/features/sftp/domain/entities/sftp_entry.dart';
import 'package:sshvault/features/sftp/domain/entities/sftp_pane_source.dart';

part 'sftp_pane_state.freezed.dart';

enum SortField { name, size, modified, type }

@freezed
abstract class SftpPaneState with _$SftpPaneState {
  const factory SftpPaneState({
    required SftpPaneSource source,
    required String currentPath,
    @Default([]) List<SftpEntry> entries,
    @Default(false) bool isLoading,
    String? error,
    @Default({}) Set<String> selectedPaths,
    @Default(SortField.name) SortField sortField,
    @Default(true) bool sortAscending,
    @Default(false) bool showHidden,
    @Default(false) bool needsHostSelection,
  }) = _SftpPaneState;
}
