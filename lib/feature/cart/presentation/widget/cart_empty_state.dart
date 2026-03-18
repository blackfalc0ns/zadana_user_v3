import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CartEmptyState extends StatelessWidget {
  final VoidCallback onStartShopping;

  const CartEmptyState({super.key, required this.onStartShopping});

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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: color.primary,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              locale.cart_empty,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              locale.start_shopping_message,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size12,
                color: color.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xl),
            SizedBox(
              width: 200,
              height: Spacing.buttonHeight,
              child: ElevatedButton(
                onPressed: onStartShopping,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.primary,
                  foregroundColor: color.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Spacing.buttonRadius),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  locale.start_shopping,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: color.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
