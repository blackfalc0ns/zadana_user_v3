import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/reusable_product_details_screen.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/product_details/data/similar_products_data.dart';

class ProductDetailsScreen extends StatefulWidget {
  final CategoryProductModel product;
  final String? activeProductId;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    this.activeProductId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  String? _activeProductId;

  @override
  void initState() {
    super.initState();
    _activeProductId = widget.activeProductId;
  }

  @override
  void didUpdateWidget(covariant ProductDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeProductId != oldWidget.activeProductId) {
      _activeProductId = widget.activeProductId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final similarProducts = SimilarProductsData.getSimilarProducts()
        .where((product) => product.id != widget.product.id)
        .toList();

    return ReusableProductDetailsScreen(
      productId: widget.product.id,
      productName: widget.product.name,
      emoji: widget.product.emoji,
      imageUrl: widget.product.imageUrl ?? '',
      quantity: _quantity,
      onIncrease: () => setState(() => _quantity++),
      onDecrease: () => setState(() => _quantity--),
      descriptionTitle: l10n.product_description,
      description:
          'منتج طازج عالي الجودة، يتم اختياره بعناية فائقة لضمان أفضل مذاق وقيمة غذائية. مثالي للاستخدام اليومي في وجباتك الصحية.',
      basePrice: widget.product.price,
      oldPrice: widget.product.oldPrice,
      currency: l10n.egp,
      similarProducts: similarProducts,
      onSimilarProductTap: (product) async {
        // First update state to enable hero for this product only
        setState(() => _activeProductId = product.id);
        
        // Wait for frame to rebuild with new hero tag
        await WidgetsBinding.instance.endOfFrame;
        
        // Then navigate
        if (mounted) {
          ProductNavigationHelper.navigateToProductDetails(
            context,
            product,
            activeProductId: product.id,
          );
        }
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
      activeProductId: _activeProductId,
    );
  }
}
