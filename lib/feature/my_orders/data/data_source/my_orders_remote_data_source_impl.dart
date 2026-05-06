import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/my_orders/data/data_source/my_orders_remote_data_source.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/cancel_order_request_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/cancel_order_response_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/delete_order_response_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_cancellation_reason_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_details_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_support_case_dtos.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_support_reason_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/paginated_orders_response_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/retry_order_payment_response_dto.dart';

@Injectable(as: MyOrdersRemoteDataSource)
class MyOrdersRemoteDataSourceImpl implements MyOrdersRemoteDataSource {
  const MyOrdersRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<PaginatedOrdersResponseDto> getActiveOrders({
    required int page,
    required int perPage,
  }) {
    return _apiServices.getActiveOrders(page, perPage);
  }

  @override
  Future<PaginatedOrdersResponseDto> getCompletedOrders({
    required int page,
    required int perPage,
  }) {
    return _apiServices.getCompletedOrders(page, perPage);
  }

  @override
  Future<PaginatedOrdersResponseDto> getReturnedOrders({
    required int page,
    required int perPage,
  }) {
    return _apiServices.getReturnedOrders(page, perPage);
  }

  @override
  Future<OrderDetailsDto> getOrderDetails(String orderId) {
    return _apiServices.getOrderDetails(orderId);
  }

  @override
  Future<UploadedSupportCaseAttachmentDto> uploadOrderSupportCaseAttachment(
    String orderId,
    String filePath,
  ) async {
    final multipartFile = await MultipartFile.fromFile(filePath);
    return _apiServices.uploadOrderSupportCaseAttachment(
      orderId,
      multipartFile,
    );
  }

  @override
  Future<CreateOrderSupportCaseResponseDto> createOrderSupportCase(
    String orderId,
    Map<String, dynamic> request,
  ) {
    return _apiServices.createOrderSupportCase(orderId, request);
  }

  @override
  Future<OrderSupportCasesResponseDto> getOrderSupportCases(String orderId) {
    return _apiServices.getOrderSupportCases(orderId);
  }

  @override
  Future<List<OrderSupportReasonDto>> getOrderSupportReasons(String type) {
    return _apiServices.getOrderSupportReasons(type);
  }

  @override
  Future<OrderSupportCaseDetailsResponseDto> getOrderSupportCaseDetails(
    String orderId,
    String caseId,
  ) {
    return _apiServices.getOrderSupportCaseDetails(orderId, caseId);
  }

  @override
  Future<void> sendOrderSupportCaseMessage(
    String orderId,
    String caseId,
    Map<String, dynamic> request,
  ) async {
    try {
      await _apiServices.sendOrderSupportCaseMessage(orderId, caseId, request);
    } on DioException catch (_) {
      await _apiServices.sendOrderSupportCaseReply(orderId, caseId, request);
    }
  }

  @override
  Future<OrderRefundStatusResponseDto> getOrderRefundStatus(String orderId) {
    return _apiServices.getOrderRefundStatus(orderId);
  }

  @override
  Future<List<OrderCancellationReasonDto>> getCancellationReasons() {
    return _apiServices.getOrderCancellationReasons();
  }

  @override
  Future<CancelOrderResponseDto> cancelOrder(
    String orderId,
    CancelOrderRequestDto request,
  ) {
    return _apiServices.cancelOrder(orderId, request);
  }

  @override
  Future<RetryOrderPaymentResponseDto> retryOrderPayment(String orderId) {
    return _apiServices.retryOrderPayment(orderId);
  }

  @override
  Future<DeleteOrderResponseDto> deleteOrder(String orderId) {
    return _apiServices.deleteOrder(orderId);
  }
}
