import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class HomeProductFavoritesHelper {
  const HomeProductFavoritesHelper._();

  static Future<FavoriteActionResult> addProductToFavorites(
    AppSectionGlobalCubit globalCubit,
    ProductModel product,
  ) {
    return globalCubit.addProductToFavorites(product);
  }

  static Future<FavoriteActionResult> removeProductFromFavorites(
    AppSectionGlobalCubit globalCubit,
    ProductModel product,
  ) {
    return globalCubit.removeProductFromFavorites(product);
  }
}
