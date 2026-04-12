import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/shimmer_wrapper.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

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
    var filteredProducts = _applyFilters(
      products,
      filters,
      selectedQuantity: selectedQuantity,
      selectedBrand: selectedBrand,
      priceRange: priceRange,
    );
    filteredProducts = _applySorting(filteredProducts, sortOption);

    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = ProductGridLayout.resolve(constraints.maxWidth);

        if (isLoading) {
          return ShimmerWrapper(
            isLoading: true,
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

        if (filteredProducts.isEmpty) {
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
            'products_grid_${filteredProducts.length}_$subCategory',
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
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
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
              enableHeroAnimation: true,
            );
          },
        );
      },
    );
  }

  List<ProductModel> _applySorting(
    List<ProductModel> products,
    String sortOption,
  ) {
    final sortedProducts = List<ProductModel>.from(products);

    switch (sortOption) {
      case 'newest':
        return sortedProducts..sort((a, b) => b.id.compareTo(a.id));
      case 'price_low_high':
        return sortedProducts..sort((a, b) => a.price.compareTo(b.price));
      case 'price_high_low':
        return sortedProducts..sort((a, b) => b.price.compareTo(a.price));
      case 'best_selling':
        return sortedProducts..sort((a, b) {
          final aRating = a.rating ?? 0;
          final bRating = b.rating ?? 0;
          return bRating.compareTo(aRating);
        });
      case 'highest_rated':
        return sortedProducts..sort((a, b) {
          final ratingCompare = (b.rating ?? 0).compareTo(a.rating ?? 0);
          if (ratingCompare != 0) return ratingCompare;
          return (b.reviewCount ?? 0).compareTo(a.reviewCount ?? 0);
        });
      case 'alphabetical':
        return sortedProducts..sort((a, b) => a.name.compareTo(b.name));
      default:
        return sortedProducts;
    }
  }

  List<ProductModel> _applyFilters(
    List<ProductModel> products,
    List<String> filters, {
    required String? selectedQuantity,
    required String? selectedBrand,
    required RangeValues priceRange,
  }) {
    return products.where((product) {
      if (product.price < priceRange.start || product.price > priceRange.end) {
        return false;
      }

      if (selectedQuantity != null &&
          (product.unit == null || product.unit != selectedQuantity)) {
        return false;
      }

      if (selectedBrand != null && product.store != selectedBrand) {
        return false;
      }

      if (filters.isEmpty) {
        return true;
      }

      return filters.every(
        (filter) =>
            product.name.contains(filter) || product.store.contains(filter),
      );
    }).toList();
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
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
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

