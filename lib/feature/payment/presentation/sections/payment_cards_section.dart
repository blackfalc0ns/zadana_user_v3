import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/animated_card_wrapper.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/delivery_datetime_selector.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/delivery_info_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/order_summary_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_method_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/price_breakdown_card.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/promo_code_card.dart';

class PaymentCardsSection extends StatelessWidget {
  const PaymentCardsSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });
  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AnimatedCardWrapper(delay: 100, child: OrderSummaryCard()),
        const SizedBox(height: Spacing.md),
        const AnimatedCardWrapper(delay: 200, child: DeliveryInfoCard()),
        const SizedBox(height: Spacing.md),
        AnimatedCardWrapper(
          delay: 250,
          child: DeliveryDateTimeSelector(
            onDateTimeChanged: (dateTime) {
              // Seçilen tarih/saat burada işlenebilir
              debugPrint('Selected delivery time: $dateTime');
            },
          ),
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
        const AnimatedCardWrapper(delay: 400, child: PromoCodeCard()),
        const SizedBox(height: Spacing.md),
        const AnimatedCardWrapper(
          delay: 500,
          child: PriceBreakdownCard(
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
