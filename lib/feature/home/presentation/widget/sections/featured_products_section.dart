import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_product_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_data.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        SectionHeader(
          title: locale.section_featured,
          actionLabel: locale.see_all,
        ),
        const SizedBox(height: Spacing.md),
        SizedBox(
          height: 285,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Spacing.sm,
              mainAxisSpacing: Spacing.sm,
              childAspectRatio: 1.1,
            ),
            itemCount: HomeData.featured.length,
            itemBuilder: (context, index) {
              final product = HomeData.featured[index];
              return CustomProductCard(
                discountPercentage: index * 15,
                isDiscounted: index % 2 == 0,
                product: product,
                showFavorite: true,
                onAddTap: () {},
                onCardTap: () {
                  ProductNavigationHelper.navigateToProductDetails(
                    context,
                    product,
                  );
                },
                onFavoriteTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
