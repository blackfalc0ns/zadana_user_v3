import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/add_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/domain/repo/customer_addresses_repository.dart';

@injectable
class AddCustomerAddressUseCase {
  const AddCustomerAddressUseCase(this._repository);

  final CustomerAddressesRepository _repository;

  Future<ApiResult<CustomerAddressEntity>> call(
    AddCustomerAddressRequestDto request,
  ) {
    return _repository.addCustomerAddress(request);
  }
}
