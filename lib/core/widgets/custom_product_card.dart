import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/home_product_favorites_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/widgets/discount_badge.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';

class CustomProductCard extends StatefulWidget {
  const CustomProductCard({
    super.key,
    required this.product,
    this.onAddTap,
    this.onCardTap,
    this.onFavoriteTap,
    this.showFavorite = false,
    this.enableHeroAnimation = true,
    this.heroTag,
    required this.isDiscounted,
    required this.discountPercentage,
  });

  final ProductModel product;
  final VoidCallback? onAddTap;
  final VoidCallback? onCardTap;
  final VoidCallback? onFavoriteTap;
  final bool showFavorite;
  final bool enableHeroAnimation;
  final String? heroTag;
  final bool isDiscounted;
  final int discountPercentage;

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> {
  late bool _isFavorite;
  bool _isSubmittingFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  @override
  void didUpdateWidget(covariant CustomProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.isFavorite != widget.product.isFavorite) {
      _isFavorite = widget.product.isFavorite;
    }
  }

  Future<void> _handleFavoriteTap() async {
    if (_isSubmittingFavorite) return;

    if (widget.onFavoriteTap != null) {
      widget.onFavoriteTap!.call();
      return;
    }

    setState(() => _isSubmittingFavorite = true);
    final result = _isFavorite
        ? await HomeProductFavoritesHelper.removeProductFromFavorites(
            widget.product,
          )
        : await HomeProductFavoritesHelper.addProductToFavorites(
            widget.product,
          );
    if (!mounted) return;
    if (result.message.isNotEmpty) {
      if (result.isSuccess) {
        CustomSnackbar.showSuccess(context: context, message: result.message);
      } else {
        CustomSnackbar.showError(context: context, message: result.message);
      }
    }
    setState(() {
      _isSubmittingFavorite = false;
      if (result.isSuccess) _isFavorite = !_isFavorite;
    });
  }

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
        final imageHeight = (cardHeight * 0.34).clamp(38.0, 60.0).toDouble();
        final imageSectionHeight = (cardHeight * 0.5)
            .clamp(imageHeight + 14, 84.0)
            .toDouble();
        final horizontalPadding = (cardWidth * 0.06).clamp(4.0, 8.0).toDouble();
        final verticalPadding = (cardHeight * 0.05).clamp(4.0, 7.0).toDouble();
        final contentSpacing = (cardHeight * 0.045).clamp(2.0, 6.0).toDouble();
        final titleFontSize = (12 * scale).clamp(9.5, 12.5).toDouble();
        final cartSize = (28 * scale).clamp(22.0, 28.0).toDouble();
        final cartIconSize = (13 * scale).clamp(10.0, 13.0).toDouble();
        final favoriteSize = (30 * scale).clamp(24.0, 30.0).toDouble();
        final favoriteIconSize = (16 * scale).clamp(12.0, 16.0).toDouble();
        final badgeTriangleSize = (cardWidth * 0.38)
            .clamp(34.0, 45.0)
            .toDouble();

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.onCardTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
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
                          height: imageSectionHeight,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: (imageSectionHeight - imageHeight) * 0.35,
                            ),
                            child: ProductImage(
                              emoji: widget.product.emoji,
                              url: widget.product.imageUrl,
                              width: double.infinity,
                              height: imageHeight,
                              borderRadius: Spacing.cardRadius,
                              heroTag: widget.enableHeroAnimation
                                  ? (widget.heroTag ??
                                        productHeroTag(widget.product.id))
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              verticalPadding,
                              horizontalPadding,
                              verticalPadding * 0.55,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: getSemiBoldStyle(
                                    color: color.onSurface,
                                    fontFamily: FontConstant.cairo,
                                    fontSize: titleFontSize,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: contentSpacing),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: PriceText(
                                        price: widget.product.price,
                                        oldPrice: widget.product.oldPrice,
                                        compact:
                                            scale < 1.02 ||
                                            widget.product.oldPrice != null,
                                        fontScale: scale,
                                      ),
                                    ),
                                    SizedBox(
                                      width: (cardWidth * 0.035)
                                          .clamp(3.0, 6.0)
                                          .toDouble(),
                                    ),
                                    GestureDetector(
                                      onTap: widget.onAddTap,
                                      child: Container(
                                        width: cartSize,
                                        height: cartSize,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
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
                      ],
                    ),
                    if (widget.showFavorite)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: _handleFavoriteTap,
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
                              _isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: favoriteIconSize,
                              color: _isFavorite
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.isDiscounted)
                Positioned(
                  left: 0,
                  top: 0,
                  child: DiscountBadge(
                    discountText: '${widget.discountPercentage}%',
                    cornerRadius: Spacing.cardRadius,
                    color: AppColors.error,
                    trianglesize: badgeTriangleSize,
                    fontSize: (13 * scale).clamp(9.0, 13.0).toDouble(),
                    shadowColor: color.shadow,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

