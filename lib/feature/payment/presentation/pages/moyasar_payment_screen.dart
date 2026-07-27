import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';
import 'package:pay/pay.dart'
    show ApplePayButton, ApplePayButtonType, PaymentConfiguration, PaymentItem;
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

  /// Can be overridden per build environment with
  /// `--dart-define=APPLE_PAY_MERCHANT_ID=merchant.com.example`.
  ///
  /// The default matches the Apple Pay capability in Runner.entitlements.
  /// It is intentionally not inferred from the API response: the Merchant ID
  /// must match the Apple Pay capability and Moyasar certificate.
  static const _applePayMerchantId = String.fromEnvironment(
    'APPLE_PAY_MERCHANT_ID',
    defaultValue: 'merchant.com.blackfalcons.Zadna',
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
              ? _ApplePayPurchaseButton(
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

/// Uses Apple's native purchase button while keeping Moyasar's token payment
/// flow. This intentionally avoids Moyasar's `.inStore` fallback, which can
/// display an Apple Pay mark as the payment action when no eligible card is
/// available.
class _ApplePayPurchaseButton extends StatefulWidget {
  const _ApplePayPurchaseButton({
    required this.config,
    required this.onPaymentResult,
  });

  final PaymentConfig config;
  final ValueChanged<dynamic> onPaymentResult;

  @override
  State<_ApplePayPurchaseButton> createState() =>
      _ApplePayPurchaseButtonState();
}

class _ApplePayPurchaseButtonState extends State<_ApplePayPurchaseButton> {
  bool _isProcessing = false;

  PaymentConfiguration _paymentConfiguration() {
    final applePay = widget.config.applePay!;
    return PaymentConfiguration.fromJsonString(
      jsonEncode({
        'provider': 'apple_pay',
        'data': {
          'merchantIdentifier': applePay.merchantId,
          'displayName': applePay.label,
          'merchantCapabilities': applePay.merchantCapabilities,
          'supportedCountries': applePay.supportedCountries,
          'supportedNetworks': widget.config.supportedNetworks
              .map((network) => network.toJson())
              .toList(),
          'countryCode': 'SA',
          'currencyCode': widget.config.currency,
        },
      }),
    );
  }

  Future<void> _submitPayment(Map<String, dynamic> paymentResult) async {
    if (_isProcessing) return;

    final token = paymentResult['token'];
    if (token is! String || token.isEmpty) {
      widget.onPaymentResult(UnprocessableTokenError());
      return;
    }

    setState(() => _isProcessing = true);

    final applePay = widget.config.applePay!;
    final source = ApplePayPaymentRequestSource(
      token,
      applePay.manual,
      applePay.saveCard,
    );
    final request = PaymentRequest(widget.config, source);
    final result = await Moyasar.pay(
      apiKey: widget.config.publishableApiKey,
      paymentRequest: request,
    );

    if (!mounted) return;
    widget.onPaymentResult(result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isProcessing) {
      return const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return ApplePayButton(
      paymentConfiguration: _paymentConfiguration(),
      paymentItems: [
        PaymentItem(
          label: widget.config.applePay!.label,
          amount: (widget.config.amount / 100).toStringAsFixed(2),
        ),
      ],
      // `buy` renders Apple's localized "Buy with Apple Pay" PKPaymentButton.
      type: ApplePayButtonType.buy,
      width: MediaQuery.sizeOf(context).width - 32,
      height: 48,
      onPaymentResult: _submitPayment,
      onError: widget.onPaymentResult,
      loadingIndicator: const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator()),
      ),
      childOnError: _ApplePayUnavailableMessage(
        message: l10n.apple_pay_unavailable,
      ),
    );
  }
}

class _ApplePayUnavailableMessage extends StatelessWidget {
  const _ApplePayUnavailableMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: colors.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
