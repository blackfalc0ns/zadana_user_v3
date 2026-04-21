import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/data/data_source/my_orders_remote_data_source.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/cancel_order_request_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_request_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/delete_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_cancellation_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/paginated_orders_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/retry_order_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';

@Injectable(as: MyOrdersRepository)
class MyOrdersRepositoryImpl implements MyOrdersRepository {
  const MyOrdersRepositoryImpl(this._remoteDataSource);

  final MyOrdersRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<PaginatedOrdersEntity>> getActiveOrders({
    required int page,
    required int perPage,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getActiveOrders(
        page: page,
        perPage: perPage,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<PaginatedOrdersEntity>> getCompletedOrders({
    required int page,
    required int perPage,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCompletedOrders(
        page: page,
        perPage: perPage,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<PaginatedOrdersEntity>> getReturnedOrders({
    required int page,
    required int perPage,
  }) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getReturnedOrders(
        page: page,
        perPage: perPage,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<OrderDetailsEntity>> getOrderDetails(String orderId) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getOrderDetails(orderId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<List<OrderCancellationReasonEntity>>>
  getCancellationReasons() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCancellationReasons();
      return response
          .map((reason) => reason.toEntity())
          .toList(growable: false);
    });
  }

  @override
  Future<ApiResult<CancelOrderResponseEntity>> cancelOrder(
    String orderId,
    CancelOrderRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.cancelOrder(
        orderId,
        CancelOrderRequestDto.fromEntity(request),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<RetryOrderPaymentResponseEntity>> retryOrderPayment(
    String orderId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.retryOrderPayment(orderId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<DeleteOrderResponseEntity>> deleteOrder(
    String orderId,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.deleteOrder(orderId);
      return response.toEntity();
    });
  }
}
