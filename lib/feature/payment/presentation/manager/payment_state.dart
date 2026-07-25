import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_config_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/pickup_branch_option_entity.dart';

sealed class PaymentUiEffect {
  const PaymentUiEffect();
}

class OpenAddressSelectorEffect extends PaymentUiEffect {
  const OpenAddressSelectorEffect();
}

class OpenAddAddressEffect extends PaymentUiEffect {
  const OpenAddAddressEffect();
}

class OpenPickupBranchSelectorEffect extends PaymentUiEffect {
  const OpenPickupBranchSelectorEffect();
}

class OpenMoyasarPaymentEffect extends PaymentUiEffect {
  const OpenMoyasarPaymentEffect(this.providerConfig, {this.orderId});

  final MoyasarProviderConfigEntity providerConfig;
  final String? orderId;
}

class NavigateToPaymentSuccessEffect extends PaymentUiEffect {
  const NavigateToPaymentSuccessEffect(
    this.orderId, {
    this.isCashOnDelivery = false,
  });

  final String orderId;
  final bool isCashOnDelivery;
}

class NavigateToBankTransferPendingEffect extends PaymentUiEffect {
  const NavigateToBankTransferPendingEffect({
    required this.orderId,
    this.bankTransferConfig,
    this.providerReference,
  });

  final String orderId;
  final BankTransferConfigEntity? bankTransferConfig;
  final String? providerReference;
}

class ShowPaymentSuccessEffect extends PaymentUiEffect {
  const ShowPaymentSuccessEffect(this.message);

  final String message;
}

class ShowPaymentErrorEffect extends PaymentUiEffect {
  const ShowPaymentErrorEffect(this.message);

  final String message;
}

class ShowPaymentInfoEffect extends PaymentUiEffect {
  const ShowPaymentInfoEffect(this.message);

  final String message;
}

class ShowDeliveryUnavailableDialogEffect extends PaymentUiEffect {
  const ShowDeliveryUnavailableDialogEffect(this.message);

  final String message;
}

class ShowCartItemsUnavailableAtBranchEffect extends PaymentUiEffect {
  const ShowCartItemsUnavailableAtBranchEffect(this.message);

  final String message;
}

class ConfirmUnavailableItemsEffect extends PaymentUiEffect {
  const ConfirmUnavailableItemsEffect({required this.unavailableItemsCount});

  final int unavailableItemsCount;
}

class PaymentState {
  const PaymentState({
    this.vendorId,
    this.fulfillmentType = 'delivery',
    this.vendorBranchId,
    this.removeUnavailableItems = false,
    this.appliedPromoCode,
    this.isLoadingSummary = false,
    this.isLoadingConfig = false,
    this.isRefreshingSummary = false,
    this.isChangingFulfillmentType = false,
    this.isLoadingAddresses = false,
    this.isLoadingPickupBranches = false,
    this.isApplyingPromo = false,
    this.isRemovingPromo = false,
    this.isPlacingOrder = false,
    this.checkoutSummary,
    this.checkoutConfig,
    this.addresses = const [],
    this.pickupBranches = const [],
    this.selectedPaymentMethodCode,
    this.summaryFailure,
    this.addressesFailure,
    this.pickupBranchesFailure,
    this.actionFailure,
    this.feedbackMessage,
    this.placedOrder,
    this.uiEffect,
  });

  final String? vendorId;
  final String fulfillmentType;
  final String? vendorBranchId;
  final bool removeUnavailableItems;
  final String? appliedPromoCode;
  final bool isLoadingSummary;
  final bool isLoadingConfig;
  final bool isRefreshingSummary;
  final bool isChangingFulfillmentType;
  final bool isLoadingAddresses;
  final bool isLoadingPickupBranches;
  final bool isApplyingPromo;
  final bool isRemovingPromo;
  final bool isPlacingOrder;
  final CheckoutSummaryEntity? checkoutSummary;
  final CheckoutConfigEntity? checkoutConfig;
  final List<CustomerAddressEntity> addresses;
  final List<PickupBranchOptionEntity> pickupBranches;
  final String? selectedPaymentMethodCode;
  final Failure? summaryFailure;
  final Failure? addressesFailure;
  final Failure? pickupBranchesFailure;
  final Failure? actionFailure;
  final String? feedbackMessage;
  final PlaceOrderResponseEntity? placedOrder;
  final PaymentUiEffect? uiEffect;

  bool get isBusy =>
      isLoadingSummary ||
      isLoadingConfig ||
      isRefreshingSummary ||
      isLoadingPickupBranches ||
      isApplyingPromo ||
      isRemovingPromo ||
      isPlacingOrder;

  String? get selectedAddressId => checkoutSummary?.selectedAddress?.id;

  bool get isPickup => fulfillmentType.trim().toLowerCase() == 'pickup';
  bool get isDeliveryEnabled => checkoutConfig?.deliveryEnabled ?? true;
  bool get isPickupEnabled => checkoutConfig?.pickupEnabled ?? true;

