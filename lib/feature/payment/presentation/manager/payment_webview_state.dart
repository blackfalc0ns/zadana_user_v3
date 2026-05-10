import 'package:webview_flutter/webview_flutter.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_webview_screen.dart';

class PaymentWebViewState {
  const PaymentWebViewState({
    this.controller,
    this.progress = 0,
    this.hasError = false,
    this.isInitializing = true,
    this.didOpenExternalFallback = false,
    this.isResolvingCallback = false,
    this.didCompleteCallback = false,
    this.callbackResult,
  });

  final WebViewController? controller;
  final int progress;
  final bool hasError;
  final bool isInitializing;
  final bool didOpenExternalFallback;
  final bool isResolvingCallback;
  final bool didCompleteCallback;
  final PaymentCallbackResult? callbackResult;

  bool get shouldShowProgress => isInitializing || progress < 100;

  PaymentWebViewState copyWith({
    WebViewController? controller,
    int? progress,
    bool? hasError,
    bool? isInitializing,
    bool? didOpenExternalFallback,
    bool? isResolvingCallback,
    bool? didCompleteCallback,
    PaymentCallbackResult? callbackResult,
    bool clearController = false,
    bool clearCallbackResult = false,
  }) {
    return PaymentWebViewState(
      controller: clearController ? null : controller ?? this.controller,
      progress: progress ?? this.progress,
      hasError: hasError ?? this.hasError,
      isInitializing: isInitializing ?? this.isInitializing,
      didOpenExternalFallback:
          didOpenExternalFallback ?? this.didOpenExternalFallback,
      isResolvingCallback: isResolvingCallback ?? this.isResolvingCallback,
      didCompleteCallback: didCompleteCallback ?? this.didCompleteCallback,
      callbackResult: clearCallbackResult
          ? null
          : callbackResult ?? this.callbackResult,
    );
  }
}
