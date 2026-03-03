import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_item.freezed.dart';

enum TransferDirection { upload, download, hostToHost }

enum TransferStatus { queued, active, paused, completed, failed, cancelled }

@freezed
abstract class TransferItem with _$TransferItem {
  const factory TransferItem({
    required String id,
    required String sourcePath,
    required String destinationPath,
    required TransferDirection direction,
    required TransferStatus status,
    required int totalBytes,
    @Default(0) int transferredBytes,
    String? sourceServerId,
    String? destinationServerId,
    String? error,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _TransferItem;
}
