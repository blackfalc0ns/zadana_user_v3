class CheckoutFlowService {
  factory CheckoutFlowService() => _instance;

  CheckoutFlowService._internal();
  static final CheckoutFlowService _instance = CheckoutFlowService._internal();

  bool _pendingCheckout = false;
  String? _pendingVendorId;
  Future<void>? _cartSyncFuture;

  void markPendingCheckout({String? vendorId}) {
    _pendingCheckout = true;
    _pendingVendorId = vendorId;
  }

  /// Stores the cart sync future so the payment screen can await it.
  void setCartSyncFuture(Future<void> future) {
    _cartSyncFuture = future;
  }

  /// Waits for the cart sync to complete (if any), then clears the reference.
  /// Times out after 10 seconds to prevent the payment screen from hanging
  /// indefinitely if a side-effect task is slow.
  Future<void> awaitCartSyncIfPending() async {
    final future = _cartSyncFuture;
    _cartSyncFuture = null;
    if (future != null) {
      await future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {},
      );
    }
  }

  PendingCheckoutData consumePendingCheckout() {
    final current = _pendingCheckout;
    final vendorId = _pendingVendorId;
    _pendingCheckout = false;
    _pendingVendorId = null;
    return PendingCheckoutData(
      shouldResumeCheckout: current,
      vendorId: vendorId,
    );
  }
}

class PendingCheckoutData {
  const PendingCheckoutData({
    required this.shouldResumeCheckout,
    this.vendorId,
  });

  final bool shouldResumeCheckout;
  final String? vendorId;
}
