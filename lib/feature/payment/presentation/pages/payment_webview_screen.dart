import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_scaffold.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_app_bar.dart';

typedef PaymentCallbackResult = Map<String, String?>;

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    this.callbackHost = 'accept.paymobsolutions.com',
    this.callbackPath = '/api/acceptance/post_pay',
  });

  final String paymentUrl;
  final String callbackHost;
  final String callbackPath;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  static const String _statusSuccess = 'success';
  static const String _statusFailed = 'failed';
  static const String _statusPending = 'pending';

  WebViewController? _controller;
  int _progress = 0;
  bool _hasError = false;
  bool _isInitializing = true;
  bool _didOpenExternalFallback = false;
  bool _didCompleteCallback = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    try {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              return _handleNavigationChange(request.url);
            },
            onProgress: (progress) {
              if (!mounted) return;
              setState(() => _progress = progress);
            },
            onPageStarted: (url) {
              final didHandleCallback = _handleCallbackUrl(url);
              if (didHandleCallback) return;
              if (!mounted) return;
              setState(() => _hasError = false);
            },
            onWebResourceError: (_) {
              if (!mounted) return;
              setState(() => _hasError = true);
            },
          ),
        );

      await controller.loadRequest(Uri.parse(widget.paymentUrl));

      if (!mounted) return;
      setState(() {
        _controller = controller;
        _hasError = false;
        _isInitializing = false;
      });
    } on PlatformException catch (error) {
      debugPrint('Payment WebView initialization failed: $error');
      await _openInBrowserFallback();
      if (!mounted) return;
      setState(() {
        _controller = null;
        _hasError = true;
        _isInitializing = false;
      });
    } catch (error) {
      debugPrint('Unexpected payment WebView initialization error: $error');
      if (!mounted) return;
      setState(() {
        _controller = null;
        _hasError = true;
        _isInitializing = false;
      });
    }
  }

  Future<void> _openInBrowserFallback() async {
    if (_didOpenExternalFallback) return;

    final uri = Uri.tryParse(widget.paymentUrl);
    if (uri == null) return;

    _didOpenExternalFallback = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _retry() async {
    setState(() {
      _progress = 0;
      _hasError = false;
      _isInitializing = true;
    });
    await _initializeWebView();
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
    if (callbackResult != null) {
      _finishWithResult(callbackResult);
      return true;
    }

    return false;
  }

  PaymentCallbackResult? _extractCallbackResult(String? currentUrl) {
    if (_didCompleteCallback || currentUrl == null || currentUrl.isEmpty) {
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
    final expectedHost = widget.callbackHost.toLowerCase();
    final normalizedPath = uri.path;
    final expectedPath = widget.callbackPath;

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
      'orderId': _nullIfEmpty(queryParameters['order']),
      'message': _nullIfEmpty(queryParameters['data.message']),
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

  void _finishWithResult(PaymentCallbackResult result) {
    if (_didCompleteCallback || !mounted) return;

    _didCompleteCallback = true;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return AppScaffold(
      backgroundColor: colors.surface,
      appBar: PaymentAppBar(title: l10n.checkout),
      body: Column(
        children: [
          if (_isInitializing || _progress < 100)
            LinearProgressIndicator(
              value: _isInitializing ? null : _progress / 100,
            ),
          Expanded(child: _buildBody(l10n)),
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isInitializing) {
      return Center(child: Text(l10n.redirecting_to_checkout));
    }

    if (_hasError || _controller == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _didOpenExternalFallback
                    ? l10n.redirecting_to_checkout
                    : l10n.error_other_desc,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(l10n.go_back),
              ),
            ],
          ),
        ),
      );
    }

    return WebViewWidget(controller: _controller!);
  }
}
