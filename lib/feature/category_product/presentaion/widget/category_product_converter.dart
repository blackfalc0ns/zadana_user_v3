import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class CategoryProductConverter {
  static ProductModel toProductModel(CategoryProductModel categoryProduct) {
    return ProductModel(
      id: categoryProduct.id,
      name: categoryProduct.name,
      price: categoryProduct.price,
      oldPrice: categoryProduct.oldPrice,
      emoji: categoryProduct.emoji,
      imageUrl: '', // CategoryProductModel doesn't have imageUrl
      store: 'متجر زدانة', // Default store name
      unit: 'ريال', // Default unit
      isFavorite: categoryProduct.isFavorite,
    );
  }

  static CategoryProductModel fromProductModel(ProductModel product) {
    return CategoryProductModel(
      id: product.id,
      name: product.name,
      subCategoryId: 'all', // Default subcategory
      price: product.price,
      oldPrice: product.oldPrice,
      emoji: product.emoji ?? '📦',
      isFavorite: product.isFavorite,
    );
  }
}