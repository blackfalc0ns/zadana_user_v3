import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class ProductHeaderSection extends StatelessWidget {
  final String productName;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const ProductHeaderSection({
    super.key,
    required this.productName,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      color: AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName, style: AppTextStyles.h3),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      l10n.fresh_products,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Text(
                        '1 كجم',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          _buildQuantitySelector(),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(Spacing.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(Icons.remove, quantity > 1 ? onDecrease : null, quantity > 1),
          Container(
            width: 40,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.border),
                right: BorderSide(color: AppColors.border),
              ),
            ),
            child: Text(
              quantity.toString(),
              style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          _buildButton(Icons.add, onIncrease, true),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback? onTap, bool enabled) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.horizontal(
          right: icon == Icons.remove ? const Radius.circular(Spacing.sm) : Radius.zero,
          left: icon == Icons.add ? const Radius.circular(Spacing.sm) : Radius.zero,
        ),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 16,
            color: enabled ? AppColors.primary : AppColors.disabled,
          ),
        ),
      ),
    );
  }
}
