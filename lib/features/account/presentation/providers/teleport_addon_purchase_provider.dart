import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';

/// Google Play / App Store product ID for the Teleport addon (non-consumable).
const kTeleportAddonProductId = 'shellvault_teleport_addon';

/// Status of an in-progress teleport addon purchase.
enum TeleportAddonPurchaseStatus { idle, purchasing, verifying, success, error }

/// Tracks the current teleport addon purchase status for UI feedback.
final teleportAddonPurchaseStatusProvider =
    StateProvider<TeleportAddonPurchaseStatus>(
  (ref) => TeleportAddonPurchaseStatus.idle,
);

/// Optional error message from the last failed addon purchase.
final teleportAddonPurchaseErrorProvider = StateProvider<String?>((ref) => null);

/// Loads the teleport addon IAP product and handles the purchase stream.
final teleportAddonStoreProvider =
    AsyncNotifierProvider<TeleportAddonStoreNotifier, ProductDetails?>(
  TeleportAddonStoreNotifier.new,
);

class TeleportAddonStoreNotifier extends AsyncNotifier<ProductDetails?> {
  StreamSubscription<List<PurchaseDetails>>? _sub;

  @override
  Future<ProductDetails?> build() async {
    ref.onDispose(() => _sub?.cancel());

    if (!isNativeIapPlatform) return null;

    final iap = InAppPurchase.instance;
    final available = await iap.isAvailable();
    if (!available) return null;

    _sub = iap.purchaseStream.listen(_onPurchaseUpdate);

    final response = await iap.queryProductDetails({kTeleportAddonProductId});
    if (response.productDetails.isEmpty) return null;
    return response.productDetails.first;
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != kTeleportAddonProductId) continue;

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyPurchase(purchase);
        case PurchaseStatus.error:
          ref.read(teleportAddonPurchaseStatusProvider.notifier).state =
              TeleportAddonPurchaseStatus.error;
          ref.read(teleportAddonPurchaseErrorProvider.notifier).state =
              purchase.error?.message;
        case PurchaseStatus.pending:
          ref.read(teleportAddonPurchaseStatusProvider.notifier).state =
              TeleportAddonPurchaseStatus.purchasing;
        case PurchaseStatus.canceled:
          ref.read(teleportAddonPurchaseStatusProvider.notifier).state =
              TeleportAddonPurchaseStatus.idle;
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    ref.read(teleportAddonPurchaseStatusProvider.notifier).state =
        TeleportAddonPurchaseStatus.verifying;

    var verified = false;

    // Reuse the same Google/Apple verification endpoints — the server
    // distinguishes by product ID in the transaction data.
    if (Platform.isAndroid) {
      final token = purchase.verificationData.serverVerificationData;
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.verifyGooglePurchase(token);

      if (result.isSuccess && result.value.teleportUnlocked) {
        ref.read(teleportAddonPurchaseStatusProvider.notifier).state =
            TeleportAddonPurchaseStatus.success;
        ref.invalidate(billingStatusProvider);
        verified = true;
      } else {
        ref.read(teleportAddonPurchaseStatusProvider.notifier).state =
            TeleportAddonPurchaseStatus.error;
        ref.read(teleportAddonPurchaseErrorProvider.notifier).state =
            'Server verification failed';
      }
    } else if (Platform.isIOS || Platform.isMacOS) {
      final transactionId = purchase.verificationData.serverVerificationData;
      final repo = ref.read(accountRepositoryProvider);
      final result = await repo.verifyApplePurchase(transactionId);

      if (result.isSuccess && result.value.teleportUnlocked) {
        ref.read(teleportAddonPurchaseStatusProvider.notifier).state =
            TeleportAddonPurchaseStatus.success;
        ref.invalidate(billingStatusProvider);
        verified = true;
      } else {
        ref.read(teleportAddonPurchaseStatusProvider.notifier).state =
            TeleportAddonPurchaseStatus.error;
        ref.read(teleportAddonPurchaseErrorProvider.notifier).state =
            'Server verification failed';
      }
    }

    // Only acknowledge the purchase to the store after successful server
    // verification. Leaving it pending on failure allows the platform's
    // automatic refund mechanism (e.g. Google Play's 3-day window).
    if (verified) {
      await InAppPurchase.instance.completePurchase(purchase);
    }
  }

  /// Initiates a one-time purchase of the Teleport addon via the native store.
  Future<void> purchase() async {
    final product = state.value;
    if (product == null) return;

    ref.read(teleportAddonPurchaseStatusProvider.notifier).state =
        TeleportAddonPurchaseStatus.purchasing;
    ref.read(teleportAddonPurchaseErrorProvider.notifier).state = null;

    final param = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }
}
