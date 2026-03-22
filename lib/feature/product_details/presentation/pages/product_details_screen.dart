import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/reusable_product_details_screen.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/product_details/data/similar_products_data.dart';

class ProductDetailsScreen extends StatefulWidget {
  final CategoryProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ReusableProductDetailsScreen(
      productId: widget.product.id,
      productName: widget.product.name,
      emoji: widget.product.emoji,
      imageUrl: '',
      quantity: _quantity,
      onIncrease: () => setState(() => _quantity++),
      onDecrease: () => setState(() => _quantity--),
      descriptionTitle: l10n.product_description,
      description:
          'منتج طازج عالي الجودة، يتم اختياره بعناية فائقة لضمان أفضل مذاق وقيمة غذائية. مثالي للاستخدام اليومي في وجباتك الصحية.',
      basePrice: widget.product.price,
      oldPrice: widget.product.oldPrice,
      currency: l10n.egp,
      similarProducts: SimilarProductsData.getSimilarProducts(),
      onSimilarProductTap: (product) {
        ProductNavigationHelper.navigateToProductDetails(context, product);
      },
      onSimilarProductAddToCart: (product) {
        CustomSnackbar.showSuccess(
          context: context,
          message: 'تم إضافة ${product.name} إلى السلة',
        );
      },
      onAddToCart: () => CustomSnackbar.showSuccess(
        context: context,
        message: l10n.product_added_to_cart(_quantity, widget.product.name),
      ),
      onGoToCart: () =>
          CustomSnackbar.showInfo(context: context, message: 'الانتقال للسلة'),
    );
  }
}
