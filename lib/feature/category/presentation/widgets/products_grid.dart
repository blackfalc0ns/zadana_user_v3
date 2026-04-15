import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/base_error_widget.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/core/widgets/skeleton_colors.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart'
    show ShimmerEffect;

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    required this.products,
    required this.subCategory,
    this.sortOption = '',
    this.filters = const [],
    this.selectedQuantity,
    this.selectedBrand,
    this.priceRange = const RangeValues(0, 1000),
    this.activeHeroProductId,
    this.onProductTap,
    this.isLoading = false,
    this.emptyStateMessage,
    this.errorFailure,
    this.onRetryError,
  });

  final List<ProductModel> products;
  final String subCategory;
  final String sortOption;
  final List<String> filters;
  final String? selectedQuantity;
  final String? selectedBrand;
  final RangeValues priceRange;
  final String? activeHeroProductId;
  final Future<void> Function(ProductModel product)? onProductTap;
  final bool isLoading;
  final String? emptyStateMessage;
  final Failure? errorFailure;
  final VoidCallback? onRetryError;

  @override
  Widget build(BuildContext context) {
    final visibleProducts = products;

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = ProductGridLayout.resolve(constraints.maxWidth);

        if (isLoading) {
          return _ProductsGridSkeleton(layout: layout);
        }

        if (visibleProducts.isEmpty) {
          // Show full error widget when we have a Failure object
          if (errorFailure != null) {
            return ApiErrorWidget.fromFailure(
              errorFailure!,
              onRetry: onRetryError,
            );
          }

          // Show BaseErrorWidget for non-error empty states
          final isNoCategories =
              emptyStateMessage != null && emptyStateMessage!.contains('أقسام');

          return BaseErrorWidget(
            icon: isNoCategories
                ? Icons.grid_view_rounded
                : Icons.search_off_rounded,
            title: emptyStateMessage ?? 'لا توجد منتجات',
            description: isNoCategories
                ? 'لم يتم العثور على أي أقسام متاحة في الوقت الحالي. نعمل على إضافة المزيد قريباً.'
                : 'لا تتوفر منتجات في هذا القسم في الوقت الحالي، يمكنك تجربة تغيير فلاتر البحث أو العودة لاحقاً.',
            primaryColor: Theme.of(context).colorScheme.primary,
          );
        }

        return GridView.builder(
          key: PageStorageKey<String>(
            'products_grid_${visibleProducts.length}_$subCategory',
          ),
          padding: const EdgeInsets.only(
            top: 4,
            left: Spacing.md,
            right: Spacing.md,
            bottom: 85,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: layout.crossAxisCount,
            childAspectRatio: layout.childAspectRatio,
            crossAxisSpacing: Spacing.xss,
            mainAxisSpacing: Spacing.xss,
          ),
          itemCount: visibleProducts.length,
          itemBuilder: (context, index) {
            final product = visibleProducts[index];
            final heroTag = productHeroTag(product.id, source: 'category-grid');
            return CustomProductCard(
              discountPercentage: product.discountPercentage,
              isDiscounted: product.isDiscounted,
              product: product,
              heroTag: heroTag,
              onCardTap: () {
                if (onProductTap != null) {
                  onProductTap!(product);
                  return;
                }
                ProductNavigationHelper.navigateToProductDetails(
                  context,
                  product,
                  heroTag: heroTag,
                );
              },
              onAddTap: () =>
                  HomeProductCartHelper.addProductToCart(context, product),
              showFavorite: true,
            );
          },
        );
      },
    );
  }
}

class _ProductsGridSkeleton extends StatelessWidget {
  const _ProductsGridSkeleton({required this.layout});

  final ProductGridLayout layout;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: GridView.builder(
        padding: const EdgeInsets.only(
          top: 4,
          left: Spacing.md,
          right: Spacing.md,
          bottom: 85,
        ),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: layout.crossAxisCount,
          childAspectRatio: layout.childAspectRatio,
          crossAxisSpacing: Spacing.xss,
          mainAxisSpacing: Spacing.xss,
        ),
        itemCount: 15,
        itemBuilder: (_, index) => _ProductCardSkeleton(index: index),
      ),
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final skeletonCardColor = SkeletonColors.card(context);
    final skeletonBorderColor = SkeletonColors.border(context);
    return Container(
      decoration: BoxDecoration(
        color: skeletonCardColor,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: skeletonBorderColor),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Bone(height: 75, radius: Spacing.cardRadius),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7, 7, 7, 3.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bone(
                        width: switch (index % 4) {
                          0 => 72,
                          1 => 64,
                          2 => 78,
                          _ => 68,
                        },
                        height: 12,
                        radius: 999,
                      ),
                      const Spacer(),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Bone(width: 40, height: 10, radius: 999),
                                SizedBox(height: 4),
                                _Bone(width: 32, height: 10, radius: 999),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          _Bone(width: 28, height: 28, radius: 999),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Positioned(
            top: 4,
            right: 4,
            child: _Bone(width: 28, height: 28, radius: 999),
          ),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({this.width, required this.height, required this.radius});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final baseColor = SkeletonColors.base(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
