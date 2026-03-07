import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/product_image.dart';

class RecommendedCard extends StatelessWidget {
  const RecommendedCard({super.key, required this.product, this.onTap});

  final ProductModel product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.sizeOf(context).width / 2.4).clamp(
      140.0,
      200.0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Image ─────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(Spacing.sm.toDouble()),
              child: ProductImage(
                emoji: product.emoji,
                url: product.imageUrl,
                width: 48,
                height: 48,
                borderRadius: Spacing.sm.toDouble(),
              ),
            ),

            const SizedBox(width: Spacing.sm),

            // ── Text ──────────────────────────────────────────────
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // ← مش بياخد أكتر من اللازم
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.labelMedium.copyWith(fontSize: 12),
                    maxLines: 1, // ← 1 بدل 2 عشان ميتعداش الـ height
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.store,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
