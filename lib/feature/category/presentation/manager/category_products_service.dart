import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/shopping_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_products_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_shopping_products_usecase.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_helpers.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_state.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class CategoryProductsService {
  const CategoryProductsService({
    required GetCategoryProductsUseCase getCategoryProductsUseCase,
    required GetShoppingProductsUseCase getShoppingProductsUseCase,
  }) : _getCategoryProductsUseCase = getCategoryProductsUseCase,
       _getShoppingProductsUseCase = getShoppingProductsUseCase;

  final GetCategoryProductsUseCase _getCategoryProductsUseCase;
  final GetShoppingProductsUseCase _getShoppingProductsUseCase;

  Future<ApiResult<List<ProductModel>>> loadProducts({
    required CategoryState state,
    String? overrideSubCategoryId,
    String? overrideCategoryId,
  }) {
    final subCategoryId = overrideSubCategoryId ?? state.selectedSubCategoryId;

    if (state.isShoppingMode) {
      return _loadShoppingProducts(
        state,
        categoryId: resolveCategoryIdForProducts(
          state: state,
          subCategoryId: subCategoryId,
          overrideCategoryId: overrideCategoryId,
        ),
      );
    }

    if (subCategoryId == null || subCategoryId.isEmpty) {
      return _loadShoppingProducts(
        state,
        categoryId: resolveCategoryIdForProducts(
          state: state,
          subCategoryId: subCategoryId,
          overrideCategoryId: overrideCategoryId,
        ),
      );
    }

    return _loadCategoryProductsBySubCategory(state, subCategoryId);
  }

  String? resolveCategoryIdForProducts({
    required CategoryState state,
    required String? subCategoryId,
    String? overrideCategoryId,
  }) {
    return overrideCategoryId ??
        resolveCategoryIdForSubCategory(
          showAllSubCategories: state.showAllSubCategories,
          subCategoryCategoryMap: state.subCategoryCategoryMap,
          selectedCategoryId: state.selectedCategoryId,
          subCategoryId: subCategoryId,
        ) ??
        state.selectedCategoryId;
  }

  Future<ApiResult<List<ProductModel>>> _loadCategoryProductsBySubCategory(
    CategoryState state,
    String subCategoryId,
  ) {
    return _getCategoryProductsUseCase(
      CategoryProductsRequestEntity(
        subCategoryId: subCategoryId,
        productTypeId: state.selectedProductTypeId,
        partId: state.selectedPartId,
        quantityId: state.selectedQuantityId,
        brandId: state.selectedBrandId,
        minPrice: state.priceRange.start,
        maxPrice: state.priceRange.end,
        sort: state.selectedSortOption.isEmpty ? null : state.selectedSortOption,
      ),
    );
  }

  Future<ApiResult<List<ProductModel>>> _loadShoppingProducts(
    CategoryState state, {
    String? categoryId,
  }) {
    final hasPriceFilter = state.priceRange != state.priceBounds;

    return _getShoppingProductsUseCase(
      ShoppingProductsRequestEntity(
        categoryId: categoryId,
        productTypeId: state.selectedProductTypeId,
        partId: state.selectedPartId,
        quantityId: state.selectedQuantityId,
        brandId: state.selectedBrandId,
        minPrice: hasPriceFilter ? state.priceRange.start : null,
        maxPrice: hasPriceFilter ? state.priceRange.end : null,
        sort: state.selectedSortOption.isEmpty ? null : state.selectedSortOption,
      ),
    );
  }
}
