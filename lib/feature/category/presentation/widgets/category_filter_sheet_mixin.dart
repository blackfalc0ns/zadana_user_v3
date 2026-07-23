import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/category/data/mapper/category_mapper.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_part_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_filter_helpers.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_filter_section.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/reusable_category_screen.dart';

/// Mixin that encapsulates all filter bottom sheet logic for
/// [ReusableCategoryScreen], including temp filter state management,
/// category filter loading, and the sheet presentation.
mixin CategoryFilterSheetMixin
    on State<ReusableCategoryScreen>, CategoryFilterHelpers {
  // ─── Temp filter state ───────────────────────────────────────────────
  late String? tempFilterCategory;
  late String? tempFilterCategoryId;
  late String? tempSubCategoryName;
  late String? tempSubCategoryId;
  late String? tempFilterQuantity;
  late String? tempFilterBrand;
  late String? tempFilterProductType;
  late String? tempFilterPart;
  late String? tempFilterPackageType;
  late String? tempFilterMeasurementUnit;
  late double? tempFilterMeasurementValue;
  late RangeValues tempPriceRange;
  late RangeValues tempPriceBounds;
  late List<CategorySubcategoryItemDto> tempSubCategories;
  late List<CategoryFilterOptionDto> tempQuantityOptions;
  late List<CategoryFilterBrandItemDto> tempBrandOptions;
  late List<CategoryFilterOptionDto> tempProductTypeOptions;
  late List<CategoryFilterPartItemDto> tempPartOptions;

  /// Cached expanded categories list from "show more" loads.
  List<CategoryEntity>? cachedSheetCategories;
  bool cachedHasMoreCategories = true;

  // ─── Reset ───────────────────────────────────────────────────────────

  void resetTempFilters() {
    tempFilterCategory =
        widget.filterSelectedCategory ??
        (widget.showCategoryFilterSection
            ? _resolveParentCategoryName()
            : widget.selectedCategory);
    tempFilterCategoryId = widget.selectedCategoryId;
    tempSubCategoryName = widget.selectedSubCategory.isEmpty
        ? null
        : widget.selectedSubCategory;
    tempSubCategoryId = widget.selectedSubCategoryId;
    tempFilterQuantity = widget.filterSelectedQuantity;
    tempFilterBrand = widget.filterSelectedBrand;
    tempFilterProductType = widget.selectedProductType;
    tempFilterPart = widget.selectedPart;
    tempFilterPackageType = widget.selectedPackageType;
    tempFilterMeasurementUnit = widget.selectedMeasurementUnit;
    tempFilterMeasurementValue = widget.selectedMeasurementValue;
    tempPriceRange = widget.priceRange;
    tempPriceBounds = widget.priceBounds;
    tempSubCategories = List<CategorySubcategoryItemDto>.from(
      widget.subCategories,
    );
    tempQuantityOptions = widget.availableQuantities
        .map((item) => CategoryFilterOptionDto(name: item))
        .toList(growable: false);
    tempBrandOptions = widget.brandItems.isNotEmpty
        ? widget.brandItems
              .where((item) => (item.name?.trim() ?? '').isNotEmpty)
              .toList(growable: false)
        : widget.availableBrands
              .map((item) => CategoryFilterBrandItemDto(name: item))
              .toList(growable: false);
    tempProductTypeOptions = widget.availableProductTypes
        .map((item) => CategoryFilterOptionDto(name: item))
        .toList(growable: false);
    tempPartOptions = widget.availableParts
        .map((item) => CategoryFilterPartItemDto(name: item))
        .toList(growable: false);
  }

  // ─── Helpers ─────────────────────────────────────────────────────────

  String? _resolveParentCategoryName() {
    final subCategoryId = widget.selectedSubCategoryId;
    if (subCategoryId == null || subCategoryId.isEmpty) return null;
    final parentCategoryId =
        widget.subCategoryCategoryMap[subCategoryId] ??
        widget.selectedCategoryId;
    return findCategoryNameById(parentCategoryId, widget.categories);
  }

  String? resolveTempFilterCategoryId() {
    // The bottom sheet can load additional categories that are not in the
    // initially displayed list. Keep the selected ID as the source of truth,
    // otherwise applying a selection from those later rows falls back to the
    // previous category (or null) and the selection is lost when reopening.
    if (tempFilterCategoryId != null && tempFilterCategoryId!.isNotEmpty) {
      return tempFilterCategoryId;
    }

    return findCategoryByName(tempFilterCategory, widget.categories)?.id ??
        widget.selectedCategoryId;
  }

  String? resolveTempFilterCategoryIdFrom(List<CategoryEntity> categories) {
    if (tempFilterCategoryId != null && tempFilterCategoryId!.isNotEmpty) {
      return tempFilterCategoryId;
    }
    if (tempFilterCategory != null && tempFilterCategory!.isNotEmpty) {
      for (final category in categories) {
        if (category.name == tempFilterCategory) return category.id;
      }
    }
    return widget.selectedCategoryId;
  }

  List<String> visibleTempParts() {
    return visibleParts(
      selectedProductType: tempFilterProductType,
      partOptions: tempPartOptions,
      productTypeOptions: tempProductTypeOptions,
    );
  }

  List<CategorySubcategoryItemDto> visibleTempSubCategories() {
    return visibleSubCategories(
      selectedCategoryId: resolveTempFilterCategoryId(),
      subCategories: tempSubCategories,
      subCategoryCategoryMap: widget.subCategoryCategoryMap,
    );
  }

  // ─── Load filters for a category ────────────────────────────────────

  Future<void> loadTempCategoryFilters(
    String? categoryId,
    List<CategoryEntity> categories,
    StateSetter setSheetState,
    bool Function() isSheetActive,
  ) async {
    final category = findCategoryInList(categoryId, categories);

    if (category == null) {
      if (!mounted || !isSheetActive()) return;
      setSheetState(resetTempFilters);
      return;
    }

    setSheetState(() {
      tempSubCategoryName = null;
      tempSubCategoryId = null;
      tempFilterQuantity = null;
      tempFilterBrand = null;
      tempFilterProductType = null;
      tempFilterPart = null;
    });

    // These endpoints are independent. A category can have subcategories even
    // when its optional filter metadata is unavailable, so do not discard a
    // successful subcategory response when the filters request fails.
    final results = await Future.wait<dynamic>([
      _fetchCategoryFilters(category.id),
      _fetchCategorySubcategories(category.id),
    ]);
    if (!mounted || !isSheetActive() || tempFilterCategoryId != category.id) {
      return;
    }

    final filters = results[0] as CategoryFiltersResponseModelDto?;
    final subCategories = results[1] as List<CategorySubcategoryItemDto>?;
    setSheetState(() {
      if (filters != null) {
        _applyTempCategoryFilters(filters, subCategories: subCategories);
        return;
      }

      tempSubCategories = (subCategories ?? const [])
          .where(
            (item) =>
                (item.id ?? '').isNotEmpty &&
                (item.name ?? '').trim().isNotEmpty,
          )
          .toList(growable: false);
      tempQuantityOptions = const [];
      tempBrandOptions = const [];
      tempProductTypeOptions = const [];
      tempPartOptions = const [];
      tempPriceBounds = widget.priceBounds;
      tempPriceRange = widget.priceBounds;
    });
  }

  Future<CategoryFiltersResponseModelDto?> _fetchCategoryFilters(
    String categoryId,
  ) async {
    try {
      return await getIt<ApiServices>().getCategoryFilters(categoryId);
    } catch (_) {
      return null;
    }
  }

  Future<List<CategorySubcategoryItemDto>?> _fetchCategorySubcategories(
    String categoryId,
  ) async {
    try {
      return await getIt<ApiServices>().getCategorySubcategories(categoryId, 5);
    } catch (_) {
      return null;
    }
  }

  void _applyTempCategoryFilters(
    CategoryFiltersResponseModelDto filters, {
    List<CategorySubcategoryItemDto>? subCategories,
  }) {
    tempSubCategories = (subCategories ?? filters.subcategories ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList(growable: false);
    tempQuantityOptions = (filters.quantities ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList(growable: false);
    tempBrandOptions = (filters.brands ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList(growable: false);
    tempProductTypeOptions = (filters.productTypes ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList(growable: false);
    tempPartOptions = (filters.parts ?? const [])
        .where(
          (item) =>
              (item.id ?? '').isNotEmpty && (item.name ?? '').trim().isNotEmpty,
        )
        .toList(growable: false);

    final minPrice = filters.priceRange?.min ?? 0;
    final maxPrice = filters.priceRange?.max ?? minPrice;
    final normalizedMax = maxPrice >= minPrice ? maxPrice : minPrice;
    tempPriceBounds = RangeValues(minPrice, normalizedMax);
    tempPriceRange = tempPriceBounds;
  }

  // ─── Sheet utilities ─────────────────────────────────────────────────

  void showFilterBottomSheet(
    BuildContext context,
    WidgetBuilder sheetBuilder,
    Function(dynamic)? onResult,
    {VoidCallback? onDismissed}
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: sheetBuilder,
    ).then((result) {
      onDismissed?.call();
      if (result != null && onResult != null) {
        onResult(result);
      }
    });
  }

  void scrollSheetTo(ScrollController controller, double offset) {
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

  // ─── Open filter sheet ───────────────────────────────────────────────

  void openFilterBottomSheet(BuildContext context) {
    resetTempFilters();
    final locale = context.localization;
    final sheetScrollController = ScrollController();

    var sheetCategories =
        cachedSheetCategories != null &&
            cachedSheetCategories!.length >= widget.categories.length
        ? List<CategoryEntity>.from(cachedSheetCategories!)
        : List<CategoryEntity>.from(widget.categories);
    var isLoadingMoreCats = false;
    var hasMoreCats = cachedHasMoreCategories;
    var isSheetActive = true;

    final selectedCatId = widget.selectedCategoryId;
    final needsAutoExpand =
        selectedCatId != null &&
        selectedCatId.isNotEmpty &&
        findCategoryInList(selectedCatId, sheetCategories) == null;

    showFilterBottomSheet(
      context,
      (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          if (needsAutoExpand &&
              !isLoadingMoreCats &&
              findCategoryInList(selectedCatId, sheetCategories) == null) {
            isLoadingMoreCats = true;
            Future(() async {
              try {
                final response = await getIt<ApiServices>().getHomeCategories(
                  take: 50,
                );
                if (!mounted || !isSheetActive) return;
                final allCategories = response.toCategoryEntities();
                setSheetState(() {
                  hasMoreCats = allCategories.length > sheetCategories.length;
                  sheetCategories = allCategories;
                  isLoadingMoreCats = false;
                });
                cachedSheetCategories = sheetCategories;
                cachedHasMoreCategories = hasMoreCats;
              } catch (_) {
                if (!mounted || !isSheetActive) return;
                setSheetState(() => isLoadingMoreCats = false);
              }
            });
          }

          return CustomFilterBottomSheet(
            title: locale.filter_title,
            cancelLabel: locale.cancel,
            clearAllLabel: locale.clear_all,
            applyLabel: locale.apply,
            scrollController: sheetScrollController,
            children: [
              CategoryFilterSection(
                showCategorySection: widget.showCategoryFilterSection,
                categories: sheetCategories,
                subCategories: visibleTempSubCategories(),
                quantities: tempQuantityOptions
                    .map((item) => item.name?.trim() ?? '')
                    .where((item) => item.isNotEmpty)
                    .toList(),
                brands: tempBrandOptions
                    .map((item) => item.name?.trim() ?? '')
                    .where((item) => item.isNotEmpty)
                    .toList(growable: false),
                brandItems: tempBrandOptions
                    .where((item) => (item.name?.trim() ?? '').isNotEmpty)
                    .toList(growable: false),
                productTypes: tempProductTypeOptions
                    .map((item) => item.name?.trim() ?? '')
                    .where((item) => item.isNotEmpty)
                    .toList(growable: false),
                parts: visibleTempParts(),
                packageTypes: widget.availablePackageTypes,
                measurementUnits: widget.availableMeasurementUnits,
                measurementValues: widget.availableMeasurementValues,
                measurementOptions: widget.availableMeasurementOptions,
                selectedCategoryId: resolveTempFilterCategoryIdFrom(
                  sheetCategories,
                ),
                selectedSubCategoryId: tempSubCategoryId,
                selectedQuantity: tempFilterQuantity,
                selectedBrand: tempFilterBrand,
                selectedProductType: tempFilterProductType,
                selectedPart: tempFilterPart,
                selectedPackageType: tempFilterPackageType,
                selectedMeasurementUnit: tempFilterMeasurementUnit,
                selectedMeasurementValue: tempFilterMeasurementValue,
                priceRange: tempPriceRange,
                priceBounds: tempPriceBounds,
                onLoadMoreCategories: () async {
                  if (isLoadingMoreCats || !hasMoreCats) return;
                  setSheetState(() => isLoadingMoreCats = true);
                  try {
                    final nextTake = sheetCategories.length + 8;
                    final response = await getIt<ApiServices>()
                        .getHomeCategories(take: nextTake);
                    if (!mounted || !isSheetActive) return;
                    final newItems = response.toCategoryEntities();
                    setSheetState(() {
                      hasMoreCats = newItems.length > sheetCategories.length;
                      sheetCategories = newItems;
                      isLoadingMoreCats = false;
                    });
                    cachedSheetCategories = sheetCategories;
                    cachedHasMoreCategories = hasMoreCats;
                  } catch (_) {
                    if (!mounted || !isSheetActive) return;
                    setSheetState(() => isLoadingMoreCats = false);
                  }
                },
                isLoadingMoreCategories: isLoadingMoreCats,
                hasMoreCategories: hasMoreCats,
                onCategorySelected: (categoryId) async {
                  setSheetState(() {
                    tempFilterCategoryId = categoryId;
                    tempFilterCategory = findCategoryInList(
                      categoryId,
                      sheetCategories,
                    )?.name;
                    tempFilterQuantity = null;
                    tempFilterBrand = null;
                    tempFilterProductType = null;
                    tempFilterPart = null;
                  });
                  await loadTempCategoryFilters(
                    categoryId,
                    sheetCategories,
                    setSheetState,
                    () => isSheetActive,
                  );
                  if (categoryId != null && isSheetActive) {
                    scrollSheetTo(sheetScrollController, 170);
                  }
                },
                onSubCategorySelected: (subCategory) {
                  setSheetState(() {
                    tempSubCategoryId = subCategory?.id;
                    tempSubCategoryName = subCategory?.name;
                    if (subCategory != null && subCategory.id != null) {
                      final parentCategoryId =
                          widget.subCategoryCategoryMap[subCategory.id!];
                      if (parentCategoryId != null &&
                          parentCategoryId.isNotEmpty) {
                        tempFilterCategory = findCategoryNameById(
                          parentCategoryId,
                          widget.categories,
                        );
                      }
                    }
                  });
                },
                onQuantitySelected: (quantity) {
                  setSheetState(() => tempFilterQuantity = quantity);
                  if (quantity != null) {
                    scrollSheetTo(sheetScrollController, 120);
                  }
                },
                onBrandSelected: (brand) =>
                    setSheetState(() => tempFilterBrand = brand),
                onProductTypeSelected: (productType) => setSheetState(() {
                  tempFilterProductType = productType;
                  tempFilterPart = null;
                }),
                onPartSelected: (part) =>
                    setSheetState(() => tempFilterPart = part),
                onPackageTypeSelected: (packageType) =>
                    setSheetState(() => tempFilterPackageType = packageType),
                onMeasurementUnitSelected: (unit) =>
                    setSheetState(() => tempFilterMeasurementUnit = unit),
                onMeasurementValueSelected: (value) =>
                    setSheetState(() => tempFilterMeasurementValue = value),
                onPriceRangeChanged: (values) =>
                    setSheetState(() => tempPriceRange = values),
              ),
            ],
            onApply: () => Navigator.pop(sheetContext, {
              'categoryId': resolveTempFilterCategoryId(),
              'category': tempFilterCategory,
              'subCategoryId': tempSubCategoryId,
              'subCategoryName': tempSubCategoryName,
              'quantity': tempFilterQuantity,
              'brand': tempFilterBrand,
              'productType': tempFilterProductType,
              'part': tempFilterPart,
              'packageType': tempFilterPackageType,
              'measurementUnit': tempFilterMeasurementUnit,
              'measurementValue': tempFilterMeasurementValue,
              'priceRange': tempPriceRange,
            }),
            onClearAll: () {
              setSheetState(() {
                tempFilterCategory = widget.showCategoryFilterSection
                    ? null
                    : widget.selectedCategory;
                tempFilterCategoryId = null;
                tempFilterQuantity = null;
                tempFilterBrand = null;
                tempFilterProductType = null;
                tempFilterPart = null;
                tempFilterPackageType = null;
                tempFilterMeasurementUnit = null;
                tempFilterMeasurementValue = null;
                tempSubCategoryId = null;
                tempSubCategoryName = null;
                tempPriceBounds = widget.priceBounds;
                tempPriceRange = widget.priceBounds;
              });
              widget.onClearAllFilters();
            },
          );
        },
      ),
      (result) => widget.onFilterChanged(result),
      onDismissed: () {
        isSheetActive = false;
        sheetScrollController.dispose();
      },
    );
  }
}
