import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';

sealed class CategoryEvent {
  const CategoryEvent();
}

class CategoryInitializeEvent extends CategoryEvent {
  const CategoryInitializeEvent();
}

class CategorySelectCategoryEvent extends CategoryEvent {
  const CategorySelectCategoryEvent(this.categoryId);

  final String categoryId;
}

class CategorySelectSubCategoryEvent extends CategoryEvent {
  const CategorySelectSubCategoryEvent(this.subCategory);

  final CategorySubcategoryItemDto? subCategory;
}

class CategoryApplySortEvent extends CategoryEvent {
  const CategoryApplySortEvent(this.sortValue);

  final String? sortValue;
}

class CategoryApplyFiltersEvent extends CategoryEvent {
  const CategoryApplyFiltersEvent(this.filters);

  final Map<String, dynamic>? filters;
}

class CategoryClearAllFiltersEvent extends CategoryEvent {
  const CategoryClearAllFiltersEvent();
}

class CategoryResetSelectionEvent extends CategoryEvent {
  const CategoryResetSelectionEvent();
}

class CategoryRetryEvent extends CategoryEvent {
  const CategoryRetryEvent();
}

class CategorySetActiveHeroProductEvent extends CategoryEvent {
  const CategorySetActiveHeroProductEvent(this.productId);

  final String? productId;
}

class CategoryLoadMoreProductsEvent extends CategoryEvent {
  const CategoryLoadMoreProductsEvent();
}

class CategoryLoadMoreCategoriesEvent extends CategoryEvent {
  const CategoryLoadMoreCategoriesEvent();
}

class CategoryLoadMoreSubCategoriesEvent extends CategoryEvent {
  const CategoryLoadMoreSubCategoriesEvent();
}
