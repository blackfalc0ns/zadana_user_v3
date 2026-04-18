import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';

@injectable
class GetOrderDetailsUseCase {
  const GetOrderDetailsUseCase(this._repository);

  final MyOrdersRepository _repository;

  Future<ApiResult<OrderDetailsEntity>> call(String orderId) {
    return _repository.getOrderDetails(orderId);
  }
}
