import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_response_entity.dart';

class PaymentState {
  const PaymentState({
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
  });

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

  bool get isBusy =>
      isLoadingSummary ||
      isRefreshingSummary ||
      isApplyingPromo ||
      isRemovingPromo ||
      isPlacingOrder;

  String? get selectedAddressId => checkoutSummary?.selectedAddress?.id;

  String? get selectedDeliverySlotId {
    final selected = checkoutSummary?.deliverySlots.where((item) => item.isSelected);
    if (selected == null || selected.isEmpty) return null;
    return selected.first.id;
  }

  bool get canPlaceOrder =>
      checkoutSummary != null &&
      selectedAddressId != null &&
      selectedDeliverySlotId != null &&
      selectedPaymentMethodCode != null &&
      !isPlacingOrder;

  PaymentState copyWith({
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
    bool clearCheckoutSummary = false,
    bool clearSummaryFailure = false,
    bool clearAddressesFailure = false,
    bool clearActionFailure = false,
    bool clearFeedbackMessage = false,
    bool clearPlacedOrder = false,
    bool clearSelectedPaymentMethodCode = false,
  }) {
    return PaymentState(
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
    );
  }
}
