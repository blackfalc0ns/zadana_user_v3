import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';

sealed class PaymentUiEffect {
  const PaymentUiEffect();
}

class OpenAddressSelectorEffect extends PaymentUiEffect {
  const OpenAddressSelectorEffect();
}

class OpenAddAddressEffect extends PaymentUiEffect {
  const OpenAddAddressEffect();
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

class PaymentState {
  const PaymentState({
    this.vendorId,
    this.appliedPromoCode,
    this.isLoadingSummary = false,
    this.isRefreshingSummary = false,
    this.isLoadingAddresses = false,
    this.isApplyingPromo = false,
    this.isRemovingPromo = false,
    this.isPlacingOrder = false,
    this.checkoutSummary,
    this.addresses = const [],
    this.selectedPaymentMethodCode,
    this.summaryFailure,
    this.addressesFailure,
    this.actionFailure,
    this.feedbackMessage,
    this.placedOrder,
    this.uiEffect,
  });

  final String? vendorId;
  final String? appliedPromoCode;
  final bool isLoadingSummary;
  final bool isRefreshingSummary;
  final bool isLoadingAddresses;
  final bool isApplyingPromo;
  final bool isRemovingPromo;
  final bool isPlacingOrder;
  final CheckoutSummaryEntity? checkoutSummary;
  final List<CustomerAddressEntity> addresses;
  final String? selectedPaymentMethodCode;
  final Failure? summaryFailure;
  final Failure? addressesFailure;
  final Failure? actionFailure;
  final String? feedbackMessage;
  final PlaceOrderResponseEntity? placedOrder;
  final PaymentUiEffect? uiEffect;

  bool get isBusy =>
      isLoadingSummary ||
      isRefreshingSummary ||
      isApplyingPromo ||
      isRemovingPromo ||
      isPlacingOrder;

  String? get selectedAddressId => checkoutSummary?.selectedAddress?.id;

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
      selectedAddressId != null &&
      selectedDeliverySlotId != null &&
      selectedPaymentMethodCode != null &&
      !isPlacingOrder &&
      (checkoutSummary!.isDeliveryValid);

  PaymentState copyWith({
    String? vendorId,
    String? appliedPromoCode,
    bool? isLoadingSummary,
    bool? isRefreshingSummary,
    bool? isLoadingAddresses,
    bool? isApplyingPromo,
    bool? isRemovingPromo,
    bool? isPlacingOrder,
    CheckoutSummaryEntity? checkoutSummary,
    List<CustomerAddressEntity>? addresses,
    String? selectedPaymentMethodCode,
    Failure? summaryFailure,
    Failure? addressesFailure,
    Failure? actionFailure,
    String? feedbackMessage,
    PlaceOrderResponseEntity? placedOrder,
    PaymentUiEffect? uiEffect,
    bool clearCheckoutSummary = false,
    bool clearSummaryFailure = false,
    bool clearAddressesFailure = false,
    bool clearActionFailure = false,
    bool clearFeedbackMessage = false,
    bool clearPlacedOrder = false,
    bool clearAppliedPromoCode = false,
    bool clearSelectedPaymentMethodCode = false,
    bool clearUiEffect = false,
  }) {
    return PaymentState(
      vendorId: vendorId ?? this.vendorId,
      appliedPromoCode: clearAppliedPromoCode
          ? null
          : appliedPromoCode ?? this.appliedPromoCode,
      isLoadingSummary: isLoadingSummary ?? this.isLoadingSummary,
      isRefreshingSummary: isRefreshingSummary ?? this.isRefreshingSummary,
      isLoadingAddresses: isLoadingAddresses ?? this.isLoadingAddresses,
      isApplyingPromo: isApplyingPromo ?? this.isApplyingPromo,
      isRemovingPromo: isRemovingPromo ?? this.isRemovingPromo,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      checkoutSummary: clearCheckoutSummary
          ? null
          : checkoutSummary ?? this.checkoutSummary,
      addresses: addresses ?? this.addresses,
      selectedPaymentMethodCode: clearSelectedPaymentMethodCode
          ? null
          : selectedPaymentMethodCode ?? this.selectedPaymentMethodCode,
      summaryFailure: clearSummaryFailure
          ? null
          : summaryFailure ?? this.summaryFailure,
      addressesFailure: clearAddressesFailure
          ? null
          : addressesFailure ?? this.addressesFailure,
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
