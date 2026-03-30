import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_bottom_filter_buttons.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_bottom_sheet.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_content.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_filter_section.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class ReusableCategoryScreen extends StatefulWidget {
  final String selectedCategory;
  final String selectedSubCategory;
  final String selectedSortOption;
  final List<String> selectedFilters;
  final String? selectedQuantity;
  final String? filterSelectedCategory;
  final String? filterSelectedProductType;
  final String? filterSelectedPart;
  final String? filterSelectedQuantity;
  final String? filterSelectedBrand;
  final RangeValues priceRange;
  final bool showCategoryFilterSection;
  final Function(String) onCategorySelected;
  final Function(Map<String, dynamic>) onFilterApplied;
  final Function(String?) onSortChanged;
  final Function(Map<String, dynamic>?) onFilterChanged;
  final Function() onClearAllFilters;
  final List<Map<String, dynamic>> sortOptions;
  final bool hasActiveFilters;
  final double bottomNavHeight;
  final String? activeHeroProductId;
  final Future<void> Function(ProductModel product)? onProductTap;
  final bool isLoading;

  const ReusableCategoryScreen({
    super.key,
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.selectedSortOption,
    required this.selectedFilters,
    this.selectedQuantity,
    this.filterSelectedCategory,
    this.filterSelectedProductType,
    this.filterSelectedPart,
    this.filterSelectedQuantity,
    this.filterSelectedBrand,
    required this.priceRange,
    this.showCategoryFilterSection = true,
    required this.onCategorySelected,
    required this.onFilterApplied,
    required this.onSortChanged,
    required this.onFilterChanged,
    required this.onClearAllFilters,
    required this.sortOptions,
    required this.hasActiveFilters,
    this.bottomNavHeight = 95.0,
    this.activeHeroProductId,
    this.onProductTap,
    this.isLoading = false,
  });

  @override
  State<ReusableCategoryScreen> createState() => _ReusableCategoryScreenState();
}

class _ReusableCategoryScreenState extends State<ReusableCategoryScreen> {
  late String? _tempFilterCategory;
  late String? _tempFilterProductType;
  late String? _tempFilterPart;
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
    _tempFilterProductType = widget.filterSelectedProductType;
    _tempFilterPart = widget.filterSelectedPart;
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
              selectedCategory: widget.selectedCategory,
              selectedSubCategory: widget.selectedSubCategory,
              selectedSortOption: widget.selectedSortOption,
              selectedFilters: widget.selectedFilters,
              selectedQuantity: widget.selectedQuantity,
              selectedProductType: widget.filterSelectedProductType,
              selectedPart: widget.filterSelectedPart,
              selectedBrand: widget.filterSelectedBrand,
              priceRange: widget.priceRange,
              onCategorySelected: widget.onCategorySelected,
              onFilterApplied: widget.onFilterApplied,
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
                              selectedCategory: _tempFilterCategory,
                              selectedProductType: _tempFilterProductType,
                              selectedPart: _tempFilterPart,
                              selectedQuantity: _tempFilterQuantity,
                              selectedBrand: _tempFilterBrand,
                              priceRange: _tempPriceRange,
                              onCategorySelected: (category) {
                                setSheetState(() {
                                  _tempFilterCategory = category;
                                  _tempFilterProductType = null;
                                  _tempFilterPart = null;
                                  _tempFilterQuantity = null;
                                  _tempFilterBrand = null;
                                });
                                if (category != null) {
                                  _scrollSheetTo(sheetScrollController, 170);
                                }
                              },
                              onProductTypeSelected: (type) {
                                setSheetState(() {
                                  _tempFilterProductType = type;
                                  _tempFilterPart = null;
                                });
                                if (type != null) {
                                  _scrollSheetTo(sheetScrollController, 150);
                                }
                              },
                              onPartSelected: (part) {
                                setSheetState(() => _tempFilterPart = part);
                                if (part != null) {
                                  _scrollSheetTo(sheetScrollController, 120);
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
                            'productType': _tempFilterProductType,
                            'part': _tempFilterPart,
                            'quantity': _tempFilterQuantity,
                            'brand': _tempFilterBrand,
                            'priceRange': _tempPriceRange,
                          }),
                          onClearAll: () {
                            setSheetState(() {
                              _tempFilterCategory =
                                  widget.showCategoryFilterSection
                                  ? null
                                  : widget.selectedCategory;
                              _tempFilterProductType = null;
                              _tempFilterPart = null;
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
