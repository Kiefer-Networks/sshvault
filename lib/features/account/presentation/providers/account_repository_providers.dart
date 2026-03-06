import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/features/account/data/repositories/account_repository_impl.dart';
import 'package:sshvault/features/account/domain/repositories/account_repository.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(ref.watch(apiClientProvider));
});
