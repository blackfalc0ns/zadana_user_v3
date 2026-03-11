import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/product_image.dart';

/// Reusable product card content for horizontal lists
/// Used inside BaseCard for Special Offers and Best Selling
class ProductCardContent extends StatelessWidget {
  const ProductCardContent({
    super.key,
    required this.product,
    this.showCartButton = true,
    this.onCartTap,
  });

  final ProductModel product;
  final bool showCartButton;
  final VoidCallback? onCartTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImage(
          emoji: product.emoji,
          url: product.imageUrl,
          width: 150,
          height: 90,
          borderRadius: Spacing.cardRadius,
        ),
        Padding(
          padding: const EdgeInsets.all(Spacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: AppTextStyles.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.store,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PriceText(
                    price: product.price,
                    unit: product.unit,
                  ),
                  if (showCartButton)
                    GestureDetector(
                      onTap: onCartTap,
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.cartPlus,
                          color: AppColors.white,
                          size: 15,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
