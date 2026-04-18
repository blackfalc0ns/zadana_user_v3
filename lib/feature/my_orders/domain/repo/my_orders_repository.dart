import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/paginated_orders_entity.dart';

abstract class MyOrdersRepository {
  Future<ApiResult<PaginatedOrdersEntity>> getActiveOrders({
    required int page,
    required int perPage,
  });

  Future<ApiResult<PaginatedOrdersEntity>> getCompletedOrders({
    required int page,
    required int perPage,
  });

  Future<ApiResult<PaginatedOrdersEntity>> getReturnedOrders({
    required int page,
    required int perPage,
  });

  Future<ApiResult<OrderDetailsEntity>> getOrderDetails(String orderId);
}
