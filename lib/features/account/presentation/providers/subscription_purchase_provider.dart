import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sshvault/core/utils/platform_utils.dart';
import 'package:sshvault/features/account/presentation/providers/account_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

/// Google Play / App Store one-time purchase product ID.
const kSyncProductId = 'sshvault_sync';

/// Status of an in-progress sync purchase.
enum SyncPurchaseStatus { idle, purchasing, verifying, success, error }

/// Tracks the current purchase status for UI feedback.
final syncPurchaseStatusProvider = StateProvider<SyncPurchaseStatus>(
  (ref) => SyncPurchaseStatus.idle,
);

/// Machine-readable error key from the last failed purchase.
/// UI maps this to a localized string (e.g. 'server_verification_failed').
final syncPurchaseErrorProvider = StateProvider<String?>((ref) => null);

/// Well-known error key for server verification failures.
const kPurchaseErrorServerVerificationFailed = 'server_verification_failed';

/// Loads the sync IAP product and handles the purchase stream.
final syncStoreProvider =
    AsyncNotifierProvider<SyncStoreNotifier, ProductDetails?>(
      SyncStoreNotifier.new,
    );

class SyncStoreNotifier extends AsyncNotifier<ProductDetails?> {
  StreamSubscription<List<PurchaseDetails>>? _sub;

  @override
  Future<ProductDetails?> build() async {
    ref.onDispose(() => _sub?.cancel());

    if (!isNativeIapPlatform) return null;

    final iap = InAppPurchase.instance;
    final available = await iap.isAvailable();
    if (!available) return null;

    _sub = iap.purchaseStream.listen(_onPurchaseUpdate);

    final response = await iap.queryProductDetails({kSyncProductId});
    if (response.productDetails.isEmpty) return null;
    return response.productDetails.first;
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != kSyncProductId) continue;

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyPurchase(purchase);
        case PurchaseStatus.error:
          ref.read(syncPurchaseStatusProvider.notifier).state =
              SyncPurchaseStatus.error;
          ref.read(syncPurchaseErrorProvider.notifier).state =
              purchase.error?.message;
        case PurchaseStatus.pending:
          ref.read(syncPurchaseStatusProvider.notifier).state =
              SyncPurchaseStatus.purchasing;
        case PurchaseStatus.canceled:
          ref.read(syncPurchaseStatusProvider.notifier).state =
              SyncPurchaseStatus.idle;
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    ref.read(syncPurchaseStatusProvider.notifier).state =
        SyncPurchaseStatus.verifying;

    // On Android, send the purchase token to the server for verification.
    if (Platform.isAndroid) {
      final token = purchase.verificationData.serverVerificationData;
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.verifyGooglePurchase(token);

      if (result.isSuccess && result.value.active) {
        ref.read(syncPurchaseStatusProvider.notifier).state =
            SyncPurchaseStatus.success;
        ref.invalidate(billingStatusProvider);
      } else {
        ref.read(syncPurchaseStatusProvider.notifier).state =
            SyncPurchaseStatus.error;
        ref.read(syncPurchaseErrorProvider.notifier).state =
            kPurchaseErrorServerVerificationFailed;
      }
    } else if (Platform.isIOS || Platform.isMacOS) {
      final transactionId = purchase.verificationData.serverVerificationData;
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.verifyApplePurchase(transactionId);

      if (result.isSuccess && result.value.active) {
        ref.read(syncPurchaseStatusProvider.notifier).state =
            SyncPurchaseStatus.success;
        ref.invalidate(billingStatusProvider);
      } else {
        ref.read(syncPurchaseStatusProvider.notifier).state =
            SyncPurchaseStatus.error;
        ref.read(syncPurchaseErrorProvider.notifier).state =
            kPurchaseErrorServerVerificationFailed;
      }
    }

    // Always complete the purchase to avoid store-side retries.
    await InAppPurchase.instance.completePurchase(purchase);
  }

  /// Initiates a one-time sync purchase via the native store.
  Future<void> purchase() async {
    final product = state.value;
    if (product == null) return;

    ref.read(syncPurchaseStatusProvider.notifier).state =
        SyncPurchaseStatus.purchasing;
    ref.read(syncPurchaseErrorProvider.notifier).state = null;

    final param = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }
}

/// Maps a machine-readable purchase error key to a localized string.
/// Falls back to [AppLocalizations.purchaseFailed] for unknown keys or null.
String mapPurchaseError(String? errorKey, AppLocalizations l10n) {
  if (errorKey == null) return l10n.purchaseFailed;
  return switch (errorKey) {
    kPurchaseErrorServerVerificationFailed => l10n.serverVerificationFailed,
    _ => errorKey,
  };
}
