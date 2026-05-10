import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_scaffold.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_webview_cubit.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_webview_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_webview_body.dart';

typedef PaymentCallbackResult = Map<String, String?>;

class PaymentWebViewScreen extends StatelessWidget {
  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    this.callbackHost = 'zadana.runasp.net',
    this.callbackPath = '/api/payments/paymob/return',
  });

  final String paymentUrl;
  final String callbackHost;
  final String callbackPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentWebViewCubit(
        paymentUrl: paymentUrl,
        callbackHost: callbackHost,
        callbackPath: callbackPath,
      )..initialize(),
      child: const _PaymentWebViewView(),
    );
  }
}

class _PaymentWebViewView extends StatelessWidget {
  const _PaymentWebViewView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return BlocListener<PaymentWebViewCubit, PaymentWebViewState>(
      listenWhen: (previous, current) =>
          previous.callbackResult != current.callbackResult,
      listener: (context, state) {
        final result = state.callbackResult;
        if (result == null) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          Navigator.of(context).pop(result);
        });
      },
      child: AppScaffold(
        backgroundColor: colors.surface,
        appBar: CustomAppBar(title: l10n.checkout),
        body: BlocBuilder<PaymentWebViewCubit, PaymentWebViewState>(
          builder: (context, state) => PaymentWebViewBody(
            state: state,
            onRetry: context.read<PaymentWebViewCubit>().retry,
            onClose: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
    );
  }
}
