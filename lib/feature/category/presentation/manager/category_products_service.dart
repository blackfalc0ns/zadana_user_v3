import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/paginated_products_entity.dart';
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
        subCategoryId: subCategoryId,
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
        subCategoryId: subCategoryId,
      );
    }

    final categoryId = resolveCategoryIdForProducts(
      state: state,
      subCategoryId: subCategoryId,
      overrideCategoryId: overrideCategoryId,
    );

    return _loadCategoryProductsBySubCategory(
      state,
      categoryId: categoryId ?? state.selectedCategoryId ?? '',
      subCategoryId: subCategoryId,
    );
  }

  Future<ApiResult<PaginatedProductsEntity>> loadProductsPaginated({
    required CategoryState state,
    required int page,
    int perPage = 20,
    String? overrideSubCategoryId,
    String? overrideCategoryId,
  }) {
    final subCategoryId = overrideSubCategoryId ?? state.selectedSubCategoryId;
    final categoryId = resolveCategoryIdForProducts(
      state: state,
      subCategoryId: subCategoryId,
      overrideCategoryId: overrideCategoryId,
    );

    return _loadShoppingProductsPaginated(
      state,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      page: page,
      perPage: perPage,
    );
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
    CategoryState state, {
    required String categoryId,
    required String subCategoryId,
  }) {
    return _getCategoryProductsUseCase(
      CategoryProductsRequestEntity(
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        productTypeId: state.selectedProductTypeId,
        partId: state.selectedPartId,
        quantityId: state.selectedQuantityId,
        brandId: state.selectedBrandId,
        packageTypeId: state.selectedPackageTypeId,
        measurementUnitId: state.selectedMeasurementUnitId,
        measurementValue: state.selectedMeasurementValue,
        minPrice: state.priceRange.start,
        maxPrice: state.priceRange.end,
        sort: state.selectedSortOption.isEmpty
            ? null
            : state.selectedSortOption,
      ),
    );
  }

  Future<ApiResult<List<ProductModel>>> _loadShoppingProducts(
    CategoryState state, {
    String? categoryId,
    String? subCategoryId,
  }) {
    final hasPriceFilter = state.priceRange != state.priceBounds;

    final String? requestCategoryId;
    final String? requestSubCategoryId;

    if (subCategoryId != null && subCategoryId.isNotEmpty) {
      requestCategoryId = categoryId ??
          state.subCategoryCategoryMap[subCategoryId] ??
          state.selectedCategoryId;
      requestSubCategoryId = subCategoryId;
    } else {
      requestCategoryId = categoryId;
      requestSubCategoryId = null;
    }

    return _getShoppingProductsUseCase(
      ShoppingProductsRequestEntity(
        categoryId: requestCategoryId,
        subCategoryId: requestSubCategoryId,
        productTypeId: state.selectedProductTypeId,
        partId: state.selectedPartId,
        quantityId: state.selectedQuantityId,
        brandId: state.selectedBrandId,
        packageTypeId: state.selectedPackageTypeId,
        measurementUnitId: state.selectedMeasurementUnitId,
        measurementValue: state.selectedMeasurementValue,
        minPrice: hasPriceFilter ? state.priceRange.start : null,
        maxPrice: hasPriceFilter ? state.priceRange.end : null,
        sort: state.selectedSortOption.isEmpty
            ? null
            : state.selectedSortOption,
      ),
    );
  }

  Future<ApiResult<PaginatedProductsEntity>> loadProductsForSubCategoryOnly({
    required CategoryState state,
    required int page,
    required String subCategoryId,
    String? categoryId,
    int perPage = 20,
  }) {
    final hasPriceFilter = state.priceRange != state.priceBounds;

    return _getShoppingProductsUseCase.callPaginated(
      ShoppingProductsRequestEntity(
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        minPrice: hasPriceFilter ? state.priceRange.start : null,
        maxPrice: hasPriceFilter ? state.priceRange.end : null,
        page: page,
        perPage: perPage,
      ),
    );
  }

  Future<ApiResult<PaginatedProductsEntity>> _loadShoppingProductsPaginated(
    CategoryState state, {
    String? categoryId,
    String? subCategoryId,
    required int page,
    required int perPage,
  }) {
    final hasPriceFilter = state.priceRange != state.priceBounds;

    final String? requestCategoryId;
    final String? requestSubCategoryId;

    if (subCategoryId != null && subCategoryId.isNotEmpty) {
      requestCategoryId = categoryId ??
          state.subCategoryCategoryMap[subCategoryId] ??
          state.selectedCategoryId;
      requestSubCategoryId = subCategoryId;
    } else {
      requestCategoryId = categoryId;
      requestSubCategoryId = null;
    }

    return _getShoppingProductsUseCase.callPaginated(
      ShoppingProductsRequestEntity(
        categoryId: requestCategoryId,
        subCategoryId: requestSubCategoryId,
        productTypeId: state.selectedProductTypeId,
        partId: state.selectedPartId,
        quantityId: state.selectedQuantityId,
        brandId: state.selectedBrandId,
        packageTypeId: state.selectedPackageTypeId,
        measurementUnitId: state.selectedMeasurementUnitId,
        measurementValue: state.selectedMeasurementValue,
        minPrice: hasPriceFilter ? state.priceRange.start : null,
        maxPrice: hasPriceFilter ? state.priceRange.end : null,
        sort: state.selectedSortOption.isEmpty
            ? null
            : state.selectedSortOption,
        page: page,
        perPage: perPage,
      ),
    );
  }
}
