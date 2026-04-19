import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/pages/product_details_screen.dart';

class ProductNavigationHelper {
  static Future<void> navigateToProductDetails(
    BuildContext context,
    ProductModel product, {
    String? activeProductId,
    String? heroTag,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductDetailsScreen(
          product: product,
          activeProductId: activeProductId,
          heroTag: heroTag,
        ),
      ),
    );
  }
}
