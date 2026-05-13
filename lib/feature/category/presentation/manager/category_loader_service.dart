import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_categories_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_filters_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_subcategories_usecase.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_helpers.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';

class CategoryLoaderService {
  const CategoryLoaderService({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetCategoryFiltersUseCase getCategoryFiltersUseCase,
    required GetCategorySubcategoriesUseCase getCategorySubcategoriesUseCase,
  }) : _getCategoriesUseCase = getCategoriesUseCase,
       _getCategoryFiltersUseCase = getCategoryFiltersUseCase,
       _getCategorySubcategoriesUseCase = getCategorySubcategoriesUseCase;

  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetCategoryFiltersUseCase _getCategoryFiltersUseCase;
  final GetCategorySubcategoriesUseCase _getCategorySubcategoriesUseCase;

  Future<ApiResult<List<CategoryEntity>>> loadInitialCategories() {
    return _getCategoriesUseCase();
  }

  Future<DefaultShoppingLoadResult> loadDefaultShoppingData() async {
    final result = await _getCategorySubcategoriesUseCase();
    switch (result) {
      case ApiSuccessResult<List<CategorySubcategoryItemDto>>():
        return DefaultShoppingLoadSuccess(
          buildShoppingSubCategoriesFromFlatList(result.data),
        );
      case ApiErrorResult<List<CategorySubcategoryItemDto>>():
        return DefaultShoppingLoadFailure(result.failure);
    }
  }

  Future<CategorySelectionLoadResult> loadCategorySelection({
    required List<CategoryEntity> categories,
    required CategoryEntity category,
    required bool showAllSubCategories,
  }) async {
    if (showAllSubCategories) {
      return _loadCategoryWithAllSubCategories(
        categories: categories,
        category: category,
      );
    }

    return _loadSingleCategorySelection(category);
  }

  Future<CategoryFiltersReloadResult> loadFiltersForCategory({
    required String categoryId,
    required List<CategorySubcategoryItemDto> subCategories,
    required Map<String, String> subCategoryCategoryMap,
  }) async {
    final filtersResult = await _getCategoryFiltersUseCase(categoryId);
    switch (filtersResult) {
      case ApiSuccessResult<CategoryFiltersResponseModelDto>():
        return CategoryFiltersReloadSuccess(
          CategorySelectionData(
            filters: filtersResult.data,
            subCategories: subCategories,
            subCategoryCategoryMap: subCategoryCategoryMap,
          ),
        );
      case ApiErrorResult<CategoryFiltersResponseModelDto>():
        return CategoryFiltersReloadFailure(filtersResult.failure);
    }
  }

  Future<ExternalSubCategoryLoadResult> loadExternalSubCategorySelection({
    required List<CategoryEntity> categories,
    String? subCategoryId,
    String? subCategoryName,
  }) async {
    for (final category in categories) {
      final subCategoriesResult = await _getCategorySubcategoriesUseCase(
        categoryId: category.id,
      );

      if (subCategoriesResult
          case ApiErrorResult<List<CategorySubcategoryItemDto>>()) {
        return ExternalSubCategoryLoadFailure(subCategoriesResult.failure);
      }

      final subCategories =
          (subCategoriesResult
                  as ApiSuccessResult<List<CategorySubcategoryItemDto>>)
              .data;
      final requestedSubCategory = resolveRequestedSubCategory(
        subCategories,
        subCategoryId: subCategoryId,
        subCategoryName: subCategoryName,
      );
      final resolvedSubCategoryId = requestedSubCategory?.id;
      if (resolvedSubCategoryId == null || resolvedSubCategoryId.isEmpty) {
        continue;
      }
      final resolvedSubCategory = requestedSubCategory!;

      final filtersResult = await _getCategoryFiltersUseCase(category.id);
      switch (filtersResult) {
        case ApiSuccessResult<CategoryFiltersResponseModelDto>():
          return ExternalSubCategoryLoadSuccess(
            category: category,
            subCategory: resolvedSubCategory,
            data: CategorySelectionData(
              filters: filtersResult.data,
              subCategories: subCategories,
              subCategoryCategoryMap: {
                for (final item in subCategories)
                  if ((item.id ?? '').isNotEmpty) item.id!: category.id,
              },
            ),
          );
        case ApiErrorResult<CategoryFiltersResponseModelDto>():
          return ExternalSubCategoryLoadFailure(filtersResult.failure);
      }
    }

    return const ExternalSubCategoryNotFound();
  }

  Future<ApiResult<List<CategoryFiltersResponseModelDto>>>
  getFiltersForCategories(List<CategoryEntity> categories) async {
    final results = await Future.wait(
      categories
          .map((item) => _getCategoryFiltersUseCase(item.id))
          .toList(growable: false),
    );

    final filters = <CategoryFiltersResponseModelDto>[];
    for (final result in results) {
      switch (result) {
        case ApiSuccessResult<CategoryFiltersResponseModelDto>():
          filters.add(result.data);
        case ApiErrorResult<CategoryFiltersResponseModelDto>():
          return ApiErrorResult<List<CategoryFiltersResponseModelDto>>(
            failure: result.failure,
          );
      }
    }

    return ApiSuccessResult<List<CategoryFiltersResponseModelDto>>(
      data: filters,
    );
  }

