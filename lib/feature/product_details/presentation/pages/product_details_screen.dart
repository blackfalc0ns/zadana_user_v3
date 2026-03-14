import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/price_comparison_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_description_section.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_header_section.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';

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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(widget.product.name, style: AppTextStyles.h4),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              color: AppColors.surface,
              child: Center(
                child: ProductImage(
                  emoji: widget.product.emoji,
                  url: '',
                  width: double.infinity,
                  height: 250,
                  borderRadius: 0,
                  heroTag: 'product_image_${widget.product.id}',
                ),
              ),
            ),
            ProductHeaderSection(
              productName: widget.product.name,
              quantity: _quantity,
              onIncrease: () => setState(() => _quantity++),
              onDecrease: () => setState(() => _quantity--),
            ),
            const SizedBox(height: Spacing.base),
            ProductDescriptionSection(
              title: l10n.product_description,
              description:
                  'منتج طازج عالي الجودة، يتم اختياره بعناية فائقة لضمان أفضل مذاق وقيمة غذائية. مثالي للاستخدام اليومي في وجباتك الصحية.',
            ),
            const SizedBox(height: Spacing.base),
            PriceComparisonSection(
              basePrice: widget.product.price,
              oldPrice: widget.product.oldPrice,
              currency: l10n.egp,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(Spacing.base),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => CustomSnackbar.showSuccess(
                    context: context,
                    message: l10n.product_added_to_cart(
                      _quantity,
                      widget.product.name,
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.cartPlus, size: 18),
                  label: Text(l10n.add_to_cart_button),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => CustomSnackbar.showInfo(
                    context: context,
                    message: 'الانتقال للسلة',
                  ),
                  icon: const FaIcon(FontAwesomeIcons.shoppingCart, size: 18),
                  label: const Text('السلة'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
