import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/account/domain/entities/billing_status.dart';
import 'package:shellvault/features/account/domain/entities/device_entity.dart';
import 'package:shellvault/features/auth/domain/entities/user_entity.dart';

abstract class AccountRepository {
  Future<Result<UserEntity>> getProfile();
  Future<Result<UserEntity>> updateProfile({String? email});
  Future<Result<void>> changePassword(String oldPassword, String newPassword);
  Future<Result<void>> deleteAccount();
  Future<Result<List<DeviceEntity>>> getDevices();
  Future<Result<String>> registerDevice(String name, String platform);
  Future<Result<void>> deleteDevice(String deviceId);
  Future<Result<int>> logoutAllDevices();
  Future<Result<BillingStatus>> getBillingStatus();
  Future<Result<String>> createCheckout();
  Future<Result<String>> createPortal();
}
