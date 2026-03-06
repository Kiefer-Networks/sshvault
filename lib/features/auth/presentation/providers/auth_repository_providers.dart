import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sshvault/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(apiClientProvider));
});
