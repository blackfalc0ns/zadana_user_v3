import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class StorePriceCard extends StatelessWidget {
  final String storeName;
  final double price;
  final bool isAvailable;
  final String currency;

  const StorePriceCard({
    super.key,
    required this.storeName,
    required this.price,
    required this.isAvailable,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: isAvailable ? AppColors.successLight : AppColors.errorLight,
        borderRadius: BorderRadius.circular(Spacing.sm),
        border: Border.all(color: isAvailable ? AppColors.success : AppColors.error),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.store,
              color: isAvailable ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(storeName, style: AppTextStyles.labelMedium),
                Text(
                  isAvailable ? l10n.available : l10n.not_available,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isAvailable ? AppColors.success : AppColors.error,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${price.toStringAsFixed(0)} $currency',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
