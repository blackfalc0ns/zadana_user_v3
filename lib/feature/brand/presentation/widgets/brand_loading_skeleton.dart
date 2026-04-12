import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/layout/product_grid_layout.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_loading_skeleton.dart';

class BrandLoadingSkeleton extends StatelessWidget {
  const BrandLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ShimmerEffect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final layout = ProductGridLayout.resolve(
              constraints.maxWidth,
              horizontalPadding: Spacing.md * 2,
              crossAxisSpacing: Spacing.xs,
            );

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Spacing.md),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: layout.crossAxisCount,
                childAspectRatio: layout.childAspectRatio,
                crossAxisSpacing: Spacing.xs,
                mainAxisSpacing: Spacing.xs,
              ),
              itemCount: 8,
              itemBuilder: (_, _) => const ProductCardSkeleton(),
            );
          },
        ),
      ),
    );
  }
}
