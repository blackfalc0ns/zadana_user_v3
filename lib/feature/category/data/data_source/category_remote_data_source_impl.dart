import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/category/data/data_source/category_remote_data_source.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_products_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/shopping_products_request_entity.dart';
import 'package:zadana_user_v3/feature/home/data/models/categories/home_categories_response_model_dto.dart';

@Injectable(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  const CategoryRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<HomeCategoriesResponseModelDto> getCategories({int? take}) {
    return _apiServices.getHomeCategories(take: take);
  }

  @override
  Future<CategoryFiltersResponseModelDto> getCategoryFilters(
    String categoryId,
  ) {
    return _apiServices.getCategoryFilters(categoryId);
  }

  @override
  Future<List<CategorySubcategoryItemDto>> getCategorySubcategories(
    String? categoryId, {
    int? limit,
  }) {
    return _apiServices.getCategorySubcategories(categoryId, limit);
  }

  @override
  Future<CategoryProductsResponseModelDto> getCategoryProducts(
    CategoryProductsRequestEntity request,
  ) {
    return _apiServices.getCategoryProducts(
      request.categoryId,
      request.subCategoryId,
      request.productTypeId,
      request.partId,
      request.quantityId,
      request.brandId,
      request.minPrice,
      request.maxPrice,
      request.sort,
    );
  }

  @override
  Future<CategoryProductsResponseModelDto> getShoppingProducts(
    ShoppingProductsRequestEntity request,
  ) {
    final hasCategoryId =
        request.categoryId != null && request.categoryId!.trim().isNotEmpty;
    final categoryId = hasCategoryId ? request.categoryId!.trim() : null;

    final hasSubCategoryId =
        request.subCategoryId != null && request.subCategoryId!.trim().isNotEmpty;
    final subCategoryId = hasSubCategoryId ? request.subCategoryId!.trim() : null;

    return _apiServices.getShoppingProducts(
      categoryId,
      subCategoryId,
      request.productTypeId,
      request.partId,
      request.quantityId,
      request.brandId,
      request.minPrice,
      request.maxPrice,
      request.sort,
      request.page,
      request.perPage,
    );
  }
}
