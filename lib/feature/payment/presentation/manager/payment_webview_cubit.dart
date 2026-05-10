import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zadana_user_v3/core/utils/localized_api_message.dart';
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

  void _logWebViewEvent(String event, String url) {
    debugPrint('[PaymentWebViewCubit] $event: $url');
  }

  Uri? _normalizeCallbackUri(Uri uri) {
    if (!_isCallbackUri(uri)) {
      return null;
    }

    if (uri.scheme.toLowerCase() == 'https') {
      return uri;
    }

    return uri.replace(scheme: 'https');
  }

  Future<void> initialize() async {
    emit(
      state.copyWith(
        progress: 0,
        hasError: false,
        isInitializing: true,
        isResolvingCallback: false,
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
            onNavigationRequest: (request) async {
              _logWebViewEvent('onNavigationRequest', request.url);
              return _handleNavigationChange(controller, request.url);
            },
            onProgress: _handleProgressChanged,
            onPageStarted: _handlePageStarted,
            onPageFinished: (url) => _handlePageFinished(controller, url),
            onWebResourceError: (error) {
              debugPrint(
                '[PaymentWebViewCubit] onWebResourceError: '
                'code=${error.errorCode}, '
                'type=${error.errorType}, '
                'description=${error.description}, '
                'url=${error.url}',
              );
              emit(state.copyWith(hasError: true));
            },
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
    _logWebViewEvent('onPageStarted', url);
    emit(state.copyWith(hasError: false));
  }

  Future<void> _handlePageFinished(
    WebViewController controller,
    String url,
  ) async {
    if (state.didCompleteCallback || state.isResolvingCallback) return;

    _logWebViewEvent('onPageFinished', url);

    final callbackResult = await _extractCallbackResult(controller, url);

    if (callbackResult == null) return;

    emit(state.copyWith(isResolvingCallback: true));

    debugPrint(
      '[PaymentWebViewCubit] Callback detected from ${callbackResult['source'] ?? 'unknown'} '
      'with status=${callbackResult['status'] ?? callbackResult['paymentStatus']} '
      'transactionId=${callbackResult['transactionId']} '
      'message=${callbackResult['message']}',
    );

    // Give the backend callback a brief moment to finish any final side effects
    // before closing the payment screen.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _finishWithResult(callbackResult);
  }

  Future<NavigationDecision> _handleNavigationChange(
    WebViewController controller,
    String url,
  ) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return NavigationDecision.navigate;
    }

    final normalizedCallbackUri = _normalizeCallbackUri(uri);
    if (normalizedCallbackUri != null && normalizedCallbackUri != uri) {
      debugPrint(
        '[PaymentWebViewCubit] Rewriting callback URL to HTTPS: '
        '$normalizedCallbackUri',
      );
      await controller.loadRequest(normalizedCallbackUri);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  Future<PaymentCallbackResult?> _extractCallbackResult(
    WebViewController controller,
    String? currentUrl,
  ) async {
    if (state.didCompleteCallback || currentUrl == null || currentUrl.isEmpty) {
      return null;
    }

    try {
      final uri = Uri.parse(currentUrl);
      if (!_isCallbackUri(uri)) {
        return null;
      }

      // Ignore the transient HTTP callback page and wait for the HTTPS version
      // before deciding the final result.
      if (uri.scheme.toLowerCase() != 'https') {
        debugPrint(
          '[PaymentWebViewCubit] Skipping non-HTTPS callback result: $uri',
        );
        return null;
      }

      final callbackBodyResult = await _extractCallbackBodyResult(controller);
      if (callbackBodyResult != null) {
        return callbackBodyResult;
      }

      for (var attempt = 1; attempt <= 3; attempt++) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
        final retriedBodyResult = await _extractCallbackBodyResult(controller);
        if (retriedBodyResult != null) {
          debugPrint(
            '[PaymentWebViewCubit] Callback body resolved on retry attempt $attempt',
          );
          return retriedBodyResult;
        }
      }

      return _buildCallbackQueryResult(uri);
    } on FormatException catch (error) {
      debugPrint('Invalid payment callback URL: $error');
      return null;
    }
  }

  bool _isCallbackUri(Uri uri) {
    final normalizedHost = uri.host.toLowerCase();
    final expectedHost = callbackHost.toLowerCase();
    final normalizedPath = uri.path.toLowerCase();
    final expectedPath = callbackPath.toLowerCase();

    // Treat only the backend callback as authoritative. Intermediate payment
    // provider pages can report success before the backend finalizes the order
    // and clears the cart.
    return normalizedHost == expectedHost && normalizedPath == expectedPath;
  }

  Future<PaymentCallbackResult?> _extractCallbackBodyResult(
    WebViewController controller,
  ) async {
    try {
      final rawBodyText = await controller.runJavaScriptReturningResult(
        "JSON.stringify((document.body && (document.body.innerText || document.body.textContent)) || (document.documentElement && (document.documentElement.innerText || document.documentElement.textContent)) || '')",
      );
      debugPrint(
        '[PaymentWebViewCubit] Callback body JS result type=${rawBodyText.runtimeType}',
      );
      final bodyText = _normalizeJavascriptStringResult(rawBodyText);
      if (bodyText == null) {
        debugPrint('[PaymentWebViewCubit] Callback body text is empty');
        return null;
      }

      debugPrint(
        '[PaymentWebViewCubit] Callback body preview=${bodyText.substring(0, bodyText.length > 220 ? 220 : bodyText.length)}',
      );

      final decoded = jsonDecode(bodyText);
      final normalizedDecoded = decoded is String
          ? jsonDecode(decoded)
          : decoded;
      if (normalizedDecoded is! Map<String, dynamic>) {
        debugPrint(
          '[PaymentWebViewCubit] Callback body is not a JSON object: ${normalizedDecoded.runtimeType}',
        );
        return null;
      }

      return <String, String?>{
        'source': 'response_body',
        'status': _resolveStatusFromBackendPayload(normalizedDecoded),
        'paymentId': _stringValue(normalizedDecoded['paymentId']),
        'paymentStatus': _stringValue(normalizedDecoded['paymentStatus']),
        'userId': _stringValue(normalizedDecoded['userId']),
        'orderId': _stringValue(normalizedDecoded['orderId']),
        'orderStatus': _stringValue(normalizedDecoded['orderStatus']),
        'alreadyConfirmed': _stringValue(normalizedDecoded['alreadyConfirmed']),
        'message': _stringValue(normalizedDecoded['message']),
      };
    } catch (error) {
      debugPrint(
        '[PaymentWebViewCubit] Failed to read callback response body: $error',
      );
      return null;
    }
  }

  PaymentCallbackResult? _buildCallbackQueryResult(Uri uri) {
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
      'source': 'query_params',
      'status': status,
      'paymentId': _nullIfEmpty(queryParameters['paymentId']),
      'transactionId': _nullIfEmpty(queryParameters['id']),
      'orderId': _nullIfEmpty(queryParameters['merchant_order_id']),
      'message': _nullIfEmpty(
        resolveLocalizedApiMessageFromQuery(queryParameters),
      ),
    };
  }

  String? _resolveStatusFromBackendPayload(Map<String, dynamic> payload) {
    final paymentStatus = _stringValue(payload['paymentStatus'])?.toLowerCase();
    if (paymentStatus == null || paymentStatus.isEmpty) {
      return null;
    }

    if (paymentStatus == 'paid' ||
        paymentStatus == 'success' ||
        paymentStatus == 'succeeded') {
      return _statusSuccess;
    }

    if (paymentStatus == 'failed' ||
        paymentStatus == 'unpaid' ||
        paymentStatus == 'canceled' ||
        paymentStatus == 'cancelled') {
      return _statusFailed;
    }

    if (paymentStatus == 'pending' || paymentStatus == 'processing') {
      return _statusPending;
    }

    return null;
  }

  String? _normalizeJavascriptStringResult(Object? value) {
    if (value == null) return null;

    if (value is String) {
      final normalized = value.trim();
      if (normalized.isEmpty) {
        return null;
      }

      try {
        final decoded = jsonDecode(normalized);
        if (decoded is String && decoded.trim().isNotEmpty) {
          return decoded.trim();
        }
      } catch (_) {
        if (normalized.isNotEmpty) {
          return normalized;
        }
      }
    }

    return null;
  }

  String? _stringValue(Object? value) {
    if (value == null) return null;
    final normalized = value.toString().trim();
    return normalized.isEmpty ? null : normalized;
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

  Future<void> _openInBrowserFallback() async {
    if (state.didOpenExternalFallback) return;

    final uri = Uri.tryParse(paymentUrl);
    if (uri == null) return;

    final didOpen = await launchUrl(uri, mode: LaunchMode.externalApplication);

    emit(state.copyWith(didOpenExternalFallback: didOpen));
  }

  void _finishWithResult(PaymentCallbackResult result) {
    if (state.didCompleteCallback) return;

    emit(
      state.copyWith(
        callbackResult: result,
        didCompleteCallback: true,
        isResolvingCallback: false,
      ),
    );
  }
}
