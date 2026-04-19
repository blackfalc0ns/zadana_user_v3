import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_helpers.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';

class CategoryFiltersService {
  const CategoryFiltersService();

  CategoryFilterSelection fromMap(
    Map<String, dynamic> result, {
    required RangeValues fallbackPriceRange,
  }) {
    return CategoryFilterSelection(
      categoryId: result['categoryId'] as String?,
      categoryName: result['category'] as String?,
      subCategoryId: result['subCategoryId'] as String?,
      subCategoryName: result['subCategoryName'] as String?,
      quantity: result['quantity'] as String?,
      brand: result['brand'] as String?,
      productType: result['productType'] as String?,
      part: result['part'] as String?,
      priceRange: normalizePriceRange(
        result['priceRange'] as RangeValues?,
        fallback: fallbackPriceRange,
      ),
    );
  }

  SelectedSubCategory resolveSubCategorySelection(
    CategoryState state,
    CategorySubcategoryItemDto? subCategory,
  ) {
    final subCategoryId = subCategory?.id;
    final isSameSubCategory = state.selectedSubCategoryId == subCategoryId;

    return SelectedSubCategory(
      id: isSameSubCategory ? null : subCategoryId,
      name: isSameSubCategory ? null : subCategory?.name,
    );
  }

  CategoryFiltersData prepareFilters(
    CategoryFiltersResponseModelDto filters, {
    List<CategorySubcategoryItemDto>? subCategories,
  }) {
    final priceBounds = _priceBounds(filters);

    return CategoryFiltersData(
      subCategories: validItems(
        subCategories ?? filters.subcategories ?? const [],
        idOf: (item) => item.id,
        nameOf: (item) => item.name,
      ),
      quantityOptions: validItems(
        filters.quantities ?? const [],
        idOf: (item) => item.id,
        nameOf: (item) => item.name,
      ),
      brandOptions: validItems(
        filters.brands ?? const [],
        idOf: (item) => item.id,
        nameOf: (item) => item.name,
      ),
      productTypeOptions: validItems(
        filters.productTypes ?? const [],
        idOf: (item) => item.id,
        nameOf: (item) => item.name,
      ),
      partOptions: validItems(
        filters.parts ?? const [],
        idOf: (item) => item.id,
        nameOf: (item) => item.name,
      ),
      sortOptions: (filters.sortOptions ?? const [])
          .map(
            (item) => {
              'value': item.value ?? '',
              'title': item.label ?? '',
              'subtitle': null,
            },
          )
          .where((item) => (item['value'] as String).isNotEmpty)
          .toList(growable: false),
      priceBounds: priceBounds,
    );
  }

  RangeValues normalizePriceRange(
    RangeValues? value, {
    required RangeValues fallback,
  }) {
    if (value == null) {
      return fallback;
    }

    final start = value.start;
    final end = value.end >= start ? value.end : start;
    return RangeValues(start, end);
  }

  RangeValues _priceBounds(CategoryFiltersResponseModelDto filters) {
    final minPrice = filters.priceRange?.min ?? 0;
    final maxPrice = filters.priceRange?.max ?? minPrice;
    final safeMaxPrice = maxPrice >= minPrice ? maxPrice : minPrice;
    return RangeValues(minPrice, safeMaxPrice);
  }
}

class CategoryFilterSelection {
  const CategoryFilterSelection({
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.quantity,
    required this.brand,
    required this.productType,
    required this.part,
    required this.priceRange,
  });

  final String? categoryId;
  final String? categoryName;
  final String? subCategoryId;
  final String? subCategoryName;
  final String? quantity;
  final String? brand;
  final String? productType;
  final String? part;
  final RangeValues priceRange;
}

class SelectedSubCategory {
  const SelectedSubCategory({required this.id, required this.name});

  final String? id;
  final String? name;
}
