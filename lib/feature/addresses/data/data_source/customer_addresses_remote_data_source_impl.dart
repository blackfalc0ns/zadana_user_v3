import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/addresses/data/data_source/customer_addresses_remote_data_source.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/add_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/customer_address_item_dto.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/update_customer_address_request_dto.dart';

@Injectable(as: CustomerAddressesRemoteDataSource)
class CustomerAddressesRemoteDataSourceImpl
    implements CustomerAddressesRemoteDataSource {
  const CustomerAddressesRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<CustomerAddressItemDto>> getCustomerAddresses() {
    return _apiServices.getCustomerAddresses();
  }

  @override
  Future<CustomerAddressItemDto> addCustomerAddress(
    AddCustomerAddressRequestDto request,
  ) {
    return _apiServices.addCustomerAddress(request);
  }

  @override
  Future<bool> updateCustomerAddress(
    String addressId,
    UpdateCustomerAddressRequestDto request,
  ) async {
    await _apiServices.updateCustomerAddress(addressId, request);
    return true;
  }

  @override
  Future<bool> setCustomerAddressAsDefault(String addressId) async {
    await _apiServices.setCustomerAddressAsDefault(addressId);
    return true;
  }

  @override
  Future<bool> deleteCustomerAddress(String addressId) async {
    await _apiServices.deleteCustomerAddress(addressId);
    return true;
  }
}