  Future<CategorySelectionLoadResult> _loadCategoryWithAllSubCategories({
    required List<CategoryEntity> categories,
    required CategoryEntity category,
  }) async {
    final filtersResult = await getFiltersForCategories(categories);
    switch (filtersResult) {
      case ApiSuccessResult<List<CategoryFiltersResponseModelDto>>():
        final shoppingData = buildShoppingSubCategories(
          categories: categories,
          categoryFilters: filtersResult.data,
        );

        return CategorySelectionLoadSuccess(
          CategorySelectionData(
            filters: resolveCategoryFilters(category.id, filtersResult.data),
            subCategories: shoppingData.subCategories,
            subCategoryCategoryMap: shoppingData.categoryMap,
          ),
        );
      case ApiErrorResult<List<CategoryFiltersResponseModelDto>>():
        return CategorySelectionLoadFailure(filtersResult.failure);
    }
  }

  Future<CategorySelectionLoadResult> _loadSingleCategorySelection(
    CategoryEntity category,
  ) async {
    final filtersResult = await _getCategoryFiltersUseCase(category.id);
    final subCategoriesResult = await _getCategorySubcategoriesUseCase(
      categoryId: category.id,
    );

    if (filtersResult case ApiErrorResult<CategoryFiltersResponseModelDto>()) {
      return CategorySelectionLoadFailure(filtersResult.failure);
    }

    if (subCategoriesResult
        case ApiErrorResult<List<CategorySubcategoryItemDto>>()) {
      return CategorySelectionLoadFailure(subCategoriesResult.failure);
    }

    final filters =
        (filtersResult as ApiSuccessResult<CategoryFiltersResponseModelDto>)
            .data;
    final subCategories =
        (subCategoriesResult
                as ApiSuccessResult<List<CategorySubcategoryItemDto>>)
            .data;

    return CategorySelectionLoadSuccess(
      CategorySelectionData(
        filters: filters,
        subCategories: subCategories,
        subCategoryCategoryMap: {
          for (final item in subCategories)
            if ((item.id ?? '').isNotEmpty) item.id!: category.id,
        },
      ),
    );
  }
}

class CategorySelectionData {
  const CategorySelectionData({
    required this.filters,
    required this.subCategories,
    required this.subCategoryCategoryMap,
  });

  final CategoryFiltersResponseModelDto filters;
  final List<CategorySubcategoryItemDto> subCategories;
  final Map<String, String> subCategoryCategoryMap;
}

sealed class DefaultShoppingLoadResult {
  const DefaultShoppingLoadResult();
}

class DefaultShoppingLoadSuccess extends DefaultShoppingLoadResult {
  const DefaultShoppingLoadSuccess(this.data);

  final ShoppingSubCategoriesData data;
}

class DefaultShoppingLoadFailure extends DefaultShoppingLoadResult {
  const DefaultShoppingLoadFailure(this.failure);

  final dynamic failure;
}

sealed class CategorySelectionLoadResult {
  const CategorySelectionLoadResult();
}

class CategorySelectionLoadSuccess extends CategorySelectionLoadResult {
  const CategorySelectionLoadSuccess(this.data);

  final CategorySelectionData data;
}

class CategorySelectionLoadFailure extends CategorySelectionLoadResult {
  const CategorySelectionLoadFailure(this.failure);

  final dynamic failure;
}

sealed class CategoryFiltersReloadResult {
  const CategoryFiltersReloadResult();
}

class CategoryFiltersReloadSuccess extends CategoryFiltersReloadResult {
  const CategoryFiltersReloadSuccess(this.data);

  final CategorySelectionData data;
}

class CategoryFiltersReloadFailure extends CategoryFiltersReloadResult {
  const CategoryFiltersReloadFailure(this.failure);

  final dynamic failure;
}

sealed class ExternalSubCategoryLoadResult {
  const ExternalSubCategoryLoadResult();
}

class ExternalSubCategoryLoadSuccess extends ExternalSubCategoryLoadResult {
  const ExternalSubCategoryLoadSuccess({
    required this.category,
    required this.subCategory,
    required this.data,
  });

  final CategoryEntity category;
  final CategorySubcategoryItemDto subCategory;
  final CategorySelectionData data;
}

class ExternalSubCategoryLoadFailure extends ExternalSubCategoryLoadResult {
  const ExternalSubCategoryLoadFailure(this.failure);

  final dynamic failure;
}

class ExternalSubCategoryNotFound extends ExternalSubCategoryLoadResult {
  const ExternalSubCategoryNotFound();
}
