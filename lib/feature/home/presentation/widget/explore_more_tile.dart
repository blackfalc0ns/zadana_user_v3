import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/utils/home_product_favorites_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';

class ExploreMoreTile extends StatefulWidget {
  const ExploreMoreTile({
    super.key,
    required this.product,
    required this.addToCartLabel,
    required this.heroTag,
    this.onAddTap,
    this.onFavoriteTap,
    this.onTap,
  });

  final ProductModel product;
  final String addToCartLabel;
  final String heroTag;
  final VoidCallback? onAddTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  @override
  State<ExploreMoreTile> createState() => _ExploreMoreTileState();
}

class _ExploreMoreTileState extends State<ExploreMoreTile> {
  late bool _isFavorite;
  bool _isSubmittingFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  @override
  void didUpdateWidget(covariant ExploreMoreTile oldWidget) {
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
    return GestureDetector(
      onTap: widget.onTap,
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
              emoji: widget.product.emoji,
              url: widget.product.imageUrl,
              width: 72,
              height: 72,
              borderRadius: Spacing.cardRadius,
              heroTag: widget.heroTag,
            ),

            const SizedBox(width: Spacing.base),

            // ── Info ─────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: AppTextStyles.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(widget.product.store, style: AppTextStyles.bodySmall),
                  const SizedBox(height: Spacing.xs),
                  Row(
                    children: [
                      PriceText(
                        price: widget.product.price,
                        oldPrice: widget.product.oldPrice,
                        unit: widget.product.unit,
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
                  onTap: _handleFavoriteTap,
                  child: Icon(
                    _isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                    color: _isFavorite
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                GestureDetector(
                  onTap: widget.onAddTap,
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
                      widget.addToCartLabel,
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
