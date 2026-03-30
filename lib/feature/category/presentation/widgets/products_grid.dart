import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/shimmer_wrapper.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    required this.category,
    required this.subCategory,
    this.sortOption = '',
    this.filters = const [],
    this.selectedQuantity,
    this.selectedProductType,
    this.selectedPart,
    this.selectedBrand,
    this.priceRange = const RangeValues(0, 1000),
    this.activeHeroProductId,
    this.onProductTap,
    this.isLoading = false,
  });

  final String category;
  final String subCategory;
  final String sortOption;
  final List<String> filters;
  final String? selectedQuantity;
  final String? selectedProductType;
  final String? selectedPart;
  final String? selectedBrand;
  final RangeValues priceRange;
  final String? activeHeroProductId;
  final Future<void> Function(ProductModel product)? onProductTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    List<ProductModel> products = _getProductsForCategory(
      category,
      subCategory,
    );

    products = _applyFilters(
      products,
      filters,
      category: category,
      selectedProductType: selectedProductType,
      selectedPart: selectedPart,
      selectedBrand: selectedBrand,
      priceRange: priceRange,
    );
    products = _applySorting(products, sortOption);

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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: .9,
            crossAxisSpacing: Spacing.xss,
            mainAxisSpacing: Spacing.xss,
          ),
          itemCount: 15,
          itemBuilder: (_, index) => _ProductCardSkeleton(index: index),
        ),
      );
    }

    return GridView.builder(
      key: PageStorageKey<String>('products_grid_${category}_$subCategory'),
      padding: const EdgeInsets.only(
        top: 4,
        left: Spacing.md,
        right: Spacing.md,
        bottom: 85,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: .9,
        //  childAspectRatio,
        crossAxisSpacing: Spacing.xss,
        mainAxisSpacing: Spacing.xss,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = selectedQuantity == null
            ? products[index]
            : products[index].copyWith(unit: selectedQuantity);
        return CustomProductCard(
          discountPercentage: index * 12,
          isDiscounted: index % 2 == 0,
          product: product,
          onCardTap: () {
            if (onProductTap != null) {
              onProductTap!(product);
              return;
            }
            ProductNavigationHelper.navigateToProductDetails(context, product);
          },
          onAddTap: () {},
          showFavorite: true,
          onFavoriteTap: () {},
          enableHeroAnimation: true,
        );
      },
    );
  }

  List<ProductModel> _getProductsForCategory(
    String category,
    String subCategory,
  ) {
    return kCategoryProducts[category] ?? [];
  }

  List<ProductModel> _applySorting(
    List<ProductModel> products,
    String sortOption,
  ) {
    final sortedProducts = List<ProductModel>.from(products);

    switch (sortOption) {
      case 'newest':
        return sortedProducts..sort((a, b) {
          final aId = int.tryParse(a.id) ?? 0;
          final bId = int.tryParse(b.id) ?? 0;
          return bId.compareTo(aId);
        });
      case 'price_low_high':
        return sortedProducts..sort((a, b) => a.price.compareTo(b.price));
      case 'price_high_low':
        return sortedProducts..sort((a, b) => b.price.compareTo(a.price));
      case 'best_selling':
        return sortedProducts..sort((a, b) {
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          final aHasDiscount =
              (a.discount?.isNotEmpty ?? false) || a.oldPrice != null;
          final bHasDiscount =
              (b.discount?.isNotEmpty ?? false) || b.oldPrice != null;
          if (aHasDiscount && !bHasDiscount) return -1;
          if (!aHasDiscount && bHasDiscount) return 1;
          final aRating = a.rating ?? 0;
          final bRating = b.rating ?? 0;
          if (aRating != bRating) return bRating.compareTo(aRating);
          return 0;
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
    required String category,
    required String? selectedProductType,
    required String? selectedPart,
    required String? selectedBrand,
    required RangeValues priceRange,
  }) {
    return products.where((product) {
      if (product.price < priceRange.start || product.price > priceRange.end) {
        return false;
      }

      if (selectedPart != null && !product.name.contains(selectedPart)) {
        return false;
      }

      if (selectedBrand != null && product.store != selectedBrand) {
        return false;
      }

      if (selectedProductType != null) {
        final matchingParts =
            kProductParts[category]?[selectedProductType] ?? const <String>[];

        if (matchingParts.isNotEmpty) {
          final matchesType = matchingParts.any(product.name.contains);
          if (!matchesType) {
            return false;
          }
        } else if (!product.name.contains(selectedProductType)) {
          return false;
        }
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
