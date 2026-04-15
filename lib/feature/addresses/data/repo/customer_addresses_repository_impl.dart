import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/addresses/data/data_source/customer_addresses_remote_data_source.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/add_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/customer_address_item_dto.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/update_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/domain/repo/customer_addresses_repository.dart';

@Injectable(as: CustomerAddressesRepository)
class CustomerAddressesRepositoryImpl implements CustomerAddressesRepository {
  const CustomerAddressesRepositoryImpl(this._remoteDataSource);

  final CustomerAddressesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCustomerAddresses();
      return response.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> addCustomerAddress(
    AddCustomerAddressRequestDto request,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.addCustomerAddress(request);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<String>> updateCustomerAddress(
    String addressId,
    UpdateCustomerAddressRequestDto request,
  ) async {
    return safeApiCall(() async {
      await _remoteDataSource.updateCustomerAddress(addressId, request);
      return 'تم تحديث العنوان بنجاح';
    });
  }

  @override
  Future<ApiResult<String>> setCustomerAddressAsDefault(
    String addressId,
  ) async {
    return safeApiCall(() async {
      await _remoteDataSource.setCustomerAddressAsDefault(addressId);
      return 'تم تعيين العنوان كافتراضي بنجاح';
    });
  }

  @override
  Future<ApiResult<String>> deleteCustomerAddress(String addressId) async {
    return safeApiCall(() async {
      await _remoteDataSource.deleteCustomerAddress(addressId);
      return 'تم حذف العنوان بنجاح';
    });
  }
}
