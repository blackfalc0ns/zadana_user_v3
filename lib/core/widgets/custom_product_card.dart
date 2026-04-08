import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/widgets/discount_badge.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';

class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
    super.key,
    required this.product,
    this.onAddTap,
    this.onCardTap,
    this.onFavoriteTap,
    this.showFavorite = false,
    this.enableHeroAnimation = true,
    required this.isDiscounted,
    required this.discountPercentage,
  });

  final ProductModel product;
  final VoidCallback? onAddTap;
  final VoidCallback? onCardTap;
  final VoidCallback? onFavoriteTap;
  final bool showFavorite;
  final bool enableHeroAnimation;
  final bool isDiscounted;
  final int discountPercentage;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width / 3;
        final cardHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 140.0;
        final scale = (cardWidth / 110).clamp(0.82, 1.12).toDouble();
        final imageHeight = (cardHeight * 0.42).clamp(46.0, 75.0).toDouble();
        final horizontalPadding = (cardWidth * 0.06).clamp(4.0, 8.0).toDouble();
        final verticalPadding = (cardHeight * 0.05).clamp(4.0, 8.0).toDouble();
        final titleFontSize = (12 * scale).clamp(9.5, 12.5).toDouble();
        final cartSize = (30 * scale).clamp(24.0, 32.0).toDouble();
        final cartIconSize = (14 * scale).clamp(10.0, 14.0).toDouble();
        final favoriteSize = (30 * scale).clamp(24.0, 30.0).toDouble();
        final favoriteIconSize = (16 * scale).clamp(12.0, 16.0).toDouble();
        final badgeTriangleSize = (cardWidth * 0.38)
            .clamp(34.0, 45.0)
            .toDouble();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
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
                        SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: ProductImage(
                            emoji: product.emoji,
                            url: product.imageUrl,
                            width: double.infinity,
                            height: imageHeight,
                            borderRadius: Spacing.cardRadius,
                            heroTag: enableHeroAnimation
                                ? productHeroTag(product.id)
                                : null,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              verticalPadding,
                              horizontalPadding,
                              verticalPadding * 0.75,
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: getSemiBoldStyle(color: color.onSurface,
                                      fontFamily: FontConstant.cairo,
                                      fontSize: titleFontSize,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: (cardHeight * 0.025)
                                        .clamp(1.0, 2.0)
                                        .toDouble(),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: PriceText(
                                          price: product.price,
                                          oldPrice: product.oldPrice,
                                          compact: scale < 0.95,
                                          fontScale: scale,
                                        ),
                                      ),
                                      SizedBox(
                                        width: (cardWidth * 0.035)
                                            .clamp(3.0, 6.0)
                                            .toDouble(),
                                      ),
                                      GestureDetector(
                                        onTap: onAddTap,
                                        child: Container(
                                          width: cartSize,
                                          height: cartSize,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            color: AppColors.primary,
                                          ),
                                          child: Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.cartPlus,
                                              color: AppColors.white,
                                              size: cartIconSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (showFavorite)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: onFavoriteTap,
                          child: Container(
                            width: favoriteSize,
                            height: favoriteSize,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 0.5,
                                ),
                              ],
                            ),
                            child: Icon(
                              product.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: favoriteIconSize,
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
            ),
            if (isDiscounted)
              Positioned(
                left: 0,
                top: 0,
                child: DiscountBadge(
                  discountText: '$discountPercentage%',
                  cornerRadius: Spacing.cardRadius,
                  color: AppColors.error,
                  trianglesize: badgeTriangleSize,
                  fontSize: (13 * scale).clamp(9.0, 13.0).toDouble(),
                  shadowColor: color.shadow,
                ),
              ),
          ],
        );
      },
    );
  }
}
