import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// Product IDs for consumable support purchases.
const _kProductIds = <String>{
  'support_1',
  'support_5',
  'support_10',
  'support_25',
};

/// Stripe Payment Link for Desktop/Web fallback (replace with real URL).
const kStripeSupportUrl = 'https://sshvault.app/support';

/// Status of an in-progress support purchase.
enum SupportPurchaseStatus { idle, purchasing, success, error }

/// Tracks the current purchase status for UI feedback.
final supportPurchaseStatusProvider =
    StateProvider<SupportPurchaseStatus>((ref) => SupportPurchaseStatus.idle);

/// Loads available IAP products and handles the purchase stream.
final supportStoreProvider =
    AsyncNotifierProvider<SupportStoreNotifier, List<ProductDetails>>(
  SupportStoreNotifier.new,
);

class SupportStoreNotifier extends AsyncNotifier<List<ProductDetails>> {
  StreamSubscription<List<PurchaseDetails>>? _sub;

  @override
  Future<List<ProductDetails>> build() async {
    ref.onDispose(() => _sub?.cancel());

    if (!isNativeIapPlatform) return [];

    final iap = InAppPurchase.instance;
    final available = await iap.isAvailable();
    if (!available) return [];

    // Listen for purchase updates.
    _sub = iap.purchaseStream.listen(_onPurchaseUpdate);

    final response = await iap.queryProductDetails(_kProductIds);
    final products = response.productDetails
      ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    return products;
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          InAppPurchase.instance.completePurchase(purchase);
          ref.read(supportPurchaseStatusProvider.notifier).state =
              SupportPurchaseStatus.success;
        case PurchaseStatus.error:
          ref.read(supportPurchaseStatusProvider.notifier).state =
              SupportPurchaseStatus.error;
        case PurchaseStatus.pending:
          ref.read(supportPurchaseStatusProvider.notifier).state =
              SupportPurchaseStatus.purchasing;
        case PurchaseStatus.canceled:
          ref.read(supportPurchaseStatusProvider.notifier).state =
              SupportPurchaseStatus.idle;
      }
    }
  }

  /// Initiates a consumable purchase.
  Future<void> buyProduct(ProductDetails product) async {
    ref.read(supportPurchaseStatusProvider.notifier).state =
        SupportPurchaseStatus.purchasing;
    final param = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyConsumable(purchaseParam: param);
  }
}
