import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_bottom_filter_buttons.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_bottom_sheet.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_content.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_filter_section.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class ReusableCategoryScreen extends StatefulWidget {
  const ReusableCategoryScreen({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.selectedSortOption,
    required this.selectedFilters,
    required this.products,
    this.availableBrands = const [],
    this.availableQuantities = const [],
    this.selectedQuantity,
    this.filterSelectedCategory,
    this.filterSelectedQuantity,
    this.filterSelectedBrand,
    required this.priceRange,
    this.showCategoryFilterSection = true,
    required this.onCategorySelected,
    required this.onSubCategorySelected,
    required this.onFilterApplied,
    required this.onSortChanged,
    required this.onFilterChanged,
    required this.onClearAllFilters,
    required this.sortOptions,
    this.subCategories = const [],
    this.selectedSubCategoryId,
    this.isSubCategoriesLoading = false,
    this.emptyStateMessage,
    required this.hasActiveFilters,
    this.bottomNavHeight = 95.0,
    this.activeHeroProductId,
    this.onProductTap,
    this.isLoading = false,
  });

  final List<CategoryEntity> categories;
  final String selectedCategory;
  final String selectedSubCategory;
  final String selectedSortOption;
  final List<String> selectedFilters;
  final List<ProductModel> products;
  final List<String> availableBrands;
  final List<String> availableQuantities;
  final String? selectedQuantity;
  final String? filterSelectedCategory;
  final String? filterSelectedQuantity;
  final String? filterSelectedBrand;
  final RangeValues priceRange;
  final bool showCategoryFilterSection;
  final Function(String) onCategorySelected;
  final Function(CategorySubcategoryItemDto) onSubCategorySelected;
  final Function(Map<String, dynamic>) onFilterApplied;
  final Function(String?) onSortChanged;
  final Function(Map<String, dynamic>?) onFilterChanged;
  final Function() onClearAllFilters;
  final List<Map<String, dynamic>> sortOptions;
  final List<CategorySubcategoryItemDto> subCategories;
  final String? selectedSubCategoryId;
  final bool isSubCategoriesLoading;
  final String? emptyStateMessage;
  final bool hasActiveFilters;
  final double bottomNavHeight;
  final String? activeHeroProductId;
  final Future<void> Function(ProductModel product)? onProductTap;
  final bool isLoading;

  @override
  State<ReusableCategoryScreen> createState() => _ReusableCategoryScreenState();
}

class _ReusableCategoryScreenState extends State<ReusableCategoryScreen> {
  late String? _tempFilterCategory;
  late String? _tempFilterQuantity;
  late String? _tempFilterBrand;
  late RangeValues _tempPriceRange;

  @override
  void initState() {
    super.initState();
    _resetTempFilters();
  }

  void _resetTempFilters() {
    _tempFilterCategory = widget.filterSelectedCategory ??
        (widget.showCategoryFilterSection ? null : widget.selectedCategory);
    _tempFilterQuantity = widget.filterSelectedQuantity;
    _tempFilterBrand = widget.filterSelectedBrand;
    _tempPriceRange = widget.priceRange;
  }

  void _showBottomSheet(
    BuildContext context,
    WidgetBuilder sheetBuilder,
    Function(dynamic)? onResult,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: sheetBuilder,
    ).then((result) {
      if (result != null && onResult != null) {
        onResult(result);
      }
    });
  }

  void _scrollSheetTo(ScrollController controller, double offset) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;
      final target = (controller.offset + offset).clamp(
        0.0,
        controller.position.maxScrollExtent,
      );
      controller.animateTo(
        target,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: Stack(
          children: [
            CategoryContent(
              categories: widget.categories,
              showCategoryChips: widget.showCategoryFilterSection,
              selectedCategory: widget.selectedCategory,
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
            ),
            if (!widget.isLoading)
              Positioned(
                bottom: widget.bottomNavHeight + 20,
                left: 45,
                right: 45,
                child: CustomBottomFilterButtons(
                  sortLabel: locale.sort_button,
                  filterLabel: locale.filter_button,
                  onSortPressed: () => _showBottomSheet(
                    context,
                    (_) => CustomSortBottomSheet(
                      selectedSortOption: widget.selectedSortOption,
                      sortOptions: widget.sortOptions,
                      title: locale.sort_title,
                      cancelLabel: locale.cancel,
                      applyLabel: locale.apply,
                    ),
                    (result) => widget.onSortChanged(result),
                  ),
                  onFilterPressed: () {
                    _resetTempFilters();
                    final sheetScrollController = ScrollController();
                    _showBottomSheet(
                      context,
                      (sheetContext) => StatefulBuilder(
                        builder: (sheetContext, setSheetState) {
                          return CustomFilterBottomSheet(
                            title: ' تصنيف المنتجات',
                            cancelLabel: locale.cancel,
                            clearAllLabel: 'مسح الكل',
                            applyLabel: locale.apply,
                            scrollController: sheetScrollController,
                            children: [
                              CategoryFilterSection(
                                showCategorySection:
                                    widget.showCategoryFilterSection,
                                categories: widget.categories,
                                quantities: widget.availableQuantities,
                                brands: widget.availableBrands,
                                selectedCategory: _tempFilterCategory,
                                selectedQuantity: _tempFilterQuantity,
                                selectedBrand: _tempFilterBrand,
                                priceRange: _tempPriceRange,
                                onCategorySelected: (category) {
                                  setSheetState(() {
                                    _tempFilterCategory = category;
                                    _tempFilterQuantity = null;
                                    _tempFilterBrand = null;
                                  });
                                  if (category != null) {
                                    _scrollSheetTo(sheetScrollController, 170);
                                  }
                                },
                                onQuantitySelected: (quantity) {
                                  setSheetState(
                                    () => _tempFilterQuantity = quantity,
                                  );
                                  if (quantity != null) {
                                    _scrollSheetTo(sheetScrollController, 120);
                                  }
                                },
                                onBrandSelected: (brand) => setSheetState(
                                  () => _tempFilterBrand = brand,
                                ),
                                onPriceRangeChanged: (values) => setSheetState(
                                  () => _tempPriceRange = values,
                                ),
                              ),
                            ],
                            onApply: () => Navigator.pop(sheetContext, {
                              'category': _tempFilterCategory,
                              'quantity': _tempFilterQuantity,
                              'brand': _tempFilterBrand,
                              'priceRange': _tempPriceRange,
                            }),
                            onClearAll: () {
                              setSheetState(() {
                                _tempFilterCategory = widget.showCategoryFilterSection
                                    ? null
                                    : widget.selectedCategory;
                                _tempFilterQuantity = null;
                                _tempFilterBrand = null;
                                _tempPriceRange = const RangeValues(0, 1000);
                              });
                              widget.onClearAllFilters();
                            },
                          );
                        },
                      ),
                      (result) => widget.onFilterChanged(result),
                    );
                  },
                  hasActiveFilters: widget.hasActiveFilters,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
