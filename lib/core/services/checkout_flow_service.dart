class CheckoutFlowService {
  static final CheckoutFlowService _instance = CheckoutFlowService._internal();

  factory CheckoutFlowService() => _instance;

  CheckoutFlowService._internal();

  bool _pendingCheckout = false;

  void markPendingCheckout() {
    _pendingCheckout = true;
  }

  bool consumePendingCheckout() {
    final current = _pendingCheckout;
    _pendingCheckout = false;
    return current;
  }
}
