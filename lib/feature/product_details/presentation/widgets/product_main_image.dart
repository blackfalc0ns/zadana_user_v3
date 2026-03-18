import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';

class ProductMainImage extends StatelessWidget {
  final String emoji;
  final String imageUrl;
  final String productId;
  final double height;

  const ProductMainImage({
    super.key,
    required this.emoji,
    required this.imageUrl,
    required this.productId,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: AppColors.surface,
      child: Center(
        child: ProductImage(
          emoji: emoji,
          url: imageUrl,
          width: double.infinity,
          height: height,
          borderRadius: 0,
          heroTag: 'product_image_$productId',
        ),
      ),
    );
  }
}