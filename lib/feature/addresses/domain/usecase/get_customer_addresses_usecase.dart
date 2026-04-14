import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/domain/repo/customer_addresses_repository.dart';

@injectable
class GetCustomerAddressesUseCase {
  const GetCustomerAddressesUseCase(this._repository);

  final CustomerAddressesRepository _repository;

  Future<ApiResult<List<CustomerAddressEntity>>> call() {
    return _repository.getCustomerAddresses();
  }
}
