import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
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
    return Row(
      children: [
        Expanded(child: _buildComparisonButton()),
        const SizedBox(width: 8),
        Expanded(child: _buildCheckoutButton()),
      ],
    );
  }

  Widget _buildComparisonButton() {
    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: onComparison,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.compare_arrows, color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Text(
              'مقارنة',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return AppButton(
      height: 36,
      onPressed: onCheckout,
      text: 'متابعة الدفع',
    );
  }
}