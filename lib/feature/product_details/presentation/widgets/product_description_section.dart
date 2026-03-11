import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/nutrition_info_card.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String title;
  final String description;

  const ProductDescriptionSection({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          const NutritionInfoCard(),
        ],
      ),
    );
  }
}
