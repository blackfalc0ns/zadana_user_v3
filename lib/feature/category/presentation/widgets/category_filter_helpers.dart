import 'package:zadana_user_v3/feature/category/data/models/category_filter_option_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filter_part_item_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';

/// Helper utilities for category filter resolution.
mixin CategoryFilterHelpers {
  CategoryEntity? findCategoryByName(
    String? categoryName,
    List<CategoryEntity> categories,
  ) {
    if (categoryName == null || categoryName.isEmpty) return null;
    for (final category in categories) {
      if (category.name == categoryName) return category;
    }
    return null;
  }

  CategoryEntity? findCategoryById(
    String? categoryId,
    List<CategoryEntity> categories,
  ) {
    if (categoryId == null || categoryId.isEmpty) return null;
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  CategoryEntity? findCategoryInList(
    String? categoryId,
    List<CategoryEntity> categories,
  ) {
    return findCategoryById(categoryId, categories);
  }

  String? findCategoryNameById(
    String? categoryId,
    List<CategoryEntity> categories,
  ) {
    return findCategoryById(categoryId, categories)?.name;
  }

  String? findProductTypeIdByName(
    String? productTypeName,
    List<CategoryFilterOptionDto> productTypeOptions,
  ) {
    if (productTypeName == null || productTypeName.isEmpty) return null;
    for (final option in productTypeOptions) {
      if (option.name == productTypeName) return option.id;
    }
    return null;
  }

  List<String> visibleParts({
    required String? selectedProductType,
    required List<CategoryFilterPartItemDto> partOptions,
    required List<CategoryFilterOptionDto> productTypeOptions,
  }) {
    final selectedProductTypeId = findProductTypeIdByName(
      selectedProductType,
      productTypeOptions,
    );

    return partOptions
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

  List<CategorySubcategoryItemDto> visibleSubCategories({
    required String? selectedCategoryId,
    required List<CategorySubcategoryItemDto> subCategories,
    required Map<String, String> subCategoryCategoryMap,
  }) {
    if (selectedCategoryId == null || selectedCategoryId.isEmpty) {
      return subCategories;
    }

    final filtered = subCategories
        .where((item) {
          final subCategoryId = item.id;
          if (subCategoryId == null || subCategoryId.isEmpty) return false;
          return subCategoryCategoryMap[subCategoryId] == selectedCategoryId;
        })
        .toList(growable: false);

    return filtered.isNotEmpty ? filtered : subCategories;
  }
}
