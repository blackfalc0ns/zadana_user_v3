import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_request_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/delete_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_cancellation_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/paginated_orders_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/retry_order_payment_response_entity.dart';

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

  Future<ApiResult<List<OrderCancellationReasonEntity>>>
  getCancellationReasons();

  Future<ApiResult<CancelOrderResponseEntity>> cancelOrder(
    String orderId,
    CancelOrderRequestEntity request,
  );

  Future<ApiResult<RetryOrderPaymentResponseEntity>> retryOrderPayment(
    String orderId,
  );

  Future<ApiResult<DeleteOrderResponseEntity>> deleteOrder(String orderId);
}
