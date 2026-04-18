import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_webview_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_webview_error_view.dart';

class PaymentWebViewBody extends StatelessWidget {
  const PaymentWebViewBody({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onClose,
  });

  final PaymentWebViewState state;
  final Future<void> Function() onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        if (state.shouldShowProgress)
          LinearProgressIndicator(
            value: state.isInitializing ? null : state.progress / 100,
          ),
        Expanded(
          child: _PaymentWebViewContent(
            state: state,
            l10n: l10n,
            onRetry: onRetry,
            onClose: onClose,
          ),
        ),
      ],
    );
  }
}

class _PaymentWebViewContent extends StatelessWidget {
  const _PaymentWebViewContent({
    required this.state,
    required this.l10n,
    required this.onRetry,
    required this.onClose,
  });

  final PaymentWebViewState state;
  final AppLocalizations l10n;
  final Future<void> Function() onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    if (state.isInitializing) {
      return Center(child: Text(l10n.redirecting_to_checkout));
    }

    if (state.hasError || state.controller == null) {
      return PaymentWebViewErrorView(
        message: state.didOpenExternalFallback
            ? l10n.redirecting_to_checkout
            : l10n.error_other_desc,
        onRetry: onRetry,
        onClose: onClose,
      );
    }

    return WebViewWidget(controller: state.controller!);
  }
}
