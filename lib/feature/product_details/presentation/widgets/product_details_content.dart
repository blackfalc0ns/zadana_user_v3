import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/price_comparison_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_description_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_header_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/similar_products_section.dart';

class ProductDetailsContent extends StatelessWidget {
  final String productName;
  final String? unit;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final String descriptionTitle;
  final String description;
  final double basePrice;
  final double? oldPrice;
  final String currency;
  final List<ProductVendorPriceEntity> vendorPrices;
  final List<ProductModel> similarProducts;
  final Function(ProductModel)? onSimilarProductTap;
  final Future<void> Function(ProductModel)? onSimilarProductAddToCart;
  final String? activeProductId;

  const ProductDetailsContent({
    super.key,
    required this.productName,
    this.unit,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.descriptionTitle,
    required this.description,
    required this.basePrice,
    this.oldPrice,
    required this.currency,
    required this.vendorPrices,
    required this.similarProducts,
    this.onSimilarProductTap,
    this.onSimilarProductAddToCart,
    this.activeProductId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductHeaderSection(
          productName: productName,
          unit: unit,
          quantity: quantity,
          onIncrease: onIncrease,
          onDecrease: onDecrease,
        ),
        ProductDescriptionSection(
          title: descriptionTitle,
          description: description,
        ),
        const SizedBox(height: Spacing.base),
        PriceComparisonSection(
          basePrice: basePrice,
          oldPrice: oldPrice,
          currency: currency,
          vendorPrices: vendorPrices,
        ),
        const SizedBox(height: Spacing.base),
        SimilarProductsSection(
          similarProducts: similarProducts,
          onProductTap: onSimilarProductTap,
          onAddToCart: onSimilarProductAddToCart,
          activeProductId: activeProductId,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
