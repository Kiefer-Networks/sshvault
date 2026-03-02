import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/account/domain/entities/audit_log_entity.dart';
import 'package:shellvault/features/account/domain/entities/billing_status.dart';
import 'package:shellvault/features/account/domain/entities/device_entity.dart';
import 'package:shellvault/features/account/presentation/providers/account_repository_providers.dart';

export 'package:shellvault/features/account/presentation/providers/account_repository_providers.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/auth/domain/entities/user_entity.dart';

final userProfileProvider = FutureProvider<UserEntity?>((ref) async {
  // Re-fetch when auth state changes (login/logout)
  final auth = ref.watch(authProvider).value;
  if (auth != AuthStatus.authenticated) return null;

  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getProfile();
  return result.isSuccess ? result.value : null;
});

final deviceListProvider = FutureProvider<List<DeviceEntity>>((ref) async {
  // Re-fetch when auth state changes (login/logout)
  final auth = ref.watch(authProvider).value;
  if (auth != AuthStatus.authenticated) return [];

  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getDevices();
  return result.isSuccess ? result.value : [];
});

final billingStatusProvider = FutureProvider<BillingStatus>((ref) async {
  // Re-fetch when auth state changes (login/logout)
  final auth = ref.watch(authProvider).value;
  if (auth != AuthStatus.authenticated) {
    return const BillingStatus(active: false);
  }

  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getBillingStatus();
  return result.isSuccess ? result.value : const BillingStatus(active: false);
});

final auditLogsProvider =
    FutureProvider.family<AuditLogResult, ({String? category, int offset})>((
      ref,
      params,
    ) async {
      final auth = ref.watch(authProvider).value;
      if (auth != AuthStatus.authenticated) {
        return const AuditLogResult(logs: [], total: 0, limit: 50, offset: 0);
      }

      final repo = ref.watch(accountRepositoryProvider);
      final result = await repo.getAuditLogs(
        category: params.category,
        limit: 50,
        offset: params.offset,
      );
      return result.isSuccess
          ? result.value
          : const AuditLogResult(logs: [], total: 0, limit: 50, offset: 0);
    });
