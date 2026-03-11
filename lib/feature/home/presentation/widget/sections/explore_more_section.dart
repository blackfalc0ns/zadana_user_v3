import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/explore_more_tile.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_data.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class ExploreMoreSection extends StatelessWidget {
  const ExploreMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        SectionHeader(
          title: locale.section_explore,
          actionLabel: locale.see_all,
        ),
        const SizedBox(height: Spacing.sm),
        ...HomeData.exploreMore.map(
          (p) =>
              ExploreMoreTile(product: p, addToCartLabel: locale.add_to_cart),
        ),
      ],
    );
  }
}
