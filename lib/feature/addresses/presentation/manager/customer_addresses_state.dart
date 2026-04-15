import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';

class CustomerAddressesState {
  const CustomerAddressesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.items = const [],
    this.failure,
    this.selectedDefaultId,
    this.deletingAddressId,
    this.settingDefaultAddressId,
    this.updatingAddressId,
    this.actionType,
    this.actionLabel,
    this.actionFailure,
  });

  final bool isLoading;
  final bool isSuccess;
  final List<CustomerAddressEntity> items;
  final Failure? failure;
  final String? selectedDefaultId;
  final String? deletingAddressId;
  final String? settingDefaultAddressId;
  final String? updatingAddressId;
  final CustomerAddressesActionType? actionType;
  final String? actionLabel;
  final Failure? actionFailure;

  CustomerAddressesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<CustomerAddressEntity>? items,
    Failure? failure,
    String? selectedDefaultId,
    String? deletingAddressId,
    String? settingDefaultAddressId,
    String? updatingAddressId,
    CustomerAddressesActionType? actionType,
    String? actionLabel,
    Failure? actionFailure,
    bool clearFailure = false,
    bool clearSelectedDefaultId = false,
    bool clearDeletingAddressId = false,
    bool clearSettingDefaultAddressId = false,
    bool clearUpdatingAddressId = false,
    bool clearActionType = false,
    bool clearActionLabel = false,
    bool clearActionFailure = false,
  }) {
    return CustomerAddressesState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      items: items ?? this.items,
      failure: clearFailure ? null : failure ?? this.failure,
      selectedDefaultId: clearSelectedDefaultId
          ? null
          : selectedDefaultId ?? this.selectedDefaultId,
      deletingAddressId: clearDeletingAddressId
          ? null
          : deletingAddressId ?? this.deletingAddressId,
      settingDefaultAddressId: clearSettingDefaultAddressId
          ? null
          : settingDefaultAddressId ?? this.settingDefaultAddressId,
      updatingAddressId: clearUpdatingAddressId
          ? null
          : updatingAddressId ?? this.updatingAddressId,
      actionType: clearActionType ? null : actionType ?? this.actionType,
      actionLabel: clearActionLabel ? null : actionLabel ?? this.actionLabel,
      actionFailure: clearActionFailure
          ? null
          : actionFailure ?? this.actionFailure,
    );
  }
}

enum CustomerAddressesActionType {
  deleteSuccess,
  setDefaultSuccess,
  editSuccess,
}
