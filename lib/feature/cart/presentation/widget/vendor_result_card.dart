import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';

class VendorResultCard extends StatelessWidget {
  final CartVendorEntity vendor;
  final double total;
  final int rank;
  final bool isCheapest;
  final bool isCurrent;
  final double savings;
  final VoidCallback onSelect;

  const VendorResultCard({
    super.key,
    required this.vendor,
    required this.total,
    required this.rank,
    required this.isCheapest,
    required this.isCurrent,
    required this.savings,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCheapest ? const Color(0xFFE0F4F7) : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCheapest
                ? AppColors.primary
                : isCurrent
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.border,
            width: isCheapest || isCurrent ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCheapest ? AppColors.primary : AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isCheapest
                        ? AppColors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        vendor.name,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (isCheapest) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🏆', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 2),
                              Text(
                                l10n.cheapest,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (!isCheapest && savings > 0)
                    Text(
                      '${l10n.more_expensive_by} ${savings.toStringAsFixed(0)} ج.م',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${total.toStringAsFixed(0)} ج.م',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isCheapest
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isCurrent && !isCheapest)
                  Text(
                    l10n.currently_selected,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
