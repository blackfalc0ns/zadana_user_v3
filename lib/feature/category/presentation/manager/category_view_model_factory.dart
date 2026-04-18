import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/core/services/favorite_sync_service.dart';
import 'package:zadana_user_v3/feature/category/data/data_source/category_remote_data_source_impl.dart';
import 'package:zadana_user_v3/feature/category/data/repo/category_repository_impl.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_categories_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_filters_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_products_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_category_subcategories_usecase.dart';
import 'package:zadana_user_v3/feature/category/domain/usecase/get_shopping_products_usecase.dart';
import 'package:zadana_user_v3/feature/category/presentation/manager/category_view_model.dart';

CategoryViewModel createCategoryViewModel() {
  final remoteDataSource = CategoryRemoteDataSourceImpl(getIt<ApiServices>());
  final repository = CategoryRepositoryImpl(remoteDataSource);

  return CategoryViewModel(
    getCategoriesUseCase: GetCategoriesUseCase(repository),
    getCategoryFiltersUseCase: GetCategoryFiltersUseCase(repository),
    getCategorySubcategoriesUseCase: GetCategorySubcategoriesUseCase(
      repository,
    ),
    getCategoryProductsUseCase: GetCategoryProductsUseCase(repository),
    getShoppingProductsUseCase: GetShoppingProductsUseCase(repository),
    navigationService: CategoryNavigationService(),
    favoriteSyncService: FavoriteSyncService(),
  );
}
