import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_bottom_actions.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_details_content.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_main_image.dart';

class ReusableProductDetailsScreen extends StatelessWidget {
  const ReusableProductDetailsScreen({
    super.key,
    required this.productId,
    required this.productName,
    this.unit,
    required this.emoji,
    required this.imageUrl,
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
    this.onAddToCart,
    this.onGoToCart,
    this.imageHeight = 250,
    this.activeProductId,
    this.heroTag,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.appBarTitleColor,
    this.appBarLeading,
    this.appBarSystemOverlayStyle,
    this.cartCount = 0,
    this.isAddingToCart = false,
  });

  final String productId;
  final String productName;
  final String? unit;
  final String emoji;
  final String imageUrl;
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
  final VoidCallback? onAddToCart;
  final VoidCallback? onGoToCart;
  final double imageHeight;
  final String? activeProductId;
  final String? heroTag;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final Color? appBarTitleColor;
  final Widget? appBarLeading;
  final SystemUiOverlayStyle? appBarSystemOverlayStyle;
  final int cartCount;
  final bool isAddingToCart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? context.colorScheme.surface,
      appBar: CustomAppBar(
        title: productName,
        backgroundColor: appBarBackgroundColor ?? backgroundColor,
        titleColor: appBarTitleColor,
        showShadow: false,
        leading: appBarLeading,
        systemOverlayStyle: appBarSystemOverlayStyle,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductMainImage(
              emoji: emoji,
              imageUrl: imageUrl,
              productId: productId,
              height: imageHeight,
              heroTag: heroTag,
            ),
            ProductDetailsContent(
              productName: productName,
              unit: unit,
              quantity: quantity,
              onIncrease: onIncrease,
              onDecrease: onDecrease,
              descriptionTitle: descriptionTitle,
              description: description,
              basePrice: basePrice,
              oldPrice: oldPrice,
              currency: currency,
              vendorPrices: vendorPrices,
              similarProducts: similarProducts,
              onSimilarProductTap: onSimilarProductTap,
              onSimilarProductAddToCart: onSimilarProductAddToCart,
              activeProductId: activeProductId,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductBottomActions(
        onAddToCart: onAddToCart,
        onGoToCart: onGoToCart,
        cartCount: cartCount,
        isAddingToCart: isAddingToCart,
      ),
    );
  }
}
