import 'package:zadana_user_v3/feature/category/data/models/category_products_item_model_dto.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

extension CategoryProductsItemModelDtoMapper on CategoryProductsItemModelDto {
  ProductModel toEntity() {
    return ProductModel(
      id: id ?? '',
      name: name ?? '',
      store: store ?? '',
      price: price ?? 0,
      oldPrice: oldPrice,
      imageUrl: imageUrl ?? '',
      rating: rating,
      reviewCount: reviewCount,
      discount: discount,
      isFavorite: isFavorite ?? false,
      unit: unit,
      isDiscounted: isDiscounted ?? false,
    );
  }
}
