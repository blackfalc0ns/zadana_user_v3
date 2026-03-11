import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category/presentaion/widget/shimmer_card.dart';

class CategoryProductsShimmer extends StatelessWidget {
  const CategoryProductsShimmer({
    super.key,
    required this.animation,
    this.itemCount = 6,
  });

  final Animation<double> animation;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        Spacing.screenH,
        Spacing.sm,
        Spacing.screenH,
        Spacing.xl,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 منتجات في الصف
        crossAxisSpacing: Spacing.xs,
        mainAxisSpacing: Spacing.xs,
        childAspectRatio: 0.85,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerCard(animation: animation);
      },
    );
  }
}