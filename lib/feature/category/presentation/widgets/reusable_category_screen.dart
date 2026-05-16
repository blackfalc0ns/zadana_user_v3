import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/utils/product_sort_options.dart';
import 'package:zadana_user_v3/core/widgets/custom_bottom_filter_buttons.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_measurement_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_content.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_filter_helpers.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_filter_sheet_mixin.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class ReusableCategoryScreen extends StatefulWidget {
  const ReusableCategoryScreen({
    super.key,
    required this.categories,
    required this.selectedCategory,
    this.selectedCategoryId,
    required this.selectedSubCategory,
    required this.selectedSortOption,
    required this.selectedFilters,
    required this.products,
    this.availableBrands = const [],
    this.brandItems = const [],
    this.availableQuantities = const [],
    this.availableProductTypes = const [],
    this.availableParts = const [],
    this.availablePackageTypes = const [],
    this.availableMeasurementUnits = const [],
    this.availableMeasurementValues = const [],
    this.availableMeasurementOptions = const [],
    this.selectedQuantity,
    this.selectedProductType,
    this.selectedPart,
    this.selectedPackageType,
    this.selectedMeasurementUnit,
    this.selectedMeasurementValue,
    this.filterSelectedCategory,
    this.filterSelectedQuantity,
    this.filterSelectedBrand,
    required this.priceRange,
    required this.priceBounds,
    this.showCategoryFilterSection = true,
    required this.onCategorySelected,
    required this.onSubCategorySelected,
    required this.onFilterApplied,
    required this.onSortChanged,
    required this.onFilterChanged,
    required this.onClearAllFilters,
    required this.sortOptions,
    this.subCategories = const [],
    this.subCategoryCategoryMap = const {},
    this.selectedSubCategoryId,
    this.isSubCategoriesLoading = false,
    this.emptyStateMessage,
    required this.hasActiveFilters,
    this.bottomNavHeight = 95.0,
    this.activeHeroProductId,
    this.onProductTap,
    this.isLoading = false,
    this.errorFailure,
    this.onRetryError,
    this.onSearchTap,
    this.isSearchActive = false,
    this.showSearchResults = false,
    this.searchController,
    this.searchFocusNode,
    this.onSearchChanged,
    this.onSearchClose,
    this.searchResults,
    this.onSearchActionTap,
    this.searchActionIcon = Icons.tune_rounded,
    this.searchActionTooltip,
    this.isSearchActionDestructive = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.onLoadMore,
    this.onLoadMoreCategories,
    this.isLoadingMoreCategories = false,
    this.hasMoreCategories = true,
    this.isLoadingMoreSubCategories = false,
    this.hasMoreSubCategories = false,
    this.onLoadMoreSubCategories,
  });

  final List<CategoryEntity> categories;
  final String selectedCategory;
  final String? selectedCategoryId;
  final String selectedSubCategory;
  final String selectedSortOption;
  final List<String> selectedFilters;
  final List<ProductModel> products;
  final List<String> availableBrands;
  final List<CategoryFilterBrandItemDto> brandItems;
  final List<String> availableQuantities;
  final List<String> availableProductTypes;
  final List<String> availableParts;
  final List<String> availablePackageTypes;
  final List<String> availableMeasurementUnits;
  final List<double> availableMeasurementValues;
  final List<CategoryMeasurementOptionDto> availableMeasurementOptions;
  final String? selectedQuantity;
  final String? selectedProductType;
  final String? selectedPart;
  final String? selectedPackageType;
  final String? selectedMeasurementUnit;
  final double? selectedMeasurementValue;
  final String? filterSelectedCategory;
  final String? filterSelectedQuantity;
  final String? filterSelectedBrand;
  final RangeValues priceRange;
  final RangeValues priceBounds;
  final bool showCategoryFilterSection;
  final Function(String) onCategorySelected;
  final Function(CategorySubcategoryItemDto) onSubCategorySelected;
  final Function(Map<String, dynamic>) onFilterApplied;
  final Function(String?) onSortChanged;
  final Function(Map<String, dynamic>?) onFilterChanged;
  final Function() onClearAllFilters;
  final List<Map<String, dynamic>> sortOptions;
  final List<CategorySubcategoryItemDto> subCategories;
  final Map<String, String> subCategoryCategoryMap;
  final String? selectedSubCategoryId;
  final bool isSubCategoriesLoading;
  final String? emptyStateMessage;
  final bool hasActiveFilters;
  final double bottomNavHeight;
  final String? activeHeroProductId;
  final Future<void> Function(ProductModel product)? onProductTap;
  final bool isLoading;
  final Failure? errorFailure;
  final VoidCallback? onRetryError;
  final VoidCallback? onSearchTap;
  final bool isSearchActive;
  final bool showSearchResults;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchClose;
  final Widget? searchResults;
  final VoidCallback? onSearchActionTap;
  final IconData searchActionIcon;
  final String? searchActionTooltip;
  final bool isSearchActionDestructive;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final VoidCallback? onLoadMoreCategories;
  final bool isLoadingMoreCategories;
  final bool hasMoreCategories;
  final bool isLoadingMoreSubCategories;
  final bool hasMoreSubCategories;
  final VoidCallback? onLoadMoreSubCategories;

  @override
  State<ReusableCategoryScreen> createState() => _ReusableCategoryScreenState();
}

