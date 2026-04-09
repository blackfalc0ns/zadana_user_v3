import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';

class ProductMainImage extends StatelessWidget {
  final String emoji;
  final String imageUrl;
  final String productId;
  final double height;
  final String? heroTag;

  const ProductMainImage({
    super.key,
    required this.emoji,
    required this.imageUrl,
    required this.productId,
    this.height = 250,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: ProductImage(
        emoji: emoji,
        url: imageUrl,
        width: double.infinity,
        height: height,
        borderRadius: Spacing.cardRadius,
        whiteBackground: true,
        heroTag: heroTag ?? productHeroTag(productId),
      ),
    );
  }
}
