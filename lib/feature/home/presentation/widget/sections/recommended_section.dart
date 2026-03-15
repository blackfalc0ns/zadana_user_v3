import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_data.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/recommended_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: 'موصي به لك', actionLabel: 'تحديث'),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            scrollDirection: Axis.horizontal,
            itemCount: HomeData.recommended.length,
            separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
            itemBuilder: (_, i) {
              final product = HomeData.recommended[i];
              return RecommendedCard(
                product: product,
                onTap: () {
                  ProductNavigationHelper.navigateToProductDetails(context, product);
                },
                onFavoriteTap: () {
                  // Handle favorite tap
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم إضافة ${product.name} للمفضلة')),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