class _ReusableCategoryScreenState extends State<ReusableCategoryScreen>
    with CategoryFilterHelpers, CategoryFilterSheetMixin {
  @override
  void initState() {
    super.initState();
    resetTempFilters();
  }

  @override
  void didUpdateWidget(covariant ReusableCategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory ||
        widget.filterSelectedCategory != oldWidget.filterSelectedCategory ||
        widget.filterSelectedQuantity != oldWidget.filterSelectedQuantity ||
        widget.filterSelectedBrand != oldWidget.filterSelectedBrand ||
        widget.selectedProductType != oldWidget.selectedProductType ||
        widget.selectedPart != oldWidget.selectedPart ||
        widget.selectedSubCategory != oldWidget.selectedSubCategory ||
        widget.selectedSubCategoryId != oldWidget.selectedSubCategoryId ||
        widget.subCategories != oldWidget.subCategories ||
        widget.priceRange != oldWidget.priceRange ||
        widget.priceBounds != oldWidget.priceBounds ||
        widget.availableQuantities != oldWidget.availableQuantities ||
        widget.availableBrands != oldWidget.availableBrands ||
        widget.availableProductTypes != oldWidget.availableProductTypes ||
        widget.availableParts != oldWidget.availableParts) {
      resetTempFilters();
    }
  }

  List<Map<String, dynamic>> _effectiveSortOptions(BuildContext context) {
    return resolveProductSortOptions(
      context.localization,
      rawOptions: widget.sortOptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final effectiveSortOptions = _effectiveSortOptions(context);

    return Scaffold(
      backgroundColor: color.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            CategoryContent(
              categories: widget.categories,
              showCategoryChips: false,
              isSearchActive: widget.isSearchActive,
              showSearchResults: widget.showSearchResults,
              selectedCategory: widget.selectedCategory,
              selectedCategoryId: widget.selectedCategoryId,
              selectedSubCategory: widget.selectedSubCategory,
              selectedSubCategoryId: widget.selectedSubCategoryId,
              selectedSortOption: widget.selectedSortOption,
              selectedFilters: widget.selectedFilters,
              products: widget.products,
              selectedQuantity: widget.selectedQuantity,
              selectedBrand: widget.filterSelectedBrand,
              priceRange: widget.priceRange,
              onCategorySelected: widget.onCategorySelected,
              onSubCategorySelected: widget.onSubCategorySelected,
              onFilterApplied: widget.onFilterApplied,
              subCategories: widget.subCategories,
              isSubCategoriesLoading: widget.isSubCategoriesLoading,
              emptyStateMessage: widget.emptyStateMessage,
              bottomPadding: 30,
              activeHeroProductId: widget.activeHeroProductId,
              onProductTap: widget.onProductTap,
              isLoading: widget.isLoading,
              errorFailure: widget.errorFailure,
              onRetryError: widget.onRetryError,
              onSearchTap: widget.onSearchTap,
              searchController: widget.searchController,
              searchFocusNode: widget.searchFocusNode,
              onSearchChanged: widget.onSearchChanged,
              onSearchClose: widget.onSearchClose,
              searchResults: widget.searchResults,
              onSearchActionTap:
                  widget.onSearchActionTap ??
                  () => openFilterBottomSheet(context),
              searchActionIcon: widget.searchActionIcon,
              searchActionTooltip:
                  widget.searchActionTooltip ?? locale.filter_button,
              isSearchActionDestructive: widget.isSearchActionDestructive,
              isLoadingMore: widget.isLoadingMore,
              hasMore: widget.hasMore,
              onLoadMore: widget.onLoadMore,
              isLoadingMoreSubCategories: widget.isLoadingMoreSubCategories,
              hasMoreSubCategories: widget.hasMoreSubCategories,
              onLoadMoreSubCategories: widget.onLoadMoreSubCategories,
            ),
            if (!widget.isLoading &&
                !widget.isSearchActive &&
                !widget.showSearchResults)
              Positioned(
                bottom: widget.bottomNavHeight + 20,
                left: 45,
                right: 45,
                child: CustomBottomFilterButtons(
                  sortLabel: locale.sort_button,
                  filterLabel: locale.filter_button,
                  onSortPressed: () => showFilterBottomSheet(
                    context,
                    (_) => CustomSortBottomSheet(
                      selectedSortOption: widget.selectedSortOption,
                      sortOptions: effectiveSortOptions,
                      title: locale.sort_title,
                      cancelLabel: locale.cancel,
                      applyLabel: locale.apply,
                    ),
                    (result) => widget.onSortChanged(result),
                  ),
                  onFilterPressed: () => openFilterBottomSheet(context),
                  hasActiveFilters: widget.hasActiveFilters,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
