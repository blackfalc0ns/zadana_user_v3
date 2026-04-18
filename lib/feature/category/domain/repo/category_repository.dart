import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/shopping_products_request_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

abstract class CategoryRepository {
  Future<ApiResult<List<CategoryEntity>>> getCategories();

  Future<ApiResult<CategoryFiltersResponseModelDto>> getCategoryFilters(
    String categoryId,
  );

  Future<ApiResult<List<CategorySubcategoryItemDto>>> getCategorySubcategories(
    String categoryId,
  );

  Future<ApiResult<List<ProductModel>>> getCategoryProducts(
    CategoryProductsRequestEntity request,
  );

  Future<ApiResult<List<ProductModel>>> getShoppingProducts(
    ShoppingProductsRequestEntity request,
  );
}
