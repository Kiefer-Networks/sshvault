import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_filter.freezed.dart';

@freezed
abstract class ServerFilter with _$ServerFilter {
  const factory ServerFilter({
    @Default('') String searchQuery,
    String? groupId,
    @Default([]) List<String> tagIds,
    bool? isActive,
  }) = _ServerFilter;
}
