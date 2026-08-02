import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moyasar/moyasar.dart';
import 'package:pay/pay.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/models/payment_callback_result.dart';

class ApplePayUnavailableException implements Exception {
  const ApplePayUnavailableException();
}

class MoyasarApplePayService {
  const MoyasarApplePayService();

  /// Can be overridden per build environment with
  /// `--dart-define=APPLE_PAY_MERCHANT_ID=merchant.com.example`.
  ///
  /// The default matches the Apple Pay capability in Runner.entitlements.
  static const merchantId = String.fromEnvironment(
    'APPLE_PAY_MERCHANT_ID',
    defaultValue: 'merchant.com.blackfalcons.Zadna',
  );

  static bool isApplePayConfig(MoyasarProviderConfigEntity config) {
    return config.methods.any(
      (method) => method.trim().toLowerCase() == 'applepay',
    );
  }

  PaymentConfiguration buildPaymentConfiguration(
    MoyasarProviderConfigEntity config,
  ) {
    return PaymentConfiguration.fromJsonString(
      jsonEncode({
        'provider': 'apple_pay',
        'data': {
          'merchantIdentifier': merchantId,
          'displayName': 'Zadana',
          'merchantCapabilities': const ['3DS', 'debit', 'credit'],
          'supportedCountries': const ['SA'],
          'supportedNetworks': _supportedNetworkNames(config),
          'countryCode': 'SA',
          'currencyCode': config.currency,
        },
      }),
    );
  }

  List<PaymentItem> buildPaymentItems(MoyasarProviderConfigEntity config) {
    return [
      PaymentItem(
        label: 'Zadana',
        amount: (config.amount / 100).toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  Future<PaymentCallbackResult?> startPayment({
    required MoyasarProviderConfigEntity config,
    required String? orderId,
  }) async {
    if (merchantId.isEmpty) {
      throw const ApplePayUnavailableException();
    }

    const provider = PayProvider.apple_pay;
    final payClient = Pay({provider: buildPaymentConfiguration(config)});

    if (!await payClient.userCanPay(provider)) {
      throw const ApplePayUnavailableException();
    }

    try {
      final paymentResult = await payClient.showPaymentSelector(
        provider,
        buildPaymentItems(config),
      );
      return submitToken(
        config: config,
        orderId: orderId,
        paymentResult: paymentResult,
      );
    } on PlatformException catch (error) {
      // Closing the system sheet is a customer cancellation, not a failed
      // payment. Leave the pending order retryable without showing an error.
      if (error.code == 'paymentCanceled') return null;
      rethrow;
    }
  }

  Future<PaymentCallbackResult> submitToken({
    required MoyasarProviderConfigEntity config,
    required String? orderId,
    required Map<String, dynamic> paymentResult,
  }) async {
    final token = paymentResult['token'];
    if (token is! String || token.isEmpty) {
      throw StateError('Apple Pay returned an invalid payment token.');
    }

    final paymentConfig = buildMoyasarPaymentConfig(config);
    final applePay = paymentConfig.applePay!;
    final source = ApplePayPaymentRequestSource(
      token,
      applePay.manual,
      applePay.saveCard,
    );
    final request = PaymentRequest(paymentConfig, source);
    final result = await Moyasar.pay(
      apiKey: paymentConfig.publishableApiKey,
      paymentRequest: request,
    );

    return mapMoyasarResult(result, orderId: orderId);
  }

  PaymentConfig buildMoyasarPaymentConfig(MoyasarProviderConfigEntity config) {
    if (config.callbackUrl.isNotEmpty) {
      PaymentConfig.callbackUrl = config.callbackUrl;
    }

    return PaymentConfig(
      publishableApiKey: config.publishableKey,
      amount: config.amount,
      currency: config.currency,
      description: config.description,
      metadata: config.metadata,
      supportedNetworks: _supportedNetworks(config),
      applePay: ApplePayConfig(
        merchantId: merchantId,
        label: 'Zadana',
        manual: false,
        saveCard: false,
      ),
    );
  }

  PaymentCallbackResult mapMoyasarResult(
    dynamic result, {
    required String? orderId,
  }) {
    if (result is! PaymentResponse) {
      return {'source': 'moyasar_sdk', 'status': 'pending', 'orderId': orderId};
    }

    final sourceMessage = _extractSourceMessage(result.source);
    switch (result.status) {
      case PaymentStatus.paid:
        return {
          'source': 'moyasar_sdk',
          'status': 'success',
          'paymentId': result.id,
          'orderId': orderId,
        };
      case PaymentStatus.failed:
        return {
          'source': 'moyasar_sdk',
          'status': 'failed',
          'paymentId': result.id,
          'orderId': orderId,
          'message': sourceMessage,
        };
      default:
        return {
          'source': 'moyasar_sdk',
          'status': 'pending',
          'paymentId': result.id,
          'orderId': orderId,
        };
    }
  }

  List<String> _supportedNetworkNames(MoyasarProviderConfigEntity config) {
    final networks = _supportedNetworks(
      config,
    ).map((network) => network.toJson()).toList();

    // The native Apple Pay request needs at least one accepted network.
    return networks.isEmpty ? const ['visa', 'masterCard', 'mada'] : networks;
  }

  List<PaymentNetwork> _supportedNetworks(MoyasarProviderConfigEntity config) {
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

  String? _extractSourceMessage(dynamic source) {
    try {
      // The concrete Moyasar response sources expose `message`, while the
      // shared SDK interface types this field dynamically.
      // ignore: avoid_dynamic_calls
      return source?.message as String?;
    } catch (_) {
      return null;
    }
  }
}
