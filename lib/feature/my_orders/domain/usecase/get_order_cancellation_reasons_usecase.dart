import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_cancellation_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';

@injectable
class GetOrderCancellationReasonsUseCase {
  const GetOrderCancellationReasonsUseCase(this._repository);

  final MyOrdersRepository _repository;

  Future<ApiResult<List<OrderCancellationReasonEntity>>> call() {
    return _repository.getCancellationReasons();
  }
}
