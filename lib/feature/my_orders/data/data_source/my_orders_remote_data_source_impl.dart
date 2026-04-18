import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/my_orders/data/data_source/my_orders_remote_data_source.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_details_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/paginated_orders_response_dto.dart';

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
}
