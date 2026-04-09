import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_chips.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/products_grid.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/search_bar_widget.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/sub_category_chips.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class CategoryContent extends StatelessWidget {
  const CategoryContent({
    super.key,
    required this.categories,
    this.showCategoryChips = true,
    required this.selectedCategory,
    required this.selectedSubCategory,
    this.selectedSubCategoryId,
    required this.selectedSortOption,
    required this.selectedFilters,
    required this.products,
    this.selectedQuantity,
    this.selectedBrand,
    required this.priceRange,
    required this.onCategorySelected,
    required this.onSubCategorySelected,
    required this.onFilterApplied,
    this.subCategories = const [],
    this.isSubCategoriesLoading = false,
    this.emptyStateMessage,
    this.bottomPadding = 120,
    this.activeHeroProductId,
    this.onProductTap,
    this.isLoading = false,
  });

  final List<CategoryEntity> categories;
  final bool showCategoryChips;
  final String selectedCategory;
  final String selectedSubCategory;
  final String? selectedSubCategoryId;
  final String selectedSortOption;
  final List<String> selectedFilters;
  final List<ProductModel> products;
  final String? selectedQuantity;
  final String? selectedBrand;
  final RangeValues priceRange;
  final Function(String) onCategorySelected;
  final Function(CategorySubcategoryItemDto) onSubCategorySelected;
  final Function(Map<String, dynamic>) onFilterApplied;
  final List<CategorySubcategoryItemDto> subCategories;
  final bool isSubCategoriesLoading;
  final String? emptyStateMessage;
  final double bottomPadding;
  final String? activeHeroProductId;
  final Future<void> Function(ProductModel product)? onProductTap;
  final bool isLoading;

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
        if (showCategoryChips)
          CategoryChips(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: onCategorySelected,
            isLoading: isLoading,
          ),
        if (subCategories.isNotEmpty || isSubCategoriesLoading) ...[
          SizedBox(height: showCategoryChips ? Spacing.sm : 0),
          SubCategoryChips(
            subCategories: subCategories,
            selectedSubCategoryId: selectedSubCategoryId,
            onSubCategorySelected: onSubCategorySelected,
            isLoading: isSubCategoriesLoading,
          ),
        ],
        const SizedBox(height: Spacing.sm),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: ProductsGrid(
              products: products,
              subCategory: selectedSubCategory,
              sortOption: selectedSortOption,
              filters: selectedFilters,
              selectedQuantity: selectedQuantity,
              selectedBrand: selectedBrand,
              priceRange: priceRange,
              activeHeroProductId: activeHeroProductId,
              onProductTap: onProductTap,
              isLoading: isLoading,
              emptyStateMessage: emptyStateMessage,
            ),
          ),
        ),
      ],
    );
  }
}
