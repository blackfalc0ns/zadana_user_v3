import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_config_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';

@injectable
class GetCheckoutConfigUseCase {
  const GetCheckoutConfigUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<CheckoutConfigEntity>> call() {
    return _repository.getCheckoutConfig();
  }
}
