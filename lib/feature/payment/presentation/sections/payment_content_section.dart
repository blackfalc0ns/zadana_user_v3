import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/payment/presentation/sections/payment_cards_section.dart';
import 'package:zadana_user_v3/feature/payment/presentation/sections/payment_progress_section.dart';

class PaymentContentSection extends StatelessWidget {
  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  const PaymentContentSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

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
          PaymentCardsSection(
            selectedPaymentMethod: selectedPaymentMethod,
            onPaymentMethodChanged: onPaymentMethodChanged,
          ),
        ],
      ),
    );
  }
}
