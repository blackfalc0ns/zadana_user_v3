import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_helpers.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';

class CategoryNavigationHandler {
  const CategoryNavigationHandler(this._navigationService);

  final CategoryNavigationService _navigationService;

  CategoryEntity? get requestedCategory => _navigationService.selectedCategory;

  CategoryEntity? resolveRequestedCategory(List<CategoryEntity> categories) {
    return resolveRequestedCategoryHelper(
      categories,
      _navigationService.selectedCategory,
    );
  }

  ExternalSubCategorySelection? requestedSubCategorySelection() {
    final subCategoryId = _navigationService.selectedSubCategoryId;
    final subCategoryName = _navigationService.selectedSubCategoryName;
    if (!hasRequestedSubCategory(
      subCategoryId: subCategoryId,
      subCategoryName: subCategoryName,
    )) {
      return null;
    }

    return ExternalSubCategorySelection(
      subCategoryId: subCategoryId,
      subCategoryName: subCategoryName,
    );
  }

  CategorySubcategoryItemDto? resolveRequestedSubCategory(
    List<CategorySubcategoryItemDto> subCategories, {
    String? subCategoryId,
    String? subCategoryName,
  }) {
    return resolveRequestedSubCategoryHelper(
      subCategories,
      subCategoryId: subCategoryId,
      subCategoryName: subCategoryName,
    );
  }

  String? resolveTargetCategoryId(
    CategoryState state,
    String? subCategoryId,
  ) {
    return resolveCategoryIdForSubCategory(
      showAllSubCategories: state.showAllSubCategories,
      subCategoryCategoryMap: state.subCategoryCategoryMap,
      selectedCategoryId: state.selectedCategoryId,
      subCategoryId: subCategoryId,
    );
  }

  bool consumeResetToDefault() {
    return _navigationService.consumeResetToDefault();
  }

  void clearSelectedCategory() {
    _navigationService.clearSelectedCategory();
  }
}

class ExternalSubCategorySelection {
  const ExternalSubCategorySelection({
    required this.subCategoryId,
    required this.subCategoryName,
  });

  final String? subCategoryId;
  final String? subCategoryName;
}

CategoryEntity? resolveRequestedCategoryHelper(
  List<CategoryEntity> categories,
  CategoryEntity? requested,
) {
  return resolveRequestedCategory(categories, requested);
}

CategorySubcategoryItemDto? resolveRequestedSubCategoryHelper(
  List<CategorySubcategoryItemDto> subCategories, {
  String? subCategoryId,
  String? subCategoryName,
}) {
  return resolveRequestedSubCategory(
    subCategories,
    subCategoryId: subCategoryId,
    subCategoryName: subCategoryName,
  );
}
