import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class FavoritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasProducts;
  final VoidCallback onClearAll;

  const FavoritesAppBar({
    super.key,
    required this.hasProducts,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      title: Text(
        'المفضلة',
        style: AppTextStyles.h4.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        if (hasProducts)
          TextButton(
            onPressed: onClearAll,
            child: Text(
              'مسح الكل',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
