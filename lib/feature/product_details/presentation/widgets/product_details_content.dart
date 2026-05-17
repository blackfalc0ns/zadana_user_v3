import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_variant_option_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/price_comparison_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_description_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_header_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_variant_options_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/similar_products_section.dart';

class ProductDetailsContent extends StatelessWidget {
  const ProductDetailsContent({
    super.key,
    required this.productName,
    this.unit,
    this.displaySize,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.descriptionTitle,
    required this.description,
    required this.basePrice,
    this.oldPrice,
    required this.currency,
    required this.variantOptions,
    required this.vendorPrices,
    required this.similarProducts,
    this.onVariantSelected,
    this.onSimilarProductTap,
    this.onSimilarProductAddToCart,
    this.activeProductId,
  });
  final String productName;
  final String? unit;
  final String? displaySize;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final String descriptionTitle;
  final String description;
  final double basePrice;
  final double? oldPrice;
  final String currency;
  final List<ProductVariantOptionEntity> variantOptions;
  final List<ProductVendorPriceEntity> vendorPrices;
  final List<ProductModel> similarProducts;
  final ValueChanged<ProductVariantOptionEntity>? onVariantSelected;
  final Function(ProductModel)? onSimilarProductTap;
  final Future<void> Function(ProductModel)? onSimilarProductAddToCart;
  final String? activeProductId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductHeaderSection(
          productName: productName,
          unit: unit,
          displaySize: variantOptions.length <= 1 ? displaySize : null,
          quantity: quantity,
          onIncrease: onIncrease,
          onDecrease: onDecrease,
        ),
        // Size selector directly after product name
        if (variantOptions.length > 1) ...[
          const SizedBox(height: Spacing.sm),
          ProductVariantOptionsSection(
            variantOptions: variantOptions,
            onVariantSelected: onVariantSelected,
          ),
        ],
        // Store price directly after size selector
        if (vendorPrices.isNotEmpty) ...[
          const SizedBox(height: Spacing.base),
          PriceComparisonSection(vendorPrices: vendorPrices),
        ],
        // Description moved below the key purchase info
        const SizedBox(height: Spacing.base),
        ProductDescriptionSection(
          title: descriptionTitle,
          description: description,
        ),
        const SizedBox(height: Spacing.base),
        SimilarProductsSection(
          similarProducts: similarProducts,
          onProductTap: onSimilarProductTap,
          onAddToCart: onSimilarProductAddToCart,
          activeProductId: activeProductId,
        ),
        const SizedBox(height: Spacing.base),
      ],
    );
  }
}
