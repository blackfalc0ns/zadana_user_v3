import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/data/data_source/my_orders_remote_data_source.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/paginated_orders_entity.dart';
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
}
