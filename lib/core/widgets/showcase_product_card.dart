import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/home_product_favorites_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/core/widgets/discount_badge.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/core/widgets/product_size_summary.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
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
  final Future<void> Function()? onAddTap;
  final Future<void> Function()? onFavoriteTap;

  @override
  State<ShowcaseProductCard> createState() => _ShowcaseProductCardState();
}

class _ShowcaseProductCardState extends State<ShowcaseProductCard> {
  late bool _isFavorite;
  bool _isSubmittingFavorite = false;
  bool _isSubmittingCart = false;

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
      setState(() => _isSubmittingFavorite = true);
      try {
        await widget.onFavoriteTap!.call();
      } finally {
        if (mounted) {
          setState(() => _isSubmittingFavorite = false);
        }
      }
      return;
    }

    setState(() => _isSubmittingFavorite = true);
    final globalCubit = context.read<AppSectionGlobalCubit>();
    final result = _isFavorite
        ? await HomeProductFavoritesHelper.removeProductFromFavorites(
            globalCubit,
            widget.product,
          )
        : await HomeProductFavoritesHelper.addProductToFavorites(
            globalCubit,
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

  Future<void> _handleAddTap() async {
    if (_isSubmittingCart || widget.onAddTap == null) return;

    setState(() => _isSubmittingCart = true);
    try {
      await widget.onAddTap!.call();
    } finally {
      if (mounted) {
        setState(() => _isSubmittingCart = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final discount = widget.product.discountPercentage;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 100,
            padding: const EdgeInsetsDirectional.fromSTEB(4, 6, 8, 6),
            decoration: BoxDecoration(
              color: color.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.primary.withValues(alpha: 0.12)),
            
            ),
            child: Row(
              children: [
                _ProductVisual(
                  emoji: widget.product.emoji,
                  imageUrl: widget.product.imageUrl,
                  heroTag: widget.heroTag,
                  isFavorite: _isFavorite,
                  isLoading: _isSubmittingFavorite,
                  onFavoriteTap: _handleFavoriteTap,
                ),
                const SizedBox(width: 4),
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
                          fontSize: 11,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      ProductSizeSummary(
                        product: widget.product,
                        fontSize: 9,
                        compact: true,
                      ),
                      const SizedBox(height: 4),
                      PriceText(
                        price: widget.product.price,
                        oldPrice: widget.product.oldPrice,
                        compact: true,
                        fontScale: 0.82,
                      ),
                      const SizedBox(height: 5),
                      _AddButton(
                        onTap: _handleAddTap,
                        isLoading: _isSubmittingCart,
                      ),
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
                color: color.error,
                trianglesize: 32,
                cornerRadius: 12,
                fontSize: 8.4,
                shadowColor: color.shadow,
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
    required this.isLoading,
    required this.onFavoriteTap,
  });

  final String? emoji;
  final String imageUrl;
  final String heroTag;
  final bool isFavorite;
  final bool isLoading;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: 62,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: color.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: color.outlineVariant),
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
          PositionedDirectional(
            top: 4,
            end: 4,
            child: _FavoritePill(
              isFavorite: isFavorite,
              isLoading: isLoading,
              onTap: onFavoriteTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritePill extends StatelessWidget {
  const _FavoritePill({
    required this.isFavorite,
    required this.isLoading,
    required this.onTap,
  });

  final bool isFavorite;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: color.surface.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.12),
              blurRadius: 1.5,
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.7,
                      color: color.error,
                    ),
                  ),
                )
              : Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 15,
                  color: isFavorite ? color.error : color.onSurfaceVariant,
                ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap, required this.isLoading});

  final Future<void> Function() onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 22,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.primaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.primary.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: isLoading
                ? SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.6,
                      color: color.primary,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.cartPlus,
                        size: 8,
                        color: color.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.localization.add_button,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: 9,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
