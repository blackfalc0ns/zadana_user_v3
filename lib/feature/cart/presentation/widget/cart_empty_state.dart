import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class CartEmptyState extends StatelessWidget {
  final VoidCallback onStartShopping;

  const CartEmptyState({super.key, required this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  color: Color(0xFFE0F4F7), shape: BoxShape.circle),
              child: const Icon(Icons.shopping_cart_outlined,
                  size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: Spacing.lg),
            Text(l10n.cart_empty,
                style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: Spacing.sm),
            Text(l10n.start_shopping_message,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: Spacing.xl),
            SizedBox(
              width: 200,
              height: Spacing.buttonHeight,
              child: ElevatedButton(
                onPressed: onStartShopping,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Spacing.buttonRadius)),
                  elevation: 0,
                ),
                child: Text(l10n.start_shopping, style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
