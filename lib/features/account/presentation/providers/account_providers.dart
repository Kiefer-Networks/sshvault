import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/features/account/domain/entities/audit_log_entity.dart';
import 'package:shellvault/features/account/domain/entities/billing_status.dart';
import 'package:shellvault/features/account/domain/entities/device_entity.dart';
import 'package:shellvault/features/account/presentation/providers/account_repository_providers.dart';

export 'package:shellvault/features/account/presentation/providers/account_repository_providers.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/auth/domain/entities/user_entity.dart';

const _cachedUserProfileKey = 'cached_user_profile';
const _cachedBillingStatusKey = 'cached_billing_status';

/// Checks whether the sync server is reachable via GET /health.
/// Polls periodically: 30s when offline, 60s when online.
/// Only yields on status change to avoid unnecessary rebuilds.
final serverReachableProvider = StreamProvider<bool>((ref) async* {
  final baseUrl = ref.watch(serverUrlProvider);
  final client = ApiClient(baseUrl);

  bool? lastStatus;

  while (true) {
    final result = await client.get('/health');
    final reachable = result.isSuccess;

    if (reachable != lastStatus) {
      lastStatus = reachable;
      yield reachable;
    }

    await Future<void>.delayed(
      Duration(seconds: reachable ? 60 : 30),
    );
  }
});

final userProfileProvider = FutureProvider<UserEntity?>((ref) async {
  final auth = ref.watch(authProvider).value;
  if (auth != AuthStatus.authenticated) return null;

  final dao = ref.read(databaseProvider).appSettingsDao;
  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getProfile();

  if (result.isSuccess) {
    final profile = result.value;
    await dao.setValue(_cachedUserProfileKey, jsonEncode(profile.toJson()));
    return profile;
  }

  // Network error — try cache
  final cached = await dao.getValue(_cachedUserProfileKey);
  if (cached != null) {
    return UserEntity.fromJson(
      jsonDecode(cached) as Map<String, dynamic>,
    );
  }
  return null;
});

final deviceListProvider = FutureProvider<List<DeviceEntity>>((ref) async {
  final auth = ref.watch(authProvider).value;
  if (auth != AuthStatus.authenticated) return [];

  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getDevices();
  return result.isSuccess ? result.value : [];
});

final billingStatusProvider = FutureProvider<BillingStatus>((ref) async {
  final auth = ref.watch(authProvider).value;
  if (auth != AuthStatus.authenticated) {
    return const BillingStatus(active: false);
  }

  final dao = ref.read(databaseProvider).appSettingsDao;
  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getBillingStatus();

  if (result.isSuccess) {
    final billing = result.value;
    await dao.setValue(_cachedBillingStatusKey, jsonEncode(billing.toJson()));
    return billing;
  }

  // Network error — try cache
  final cached = await dao.getValue(_cachedBillingStatusKey);
  if (cached != null) {
    return BillingStatus.fromJson(
      jsonDecode(cached) as Map<String, dynamic>,
    );
  }
  return const BillingStatus(active: false);
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
