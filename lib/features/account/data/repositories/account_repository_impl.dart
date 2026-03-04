import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/features/account/domain/entities/audit_log_entity.dart';
import 'package:shellvault/features/account/domain/entities/billing_status.dart';
import 'package:shellvault/features/account/domain/entities/device_entity.dart';
import 'package:shellvault/features/account/domain/repositories/account_repository.dart';
import 'package:shellvault/features/auth/domain/entities/user_entity.dart';

class AccountRepositoryImpl implements AccountRepository {
  final ApiClient _apiClient;

  AccountRepositoryImpl(this._apiClient);

  @override
  Future<Result<UserEntity>> getProfile() async {
    final result = await _apiClient.get('/v1/user');
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(UserEntity.fromJson(data));
        } catch (e) {
          return Err(NetworkFailure('Invalid profile response', cause: e));
        }
      },
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<UserEntity>> updateProfile({String? email}) async {
    final result = await _apiClient.put('/v1/user', data: {'email': ?email});
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(UserEntity.fromJson(data));
        } catch (e) {
          return Err(NetworkFailure('Invalid profile response', cause: e));
        }
      },
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final result = await _apiClient.put(
      '/v1/user/password',
      data: {'current_password': oldPassword, 'new_password': newPassword},
    );
    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<void>> deleteAccount() async {
    final result = await _apiClient.delete('/v1/user');
    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<List<DeviceEntity>>> getDevices() async {
    final result = await _apiClient.get('/v1/devices');
    return result.fold(
      onSuccess: (data) {
        try {
          final list = (data['devices'] as List<dynamic>?) ?? [];
          return Success(
            list
                .map((e) => DeviceEntity.fromJson(e as Map<String, dynamic>))
                .toList(),
          );
        } catch (e) {
          return Err(NetworkFailure('Invalid devices response', cause: e));
        }
      },
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<String>> registerDevice(String name, String platform) async {
    final result = await _apiClient.post(
      '/v1/devices',
      data: {'name': name, 'platform': platform},
    );
    return result.fold(
      onSuccess: (data) => Success(data['id'] as String? ?? ''),
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<int>> logoutAllDevices() async {
    final result = await _apiClient.post('/v1/auth/logout-all');
    return result.fold(
      onSuccess: (data) => Success(data['revoked'] as int? ?? 0),
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<void>> deleteDevice(String deviceId) async {
    final result = await _apiClient.delete('/v1/devices/$deviceId');
    return result.fold(
      onSuccess: (_) => const Success(null),
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<BillingStatus>> getBillingStatus() async {
    final result = await _apiClient.get('/v1/billing/status');
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(BillingStatus.fromJson(data));
        } catch (e) {
          return Err(NetworkFailure('Invalid billing response', cause: e));
        }
      },
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<String>> createCheckout() async {
    final result = await _apiClient.post('/v1/billing/checkout');
    return result.fold(
      onSuccess: (data) => Success(data['url'] as String? ?? ''),
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<String>> createPortal() async {
    final result = await _apiClient.post('/v1/billing/portal');
    return result.fold(
      onSuccess: (data) => Success(data['url'] as String? ?? ''),
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<BillingStatus>> verifyGooglePurchase(
    String purchaseToken,
  ) async {
    final result = await _apiClient.post(
      '/v1/billing/verify-google',
      data: {'purchase_token': purchaseToken},
    );
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(BillingStatus.fromJson(data));
        } catch (e) {
          return Err(NetworkFailure('Invalid verification response', cause: e));
        }
      },
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<BillingStatus>> verifyApplePurchase(
    String transactionId,
  ) async {
    final result = await _apiClient.post(
      '/v1/billing/verify-apple',
      data: {'transaction_id': transactionId},
    );
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(BillingStatus.fromJson(data));
        } catch (e) {
          return Err(NetworkFailure('Invalid verification response', cause: e));
        }
      },
      onFailure: (f) => Err(f),
    );
  }

  @override
  Future<Result<AuditLogResult>> getAuditLogs({
    String? category,
    String? action,
    DateTime? from,
    DateTime? to,
    int limit = 50,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    if (category != null) queryParams['category'] = category;
    if (action != null) queryParams['action'] = action;
    if (from != null) queryParams['from'] = from.toUtc().toIso8601String();
    if (to != null) queryParams['to'] = to.toUtc().toIso8601String();

    final result = await _apiClient.get(
      '/v1/audit',
      queryParameters: queryParams,
    );
    return result.fold(
      onSuccess: (data) {
        try {
          return Success(AuditLogResult.fromJson(data));
        } catch (e) {
          return Err(NetworkFailure('Invalid audit log response', cause: e));
        }
      },
      onFailure: (f) => Err(f),
    );
  }
}
