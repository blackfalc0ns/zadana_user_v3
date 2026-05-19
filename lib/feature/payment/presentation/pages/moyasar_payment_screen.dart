import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_scaffold.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/models/payment_callback_result.dart';

/// Safely extracts the `message` field from the payment source object.
/// The source is typed as `dynamic` in the Moyasar SDK.
String? _extractSourceMessage(dynamic source) {
  try {
    // CardPaymentResponseSource and others have a `message` field.
    // ignore: avoid_dynamic_calls
    return source?.message as String?;
  } catch (_) {
    return null;
  }
}

/// Screen that renders the native Moyasar credit card form using
/// [MoyasarProviderConfigEntity] returned from the backend.
///
/// Pops with a [PaymentCallbackResult] map on completion.
class MoyasarPaymentScreen extends StatelessWidget {
  const MoyasarPaymentScreen({
    super.key,
    required this.config,
    this.orderId,
  });

  final MoyasarProviderConfigEntity config;
  final String? orderId;

  PaymentConfig _buildPaymentConfig() {
    return PaymentConfig(
      publishableApiKey: config.publishableKey,
      amount: config.amount,
      description: config.description,
      metadata: config.metadata,
      creditCard: CreditCardConfig(
        saveCard: false,
        manual: false,
      ),
    );
  }

  void _onPaymentResult(BuildContext context, dynamic result) {
    if (result is PaymentResponse) {
      PaymentCallbackResult callbackResult;
      final sourceMessage = _extractSourceMessage(result.source);

      switch (result.status) {
        case PaymentStatus.paid:
          callbackResult = {
            'source': 'moyasar_sdk',
            'status': 'success',
            'paymentId': result.id,
            'orderId': orderId,
          };
        case PaymentStatus.failed:
          callbackResult = {
            'source': 'moyasar_sdk',
            'status': 'failed',
            'paymentId': result.id,
            'orderId': orderId,
            'message': sourceMessage,
          };
        default:
          callbackResult = {
            'source': 'moyasar_sdk',
            'status': 'pending',
            'paymentId': result.id,
            'orderId': orderId,
          };
      }

      Navigator.of(context).pop(callbackResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final paymentConfig = _buildPaymentConfig();

    return AppScaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(title: l10n.checkout),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: CreditCard(
            config: paymentConfig,
            onPaymentResult: (result) => _onPaymentResult(context, result),
          ),
        ),
      ),
    );
  }
}
