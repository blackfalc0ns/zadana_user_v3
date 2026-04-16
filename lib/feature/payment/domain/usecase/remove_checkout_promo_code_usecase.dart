import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_promo_result_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';

@injectable
class RemoveCheckoutPromoCodeUseCase {
  const RemoveCheckoutPromoCodeUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<CheckoutPromoResultEntity>> call() {
    return _repository.removePromoCode();
  }
}
