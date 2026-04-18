import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/paginated_orders_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';

@injectable
class GetCompletedOrdersUseCase {
  const GetCompletedOrdersUseCase(this._repository);

  final MyOrdersRepository _repository;

  Future<ApiResult<PaginatedOrdersEntity>> call({
    required int page,
    required int perPage,
  }) {
    return _repository.getCompletedOrders(page: page, perPage: perPage);
  }
}
