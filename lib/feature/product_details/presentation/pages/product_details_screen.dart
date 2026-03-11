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
              height: 350,
              color: AppColors.surface,
              child: Center(
                child: Text(
                  widget.product.emoji,
                  style: const TextStyle(fontSize: 180),
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
                child: OutlinedButton.icon(
                  onPressed: () => CustomSnackbar.showSuccess(
                    context: context,
                    message: l10n.product_added_to_cart(
                      _quantity,
                      widget.product.name,
                    ),
                  ),
                  icon: FaIcon(FontAwesomeIcons.cartPlus, size: 20),
                  label: Text(l10n.add_to_cart_button),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => CustomSnackbar.showInfo(
                    context: context,
                    message: l10n.redirecting_to_checkout,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.buy_now),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
