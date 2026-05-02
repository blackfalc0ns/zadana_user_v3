import 'package:zadana_user_v3/feature/my_orders/data/models/cancel_order_request_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/cancel_order_response_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/delete_order_response_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_cancellation_reason_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_details_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_support_case_dtos.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/paginated_orders_response_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/retry_order_payment_response_dto.dart';

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

  Future<UploadedSupportCaseAttachmentDto> uploadOrderSupportCaseAttachment(
    String orderId,
    String filePath,
  );

  Future<CreateOrderSupportCaseResponseDto> createOrderSupportCase(
    String orderId,
    Map<String, dynamic> request,
  );

  Future<OrderSupportCasesResponseDto> getOrderSupportCases(String orderId);

  Future<OrderSupportCaseDetailsResponseDto> getOrderSupportCaseDetails(
    String orderId,
    String caseId,
  );

  Future<List<OrderCancellationReasonDto>> getCancellationReasons();

  Future<CancelOrderResponseDto> cancelOrder(
    String orderId,
    CancelOrderRequestDto request,
  );

  Future<RetryOrderPaymentResponseDto> retryOrderPayment(String orderId);

  Future<DeleteOrderResponseDto> deleteOrder(String orderId);
}
