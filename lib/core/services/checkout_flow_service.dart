class CheckoutFlowService {
  factory CheckoutFlowService() => _instance;

  CheckoutFlowService._internal();
  static final CheckoutFlowService _instance = CheckoutFlowService._internal();

  bool _pendingCheckout = false;
  String? _pendingVendorId;

  void markPendingCheckout({String? vendorId}) {
    _pendingCheckout = true;
    _pendingVendorId = vendorId;
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
