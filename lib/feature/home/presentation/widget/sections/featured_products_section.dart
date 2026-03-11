import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/base_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/featured_card_content.dart';
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: Row(
            children: HomeData.featured.map((product) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.sm),
                  child: BaseCard(
                    showFavorite: true,
                    isFavorite: product.isFavorite,
                    child: FeaturedCardContent(product: product),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
