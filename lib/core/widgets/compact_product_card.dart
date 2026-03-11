import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/product_image.dart';

class CompactProductCard extends StatelessWidget {
  const CompactProductCard({
    super.key,
    required this.product,
    this.onAddTap,
    this.onCardTap,
    this.onFavoriteTap,
    this.showFavorite = false,
  });

  final ProductModel product;
  final VoidCallback? onAddTap;
  final VoidCallback? onCardTap;
  final VoidCallback? onFavoriteTap;
  final bool showFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image ────────────────────────────────────────────
                Container(
                  height: 80, // ارتفاع ثابت للصورة
                  width: double.infinity,
                  child: ProductImage(
                    emoji: product.emoji,
                    url: product.imageUrl,
                    width: double.infinity,
                    height: 80,
                    borderRadius: Spacing.cardRadius,
                  ),
                ),

                // ── Info ─────────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.xs,
                      Spacing.xs + 2, // زيادة المسافة من الأعلى
                      Spacing.xs,
                      Spacing.xs,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end, // تغيير إلى end لدفع المحتوى لأسفل
                      children: [
                        // Product name
                        Text(
                          product.name,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontSize: 10,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 2), // تقليل المسافة من 4 إلى 2
                        
                        // Price and cart button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: PriceText(
                                price: product.price,
                                unit: product.unit,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: onAddTap,
                              child: Container(
                                width: 24, // تكبير من 20 إلى 24
                                height: 24, // تكبير من 20 إلى 24
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const FaIcon(
                                  FontAwesomeIcons.cartPlus,
                                  color: AppColors.white,
                                  size: 10, // تكبير من 8 إلى 10
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // ── Favorite Button ──────────────────────────────────
            if (showFavorite)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    width: 22, // تكبير من 18 إلى 22
                    height: 22, // تكبير من 18 إلى 22
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      product.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 11, // تكبير من 9 إلى 11
                      color: product.isFavorite
                          ? AppColors.primary
                          : AppColors.textSecondary,
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