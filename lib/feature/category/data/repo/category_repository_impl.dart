import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/data/data_source/category_remote_data_source.dart';
import 'package:zadana_user_v3/feature/category/data/mapper/category_mapper.dart';
import 'package:zadana_user_v3/feature/category/data/mapper/category_products_mapper.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/shopping_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/repo/category_repository.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

@Injectable(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._remoteDataSource);

  final CategoryRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCategories();
      return response.toCategoryEntities();
    });
  }

  @override
  Future<ApiResult<CategoryFiltersResponseModelDto>> getCategoryFilters(
    String categoryId,
  ) async {
    return safeApiCall(() async {
      return _remoteDataSource.getCategoryFilters(categoryId);
    });
  }

  @override
  Future<ApiResult<List<CategorySubcategoryItemDto>>> getCategorySubcategories(
    String? categoryId,
  ) async {
    return safeApiCall(() async {
      return _remoteDataSource.getCategorySubcategories(categoryId);
    });
  }

  @override
  Future<ApiResult<List<ProductModel>>> getCategoryProducts(
    CategoryProductsRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCategoryProducts(request);
      return (response.items ?? const [])
          .map((item) => item.toEntity())
          .toList(growable: false);
    });
  }

  @override
  Future<ApiResult<List<ProductModel>>> getShoppingProducts(
    ShoppingProductsRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getShoppingProducts(request);
      return (response.items ?? const [])
          .map((item) => item.toEntity())
          .toList(growable: false);
    });
  }
}
