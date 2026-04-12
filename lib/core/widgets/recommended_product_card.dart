import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/utils/home_product_favorites_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';

class RecommendedProductCard extends StatefulWidget {
  const RecommendedProductCard({
    super.key,
    required this.product,
    required this.heroTag,
    this.onTap,
    this.onAddTap,
    this.onFavoriteTap,
  });

  final ProductModel product;
  final String heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onFavoriteTap;

  @override
  State<RecommendedProductCard> createState() => _RecommendedProductCardState();
}

class _RecommendedProductCardState extends State<RecommendedProductCard> {
  late bool _isFavorite;
  bool _isSubmittingFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  @override
  void didUpdateWidget(covariant RecommendedProductCard oldWidget) {
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
    final cardWidth = (MediaQuery.sizeOf(context).width / 2.4).clamp(
      140.0,
      200.0,
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            width: cardWidth,
            constraints: const BoxConstraints(minHeight: 78),
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: Spacing.sm),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.cardRadius),
                    child: ProductImage(
                      emoji: widget.product.emoji,
                      url: widget.product.imageUrl,
                      width: 48,
                      height: 48,
                      borderRadius: Spacing.cardRadius,
                      heroTag: widget.heroTag,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: AppTextStyles.labelMedium.copyWith(
                                fontSize: 12,
                                height: 1.15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: Spacing.xs),
                            PriceText(
                              price: widget.product.price,
                              oldPrice: widget.product.oldPrice,
                              compact: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      GestureDetector(
                        onTap: widget.onAddTap,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.cartPlus,
                            color: AppColors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: _handleFavoriteTap,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(color: AppColors.shadow, blurRadius: 0.5),
                  ],
                ),
                child: Icon(
                  _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 16,
                  color: _isFavorite
                      ? AppColors.error
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
