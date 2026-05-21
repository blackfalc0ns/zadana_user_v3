import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/home_product_favorites_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/core/widgets/discount_badge.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/core/widgets/product_size_summary.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
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
  final Future<void> Function()? onAddTap;
  final VoidCallback? onCardTap;
  final Future<void> Function()? onFavoriteTap;
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
  bool _isSubmittingCart = false;

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
    final cardBackground = color.surface;
    final cardBorderColor = color.outlineVariant;
    final titleColor = color.onSurface;
    final favoriteBackground = Color.alphaBlend(
      color.surfaceTint.withValues(alpha: 0.08),
      color.surface,
    );
    final favoriteIconColor = color.onSurfaceVariant;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.sizeOf(context);
        final cardWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width / 3;
        final cardHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 140.0;
        final useTabletLayout = screenSize.shortestSide >= 600;
        final spec = _CardLayoutSpec.resolve(
          cardWidth: cardWidth,
          cardHeight: cardHeight,
          isTablet: useTabletLayout,
        );
        final imageSectionHeight = math.min(
          spec.imageSectionHeight,
          math.max(0.0, cardHeight - spec.minContentHeight),
        );
        final imageHeight = math.min(
          spec.imageHeight,
          math.max(0.0, imageSectionHeight - spec.imageBottomInset),
        );
        final widthScale = (cardWidth / (useTabletLayout ? 150 : 110))
            .clamp(0.82, useTabletLayout ? 1.18 : 1.12)
            .toDouble();
        final heightScale = (cardHeight / (useTabletLayout ? 180 : 145))
            .clamp(0.76, useTabletLayout ? 1.08 : 1.0)
            .toDouble();
        final scale = math.min(widthScale, heightScale);

        return GestureDetector(
          onTap: widget.onCardTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(Spacing.cardRadius),
                  border: Border.all(color: cardBorderColor),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: imageSectionHeight,
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ProductImage(
                              emoji: widget.product.emoji,
                              url: widget.product.imageUrl,
                              width: double.infinity,
                              height: imageHeight,
                              fit: BoxFit.contain,
                              whiteBackground: useTabletLayout,
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
                              spec.horizontalPadding,
                              spec.verticalPadding,
                              spec.horizontalPadding,
                              spec.bottomPadding,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: getSemiBoldStyle(
                                    color: titleColor,
                                    fontFamily: FontConstant.cairo,
                                    fontSize: spec.titleFontSize,
                                  ),
                                  maxLines: widget.product.showPriceOnCard
                                      ? 1
                                      : 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                ProductSizeSummary(
                                  product: widget.product,
                                  fontSize: spec.titleFontSize * 0.82,
                                  compact: true,
                                ),
                                if (widget.product.hasMultipleVariants)
                                  _VariantCountBadge(
                                    count: widget.product.variantCount!,
                                    fontSize: spec.titleFontSize * 0.78,
                                  ),
                                SizedBox(height: spec.contentSpacing),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (widget.product.showPriceOnCard)
                                      Expanded(
                                        child: PriceText(
                                          price: widget.product.price,
                                          oldPrice: widget.product.oldPrice,
                                          compact:
                                              (!useTabletLayout &&
                                                  (scale < 1.04 ||
                                                      cardHeight < 142)) ||
                                              widget.product.oldPrice != null,
                                          fontScale: useTabletLayout
                                              ? (scale * 1.06)
                                              : scale,
                                        ),
                                      )
                                    else
                                      const Spacer(),
                                    SizedBox(width: spec.actionSpacing),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: _handleAddTap,
                                      child: Container(
                                        width: spec.cartSize,
                                        height: spec.cartSize,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            spec.buttonRadius,
                                          ),
                                          color: AppColors.primary,
                                        ),
                                        child: Center(
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 180,
                                            ),
                                            child: _isSubmittingCart
                                                ? SizedBox(
                                                    width:
                                                        spec.cartIconSize + 2,
                                                    height:
                                                        spec.cartIconSize + 2,
                                                    child:
                                                        const CircularProgressIndicator(
                                                          strokeWidth: 1.9,
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                  )
                                                : FaIcon(
                                                    FontAwesomeIcons.cartPlus,
                                                    color: AppColors.white,
                                                    size: spec.cartIconSize,
                                                  ),
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
                          behavior: HitTestBehavior.opaque,
                          onTap: _handleFavoriteTap,
                          child: Container(
                            width: spec.favoriteSize,
                            height: spec.favoriteSize,
                            decoration: BoxDecoration(
                              color: favoriteBackground,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 0.5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: _isSubmittingFavorite
                                    ? SizedBox(
                                        width: spec.favoriteIconSize + 2,
                                        height: spec.favoriteIconSize + 2,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 1.8,
                                          color: AppColors.error,
                                        ),
                                      )
                                    : Icon(
                                        _isFavorite
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        size: spec.favoriteIconSize,
                                        color: _isFavorite
                                            ? AppColors.error
                                            : favoriteIconColor,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.isDiscounted && widget.product.showPriceOnCard)
                Positioned(
                  left: 0,
                  top: 0,
                  child: DiscountBadge(
                    discountText: '${widget.discountPercentage}%',
                    cornerRadius: Spacing.cardRadius,
                    color: AppColors.error,
                    trianglesize: spec.badgeTriangleSize,
                    fontSize: spec.badgeFontSize,
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

class _CardLayoutSpec {
  const _CardLayoutSpec({
    required this.imageHeight,
    required this.imageSectionHeight,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.bottomPadding,
    required this.contentSpacing,
    required this.titleFontSize,
    required this.cartSize,
    required this.cartIconSize,
    required this.favoriteSize,
    required this.favoriteIconSize,
    required this.badgeTriangleSize,
    required this.badgeFontSize,
    required this.actionSpacing,
    required this.buttonRadius,
    required this.minContentHeight,
    required this.imageBottomInset,
  });

  final double imageHeight;
  final double imageSectionHeight;
  final double horizontalPadding;
  final double verticalPadding;
  final double bottomPadding;
  final double contentSpacing;
  final double titleFontSize;
  final double cartSize;
  final double cartIconSize;
  final double favoriteSize;
  final double favoriteIconSize;
  final double badgeTriangleSize;
  final double badgeFontSize;
  final double actionSpacing;
  final double buttonRadius;
  final double minContentHeight;
  final double imageBottomInset;

  static _CardLayoutSpec resolve({
    required double cardWidth,
    required double cardHeight,
    required bool isTablet,
  }) {
    if (isTablet) {
      return _CardLayoutSpec(
        imageHeight: (cardHeight * 0.5).clamp(74.0, 112.0).toDouble(),
        imageSectionHeight: (cardHeight * 0.6).clamp(98.0, 134.0).toDouble(),
        horizontalPadding: (cardWidth * 0.06).clamp(6.0, 10.0).toDouble(),
        verticalPadding: (cardHeight * 0.038).clamp(4.0, 8.0).toDouble(),
        bottomPadding: (cardHeight * 0.03).clamp(4.0, 7.0).toDouble(),
        contentSpacing: (cardHeight * 0.018).clamp(1.0, 3.0).toDouble(),
        titleFontSize: (cardWidth * 0.08).clamp(10.5, 14.0).toDouble(),
        cartSize: (cardWidth * 0.22).clamp(28.0, 34.0).toDouble(),
        cartIconSize: (cardWidth * 0.092).clamp(12.0, 15.0).toDouble(),
        favoriteSize: (cardWidth * 0.22).clamp(28.0, 34.0).toDouble(),
        favoriteIconSize: (cardWidth * 0.105).clamp(14.0, 18.0).toDouble(),
        badgeTriangleSize: (cardWidth * 0.34).clamp(40.0, 52.0).toDouble(),
        badgeFontSize: (cardWidth * 0.07).clamp(10.0, 14.0).toDouble(),
        actionSpacing: (cardWidth * 0.04).clamp(5.0, 8.0).toDouble(),
        buttonRadius: 8.0,
        minContentHeight: 74.0,
        imageBottomInset: 8.0,
      );
    }

    return _CardLayoutSpec(
      imageHeight: (cardHeight * 0.38).clamp(44.0, 66.0).toDouble(),
      imageSectionHeight: (cardHeight * 0.46).clamp(54.0, 80.0).toDouble(),
      horizontalPadding: (cardWidth * 0.06).clamp(4.0, 8.0).toDouble(),
      verticalPadding: (cardHeight * 0.042).clamp(3.0, 6.0).toDouble(),
      bottomPadding: (cardHeight * 0.02).clamp(1.0, 3.0).toDouble(),
      contentSpacing: (cardHeight * 0.01).clamp(0.0, 1.5).toDouble(),
      titleFontSize: (cardWidth * 0.11).clamp(9.0, 12.0).toDouble(),
      cartSize: (cardWidth * 0.24).clamp(20.0, 27.0).toDouble(),
      cartIconSize: (cardWidth * 0.11).clamp(9.0, 12.0).toDouble(),
      favoriteSize: (cardWidth * 0.26).clamp(24.0, 30.0).toDouble(),
      favoriteIconSize: (cardWidth * 0.14).clamp(12.0, 16.0).toDouble(),
      badgeTriangleSize: (cardWidth * 0.38).clamp(34.0, 45.0).toDouble(),
      badgeFontSize: (cardWidth * 0.11).clamp(9.0, 13.0).toDouble(),
      actionSpacing: (cardWidth * 0.035).clamp(3.0, 6.0).toDouble(),
      buttonRadius: 6.0,
      minContentHeight: 60.0,
      imageBottomInset: 6.0,
    );
  }
}

class _VariantCountBadge extends StatelessWidget {
  const _VariantCountBadge({required this.count, required this.fontSize});

  final int count;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        l10n.variant_sizes_count(count),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: fontSize,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
