import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class CartActionButtons extends StatelessWidget {
  final VoidCallback onComparison;
  final VoidCallback onCheckout;

  const CartActionButtons({
    super.key,
    required this.onComparison,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AppButton(height: 36, onPressed: onCheckout, text: locale.checkout);
  }
}
