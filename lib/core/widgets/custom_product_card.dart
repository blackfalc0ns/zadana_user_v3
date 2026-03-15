import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';

class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
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
    // حساب الأحجام بناءً على حجم الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // أحجام responsive
    final cartSize = isSmallScreen ? 26.0 : 30.0; // زيادة من 22-26 إلى 26-30
    final cartIconSize = isSmallScreen
        ? 12.0
        : 14.0; // زيادة من 10-12 إلى 12-14
    final fontSize = isSmallScreen ? 11.0 : 12.0; // زيادة من 9-10 إلى 11-12
    final padding = isSmallScreen ? 5.0 : 7.0; // زيادة من 4-6 إلى 5-7

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
                SizedBox(
                  height: 75, // تقليل من 80 إلى 75
                  width: double.infinity,
                  child: ProductImage(
                    emoji: product.emoji,
                    url: product.imageUrl,
                    width: double.infinity,
                    height: 75, // تقليل من 80 إلى 75
                    borderRadius: Spacing.cardRadius,
                    heroTag: 'product_image_${product.id}',
                  ),
                ),

                // ── Info ─────────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      padding,
                      padding * 0.6,
                      padding,
                      padding * 0.8,
                    ), // تقليل الـ padding العلوي والسفلي
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // تغيير من end إلى spaceBetween
                      children: [
                        // Product name
                        Flexible(
                          // إضافة Flexible للنص
                          child: Text(
                            product.name,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: fontSize,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(
                          height: isSmallScreen ? 1 : 2,
                        ), // تقليل المساحة
                        // Price and cart button
                        Flexible(
                          // إضافة Flexible للـ Row
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: PriceText(price: product.price)),
                              SizedBox(width: isSmallScreen ? 2 : 4),
                              GestureDetector(
                                onTap: onAddTap,
                                child: Container(
                                  width: cartSize,
                                  height: cartSize,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.cartPlus,
                                    color: AppColors.white,
                                    size: cartIconSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                    width: 30, // زيادة من 26 إلى 30
                    height: 30, // زيادة من 26 إلى 30
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.shadow, blurRadius: 0.5),
                      ],
                    ),
                    child: Icon(
                      product.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16, // زيادة من 14 إلى 16
                      color: product.isFavorite
                          ? AppColors.error
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
