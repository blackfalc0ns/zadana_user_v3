import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_scaffold.dart';
import 'package:zadana_user_v3/feature/payment/presentation/mixins/payment_animations_mixin.dart';
import 'package:zadana_user_v3/feature/payment/presentation/mixins/payment_order_mixin.dart';
import 'package:zadana_user_v3/feature/payment/presentation/sections/sections.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_app_bar.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_bottom_action.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin, PaymentAnimationsMixin, PaymentOrderMixin {
  String _selectedPaymentMethod = 'card';

  @override
  void initState() {
    super.initState();
    initializePaymentAnimations();
  }

  @override
  void dispose() {
    disposePaymentAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return AppScaffold(
      backgroundColor: colors.surface,
      appBar: PaymentAppBar(title: l10n.checkout),
      body: Column(
        children: [
          Expanded(
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: PaymentContentSection(
                  selectedPaymentMethod: _selectedPaymentMethod,
                  onPaymentMethodChanged: (method) {
                    setState(() => _selectedPaymentMethod = method);
                  },
                ),
              ),
            ),
          ),
          PaymentBottomAction(
            buttonText: isLoading
                ? l10n.processing
                : '${l10n.checkout} - 110.00 ${l10n.sar}',
            isLoading: isLoading,
            onPressed: handlePlaceOrder,
          ),
        ],
      ),
    );
  }
}
