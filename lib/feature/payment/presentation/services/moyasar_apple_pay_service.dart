import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:moyasar/moyasar.dart';
import 'package:pay/pay.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/models/payment_callback_result.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/apple_pay_token_encoder.dart';

class ApplePayUnavailableException implements Exception {
  const ApplePayUnavailableException([this.reason = 'unknown']);

  final String reason;

  @override
  String toString() => 'ApplePayUnavailableException(reason: $reason)';
}

class MoyasarApplePayService {
  const MoyasarApplePayService();

  static const _diagnosticsChannel = MethodChannel(
    'com.zadnauser/apple_pay_diagnostics',
  );
  static const _logName = 'ApplePayDiagnostics';

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
    final supportedNetworkNames = _supportedNetworkNames(config);
    _log(
      'Payment started: '
      'orderId=${_maskedId(orderId)}, '
      'amountMinor=${config.amount}, '
      'currency=${config.currency}, '
      'merchantId=$merchantId, '
      'API methods=${config.methods}, '
      'API networks=${config.supportedNetworks}, '
      'normalizedNetworks=$supportedNetworkNames',
    );

    if (merchantId.isEmpty) {
      _log('Availability failed: APPLE_PAY_MERCHANT_ID is empty.', level: 1000);
      throw const ApplePayUnavailableException('merchant_id_empty');
    }

    await _logNativeDiagnostics(supportedNetworkNames);

    const provider = PayProvider.apple_pay;
    final payClient = Pay({provider: buildPaymentConfiguration(config)});

    final bool userCanPay;
    try {
      _log('Calling pay.userCanPay().');
      userCanPay = await payClient.userCanPay(provider);
      _log('pay.userCanPay() returned $userCanPay.');
    } catch (error, stackTrace) {
      _log(
        'pay.userCanPay() threw an exception.',
        error: error,
        stackTrace: stackTrace,
        level: 1000,
      );
      rethrow;
    }

    if (!userCanPay) {
      _log(
        'Availability failed: no eligible card for the requested networks '
        'or Apple Pay is restricted on this device.',
        level: 900,
      );
      throw const ApplePayUnavailableException('user_cannot_pay');
    }

    try {
      _log('Presenting the native Apple Pay sheet.');
      final paymentResult = await payClient.showPaymentSelector(
        provider,
        buildPaymentItems(config),
      );
      final rawToken = paymentResult['token'];
      final encodedToken = encodeApplePayToken(rawToken);
      _log(
        'Apple Pay sheet returned successfully: '
        'resultKeys=${paymentResult.keys.toList()}, '
        'rawTokenType=${rawToken.runtimeType}, '
        'tokenEncodable=${encodedToken != null}.',
      );
      return submitToken(
        config: config,
        orderId: orderId,
        paymentResult: paymentResult,
      );
    } on PlatformException catch (error) {
      _log(
        'Apple Pay platform result: '
        'code=${error.code}, message=${error.message}.',
        error: error,
        level: error.code == 'paymentCanceled' ? 800 : 1000,
      );
      // Closing the system sheet is a customer cancellation, not a failed
      // payment. Leave the pending order retryable without showing an error.
      if (error.code == 'paymentCanceled') return null;
      rethrow;
    } catch (error, stackTrace) {
      _log(
        'Apple Pay sheet or token submission failed.',
        error: error,
        stackTrace: stackTrace,
        level: 1000,
      );
      rethrow;
    }
  }

  Future<PaymentCallbackResult> submitToken({
    required MoyasarProviderConfigEntity config,
    required String? orderId,
    required Map<String, dynamic> paymentResult,
  }) async {
    final rawToken = paymentResult['token'];
    final token = encodeApplePayToken(rawToken);
    if (token == null) {
      _log(
        'Token validation failed: '
        'rawTokenType=${rawToken.runtimeType}, token is empty or unsupported.',
        level: 1000,
      );
      throw StateError('Apple Pay returned an invalid payment token.');
    }

    _log('Apple Pay token received; submitting it to Moyasar.');
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

    if (result is PaymentResponse) {
      _log(
        'Moyasar responded: '
        'status=${result.status.name}, paymentId=${_maskedId(result.id)}.',
      );
    } else {
      _log(
        'Moyasar returned an unexpected result type: ${result.runtimeType}.',
        level: 900,
      );
    }

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

  Future<void> _logNativeDiagnostics(List<String> networks) async {
    try {
      final diagnostics = await _diagnosticsChannel
          .invokeMapMethod<String, dynamic>('collect', <String, dynamic>{
            'merchantIdentifier': merchantId,
            'supportedNetworks': networks,
          });
      _log('Native PassKit diagnostics: ${jsonEncode(diagnostics)}');
    } on MissingPluginException {
      _log('Native PassKit diagnostics are unavailable on this platform.');
    } catch (error, stackTrace) {
      _log(
        'Could not collect native PassKit diagnostics.',
        error: error,
        stackTrace: stackTrace,
        level: 900,
      );
    }
  }

  static String _maskedId(String? value) {
    if (value == null || value.isEmpty) return 'none';
    if (value.length <= 6) return '***';
    return '***${value.substring(value.length - 6)}';
  }

  static void _log(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    int level = 800,
  }) {
    developer.log(
      message,
      name: _logName,
      error: error,
      stackTrace: stackTrace,
      level: level,
    );
    unawaited(
      _diagnosticsChannel
          .invokeMethod<void>('log', <String, dynamic>{
            'message': message,
            'level': level,
            if (error != null) 'errorType': error.runtimeType.toString(),
          })
          .catchError((_) {}),
    );
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
