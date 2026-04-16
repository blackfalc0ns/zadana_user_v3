import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_promo_result_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';

@injectable
class ApplyCheckoutPromoCodeUseCase {
  const ApplyCheckoutPromoCodeUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<CheckoutPromoResultEntity>> call(String code) {
    return _repository.applyPromoCode(code);
  }
}
