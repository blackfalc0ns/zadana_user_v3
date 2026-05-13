import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_products_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_products_request_entity.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/shopping_products_request_entity.dart';
import 'package:zadana_user_v3/feature/home/data/models/categories/home_categories_response_model_dto.dart';

abstract class CategoryRemoteDataSource {
  Future<HomeCategoriesResponseModelDto> getCategories();

  Future<CategoryFiltersResponseModelDto> getCategoryFilters(String categoryId);

  Future<List<CategorySubcategoryItemDto>> getCategorySubcategories(
    String? categoryId,
  );

  Future<CategoryProductsResponseModelDto> getCategoryProducts(
    CategoryProductsRequestEntity request,
  );

  Future<CategoryProductsResponseModelDto> getShoppingProducts(
    ShoppingProductsRequestEntity request,
  );
}
