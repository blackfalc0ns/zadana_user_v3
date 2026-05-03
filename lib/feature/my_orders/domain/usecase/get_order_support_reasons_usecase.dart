import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';

@injectable
class GetOrderSupportReasonsUseCase {
  const GetOrderSupportReasonsUseCase(this._repository);

  final MyOrdersRepository _repository;

  Future<ApiResult<List<OrderSupportReasonEntity>>> call(
    OrderSupportCaseType type,
  ) {
    return _repository.getSupportReasons(type);
  }
}
