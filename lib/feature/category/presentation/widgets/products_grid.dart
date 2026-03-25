import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

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

    return GridView.builder(
      key: PageStorageKey<String>('products_grid_${category}_$subCategory'),
      padding: const EdgeInsets.only(
        top: 4,
        left: Spacing.md,
        right: Spacing.md,
        bottom: 85,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: Spacing.xss,
        mainAxisSpacing: Spacing.xss,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = selectedQuantity == null
            ? products[index]
            : products[index].copyWith(unit: selectedQuantity);
        return CustomProductCard(
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
          enableHeroAnimation: activeHeroProductId == product.id,
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
        // For now, we'll sort by ID (assuming higher ID = newer)
        return sortedProducts..sort((a, b) => b.id.compareTo(a.id));
      case 'price_low_high':
        return sortedProducts..sort((a, b) => a.price.compareTo(b.price));
      case 'price_high_low':
        return sortedProducts..sort((a, b) => b.price.compareTo(a.price));
      case 'best_selling':
        // For now, we'll sort by favorites (assuming favorites = popular)
        return sortedProducts..sort((a, b) {
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          return 0;
        });
      case 'highest_rated':
        // For now, we'll sort by price (assuming higher price = better quality)
        return sortedProducts..sort((a, b) => b.price.compareTo(a.price));
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
