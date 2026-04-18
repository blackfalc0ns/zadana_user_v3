import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';

sealed class CategoryEvent {
  const CategoryEvent();
}

class CategoryInitializeEvent extends CategoryEvent {
  const CategoryInitializeEvent();
}

class CategorySelectCategoryByNameEvent extends CategoryEvent {
  const CategorySelectCategoryByNameEvent(this.categoryName);

  final String categoryName;
}

class CategorySelectSubCategoryEvent extends CategoryEvent {
  const CategorySelectSubCategoryEvent(this.subCategory);

  final CategorySubcategoryItemDto subCategory;
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

class CategoryRetryEvent extends CategoryEvent {
  const CategoryRetryEvent();
}

class CategorySearchQueryChangedEvent extends CategoryEvent {
  const CategorySearchQueryChangedEvent(this.query);

  final String query;
}

class CategoryCloseSearchUiEvent extends CategoryEvent {
  const CategoryCloseSearchUiEvent();
}

class CategorySyncSearchPresentationEvent extends CategoryEvent {
  const CategorySyncSearchPresentationEvent({
    required this.query,
    required this.isLoading,
    required this.hasItems,
    required this.hasFailure,
  });

  final String query;
  final bool isLoading;
  final bool hasItems;
  final bool hasFailure;
}

class CategoryRefreshSearchSessionEvent extends CategoryEvent {
  const CategoryRefreshSearchSessionEvent();
}

class CategorySetActiveHeroProductEvent extends CategoryEvent {
  const CategorySetActiveHeroProductEvent(this.productId);

  final String? productId;
}
