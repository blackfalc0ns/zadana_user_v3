import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/category/data/fake/category_fake_data.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/category_row.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  void _navigateToShoppingTab(BuildContext context, CategoryEntity category) {
    CategoryNavigationService().setSelectedCategory(category);
    mainShellKey.currentState?.jumpToTab(1);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        SectionHeader(
          title: 'تسوق حسب القسم',
          actionLabel: locale.see_all,
          onActionTap: () {
            CategoryNavigationService().clearSelectedCategory();
            mainShellKey.currentState?.jumpToTab(1);
          },
        ),
        const SizedBox(height: Spacing.md),
        CategoryRow(
          categories: kCategoryList,
          onCategoryTap: (cat) => _navigateToShoppingTab(context, cat),
        ),
      ],
    );
  }
}
