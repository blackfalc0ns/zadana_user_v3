import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/home_product_favorites_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';

class RecommendedProductCard extends StatefulWidget {
  const RecommendedProductCard({
    super.key,
    required this.product,
    required this.heroTag,
    this.cardWidth,
    this.minHeight,
    this.onTap,
    this.onAddTap,
    this.onFavoriteTap,
  });

  final ProductModel product;
  final String heroTag;
  final double? cardWidth;
  final double? minHeight;
  final VoidCallback? onTap;
  final Future<void> Function()? onAddTap;
  final Future<void> Function()? onFavoriteTap;

  @override
  State<RecommendedProductCard> createState() => _RecommendedProductCardState();
}

class _RecommendedProductCardState extends State<RecommendedProductCard> {
  late bool _isFavorite;
  bool _isSubmittingFavorite = false;
  bool _isSubmittingCart = false;

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
    final resolvedCardWidth =
        widget.cardWidth ??
        (MediaQuery.sizeOf(context).width / 2.2).clamp(140.0, 200.0).toDouble();
    final resolvedMinHeight = widget.minHeight ?? 78.0;
    final isLargeCard = resolvedCardWidth >= 220 || resolvedMinHeight >= 90;
    final imageSize = isLargeCard ? 68.0 : 58.0;
    final titleFontSize = isLargeCard ? 13.5 : 12.5;
    final actionPadding = isLargeCard ? 8.0 : 7.0;
    final actionIconSize = isLargeCard ? 15.0 : 14.0;
    final favoriteSize = isLargeCard ? 32.0 : 30.0;
    final favoriteIconSize = isLargeCard ? 17.0 : 16.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            width: resolvedCardWidth,
            constraints: BoxConstraints(minHeight: resolvedMinHeight),
            padding: const EdgeInsets.all(Spacing.xs),
            decoration: BoxDecoration(
              color: color.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              border: Border.all(color: color.outlineVariant),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.cardRadius),
                  child: ProductImage(
                    emoji: widget.product.emoji,
                    url: widget.product.imageUrl,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.contain,
                    heroTag: widget.heroTag,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          color: color.onSurface,
                          fontSize: titleFontSize,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: PriceText(
                              price: widget.product.price,
                              oldPrice: widget.product.oldPrice,
                              compact: true,
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          GestureDetector(
                            onTap: _handleAddTap,
                            child: Container(
                              padding: EdgeInsets.all(actionPadding),
                              decoration: BoxDecoration(
                                color: color.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: _isSubmittingCart
                                    ? SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.8,
                                          color: color.onPrimary,
                                        ),
                                      )
                                    : FaIcon(
                                        FontAwesomeIcons.cartPlus,
                                        color: color.onPrimary,
                                        size: actionIconSize,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 2,
            start: 2,
            child: GestureDetector(
              onTap: _handleFavoriteTap,
              child: Container(
                width: favoriteSize,
                height: favoriteSize,
                decoration: BoxDecoration(
                  color: color.surface.withValues(alpha: .6),
                  shape: BoxShape.circle,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: color.shadow.withValues(alpha: 0.12),
                  //     blurRadius: 2,
                  //   ),
                  // ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _isSubmittingFavorite
                      ? Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              color: color.error,
                            ),
                          ),
                        )
                      : Icon(
                          _isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: favoriteIconSize,
                          color: _isFavorite
                              ? color.error
                              : color.onSurfaceVariant,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
