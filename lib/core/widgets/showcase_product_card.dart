import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/utils/home_product_favorites_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/core/widgets/discount_badge.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';

class ShowcaseProductCard extends StatefulWidget {
  const ShowcaseProductCard({
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
  State<ShowcaseProductCard> createState() => _ShowcaseProductCardState();
}

class _ShowcaseProductCardState extends State<ShowcaseProductCard> {
  late bool _isFavorite;
  bool _isSubmittingFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  @override
  void didUpdateWidget(covariant ShowcaseProductCard oldWidget) {
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
    final discount = widget.product.discountPercentage;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 82,
            padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 6, 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                _ProductVisual(
                  emoji: widget.product.emoji,
                  imageUrl: widget.product.imageUrl,
                  heroTag: widget.heroTag,
                  isFavorite: _isFavorite,
                  onFavoriteTap: _handleFavoriteTap,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: 10.4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      PriceText(
                        price: widget.product.price,
                        oldPrice: widget.product.oldPrice,
                        compact: true,
                        fontScale: 0.72,
                      ),
                      const SizedBox(height: 4),
                      _AddButton(onTap: widget.onAddTap),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (discount > 0)
            Positioned(
              top: 0,
              left: 0,
              child: DiscountBadge(
                discountText: '$discount%',
                color: AppColors.error,
                trianglesize: 32,
                cornerRadius: 12,
                fontSize: 8.4,
                shadowColor: AppColors.shadow,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductVisual extends StatelessWidget {
  const _ProductVisual({
    required this.emoji,
    required this.imageUrl,
    required this.heroTag,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final String? emoji;
  final String imageUrl;
  final String heroTag;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: ProductImage(
                  emoji: emoji,
                  url: imageUrl,
                  width: 56,
                  height: 76,
                  borderRadius: 11,
                  fit: BoxFit.contain,
                  whiteBackground: true,
                  heroTag: heroTag,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 4,
            child: _FavoritePill(isFavorite: isFavorite, onTap: onFavoriteTap),
          ),
        ],
      ),
    );
  }
}

class _FavoritePill extends StatelessWidget {
  const _FavoritePill({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.85),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 0.5,
            ),
          ],
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 15,
          color: isFavorite ? AppColors.error : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.cartPlus,
              size: 7.5,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'إضافة',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 8.2,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
