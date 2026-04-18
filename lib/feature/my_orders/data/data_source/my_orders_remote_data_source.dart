import 'package:zadana_user_v3/feature/my_orders/data/models/order_details_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/paginated_orders_response_dto.dart';

abstract class MyOrdersRemoteDataSource {
  Future<PaginatedOrdersResponseDto> getActiveOrders({
    required int page,
    required int perPage,
  });

  Future<PaginatedOrdersResponseDto> getCompletedOrders({
    required int page,
    required int perPage,
  });

  Future<PaginatedOrdersResponseDto> getReturnedOrders({
    required int page,
    required int perPage,
  });

  Future<OrderDetailsDto> getOrderDetails(String orderId);
}
