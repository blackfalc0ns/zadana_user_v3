import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/pickup_branch_option_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';

@injectable
class GetPickupBranchesUseCase {
  const GetPickupBranchesUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<List<PickupBranchOptionEntity>>> call({
    String? vendorId,
    String? addressId,
    String? city,
  }) {
    return _repository.getPickupBranches(
      vendorId: vendorId,
      addressId: addressId,
      city: city,
    );
  }
}
