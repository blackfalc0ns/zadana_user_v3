import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class CategoryProductsAppBar extends StatelessWidget {
  const CategoryProductsAppBar({
    super.key,
    required this.title,
    required this.onCategoryTap,
  });

  final String title;
  final VoidCallback onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: 0,
      title: _buildTitle(),
      leading: _buildBackButton(context),
      bottom: _buildSubtitle(),
    );
  }

  Widget _buildTitle() {
    return GestureDetector(
      onTap: _openCategorySheet,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(title, style: AppTextStyles.h4),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: AppColors.textPrimary,
      ),
      onPressed: () => Navigator.maybePop(context),
    );
  }

  PreferredSize _buildSubtitle() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(10),
      child: GestureDetector(
        onTap: _openCategorySheet,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'اختر الفئة',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  void _openCategorySheet() {
    // TODO: Implement category sheet opening
    debugPrint('Open category sheet');
  }
}