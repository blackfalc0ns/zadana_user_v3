import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/base_product_card.dart';

/// Reusable horizontal scrolling product list
class HorizontalProductList extends StatelessWidget {
  const HorizontalProductList({
    super.key,
    required this.products,
    this.height = 190,
    this.cardWidth = 150,
    this.imageHeight = 90,
    this.showFavorite = false,
    this.showCartButton = true,
  });

  final List<ProductModel> products;
  final double height;
  final double cardWidth;
  final double imageHeight;
  final bool showFavorite;
  final bool showCartButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
        itemBuilder: (_, i) => BaseProductCard(
          product: products[i],
          width: cardWidth,
          imageHeight: imageHeight,
          showFavorite: showFavorite,
          showCartButton: showCartButton,
        ),
      ),
    );
  }
}
