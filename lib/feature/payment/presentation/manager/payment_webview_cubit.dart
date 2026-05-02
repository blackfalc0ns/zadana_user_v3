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
    if (state.didCompleteCallback) return;

    _logWebViewEvent('onPageFinished', url);

    final callbackResult = _extractCallbackResult(url);

    if (callbackResult == null) return;

    debugPrint(
      '[PaymentWebViewCubit] Callback detected with status=${callbackResult['status']} '
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
      'message': _nullIfEmpty(
        resolveLocalizedApiMessageFromQuery(queryParameters),
      ),
    };
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

    emit(state.copyWith(callbackResult: result, didCompleteCallback: true));
  }
}
