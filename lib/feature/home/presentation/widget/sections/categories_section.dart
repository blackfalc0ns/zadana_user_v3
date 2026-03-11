import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/pages/category_products_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/category_circle_row.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        SectionHeader(
          title: 'تسوق حسب القسم',
          actionLabel: locale.see_all,
          onActionTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CategoryProductsScreen(category: kHomeCategories.first),
            ),
          ),
        ),
        const SizedBox(height: Spacing.md),
        CategoryCircleRow(
          categories: kHomeCategories,
          onCategoryTap: (cat) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryProductsScreen(category: cat),
            ),
          ),
        ),
      ],
    );
  }
}
