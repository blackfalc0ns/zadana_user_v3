import 'package:flutter/material.dart';
import 'package:pay/pay.dart' show ApplePayButtonType, RawApplePayButton;
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class PaymentBottomAction extends StatelessWidget {
  const PaymentBottomAction({
    super.key,
    required this.buttonText,
    this.isLoading = false,
    this.onPressed,
  });
  final String buttonText;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: AppButton(
          text: buttonText,
          icon: isLoading ? null : Icons.payment,
          isLoading: isLoading,
          onPressed: onPressed,
          color: colors.primary,
          textColor: colors.onPrimary,
          height: Spacing.buttonHeight,
        ),
      ),
    );
  }
}

/// Apple's native `PKPaymentButton` used as the checkout action.
///
/// The payment-method row only selects Apple Pay. This button is the sole
/// branded control that starts the Apple Pay purchase flow.
class ApplePayBottomAction extends StatelessWidget {
  const ApplePayBottomAction({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: double.infinity,
          height: Spacing.buttonHeight,
          child: IgnorePointer(
            ignoring: onPressed == null,
            child: RawApplePayButton(
              // Recreate the native PKPaymentButton when the app locale
              // changes so iOS can apply its official localized title.
              key: ValueKey('apple-pay-checkout-$languageCode'),
              type: ApplePayButtonType.checkout,
              cornerRadius: 12,
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
