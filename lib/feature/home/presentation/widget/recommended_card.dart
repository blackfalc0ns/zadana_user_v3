import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/widgets/recommended_product_card.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

@Deprecated('Use RecommendedProductCard from lib/core/widgets instead.')
class RecommendedCard extends StatelessWidget {
  const RecommendedCard({
    super.key,
    required this.product,
    required this.heroTag,
    this.onTap,
    this.onAddTap,
    this.onFavoriteTap,
  });

  final ProductModel product;
  final String heroTag;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return RecommendedProductCard(
      product: product,
      heroTag: heroTag,
      onTap: onTap,
      onAddTap: onAddTap,
      onFavoriteTap: onFavoriteTap,
    );
  }
}
