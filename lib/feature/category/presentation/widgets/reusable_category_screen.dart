import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/widgets/custom_bottom_filter_buttons.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_bottom_sheet.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_part_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
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
    this.availableProductTypes = const [],
    this.availableParts = const [],
    this.selectedQuantity,
    this.selectedProductType,
    this.selectedPart,
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
  });

  final List<CategoryEntity> categories;
  final String selectedCategory;
  final String selectedSubCategory;
  final String selectedSortOption;
  final List<String> selectedFilters;
  final List<ProductModel> products;
  final List<String> availableBrands;
  final List<String> availableQuantities;
  final List<String> availableProductTypes;
  final List<String> availableParts;
  final String? selectedQuantity;
  final String? selectedProductType;
  final String? selectedPart;
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

  @override
  State<ReusableCategoryScreen> createState() => _ReusableCategoryScreenState();
}

class _ReusableCategoryScreenState extends State<ReusableCategoryScreen> {
  late String? _tempFilterCategory;
  late String? _tempSubCategoryName;
  late String? _tempSubCategoryId;
  late String? _tempFilterQuantity;
  late String? _tempFilterBrand;
  late String? _tempFilterProductType;
  late String? _tempFilterPart;
  late RangeValues _tempPriceRange;
  late RangeValues _tempPriceBounds;
  late List<CategorySubcategoryItemDto> _tempSubCategories;
  late List<CategoryFilterOptionDto> _tempQuantityOptions;
  late List<CategoryFilterBrandItemDto> _tempBrandOptions;
  late List<CategoryFilterOptionDto> _tempProductTypeOptions;
  late List<CategoryFilterPartItemDto> _tempPartOptions;

