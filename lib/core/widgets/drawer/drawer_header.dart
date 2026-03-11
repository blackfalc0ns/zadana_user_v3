import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(
        Radius.circular(Spacing.cardRadius),
           
          ),
        ),
        child: Column(
          children: [
            // Logo
            Image.asset(
              AppConstants.logoDark,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: Spacing.sm),
            
            // // App Name
            // Text(
            //   'زدانة',
            //   style: AppTextStyles.h3.copyWith(
            //     color: AppColors.white,
            //   ),
            // ),
            
            // Subtitle
            Text(
              'تسوق بذكاء، وفر بسهولة',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}