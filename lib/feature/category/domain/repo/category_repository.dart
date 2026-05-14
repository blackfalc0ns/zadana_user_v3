import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/paginated_products_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/shopping_products_request_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

abstract class CategoryRepository {
  Future<ApiResult<List<CategoryEntity>>> getCategories({int? take});

  Future<ApiResult<CategoryFiltersResponseModelDto>> getCategoryFilters(
    String categoryId,
  );

  Future<ApiResult<List<CategorySubcategoryItemDto>>> getCategorySubcategories(
    String? categoryId, {
    int? limit,
  });

  Future<ApiResult<List<ProductModel>>> getCategoryProducts(
    CategoryProductsRequestEntity request,
  );

  Future<ApiResult<List<ProductModel>>> getShoppingProducts(
    ShoppingProductsRequestEntity request,
  );

  Future<ApiResult<PaginatedProductsEntity>> getShoppingProductsPaginated(
    ShoppingProductsRequestEntity request,
  );
}
