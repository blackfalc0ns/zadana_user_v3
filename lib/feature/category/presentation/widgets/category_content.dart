import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_chips.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/products_grid.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/search_bar_widget.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class CategoryContent extends StatelessWidget {
  final String selectedCategory;
  final String selectedSubCategory;
  final String selectedSortOption;
  final List<String> selectedFilters;
  final String? selectedQuantity;
  final String? selectedProductType;
  final String? selectedPart;
  final String? selectedBrand;
  final RangeValues priceRange;
  final Function(String) onCategorySelected;
  final Function(Map<String, dynamic>) onFilterApplied;
  final double bottomPadding;
  final String? activeHeroProductId;
  final Future<void> Function(ProductModel product)? onProductTap;
  final bool isLoading;

  const CategoryContent({
    super.key,
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.selectedSortOption,
    required this.selectedFilters,
    this.selectedQuantity,
    this.selectedProductType,
    this.selectedPart,
    this.selectedBrand,
    required this.priceRange,
    required this.onCategorySelected,
    required this.onFilterApplied,
    this.bottomPadding = 120,
    this.activeHeroProductId,
    this.onProductTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.md),
          color: color.surface,
          child: SearchBarWidget(
            locale: locale,
            onFilterApplied: onFilterApplied,
          ),
        ),
        CategoryChips(
          selectedCategory: selectedCategory,
          onCategorySelected: onCategorySelected,
          isLoading: isLoading,
        ),
        const SizedBox(height: Spacing.sm),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: ProductsGrid(
              category: selectedCategory,
              subCategory: selectedSubCategory,
              sortOption: selectedSortOption,
              filters: selectedFilters,
              selectedQuantity: selectedQuantity,
              selectedProductType: selectedProductType,
              selectedPart: selectedPart,
              selectedBrand: selectedBrand,
              priceRange: priceRange,
              activeHeroProductId: activeHeroProductId,
              onProductTap: onProductTap,
              isLoading: isLoading,
            ),
          ),
        ),
      ],
    );
  }
}