  @override
  void initState() {
    super.initState();
    _resetTempFilters();
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
      _resetTempFilters();
    }
  }

  void _resetTempFilters() {
    _tempFilterCategory =
        widget.filterSelectedCategory ??
        (widget.showCategoryFilterSection ? null : widget.selectedCategory);
    _tempSubCategoryName = widget.selectedSubCategory.isEmpty
        ? null
        : widget.selectedSubCategory;
    _tempSubCategoryId = widget.selectedSubCategoryId;
    _tempFilterQuantity = widget.filterSelectedQuantity;
    _tempFilterBrand = widget.filterSelectedBrand;
    _tempFilterProductType = widget.selectedProductType;
    _tempFilterPart = widget.selectedPart;
    _tempPriceRange = widget.priceRange;
    _tempPriceBounds = widget.priceBounds;
    _tempSubCategories = List<CategorySubcategoryItemDto>.from(
      widget.subCategories,
    );
    _tempQuantityOptions = widget.availableQuantities
        .map((item) => CategoryFilterOptionDto(name: item))
        .toList(growable: false);
    _tempBrandOptions = widget.availableBrands
        .map((item) => CategoryFilterBrandItemDto(name: item))
        .toList(growable: false);
    _tempProductTypeOptions = widget.availableProductTypes
        .map((item) => CategoryFilterOptionDto(name: item))
        .toList(growable: false);
    _tempPartOptions = widget.availableParts
        .map((item) => CategoryFilterPartItemDto(name: item))
        .toList(growable: false);
  }

  CategoryEntity? _findCategoryByName(String? categoryName) {
    if (categoryName == null || categoryName.isEmpty) return null;

    for (final category in widget.categories) {
      if (category.name == categoryName) {
        return category;
      }
    }

    return null;
  }

  String? _findProductTypeIdByName(String? productTypeName) {
    if (productTypeName == null || productTypeName.isEmpty) return null;

    for (final option in _tempProductTypeOptions) {
      if (option.name == productTypeName) {
        return option.id;
      }
    }

    return null;
  }

  List<String> _visibleTempParts() {
    final selectedProductTypeId = _findProductTypeIdByName(_tempFilterProductType);

    return _tempPartOptions
        .where(
          (item) =>
              selectedProductTypeId == null ||
              selectedProductTypeId.isEmpty ||
              item.productTypeId == null ||
              item.productTypeId == selectedProductTypeId,
        )
        .map((item) => item.name?.trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  Future<void> _loadTempCategoryFilters(
    String? categoryName,
    StateSetter setSheetState,
  ) async {
    final category = _findCategoryByName(categoryName);

    if (category == null) {
      setSheetState(_resetTempFilters);
      return;
    }

    setSheetState(() {
      _tempSubCategoryName = null;
      _tempSubCategoryId = null;
      _tempFilterQuantity = null;
      _tempFilterBrand = null;
      _tempFilterProductType = null;
      _tempFilterPart = null;
    });

    try {
      final results = await Future.wait<dynamic>([
        getIt<ApiServices>().getCategoryFilters(category.id),
        getIt<ApiServices>().getCategorySubcategories(category.id),
      ]);
      if (!mounted) return;

      setSheetState(() {
        _applyTempCategoryFilters(
          results[0] as CategoryFiltersResponseModelDto,
          subCategories: results[1] as List<CategorySubcategoryItemDto>,
        );
      });
    } catch (_) {
      if (!mounted) return;
      setSheetState(() {
        _tempSubCategories = const [];
        _tempQuantityOptions = const [];
        _tempBrandOptions = const [];
        _tempProductTypeOptions = const [];
        _tempPartOptions = const [];
        _tempPriceBounds = widget.priceBounds;
        _tempPriceRange = widget.priceBounds;
      });
    }
  }

  void _applyTempCategoryFilters(
    CategoryFiltersResponseModelDto filters, {
    List<CategorySubcategoryItemDto>? subCategories,
  }) {
    _tempSubCategories = (subCategories ?? filters.subcategories ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList(growable: false);
    _tempQuantityOptions = (filters.quantities ?? const [])
        .where((item) => (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty)
        .toList(growable: false);
    _tempBrandOptions = (filters.brands ?? const [])
        .where((item) => (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty)
        .toList(growable: false);
    _tempProductTypeOptions = (filters.productTypes ?? const [])
        .where((item) => (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty)
        .toList(growable: false);
    _tempPartOptions = (filters.parts ?? const [])
        .where((item) => (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty)
        .toList(growable: false);

    final minPrice = filters.priceRange?.min ?? 0;
    final maxPrice = filters.priceRange?.max ?? minPrice;
    final normalizedMax = maxPrice >= minPrice ? maxPrice : minPrice;
    _tempPriceBounds = RangeValues(minPrice, normalizedMax);
    _tempPriceRange = _tempPriceBounds;
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
              showCategoryChips: false,
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
              errorFailure: widget.errorFailure,
              onRetryError: widget.onRetryError,
              onSearchTap: widget.onSearchTap,
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
                            title: 'تصنيف المنتجات',
                            cancelLabel: locale.cancel,
                            clearAllLabel: 'مسح الكل',
                            applyLabel: locale.apply,
                            scrollController: sheetScrollController,
                            children: [
                              CategoryFilterSection(
                                showCategorySection:
                                    widget.showCategoryFilterSection,
                                categories: widget.categories,
                                subCategories: _tempSubCategories,
                                quantities: _tempQuantityOptions
                                    .map((item) => item.name?.trim() ?? '')
                                    .where((item) => item.isNotEmpty)
                                    .toList(),
                                brands: _tempBrandOptions
                                    .map((item) => item.name?.trim() ?? '')
                                    .where((item) => item.isNotEmpty)
                                    .toList(growable: false),
                                productTypes: _tempProductTypeOptions
                                    .map((item) => item.name?.trim() ?? '')
                                    .where((item) => item.isNotEmpty)
                                    .toList(growable: false),
                                parts: _visibleTempParts(),
                                selectedCategory: _tempFilterCategory,
                                selectedSubCategoryId: _tempSubCategoryId,
                                selectedQuantity: _tempFilterQuantity,
                                selectedBrand: _tempFilterBrand,
                                selectedProductType: _tempFilterProductType,
                                selectedPart: _tempFilterPart,
                                priceRange: _tempPriceRange,
                                priceBounds: _tempPriceBounds,
                                onCategorySelected: (category) async {
                                  setSheetState(() {
                                    _tempFilterCategory = category;
                                    _tempFilterQuantity = null;
                                    _tempFilterBrand = null;
                                    _tempFilterProductType = null;
                                    _tempFilterPart = null;
                                  });
                                  await _loadTempCategoryFilters(
                                    category,
                                    setSheetState,
                                  );
                                  if (category != null) {
                                    _scrollSheetTo(sheetScrollController, 170);
                                  }
                                },
                                onSubCategorySelected: (subCategory) {
                                  setSheetState(() {
                                    final isSame =
                                        _tempSubCategoryId == subCategory.id;
                                    _tempSubCategoryId = isSame
                                        ? null
                                        : subCategory.id;
                                    _tempSubCategoryName = isSame
                                        ? null
                                        : subCategory.name;
                                  });
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
                                onProductTypeSelected: (productType) =>
                                    setSheetState(() {
                                      _tempFilterProductType = productType;
                                      _tempFilterPart = null;
                                    }),
                                onPartSelected: (part) =>
                                    setSheetState(() => _tempFilterPart = part),
                                onPriceRangeChanged: (values) => setSheetState(
                                  () => _tempPriceRange = values,
                                ),
                              ),
                            ],
                            onApply: () => Navigator.pop(sheetContext, {
                              'category': _tempFilterCategory,
                              'subCategoryId': _tempSubCategoryId,
                              'subCategoryName': _tempSubCategoryName,
                              'quantity': _tempFilterQuantity,
                              'brand': _tempFilterBrand,
                              'productType': _tempFilterProductType,
                              'part': _tempFilterPart,
                              'priceRange': _tempPriceRange,
                            }),
                            onClearAll: () {
                              setSheetState(() {
                                _tempFilterCategory =
                                    widget.showCategoryFilterSection
                                    ? null
                                    : widget.selectedCategory;
                                _tempFilterQuantity = null;
                                _tempFilterBrand = null;
                                _tempFilterProductType = null;
                                _tempFilterPart = null;
                                _tempSubCategoryId = null;
                                _tempSubCategoryName = null;
                                _tempPriceRange = widget.priceBounds;
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
