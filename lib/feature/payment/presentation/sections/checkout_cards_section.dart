import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/animated_card_wrapper.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_delivery_info_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_delivery_slots_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_order_summary_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_payment_method_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_price_breakdown_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_promo_code_card.dart';

class CheckoutCardsSection extends StatelessWidget {
  const CheckoutCardsSection({
    super.key,
    required this.checkoutSummary,
    required this.addresses,
    required this.selectedPaymentMethodCode,
    required this.isLoadingAddresses,
    required this.addressesFailure,
    required this.isRefreshingSummary,
    required this.isPromoLoading,
    required this.onChangeAddress,
    required this.onDeliverySlotChanged,
    required this.onPaymentMethodChanged,
    required this.onApplyPromoCode,
    required this.onRemovePromoCode,
  });

  final CheckoutSummaryEntity checkoutSummary;
  final List<CustomerAddressEntity> addresses;
  final String? selectedPaymentMethodCode;
  final bool isLoadingAddresses;
  final Failure? addressesFailure;
  final bool isRefreshingSummary;
  final bool isPromoLoading;
  final VoidCallback onChangeAddress;
  final ValueChanged<String> onDeliverySlotChanged;
  final ValueChanged<String> onPaymentMethodChanged;
  final ValueChanged<String> onApplyPromoCode;
  final VoidCallback onRemovePromoCode;

  @override
  Widget build(BuildContext context) {
    CheckoutDeliverySlotEntity? selectedSlot;
    for (final slot in checkoutSummary.deliverySlots) {
      if (slot.isSelected) {
        selectedSlot = slot;
        break;
      }
    }

    return Column(
      children: [
        AnimatedCardWrapper(
          delay: 100,
          child: CheckoutOrderSummaryCard(
            cart: checkoutSummary.cart,
            currencyCode: checkoutSummary.summary.currency,
          ),
        ),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 200,
          child: CheckoutDeliveryInfoCard(
            selectedAddress: checkoutSummary.selectedAddress,
            selectedSlot: selectedSlot,
            onChangeAddress: onChangeAddress,
            isRefreshing: isRefreshingSummary || isLoadingAddresses,
          ),
        ),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 250,
          child: CheckoutDeliverySlotsCard(
            deliverySlots: checkoutSummary.deliverySlots,
            onDeliverySlotSelected: onDeliverySlotChanged,
          ),
        ),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 300,
          child: CheckoutPaymentMethodCard(
            paymentMethods: checkoutSummary.paymentMethods,
            selectedMethodCode: selectedPaymentMethodCode,
            onMethodChanged: onPaymentMethodChanged,
          ),
        ),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 400,
          child: CheckoutPromoCodeCard(
            promoCode: checkoutSummary.promoCode,
            currencyCode: checkoutSummary.summary.currency,
            isLoading: isPromoLoading,
            onApply: onApplyPromoCode,
            onRemove: onRemovePromoCode,
          ),
        ),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 500,
          child: CheckoutPriceBreakdownCard(summary: checkoutSummary.summary),
        ),
      ],
    );
  }
}
