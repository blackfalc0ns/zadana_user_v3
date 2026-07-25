import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_config_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/sections/checkout_cards_section.dart';
import 'package:zadana_user_v3/feature/payment/presentation/sections/payment_progress_section.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_fulfillment_type_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_loading_view.dart';

class CheckoutContentSection extends StatelessWidget {
  const CheckoutContentSection({
    super.key,
    required this.checkoutSummary,
    required this.checkoutConfig,
    required this.selectedFulfillmentType,
    required this.addresses,
    required this.selectedPaymentMethodCode,
    required this.isLoadingAddresses,
    required this.addressesFailure,
    required this.isRefreshingSummary,
    required this.isChangingFulfillmentType,
    required this.isPromoLoading,
    required this.onChangeAddress,
    required this.onChangePickupBranch,
    required this.onFulfillmentTypeChanged,
    required this.onDeliverySlotChanged,
    required this.onPaymentMethodChanged,
    required this.onApplyPromoCode,
    required this.onRemovePromoCode,
  });

  final CheckoutSummaryEntity checkoutSummary;
  final CheckoutConfigEntity? checkoutConfig;
  final String selectedFulfillmentType;
  final List<CustomerAddressEntity> addresses;
  final String? selectedPaymentMethodCode;
  final bool isLoadingAddresses;
  final Failure? addressesFailure;
  final bool isRefreshingSummary;
  final bool isChangingFulfillmentType;
  final bool isPromoLoading;
  final VoidCallback onChangeAddress;
  final VoidCallback onChangePickupBranch;
  final ValueChanged<String> onFulfillmentTypeChanged;
  final ValueChanged<String> onDeliverySlotChanged;
  final ValueChanged<String> onPaymentMethodChanged;
  final ValueChanged<String> onApplyPromoCode;
  final VoidCallback onRemovePromoCode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PaymentProgressSection(),
          const SizedBox(height: Spacing.base),
          CheckoutFulfillmentTypeCard(
            checkoutConfig: checkoutConfig,
            selectedFulfillmentType: selectedFulfillmentType,
            isRefreshing: isRefreshingSummary,
            onChanged: onFulfillmentTypeChanged,
          ),
          const SizedBox(height: Spacing.base),
          if (isChangingFulfillmentType)
            const CheckoutRefreshShimmer()
          else
            CheckoutCardsSection(
              checkoutSummary: checkoutSummary,
              selectedFulfillmentType: selectedFulfillmentType,
              addresses: addresses,
              selectedPaymentMethodCode: selectedPaymentMethodCode,
              isLoadingAddresses: isLoadingAddresses,
              addressesFailure: addressesFailure,
              isRefreshingSummary: isRefreshingSummary,
              isPromoLoading: isPromoLoading,
              onChangeAddress: onChangeAddress,
              onChangePickupBranch: onChangePickupBranch,
              onDeliverySlotChanged: onDeliverySlotChanged,
              onPaymentMethodChanged: onPaymentMethodChanged,
              onApplyPromoCode: onApplyPromoCode,
              onRemovePromoCode: onRemovePromoCode,
            ),
        ],
      ),
    );
  }
}
