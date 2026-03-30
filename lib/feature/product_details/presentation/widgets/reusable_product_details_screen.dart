import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_main_image.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_details_content.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_bottom_actions.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class ReusableProductDetailsScreen extends StatelessWidget {
  final String productId;
  final String productName;
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
  final List<ProductModel> similarProducts;
  final Function(ProductModel)? onSimilarProductTap;
  final Function(ProductModel)? onSimilarProductAddToCart;
  final VoidCallback? onAddToCart;
  final VoidCallback? onGoToCart;
  final String? addToCartText;
  final String? goToCartText;
  final double imageHeight;
  final Widget? customAppBar;
  final String? activeProductId;

  const ReusableProductDetailsScreen({
    super.key,
    required this.productId,
    required this.productName,
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
    required this.similarProducts,
    this.onSimilarProductTap,
    this.onSimilarProductAddToCart,
    this.onAddToCart,
    this.onGoToCart,
    this.addToCartText,
    this.goToCartText,
    this.imageHeight = 250,
    this.customAppBar,
    this.activeProductId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:
          customAppBar as PreferredSizeWidget? ??
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Text(productName, style: AppTextStyles.h4),
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductMainImage(
              emoji: emoji,
              imageUrl: imageUrl,
              productId: productId,
              height: imageHeight,
              activeProductId: activeProductId,
            ),
            ProductDetailsContent(
              productName: productName,
              quantity: quantity,
              onIncrease: onIncrease,
              onDecrease: onDecrease,
              descriptionTitle: descriptionTitle,
              description: description,
              basePrice: basePrice,
              oldPrice: oldPrice,
              currency: currency,
              similarProducts: similarProducts,
              onSimilarProductTap: onSimilarProductTap,
              onSimilarProductAddToCart: onSimilarProductAddToCart,
              activeProductId: activeProductId,
            ),
          ],
        ),
      ),
      bottomSheet: ProductBottomActions(
        onAddToCart: onAddToCart,
        onGoToCart: onGoToCart,
        addToCartText: addToCartText,
        goToCartText: goToCartText,
      ),
    );
  }
}
