import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/base_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_data.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/product_card_content.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class BestSellingSection extends StatelessWidget {
  const BestSellingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        SectionHeader(
          title: locale.section_best_selling,
          actionLabel: locale.see_all,
        ),
        const SizedBox(height: Spacing.md),
        SizedBox(
          height: 190,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            scrollDirection: Axis.horizontal,
            itemCount: HomeData.bestSelling.length,
            separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
            itemBuilder: (_, i) {
              final product = HomeData.bestSelling[i];
              return BaseCard(
                width: 150,
                showFavorite: true,
                isFavorite: product.isFavorite,
                child: ProductCardContent(
                  product: product,
                  showCartButton: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
