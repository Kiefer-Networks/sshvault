import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/account/domain/entities/billing_status.dart';
import 'package:shellvault/features/account/domain/entities/device_entity.dart';
import 'package:shellvault/features/account/presentation/providers/account_repository_providers.dart';

export 'package:shellvault/features/account/presentation/providers/account_repository_providers.dart';
import 'package:shellvault/features/auth/domain/entities/user_entity.dart';

final userProfileProvider = FutureProvider<UserEntity?>((ref) async {
  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getProfile();
  return result.isSuccess ? result.value : null;
});

final deviceListProvider = FutureProvider<List<DeviceEntity>>((ref) async {
  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getDevices();
  return result.isSuccess ? result.value : [];
});

final billingStatusProvider = FutureProvider<BillingStatus>((ref) async {
  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getBillingStatus();
  return result.isSuccess ? result.value : const BillingStatus(active: false);
});
