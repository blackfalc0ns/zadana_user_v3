import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';

class ExploreMoreTile extends StatelessWidget {
  const ExploreMoreTile({
    super.key,
    required this.product,
    required this.addToCartLabel,
    this.onAddTap,
    this.onFavoriteTap,
    this.onTap,
  });

  final ProductModel product;
  final String addToCartLabel;
  final VoidCallback? onAddTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.xs,
        ),
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // ── Image ───────────────────────────────────────────
            ProductImage(
              emoji: product.emoji,
              url: product.imageUrl,
              width: 72,
              height: 72,
              borderRadius: Spacing.cardRadius,
              heroTag: productHeroTag(product.id),
            ),

            const SizedBox(width: Spacing.base),

            // ── Info ─────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(product.store, style: AppTextStyles.bodySmall),
                  const SizedBox(height: Spacing.xs),
                  Row(
                    children: [
                      PriceText(
                        price: product.price,
                        oldPrice: product.oldPrice,
                        unit: product.unit,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Actions ──────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onFavoriteTap,
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                GestureDetector(
                  onTap: onAddTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(Spacing.sm),
                    ),
                    child: Text(
                      addToCartLabel,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
