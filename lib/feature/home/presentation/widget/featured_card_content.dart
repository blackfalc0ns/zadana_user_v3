import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/product_image.dart';

/// Reusable featured product card content
/// Used inside BaseCard for Featured Products section
class FeaturedCardContent extends StatelessWidget {
  const FeaturedCardContent({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImage(
          emoji: product.emoji,
          url: product.imageUrl,
          width: double.infinity,
          height: 140,
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
              ),
              const SizedBox(height: 4),
              PriceText(
                price: product.price,
                unit: product.unit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
