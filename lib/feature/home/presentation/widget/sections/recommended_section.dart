import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_data.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/recommended_card.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(locale.section_recommended, style: AppTextStyles.h4),
              TextButton(
                onPressed: () {},
                child: Text(locale.refresh),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            scrollDirection: Axis.horizontal,
            itemCount: HomeData.recommended.length,
            separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
            itemBuilder: (_, i) =>
                RecommendedCard(product: HomeData.recommended[i]),
          ),
        ),
      ],
    );
  }
}
