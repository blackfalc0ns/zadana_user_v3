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
  const MoyasarPaymentScreen({super.key, required this.config, this.orderId});

  final MoyasarProviderConfigEntity config;
  final String? orderId;

  /// Supplied per build environment, e.g.
  /// `--dart-define=APPLE_PAY_MERCHANT_ID=merchant.com.example`.
  ///
  /// This is intentionally not inferred from the API response: the Merchant
  /// ID must match the Apple Pay capability and Moyasar certificate.
  static const _applePayMerchantId = String.fromEnvironment(
    'APPLE_PAY_MERCHANT_ID',
  );

  bool get _usesApplePay =>
      config.methods.any((method) => method.trim().toLowerCase() == 'applepay');

  PaymentConfig _buildPaymentConfig() {
    if (config.callbackUrl.isNotEmpty) {
      PaymentConfig.callbackUrl = config.callbackUrl;
    }

    return PaymentConfig(
      publishableApiKey: config.publishableKey,
      amount: config.amount,
      currency: config.currency,
      description: config.description,
      metadata: config.metadata,
      supportedNetworks: _supportedNetworks(),
      applePay: _usesApplePay
          ? ApplePayConfig(
              merchantId: _applePayMerchantId,
              label: 'Zadana',
              manual: false,
              saveCard: false,
            )
          : null,
      creditCard: _usesApplePay
          ? null
          : CreditCardConfig(saveCard: false, manual: false),
    );
  }

  List<PaymentNetwork> _supportedNetworks() {
    final networks = <PaymentNetwork>[];
    for (final network in config.supportedNetworks) {
      switch (network.trim().toLowerCase()) {
        case 'amex':
        case 'american_express':
          networks.add(PaymentNetwork.amex);
        case 'visa':
          networks.add(PaymentNetwork.visa);
        case 'mada':
          networks.add(PaymentNetwork.mada);
        case 'mastercard':
        case 'master_card':
          networks.add(PaymentNetwork.masterCard);
      }
    }
    return networks.toSet().toList();
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
      return;
    }

    // Covers Apple Pay cancellation and SDK-level errors that do not include
    // a Moyasar payment ID. The pending order remains retryable and is never
    // treated as paid without the backend confirmation endpoint.
    Navigator.of(context).pop(<String, String?>{
      'source': 'moyasar_sdk',
      'status': 'pending',
      'orderId': orderId,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final paymentConfig = _buildPaymentConfig();

    if (_usesApplePay && _applePayMerchantId.isEmpty) {
      return AppScaffold(
        backgroundColor: colors.surface,
        appBar: CustomAppBar(title: l10n.checkout),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('Apple Pay is not configured for this app build.'),
          ),
        ),
      );
    }

    return AppScaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(title: l10n.checkout),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _usesApplePay
              ? ApplePay(
                  config: paymentConfig,
                  onPaymentResult: (result) =>
                      _onPaymentResult(context, result),
                )
              : CreditCard(
                  config: paymentConfig,
                  onPaymentResult: (result) =>
                      _onPaymentResult(context, result),
                ),
        ),
      ),
    );
  }
}
