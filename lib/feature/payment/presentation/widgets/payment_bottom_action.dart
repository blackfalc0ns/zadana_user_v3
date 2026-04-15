import 'package:flutter/material.dart';
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

    return Padding(
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
    );
  }
}
