import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
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
    final cardWidth = (MediaQuery.sizeOf(context).width / 2.2).clamp(
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
            padding: const EdgeInsets.all(Spacing.xs),
            decoration: BoxDecoration(
              color: color.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              border: Border.all(color: color.outlineVariant),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: Spacing.sm),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.cardRadius),
                    child: ProductImage(
                      emoji: widget.product.emoji,
                      url: widget.product.imageUrl,
                      width: 48,
                      height: 48,
                      heroTag: widget.heroTag,
                    ),
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
                        style: AppTextStyles.labelMedium.copyWith(
                          fontSize: 12.5,
                          height: 1.15,
                          color: color.onSurface,
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
                              padding: const EdgeInsets.all(7),
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
                                        size: 14,
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
            top: 4,
            start: 4,
            child: GestureDetector(
              onTap: _handleFavoriteTap,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.surface.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.shadow.withValues(alpha: 0.12),
                      blurRadius: 2,
                    ),
                  ],
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
                          size: 16,
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
