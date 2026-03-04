import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';

/// Google Play / App Store subscription product ID.
const kSubscriptionProductId = 'shellvault_sync_yearly';

/// Status of an in-progress subscription purchase.
enum SubscriptionPurchaseStatus { idle, purchasing, verifying, success, error }

/// Tracks the current subscription purchase status for UI feedback.
final subscriptionPurchaseStatusProvider =
    StateProvider<SubscriptionPurchaseStatus>(
      (ref) => SubscriptionPurchaseStatus.idle,
    );

/// Optional error message from the last failed purchase.
final subscriptionPurchaseErrorProvider = StateProvider<String?>((ref) => null);

/// Loads the subscription IAP product and handles the purchase stream.
final subscriptionStoreProvider =
    AsyncNotifierProvider<SubscriptionStoreNotifier, ProductDetails?>(
      SubscriptionStoreNotifier.new,
    );

class SubscriptionStoreNotifier extends AsyncNotifier<ProductDetails?> {
  StreamSubscription<List<PurchaseDetails>>? _sub;

  @override
  Future<ProductDetails?> build() async {
    ref.onDispose(() => _sub?.cancel());

    if (!isNativeIapPlatform) return null;

    final iap = InAppPurchase.instance;
    final available = await iap.isAvailable();
    if (!available) return null;

    _sub = iap.purchaseStream.listen(_onPurchaseUpdate);

    final response = await iap.queryProductDetails({kSubscriptionProductId});
    if (response.productDetails.isEmpty) return null;
    return response.productDetails.first;
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != kSubscriptionProductId) continue;

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyPurchase(purchase);
        case PurchaseStatus.error:
          ref.read(subscriptionPurchaseStatusProvider.notifier).state =
              SubscriptionPurchaseStatus.error;
          ref.read(subscriptionPurchaseErrorProvider.notifier).state =
              purchase.error?.message;
        case PurchaseStatus.pending:
          ref.read(subscriptionPurchaseStatusProvider.notifier).state =
              SubscriptionPurchaseStatus.purchasing;
        case PurchaseStatus.canceled:
          ref.read(subscriptionPurchaseStatusProvider.notifier).state =
              SubscriptionPurchaseStatus.idle;
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    ref.read(subscriptionPurchaseStatusProvider.notifier).state =
        SubscriptionPurchaseStatus.verifying;

    // On Android, send the purchase token to the server for verification.
    if (Platform.isAndroid) {
      final token = purchase.verificationData.serverVerificationData;
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.verifyGooglePurchase(token);

      if (result.isSuccess && result.value.active) {
        ref.read(subscriptionPurchaseStatusProvider.notifier).state =
            SubscriptionPurchaseStatus.success;
        ref.invalidate(billingStatusProvider);
      } else {
        ref.read(subscriptionPurchaseStatusProvider.notifier).state =
            SubscriptionPurchaseStatus.error;
        ref.read(subscriptionPurchaseErrorProvider.notifier).state =
            'Server verification failed';
      }
    } else {
      // iOS/macOS: server-side Apple verification not yet implemented,
      // mark as success and let polling pick up the status.
      ref.read(subscriptionPurchaseStatusProvider.notifier).state =
          SubscriptionPurchaseStatus.success;
      ref.invalidate(billingStatusProvider);
    }

    // Always complete the purchase to avoid store-side retries.
    await InAppPurchase.instance.completePurchase(purchase);
  }

  /// Initiates a subscription purchase via the native store.
  Future<void> subscribe() async {
    final product = state.value;
    if (product == null) return;

    ref.read(subscriptionPurchaseStatusProvider.notifier).state =
        SubscriptionPurchaseStatus.purchasing;
    ref.read(subscriptionPurchaseErrorProvider.notifier).state = null;

    final param = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }
}
