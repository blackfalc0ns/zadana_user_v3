import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/confirm_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';

@injectable
class ConfirmMoyasarPaymentUseCase {
  const ConfirmMoyasarPaymentUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<ConfirmPaymentResponseEntity>> call(
    String moyasarPaymentId,
  ) {
    return _repository.confirmMoyasarPayment(moyasarPaymentId);
  }
}
