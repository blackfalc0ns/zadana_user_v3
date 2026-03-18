import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_header_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_description_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/price_comparison_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/similar_products_section.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class ProductDetailsContent extends StatelessWidget {
  final String productName;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final String descriptionTitle;
  final String description;
  final double basePrice;
  final double? oldPrice;
  final String currency;
  final List<ProductModel> similarProducts;
  final Function(ProductModel)? onSimilarProductTap;
  final Function(ProductModel)? onSimilarProductAddToCart;

  const ProductDetailsContent({
    super.key,
    required this.productName,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.descriptionTitle,
    required this.description,
    required this.basePrice,
    this.oldPrice,
    required this.currency,
    required this.similarProducts,
    this.onSimilarProductTap,
    this.onSimilarProductAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductHeaderSection(
          productName: productName,
          quantity: quantity,
          onIncrease: onIncrease,
          onDecrease: onDecrease,
        ),
        const SizedBox(height: Spacing.base),
        ProductDescriptionSection(
          title: descriptionTitle,
          description: description,
        ),
        const SizedBox(height: Spacing.base),
        PriceComparisonSection(
          basePrice: basePrice,
          oldPrice: oldPrice,
          currency: currency,
        ),
        const SizedBox(height: Spacing.base),
        SimilarProductsSection(
          similarProducts: similarProducts,
          onProductTap: onSimilarProductTap,
          onAddToCart: onSimilarProductAddToCart,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}