import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_request_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';

@injectable
class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<PlaceOrderResponseEntity>> call(
    PlaceOrderRequestEntity request,
  ) {
    return _repository.placeOrder(request);
  }
}
