import 'dart:developer' as developer;

import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/confirm_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/confirm_moyasar_payment_usecase.dart';
import 'package:zadana_user_v3/feature/payment/presentation/models/payment_callback_result.dart';

/// Calls the backend confirm endpoint after Moyasar SDK returns a payment ID,
/// then produces a [PaymentCallbackResult] based on the server's authoritative
/// response rather than the SDK's local status.
class MoyasarPaymentConfirmer {
  const MoyasarPaymentConfirmer(this._confirmUseCase);

  final ConfirmMoyasarPaymentUseCase _confirmUseCase;

  static bool _isExplicitlyFailed(String paymentStatus) {
    final normalized = paymentStatus.trim().toLowerCase();
    return normalized == 'failed' ||
        normalized == 'unpaid' ||
        normalized == 'canceled' ||
        normalized == 'cancelled' ||
        normalized == 'expired';
  }

  /// Confirms the payment with the backend and returns an updated
  /// [PaymentCallbackResult] reflecting the server's verdict.
  Future<PaymentCallbackResult?> confirmAndResolve(
    PaymentCallbackResult? sdkResult,
  ) async {
    if (sdkResult == null) return null;

    final moyasarPaymentId = sdkResult['paymentId']?.trim();

    if (moyasarPaymentId == null || moyasarPaymentId.isEmpty) {
      final sdkStatus = sdkResult['status']?.trim().toLowerCase();
      if (sdkStatus != 'success') return sdkResult;

      // A successful SDK callback without a provider ID cannot be verified.
      // Never promote it to a paid order.
      developer.log(
        'SDK reported success without a Moyasar payment ID; '
        'backend confirmation was not attempted.',
        name: 'MoyasarPaymentConfirmer',
        level: 1000,
      );
      return <String, String?>{
        ...sdkResult,
        'source': 'moyasar_confirm',
        'status': 'pending',
      };
    }

    developer.log(
      'Confirming Moyasar payment ID ${_maskedId(moyasarPaymentId)} '
      'with the backend.',
      name: 'MoyasarPaymentConfirmer',
    );
    final confirmResult = await _confirmUseCase(moyasarPaymentId);

    switch (confirmResult) {
      case ApiSuccessResult<ConfirmPaymentResponseEntity>():
        final entity = confirmResult.data;
        final String resolvedStatus;
        if (entity.isPaid) {
          resolvedStatus = 'success';
        } else if (_isExplicitlyFailed(entity.paymentStatus)) {
          resolvedStatus = 'failed';
        } else {
          resolvedStatus = 'pending';
        }
        developer.log(
          'Backend confirmation completed: '
          'paymentStatus=${entity.paymentStatus}, '
          'orderStatus=${entity.orderStatus}, '
          'resolvedStatus=$resolvedStatus.',
          name: 'MoyasarPaymentConfirmer',
        );
        return <String, String?>{
          'source': 'moyasar_confirm',
          'status': resolvedStatus,
          'paymentId': moyasarPaymentId,
          'orderId': entity.orderId,
          'paymentStatus': entity.paymentStatus,
          'orderStatus': entity.orderStatus,
          'message': entity.message,
        };
      case ApiErrorResult<ConfirmPaymentResponseEntity>():
        final failure = confirmResult.failure;
        final normalizedCode = failure.code.trim().toLowerCase();
        final isReservationExpired =
            normalizedCode == 'order_payment_reservation_expired';
        developer.log(
          'Backend confirmation failed: '
          'code=${failure.code}, message=${failure.errorMessage}.',
          name: 'MoyasarPaymentConfirmer',
          level: 1000,
        );
        return <String, String?>{
          'source': 'moyasar_confirm',
          'status': isReservationExpired ? 'failed' : 'pending',
          'paymentId': moyasarPaymentId,
          'orderId': sdkResult['orderId'],
          'message': failure.errorMessage,
        };
    }
  }

  static String _maskedId(String value) {
    if (value.length <= 6) return '***';
    return '***${value.substring(value.length - 6)}';
  }
}
