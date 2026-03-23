import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
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
  });

  final ProductModel product;
  final VoidCallback? onAddTap;
  final VoidCallback? onCardTap;
  final VoidCallback? onFavoriteTap;
  final bool showFavorite;
  final bool enableHeroAnimation;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final cartSize = isSmallScreen ? 26.0 : 30.0;
    final cartIconSize = isSmallScreen ? 12.0 : 14.0;
    final fontSize = isSmallScreen ? 11.0 : 12.0;
    final padding = isSmallScreen ? 5.0 : 7.0;
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
                SizedBox(
                  height: 75,
                  width: double.infinity,
                  child: ProductImage(
                    emoji: product.emoji,
                    url: product.imageUrl,
                    width: double.infinity,
                    height: 75,
                    borderRadius: Spacing.cardRadius,
                    heroTag: enableHeroAnimation
                        ? productHeroTag(product.id)
                        : null,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      padding,
                      padding * 0.6,
                      padding,
                      padding * 0.8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
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
                        Flexible(
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
            if (showFavorite)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    width: 30,
                    height: 30,
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
                      size: 16,
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
