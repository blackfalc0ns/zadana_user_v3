import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_brand_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_part_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';

class ShoppingSubCategoriesData {
  const ShoppingSubCategoriesData({
    required this.subCategories,
    required this.categoryMap,
  });

  final List<CategorySubcategoryItemDto> subCategories;
  final Map<String, String> categoryMap;
}

class CategoryViewModelFiltersStateData {
  const CategoryViewModelFiltersStateData({
    required this.subCategories,
    required this.quantityOptions,
    required this.brandOptions,
    required this.productTypeOptions,
    required this.partOptions,
    required this.sortOptions,
    required this.priceBounds,
  });

  final List<CategorySubcategoryItemDto> subCategories;
  final List<CategoryFilterOptionDto> quantityOptions;
  final List<CategoryFilterBrandItemDto> brandOptions;
  final List<CategoryFilterOptionDto> productTypeOptions;
  final List<CategoryFilterPartItemDto> partOptions;
  final List<Map<String, dynamic>> sortOptions;
  final RangeValues priceBounds;
}

class CategoryViewModelSupport {
  const CategoryViewModelSupport._();

  static CategoryEntity? resolveRequestedCategory(
    List<CategoryEntity> categories,
    CategoryEntity? requested,
  ) {
    if (requested == null) return null;

    for (final category in categories) {
      if (category.id == requested.id || category.name == requested.name) {
        return category;
      }
    }

    return null;
  }

  static CategorySubcategoryItemDto? resolveRequestedSubCategory(
    List<CategorySubcategoryItemDto> subCategories, {
    String? subCategoryId,
    String? subCategoryName,
  }) {
    final normalizedId = subCategoryId?.trim();
    if (normalizedId != null && normalizedId.isNotEmpty) {
      for (final subCategory in subCategories) {
        if (subCategory.id == normalizedId) {
          return subCategory;
        }
      }
    }

    final normalizedName = subCategoryName?.trim().toLowerCase();
    if (normalizedName == null || normalizedName.isEmpty) {
      return null;
    }

    for (final subCategory in subCategories) {
      final candidateName = subCategory.name?.trim().toLowerCase();
      if (candidateName == normalizedName) {
        return subCategory;
      }
    }

    return null;
  }

  static ShoppingSubCategoriesData buildShoppingSubCategories({
    required List<CategoryEntity> categories,
    required List<CategoryFiltersResponseModelDto> categoryFilters,
  }) {
    final items = <CategorySubcategoryItemDto>[];
    final categoryMap = <String, String>{};

    for (var i = 0; i < categoryFilters.length; i++) {
      final categoryId = i < categories.length
          ? categories[i].id
          : (categoryFilters[i].category?.id ?? '');
      if (categoryId.isEmpty) continue;

      for (final item in categoryFilters[i].subcategories ?? const []) {
        final id = item.id ?? '';
        final name = item.name?.trim() ?? '';
        if (id.isEmpty || name.isEmpty || categoryMap.containsKey(id)) {
          continue;
        }
        items.add(item);
        categoryMap[id] = categoryId;
      }
    }

    return ShoppingSubCategoriesData(
      subCategories: items,
      categoryMap: categoryMap,
    );
  }

  static CategoryEntity? findCategoryByName(
    List<CategoryEntity> categories,
    String categoryName,
  ) {
    final normalizedName = categoryName.trim();
    if (normalizedName.isEmpty) return null;

    for (final category in categories) {
      if (category.name == normalizedName) {
        return category;
      }
    }

    return null;
  }

  static CategoryEntity buildFallbackCategory({
    required String id,
    required String name,
    String emoji = '',
  }) {
    return CategoryEntity(
      id: id,
      name: name,
      imageAsset: '',
      emoji: emoji.isNotEmpty ? emoji : (name.isNotEmpty ? name[0] : ''),
    );
  }

  static bool hasRequestedSubCategory({
    String? subCategoryId,
    String? subCategoryName,
  }) {
    return (subCategoryId?.isNotEmpty ?? false) ||
        (subCategoryName?.isNotEmpty ?? false);
  }

  static CategoryViewModelFiltersStateData resolveFiltersState(
    CategoryFiltersResponseModelDto filters, {
    List<CategorySubcategoryItemDto>? subCategories,
  }) {
    final minPrice = filters.priceRange?.min ?? 0;
    final maxPrice = filters.priceRange?.max ?? minPrice;
    final normalizedMax = maxPrice >= minPrice ? maxPrice : minPrice;

    return CategoryViewModelFiltersStateData(
      subCategories: _validItems(
        subCategories ?? filters.subcategories ?? const [],
        idOf: (item) => item.id,
        nameOf: (item) => item.name,
      ),
      quantityOptions: _validItems(
        filters.quantities ?? const [],
        idOf: (item) => item.id,
        nameOf: (item) => item.name,
      ),
      brandOptions: _validItems(
        filters.brands ?? const [],
        idOf: (item) => item.id,
        nameOf: (item) => item.name,
      ),
      productTypeOptions: _validItems(
        filters.productTypes ?? const [],
        idOf: (item) => item.id,
        nameOf: (item) => item.name,
      ),
      partOptions: _validItems(
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
      priceBounds: RangeValues(minPrice, normalizedMax),
    );
  }

  static String? resolveCategoryIdForSubCategory({
    required bool showAllSubCategories,
    required Map<String, String> subCategoryCategoryMap,
    required String? selectedCategoryId,
    required String? subCategoryId,
  }) {
    if (subCategoryId == null || subCategoryId.isEmpty) {
      return selectedCategoryId;
    }

    return showAllSubCategories
        ? subCategoryCategoryMap[subCategoryId] ?? selectedCategoryId
        : selectedCategoryId;
  }

  static String? findOptionId(
    List<CategoryFilterOptionDto> options,
    String? selectedName,
  ) {
    if (selectedName == null || selectedName.isEmpty) return null;
    return options
        .where((item) => item.name == selectedName)
        .map((item) => item.id)
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);
  }

  static String? findBrandId(
    List<CategoryFilterBrandItemDto> options,
    String? selectedName,
  ) {
    if (selectedName == null || selectedName.isEmpty) return null;
    return options
        .where((item) => item.name == selectedName)
        .map((item) => item.id)
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);
  }

  static String? findPartId(
    List<CategoryFilterPartItemDto> options,
    String? selectedName,
  ) {
    if (selectedName == null || selectedName.isEmpty) return null;
    return options
        .where((item) => item.name == selectedName)
        .map((item) => item.id)
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);
  }

  static List<T> _validItems<T>(
    List<T> items, {
    required String? Function(T item) idOf,
    required String? Function(T item) nameOf,
  }) {
    return items
        .where((item) {
          final id = idOf(item) ?? '';
          final name = nameOf(item)?.trim() ?? '';
          return id.isNotEmpty && name.isNotEmpty;
        })
        .toList(growable: false);
  }
}