  List<CustomerAddressEntity> get availableAddresses {
    final summaryAddresses = checkoutSummary?.availableAddresses ?? const [];
    if (summaryAddresses.isNotEmpty) {
      return summaryAddresses
          .map(
            (address) => CustomerAddressEntity(
              id: address.id,
              contactName: '',
              contactPhone: '',
              addressLine: address.addressLine,
              label: address.label,
              buildingNo: null,
              floorNo: null,
              apartmentNo: null,
              city: '',
              area: '',
              latitude: 0,
              longitude: 0,
              isDefault: address.isDefault,
            ),
          )
          .toList();
    }

    return addresses;
  }

  String? get selectedDeliverySlotId {
    final selected = checkoutSummary?.deliverySlots.where(
      (item) => item.isSelected,
    );
    if (selected == null || selected.isEmpty) return null;
    return selected.first.id;
  }

  bool get canPlaceOrder =>
      checkoutSummary != null &&
      selectedPaymentMethodCode != null &&
      !isPlacingOrder &&
      (isPickup
          ? ((vendorBranchId ?? checkoutSummary?.pickupBranch?.id) != null)
          : (selectedAddressId != null &&
                selectedDeliverySlotId != null &&
                checkoutSummary!.isDeliveryValid));

  PaymentState copyWith({
    String? vendorId,
    String? fulfillmentType,
    String? vendorBranchId,
    bool? removeUnavailableItems,
    String? appliedPromoCode,
    bool? isLoadingSummary,
    bool? isLoadingConfig,
    bool? isRefreshingSummary,
    bool? isChangingFulfillmentType,
    bool? isLoadingAddresses,
    bool? isLoadingPickupBranches,
    bool? isApplyingPromo,
    bool? isRemovingPromo,
    bool? isPlacingOrder,
    CheckoutSummaryEntity? checkoutSummary,
    CheckoutConfigEntity? checkoutConfig,
    List<CustomerAddressEntity>? addresses,
    List<PickupBranchOptionEntity>? pickupBranches,
    String? selectedPaymentMethodCode,
    Failure? summaryFailure,
    Failure? addressesFailure,
    Failure? pickupBranchesFailure,
    Failure? actionFailure,
    String? feedbackMessage,
    PlaceOrderResponseEntity? placedOrder,
    PaymentUiEffect? uiEffect,
    bool clearCheckoutSummary = false,
    bool clearSummaryFailure = false,
    bool clearAddressesFailure = false,
    bool clearPickupBranchesFailure = false,
    bool clearActionFailure = false,
    bool clearFeedbackMessage = false,
    bool clearPlacedOrder = false,
    bool clearAppliedPromoCode = false,
    bool clearSelectedPaymentMethodCode = false,
    bool clearUiEffect = false,
  }) {
    return PaymentState(
      vendorId: vendorId ?? this.vendorId,
      fulfillmentType: fulfillmentType ?? this.fulfillmentType,
      vendorBranchId: vendorBranchId ?? this.vendorBranchId,
      removeUnavailableItems:
          removeUnavailableItems ?? this.removeUnavailableItems,
      appliedPromoCode: clearAppliedPromoCode
          ? null
          : appliedPromoCode ?? this.appliedPromoCode,
      isLoadingSummary: isLoadingSummary ?? this.isLoadingSummary,
      isLoadingConfig: isLoadingConfig ?? this.isLoadingConfig,
      isRefreshingSummary: isRefreshingSummary ?? this.isRefreshingSummary,
      isChangingFulfillmentType:
          isChangingFulfillmentType ?? this.isChangingFulfillmentType,
      isLoadingAddresses: isLoadingAddresses ?? this.isLoadingAddresses,
      isLoadingPickupBranches:
          isLoadingPickupBranches ?? this.isLoadingPickupBranches,
      isApplyingPromo: isApplyingPromo ?? this.isApplyingPromo,
      isRemovingPromo: isRemovingPromo ?? this.isRemovingPromo,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      checkoutSummary: clearCheckoutSummary
          ? null
          : checkoutSummary ?? this.checkoutSummary,
      checkoutConfig: checkoutConfig ?? this.checkoutConfig,
      addresses: addresses ?? this.addresses,
      pickupBranches: pickupBranches ?? this.pickupBranches,
      selectedPaymentMethodCode: clearSelectedPaymentMethodCode
          ? null
          : selectedPaymentMethodCode ?? this.selectedPaymentMethodCode,
      summaryFailure: clearSummaryFailure
          ? null
          : summaryFailure ?? this.summaryFailure,
      addressesFailure: clearAddressesFailure
          ? null
          : addressesFailure ?? this.addressesFailure,
      pickupBranchesFailure: clearPickupBranchesFailure
          ? null
          : pickupBranchesFailure ?? this.pickupBranchesFailure,
      actionFailure: clearActionFailure
          ? null
          : actionFailure ?? this.actionFailure,
      feedbackMessage: clearFeedbackMessage
          ? null
          : feedbackMessage ?? this.feedbackMessage,
      placedOrder: clearPlacedOrder ? null : placedOrder ?? this.placedOrder,
      uiEffect: clearUiEffect ? null : uiEffect ?? this.uiEffect,
    );
  }
}
