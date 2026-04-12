import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/assets.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key, required this.onStartShopping});
  final VoidCallback onStartShopping;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                AppAssets.emptyCart,
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              locale.cart_empty,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size20,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              locale.cart_empty_description,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: color.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xxxl),
              child: AppButton(
                onPressed: onStartShopping,
                text: locale.start_shopping,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
