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
  ///
  /// If the SDK result has no `paymentId`, or if the confirm call fails,
  /// falls back to the original SDK result.
  Future<PaymentCallbackResult?> confirmAndResolve(
    PaymentCallbackResult? sdkResult,
  ) async {
    if (sdkResult == null) return null;

    final moyasarPaymentId = sdkResult['paymentId'];

    // If SDK didn't return a Moyasar payment ID (e.g. user cancelled before
    // the form submitted), we can't confirm — return the SDK result as-is.
    if (moyasarPaymentId == null || moyasarPaymentId.isEmpty) {
      return sdkResult;
    }

    // If the SDK already reports failure, still try to confirm in case the
    // payment actually went through (3DS completed but SDK reported error).
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
        if (confirmResult.failure.code == 'ORDER_PAYMENT_RESERVATION_EXPIRED' ||
            confirmResult.failure.code == 'order_payment_reservation_expired') {
          return <String, String?>{
            'source': 'moyasar_confirm',
            'status': 'failed',
            'paymentId': moyasarPaymentId,
            'message':
                'Order reservation expired. Please start checkout again.',
          };
        }
        // Confirm failed (network error, server error, etc.).
        // Do NOT blindly trust the SDK status — the backend is authoritative.
        // Mark as pending so the user doesn't see a false success.
        return sdkResult;
    }
  }
}
