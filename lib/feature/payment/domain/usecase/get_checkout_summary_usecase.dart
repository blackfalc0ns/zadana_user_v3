import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';

@injectable
class GetCheckoutSummaryUseCase {
  const GetCheckoutSummaryUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<CheckoutSummaryEntity>> call({
    String? addressId,
    String? deliverySlotId,
  }) {
    return _repository.getCheckoutSummary(
      addressId: addressId,
      deliverySlotId: deliverySlotId,
    );
  }
}
