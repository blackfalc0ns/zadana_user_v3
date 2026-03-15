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
  });

  final String category;
  final String subCategory;
  final String sortOption;
  final List<String> filters;

  @override
  Widget build(BuildContext context) {
    List<ProductModel> products = _getProductsForCategory(
      category,
      subCategory,
    );

    products = _applySorting(products, sortOption);
    products = _applyFilters(products, filters);

    return GridView.builder(
      padding: const EdgeInsets.only(
        top: Spacing.md,
        left: Spacing.md,
        right: Spacing.md,
        bottom: 65,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.86,
        crossAxisSpacing: Spacing.xss,
        mainAxisSpacing: Spacing.xss,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return CustomProductCard(
          product: product,
          onCardTap: () {
            ProductNavigationHelper.navigateToProductDetails(context, product);
          },
          onAddTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إضافة ${product.name} إلى العربة'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          showFavorite: true,
          onFavoriteTap: () {},
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
    switch (sortOption) {
      case 'price_low_high':
        return products..sort((a, b) => a.price.compareTo(b.price));
      case 'price_high_low':
        return products..sort((a, b) => b.price.compareTo(a.price));
      case 'alphabetical':
        return products..sort((a, b) => a.name.compareTo(b.name));
      default:
        return products;
    }
  }

  List<ProductModel> _applyFilters(
    List<ProductModel> products,
    List<String> filters,
  ) {
    if (filters.isEmpty) return products;

    return products.where((product) {
      return filters.every(
        (filter) =>
            product.name.contains(filter) || product.store.contains(filter),
      );
    }).toList();
  }
}
