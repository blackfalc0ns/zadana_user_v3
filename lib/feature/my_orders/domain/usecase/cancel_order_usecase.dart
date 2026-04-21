import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_request_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';

@injectable
class CancelOrderUseCase {
  const CancelOrderUseCase(this._repository);

  final MyOrdersRepository _repository;

  Future<ApiResult<CancelOrderResponseEntity>> call(
    String orderId,
    CancelOrderRequestEntity request,
  ) {
    return _repository.cancelOrder(orderId, request);
  }
}
