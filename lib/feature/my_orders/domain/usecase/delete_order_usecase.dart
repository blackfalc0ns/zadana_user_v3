import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/delete_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';

@injectable
class DeleteOrderUseCase {
  const DeleteOrderUseCase(this._repository);

  final MyOrdersRepository _repository;

  Future<ApiResult<DeleteOrderResponseEntity>> call(String orderId) {
    return _repository.deleteOrder(orderId);
  }
}
