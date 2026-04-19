import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';

CategoryEntity? findCategoryByName(
  List<CategoryEntity> categories,
  String categoryName,
) {
  final normalizedName = categoryName.trim();
  if (normalizedName.isEmpty) {
    return null;
  }

  for (final category in categories) {
    if (category.name == normalizedName) {
      return category;
    }
  }

  return null;
}

CategoryEntity? findCategoryById(
  List<CategoryEntity> categories,
  String categoryId,
) {
  final normalizedId = categoryId.trim();
  if (normalizedId.isEmpty) {
    return null;
  }

  for (final category in categories) {
    if (category.id == normalizedId) {
      return category;
    }
  }

  return null;
}

CategoryEntity? resolveRequestedCategory(
  List<CategoryEntity> categories,
  CategoryEntity? requested,
) {
  if (requested == null) {
    return null;
  }

  for (final category in categories) {
    if (category.id == requested.id || category.name == requested.name) {
      return category;
    }
  }

  return null;
}

CategoryEntity buildFallbackCategory({
  required String id,
  required String name,
}) {
  return CategoryEntity(
    id: id,
    name: name,
    imageAsset: '',
    emoji: name.isNotEmpty ? name[0] : '',
  );
}

bool hasRequestedSubCategory({String? subCategoryId, String? subCategoryName}) {
  return (subCategoryId?.isNotEmpty ?? false) ||
      (subCategoryName?.isNotEmpty ?? false);
}

CategorySubcategoryItemDto? resolveRequestedSubCategory(
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
    if (subCategory.name?.trim().toLowerCase() == normalizedName) {
      return subCategory;
    }
  }

  return null;
}

ShoppingSubCategoriesData buildShoppingSubCategories({
  required List<CategoryEntity> categories,
  required List<CategoryFiltersResponseModelDto> categoryFilters,
}) {
  final items = <CategorySubcategoryItemDto>[];
  final categoryMap = <String, String>{};

  for (var i = 0; i < categoryFilters.length; i++) {
    final categoryId = i < categories.length
        ? categories[i].id
        : (categoryFilters[i].category?.id ?? '');
    if (categoryId.isEmpty) {
      continue;
    }

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

ShoppingSubCategoriesData buildShoppingSubCategoriesFromLists({
  required List<CategoryEntity> categories,
  required List<List<CategorySubcategoryItemDto>> categorySubCategories,
}) {
  final items = <CategorySubcategoryItemDto>[];
  final categoryMap = <String, String>{};

  for (var i = 0; i < categorySubCategories.length; i++) {
    final categoryId = i < categories.length ? categories[i].id : '';
    if (categoryId.isEmpty) {
      continue;
    }

    for (final item in categorySubCategories[i]) {
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

CategoryFiltersResponseModelDto resolveCategoryFilters(
  String categoryId,
  List<CategoryFiltersResponseModelDto> filters,
) {
  return filters.firstWhere(
    (item) => item.category?.id == categoryId,
    orElse: () => filters.first,
  );
}

String? resolveCategoryIdForSubCategory({
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

List<T> validItems<T>(
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
