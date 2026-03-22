import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/animated_card_wrapper.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/delivery_info_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/order_summary_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_method_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/price_breakdown_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/promo_code_card.dart';

class PaymentCardsSection extends StatelessWidget {
  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  const PaymentCardsSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCardWrapper(
          delay: 100,
          child: const OrderSummaryCard(),
        ),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 200,
          child: const DeliveryInfoCard(),
        ),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 300,
          child: PaymentMethodCard(
            selectedMethod: selectedPaymentMethod,
            onMethodChanged: (method) {
              HapticFeedback.lightImpact();
              onPaymentMethodChanged(method);
            },
          ),
        ),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 400,
          child: const PromoCodeCard(),
        ),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 500,
          child: const PriceBreakdownCard(
            subtotal: '125.50',
            shipping: 'مجاني',
            discount: '-15.50',
            total: '110.00',
          ),
        ),
      ],
    );
  }
}
