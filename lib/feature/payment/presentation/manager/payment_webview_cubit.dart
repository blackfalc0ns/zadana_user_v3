import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_webview_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_webview_screen.dart';

class PaymentWebViewCubit extends Cubit<PaymentWebViewState> {
  PaymentWebViewCubit({
    required this.paymentUrl,
    required this.callbackHost,
    required this.callbackPath,
  }) : super(const PaymentWebViewState());

  static const String _statusSuccess = 'success';
  static const String _statusFailed = 'failed';
  static const String _statusPending = 'pending';

  final String paymentUrl;
  final String callbackHost;
  final String callbackPath;

  Future<void> initialize() async {
    emit(
      state.copyWith(
        progress: 0,
        hasError: false,
        isInitializing: true,
        didCompleteCallback: false,
        clearController: true,
        clearCallbackResult: true,
      ),
    );

    try {
      late final WebViewController controller;
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              return _handleNavigationChange(request.url);
            },
            onProgress: _handleProgressChanged,
            onPageStarted: _handlePageStarted,
            onPageFinished: (url) => _handlePageFinished(controller, url),
            onWebResourceError: (_) => emit(state.copyWith(hasError: true)),
          ),
        );

      await controller.loadRequest(Uri.parse(paymentUrl));

      emit(
        state.copyWith(
          controller: controller,
          hasError: false,
          isInitializing: false,
        ),
      );
    } on PlatformException catch (error) {
      debugPrint('Payment WebView initialization failed: $error');
      await _openInBrowserFallback();
      emit(
        state.copyWith(
          hasError: true,
          isInitializing: false,
          clearController: true,
        ),
      );
    } catch (error) {
      debugPrint('Unexpected payment WebView initialization error: $error');
      emit(
        state.copyWith(
          hasError: true,
          isInitializing: false,
          clearController: true,
        ),
      );
    }
  }

  Future<void> retry() async {
    await initialize();
  }

  void _handleProgressChanged(int progress) {
    emit(state.copyWith(progress: progress));
  }

  void _handlePageStarted(String url) {
    final didHandleCallback = _handleCallbackUrl(url);
    if (didHandleCallback) return;

    emit(state.copyWith(hasError: false));
  }

  Future<void> _handlePageFinished(
    WebViewController controller,
    String url,
  ) async {
    if (state.didCompleteCallback) return;

    final callbackResult =
        _extractCallbackResult(url) ??
        await _extractCallbackResultFromPage(controller, url);

    if (callbackResult == null) return;

    _finishWithResult(callbackResult);
  }

  NavigationDecision _handleNavigationChange(String url) {
    final callbackResult = _extractCallbackResult(url);
    if (callbackResult != null) {
      _finishWithResult(callbackResult);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  bool _handleCallbackUrl(String url) {
    final callbackResult = _extractCallbackResult(url);
    if (callbackResult == null) {
      return false;
    }

    _finishWithResult(callbackResult);
    return true;
  }

  PaymentCallbackResult? _extractCallbackResult(String? currentUrl) {
    if (state.didCompleteCallback || currentUrl == null || currentUrl.isEmpty) {
      return null;
    }

    try {
      final uri = Uri.parse(currentUrl);
      if (!_isCallbackUri(uri)) {
        return null;
      }

      return _buildCallbackResult(uri);
    } on FormatException catch (error) {
      debugPrint('Invalid payment callback URL: $error');
      return null;
    }
  }

  Future<PaymentCallbackResult?> _extractCallbackResultFromPage(
    WebViewController controller,
    String currentUrl,
  ) async {
    final uri = Uri.tryParse(currentUrl);
    if (uri == null || !_isCallbackUri(uri)) {
      return null;
    }

    try {
      final rawBody = await controller.runJavaScriptReturningResult(
        'window.document.body ? window.document.body.innerText : ""',
      );
      final bodyText = _normalizeJavaScriptResult(rawBody);
      if (bodyText == null || bodyText.isEmpty) {
        return null;
      }

      final decodedBody = jsonDecode(bodyText);
      if (decodedBody is! Map) {
        return null;
      }

      return _buildCallbackResultFromPayload(
        decodedBody.cast<String, dynamic>(),
      );
    } catch (error) {
      debugPrint('Failed to parse payment callback body: $error');
      return null;
    }
  }

  bool _isCallbackUri(Uri uri) {
    final normalizedHost = uri.host.toLowerCase();
    final expectedHost = callbackHost.toLowerCase();
    final normalizedPath = uri.path.toLowerCase();
    final expectedPath = callbackPath.toLowerCase();

    final isExactConfiguredCallback =
        normalizedHost == expectedHost && normalizedPath == expectedPath;
    if (isExactConfiguredCallback) {
      return true;
    }

    return normalizedPath == '/api/payments/paymob/return' ||
        normalizedPath == '/api/acceptance/post_pay';
  }

  PaymentCallbackResult? _buildCallbackResult(Uri uri) {
    final queryParameters = uri.queryParameters;
    final isFailed =
        _isFalse(queryParameters['success']) ||
        _isTrue(queryParameters['error_occured']);
    final isSuccess = _isTrue(queryParameters['success']);
    final isPending = _isTrue(queryParameters['pending']);

    String? status;
    if (isFailed) {
      status = _statusFailed;
    } else if (isSuccess) {
      status = _statusSuccess;
    } else if (isPending) {
      status = _statusPending;
    }

    if (status == null) {
      return null;
    }

    return <String, String?>{
      'status': status,
      'transactionId': _nullIfEmpty(queryParameters['id']),
      'orderId': _nullIfEmpty(queryParameters['order']),
      'message': _nullIfEmpty(queryParameters['data.message']),
    };
  }

  PaymentCallbackResult? _buildCallbackResultFromPayload(
    Map<String, dynamic> payload,
  ) {
    final paymentStatus = payload['paymentStatus']?.toString();
    final orderStatus = payload['orderStatus']?.toString();
    final resolvedStatus = _mapPayloadStatus(
      paymentStatus: paymentStatus,
      orderStatus: orderStatus,
    );

    if (resolvedStatus == null) {
      return null;
    }

    return <String, String?>{
      'status': resolvedStatus,
      'paymentStatus': _nullIfEmpty(paymentStatus),
      'orderStatus': _nullIfEmpty(orderStatus),
      'paymentId': _nullIfEmpty(payload['paymentId']?.toString()),
      'orderId': _nullIfEmpty(payload['orderId']?.toString()),
      'message': _nullIfEmpty(payload['message']?.toString()),
    };
  }

  String? _mapPayloadStatus({
    String? paymentStatus,
    String? orderStatus,
  }) {
    final normalizedPaymentStatus = paymentStatus?.trim().toLowerCase();
    final normalizedOrderStatus = orderStatus?.trim().toLowerCase();

    if (normalizedPaymentStatus == 'paid' ||
        normalizedPaymentStatus == 'success' ||
        normalizedPaymentStatus == 'succeeded') {
      return _statusSuccess;
    }

    if (normalizedPaymentStatus == 'failed' ||
        normalizedPaymentStatus == 'unpaid' ||
        normalizedPaymentStatus == 'canceled' ||
        normalizedPaymentStatus == 'cancelled') {
      return _statusFailed;
    }

    if (normalizedPaymentStatus == 'pending' ||
        normalizedPaymentStatus == 'processing' ||
        (normalizedOrderStatus?.contains('pending') ?? false)) {
      return _statusPending;
    }

    return null;
  }

  bool _isTrue(String? value) {
    final normalizedValue = value?.trim().toLowerCase();
    return normalizedValue == 'true' || normalizedValue == '1';
  }

  bool _isFalse(String? value) {
    final normalizedValue = value?.trim().toLowerCase();
    return normalizedValue == 'false' || normalizedValue == '0';
  }

  String? _nullIfEmpty(String? value) {
    final normalizedValue = value?.trim();
    if (normalizedValue == null || normalizedValue.isEmpty) {
      return null;
    }

    return normalizedValue;
  }

  String? _normalizeJavaScriptResult(Object? result) {
    if (result == null) return null;

    if (result is String) {
      final trimmed = result.trim();
      if (trimmed.isEmpty) return null;

      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is String) {
          return decoded.trim();
        }
      } catch (_) {
        return trimmed;
      }

      return trimmed;
    }

    final normalized = result.toString().trim();
    return normalized.isEmpty ? null : normalized;
  }

  Future<void> _openInBrowserFallback() async {
    if (state.didOpenExternalFallback) return;

    final uri = Uri.tryParse(paymentUrl);
    if (uri == null) return;

    final didOpen = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    emit(state.copyWith(didOpenExternalFallback: didOpen));
  }

  void _finishWithResult(PaymentCallbackResult result) {
    if (state.didCompleteCallback) return;

    emit(
      state.copyWith(
        callbackResult: result,
        didCompleteCallback: true,
      ),
    );
  }
}
