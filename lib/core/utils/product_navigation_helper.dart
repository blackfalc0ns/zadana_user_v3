import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/pages/product_details_screen.dart';

class ProductNavigationHelper {
  static CategoryProductModel convertToNavigationModel(ProductModel product) {
    return CategoryProductModel(
      id: product.id,
      name: product.name,
      subCategoryId: 'general',
      price: product.price,
      oldPrice: product.oldPrice,
      emoji: product.emoji ?? '📦',
      isFavorite: product.isFavorite,
      imageUrl: product.imageUrl,
      store: product.store,
      rating: product.rating,
      reviewCount: product.reviewCount,
      discount: product.discount,
      unit: product.unit,
    );
  }

  static Future<void> navigateToProductDetails(
    BuildContext context,
    ProductModel product, {
    String? activeProductId,
  }) {
    final navigationModel = convertToNavigationModel(product);

    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductDetailsScreen(
          product: navigationModel,
          activeProductId: activeProductId,
        ),
      ),
    );
  }
}
