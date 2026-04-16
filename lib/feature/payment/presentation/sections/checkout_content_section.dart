import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/sections/checkout_cards_section.dart';
import 'package:zadana_user_v3/feature/payment/presentation/sections/payment_progress_section.dart';

class CheckoutContentSection extends StatelessWidget {
  const CheckoutContentSection({
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
          CheckoutCardsSection(
            checkoutSummary: checkoutSummary,
            addresses: addresses,
            selectedPaymentMethodCode: selectedPaymentMethodCode,
            isLoadingAddresses: isLoadingAddresses,
            addressesFailure: addressesFailure,
            isRefreshingSummary: isRefreshingSummary,
            isPromoLoading: isPromoLoading,
            onChangeAddress: onChangeAddress,
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
