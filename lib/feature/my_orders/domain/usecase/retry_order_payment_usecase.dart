import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/retry_order_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';

@injectable
class RetryOrderPaymentUseCase {
  const RetryOrderPaymentUseCase(this._repository);

  final MyOrdersRepository _repository;

  Future<ApiResult<RetryOrderPaymentResponseEntity>> call(String orderId) {
    return _repository.retryOrderPayment(orderId);
  }
}
