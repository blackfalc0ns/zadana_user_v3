import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/update_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/domain/usecase/delete_customer_address_usecase.dart';
import 'package:zadana_user_v3/feature/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:zadana_user_v3/feature/addresses/domain/usecase/set_customer_address_as_default_usecase.dart';
import 'package:zadana_user_v3/feature/addresses/domain/usecase/update_customer_address_usecase.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/manager/customer_addresses_event.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/manager/customer_addresses_state.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

@injectable
class CustomerAddressesViewModel extends Cubit<CustomerAddressesState> {
  CustomerAddressesViewModel(
    this._getCustomerAddressesUseCase,
    this._deleteCustomerAddressUseCase,
    this._setCustomerAddressAsDefaultUseCase,
    this._updateCustomerAddressUseCase,
  ) : super(const CustomerAddressesState());

  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;
  final DeleteCustomerAddressUseCase _deleteCustomerAddressUseCase;
  final SetCustomerAddressAsDefaultUseCase _setCustomerAddressAsDefaultUseCase;
  final UpdateCustomerAddressUseCase _updateCustomerAddressUseCase;

  void doIntent(CustomerAddressesEvent event) {
    switch (event) {
      case CustomerAddressesLoadEvent():
        _loadAddresses();
      case CustomerAddressesRetryEvent():
        _loadAddresses();
      case CustomerAddressDeleteEvent():
        _deleteAddress(event.addressId);
      case CustomerAddressSetDefaultEvent():
        _setDefaultAddress(event.addressId);
      case CustomerAddressUpdateEvent():
        _updateAddress(event.originalAddress, event.updatedLocation);
    }
  }

  Future<void> _loadAddresses() async {
    emit(state.copyWith(isLoading: true, isSuccess: false, clearFailure: true));

    developer.log(
      'Loading customer addresses',
      name: 'CustomerAddressesViewModel',
    );

    final result = await _getCustomerAddressesUseCase();

    switch (result) {
      case ApiSuccessResult<List<CustomerAddressEntity>>():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            items: result.data,
            selectedDefaultId: _resolveDefaultId(result.data),
            clearFailure: true,
          ),
        );
      case ApiErrorResult<List<CustomerAddressEntity>>():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    emit(
      state.copyWith(
        deletingAddressId: addressId,
        clearActionType: true,
        clearActionLabel: true,
        clearActionFailure: true,
      ),
    );

    final result = await _deleteCustomerAddressUseCase(addressId);

    switch (result) {
      case ApiSuccessResult<String>():
        emit(
          state.copyWith(
            items: state.items.where((item) => item.id != addressId).toList(),
            selectedDefaultId: _resolveDefaultId(
              state.items.where((item) => item.id != addressId).toList(),
            ),
            actionType: CustomerAddressesActionType.deleteSuccess,
            clearDeletingAddressId: true,
            clearActionFailure: true,
          ),
        );
      case ApiErrorResult<String>():
        emit(
          state.copyWith(
            actionFailure: result.failure,
            clearDeletingAddressId: true,
            clearActionType: true,
            clearActionLabel: true,
          ),
        );
    }
  }

  Future<void> _setDefaultAddress(String addressId) async {
    emit(
      state.copyWith(
        settingDefaultAddressId: addressId,
        clearActionType: true,
        clearActionLabel: true,
        clearActionFailure: true,
      ),
    );

    final result = await _setCustomerAddressAsDefaultUseCase(addressId);

    switch (result) {
      case ApiSuccessResult<String>():
        final updatedItems = state.items
            .map(
              (item) => CustomerAddressEntity(
                id: item.id,
                contactName: item.contactName,
                contactPhone: item.contactPhone,
                addressLine: item.addressLine,
                label: item.label,
                buildingNo: item.buildingNo,
                floorNo: item.floorNo,
                apartmentNo: item.apartmentNo,
                city: item.city,
                area: item.area,
                latitude: item.latitude,
                longitude: item.longitude,
                isDefault: item.id == addressId,
              ),
            )
            .toList();
        final selectedItem = updatedItems.firstWhere(
          (item) => item.id == addressId,
        );
        emit(
          state.copyWith(
            items: updatedItems,
            selectedDefaultId: addressId,
            clearSettingDefaultAddressId: true,
            actionType: CustomerAddressesActionType.setDefaultSuccess,
            actionLabel: selectedItem.label,
            clearActionFailure: true,
          ),
        );
      case ApiErrorResult<String>():
        emit(
          state.copyWith(
            actionFailure: result.failure,
            clearSettingDefaultAddressId: true,
            clearActionType: true,
            clearActionLabel: true,
          ),
        );
    }
  }

  Future<void> _updateAddress(
    CustomerAddressEntity originalAddress,
    LocationEntity updatedLocation,
  ) async {
    emit(
      state.copyWith(
        updatingAddressId: originalAddress.id,
        clearActionType: true,
        clearActionLabel: true,
        clearActionFailure: true,
      ),
    );

    final request = UpdateCustomerAddressRequestDto(
      id: originalAddress.id,
      contactName: originalAddress.contactName,
      contactPhone: originalAddress.contactPhone,
      addressLine: updatedLocation.addressLine.trim(),
      label: updatedLocation.label.trim().isEmpty
          ? originalAddress.label
          : updatedLocation.label.trim(),
      buildingNo: _nullIfEmpty(updatedLocation.buildingNo),
      floorNo: updatedLocation.floorNo.trim(),
      apartmentNo: updatedLocation.apartmentNo.trim(),
      city: updatedLocation.city.trim(),
      area: _nullIfEmpty(updatedLocation.area),
      latitude: updatedLocation.latitude,
      longitude: updatedLocation.longitude,
      isDefault: originalAddress.isDefault,
    );

    final result = await _updateCustomerAddressUseCase(
      originalAddress.id,
      request,
    );

    switch (result) {
      case ApiSuccessResult<String>():
        final updatedItems = state.items
            .map(
              (item) => item.id == originalAddress.id
                  ? CustomerAddressEntity(
                      id: item.id,
                      contactName: item.contactName,
                      contactPhone: item.contactPhone,
                      addressLine: request.addressLine,
                      label: request.label,
                      buildingNo: request.buildingNo,
                      floorNo: request.floorNo,
                      apartmentNo: request.apartmentNo,
                      city: request.city,
                      area: request.area ?? '',
                      latitude: request.latitude,
                      longitude: request.longitude,
                      isDefault: item.isDefault,
                    )
                  : item,
            )
            .toList();
        emit(
          state.copyWith(
            items: updatedItems,
            clearUpdatingAddressId: true,
            actionType: CustomerAddressesActionType.editSuccess,
            actionLabel: request.label,
            clearActionFailure: true,
          ),
        );
      case ApiErrorResult<String>():
        emit(
          state.copyWith(
            clearUpdatingAddressId: true,
            actionFailure: result.failure,
            clearActionType: true,
            clearActionLabel: true,
          ),
        );
    }
  }

  void clearActionFeedback() {
    emit(
      state.copyWith(
        clearActionType: true,
        clearActionLabel: true,
        clearActionFailure: true,
      ),
    );
  }

  String? _resolveDefaultId(List<CustomerAddressEntity> items) {
    if (items.isEmpty) return null;
    final apiDefault = items.where((item) => item.isDefault).firstOrNull;
    return apiDefault?.id ?? items.first.id;
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
