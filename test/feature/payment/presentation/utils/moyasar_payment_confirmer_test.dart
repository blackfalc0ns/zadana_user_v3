import 'package:flutter_test/flutter_test.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/payment/data/models/confirm_payment_response_dto.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/confirm_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/confirm_moyasar_payment_usecase.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/moyasar_payment_confirmer.dart';

void main() {
  test('confirms using the Moyasar SDK payment ID and resolves paid', () async {
    final repository = _ConfirmPaymentRepository(
      ApiSuccessResult(
        data: const ConfirmPaymentResponseEntity(
          message: 'Payment confirmed',
          paymentId: 'zadana-payment-id',
          paymentStatus: 'paid',
          userId: 'user-1',
          orderId: 'order-1',
          orderStatus: 'pending_acceptance',
          alreadyConfirmed: false,
        ),
      ),
    );
    final confirmer = MoyasarPaymentConfirmer(
      ConfirmMoyasarPaymentUseCase(repository),
    );

    final result = await confirmer.confirmAndResolve(<String, String?>{
      'source': 'moyasar_sdk',
      'status': 'success',
      'paymentId': 'moyasar-payment-id',
      'orderId': 'order-1',
    });

    expect(repository.receivedPaymentId, 'moyasar-payment-id');
    expect(result?['status'], 'success');
    expect(result?['source'], 'moyasar_confirm');
    expect(result?['paymentStatus'], 'paid');
  });

  test('does not trust SDK success when backend confirmation fails', () async {
    final repository = _ConfirmPaymentRepository(
      ApiErrorResult(
        failure: Failure(
          errorMessage: 'Payment confirmation failed',
          code: 'PAYMENT_CONFIRMATION_FAILED',
        ),
      ),
    );
    final confirmer = MoyasarPaymentConfirmer(
      ConfirmMoyasarPaymentUseCase(repository),
    );

    final result = await confirmer.confirmAndResolve(<String, String?>{
      'source': 'moyasar_sdk',
      'status': 'success',
      'paymentId': 'moyasar-payment-id',
      'orderId': 'order-1',
    });

    expect(result?['status'], 'pending');
    expect(result?['source'], 'moyasar_confirm');
    expect(result?['message'], 'Payment confirmation failed');
    expect(result?['orderId'], 'order-1');
  });

  test('does not report success without a Moyasar payment ID', () async {
    final repository = _ConfirmPaymentRepository(
      ApiErrorResult(failure: Failure(errorMessage: 'must not be called')),
    );
    final confirmer = MoyasarPaymentConfirmer(
      ConfirmMoyasarPaymentUseCase(repository),
    );

    final result = await confirmer.confirmAndResolve(<String, String?>{
      'source': 'moyasar_sdk',
      'status': 'success',
      'orderId': 'order-1',
    });

    expect(repository.receivedPaymentId, isNull);
    expect(result?['status'], 'pending');
    expect(result?['source'], 'moyasar_confirm');
  });

  test('maps an expired reservation confirmation to failed', () async {
    final repository = _ConfirmPaymentRepository(
      ApiErrorResult(
        failure: Failure(
          errorMessage: 'Order reservation expired',
          code: 'ORDER_PAYMENT_RESERVATION_EXPIRED',
        ),
      ),
    );
    final confirmer = MoyasarPaymentConfirmer(
      ConfirmMoyasarPaymentUseCase(repository),
    );

    final result = await confirmer.confirmAndResolve(<String, String?>{
      'source': 'moyasar_sdk',
      'status': 'success',
      'paymentId': 'moyasar-payment-id',
      'orderId': 'order-1',
    });

    expect(result?['status'], 'failed');
    expect(result?['message'], 'Order reservation expired');
  });

  test('parses snake_case backend confirmation fields', () {
    final result = ConfirmPaymentResponseDto.fromJson(<String, dynamic>{
      'message': 'Payment confirmed',
      'payment_id': 'payment-1',
      'payment_status': 'paid',
      'user_id': 'user-1',
      'order_id': 'order-1',
      'order_status': 'pending_acceptance',
      'already_confirmed': true,
    });

    expect(result.paymentId, 'payment-1');
    expect(result.paymentStatus, 'paid');
    expect(result.orderId, 'order-1');
    expect(result.orderStatus, 'pending_acceptance');
    expect(result.alreadyConfirmed, isTrue);
  });
}

class _ConfirmPaymentRepository implements PaymentRepository {
  _ConfirmPaymentRepository(this.result);

  final ApiResult<ConfirmPaymentResponseEntity> result;
  String? receivedPaymentId;

  @override
  Future<ApiResult<ConfirmPaymentResponseEntity>> confirmMoyasarPayment(
    String moyasarPaymentId,
  ) async {
    receivedPaymentId = moyasarPaymentId;
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
