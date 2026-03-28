import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.lg, // تقليل من xl إلى lg
            Spacing.xs, // تقليل من base إلى sm
            Spacing.lg, // تقليل من xl إلى lg
            Spacing.md, // تقليل من xl إلى lg
          ),
          child: Column(
            children: [
              // Profile Image
              Container(
                width: 50, // تقليل من 90 إلى 70
                height: 50, // تقليل من 90 إلى 70
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 3,
                  ), // تقليل من 4 إلى 3
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.3),
                      blurRadius: 12, // تقليل من 15 إلى 12
                      offset: const Offset(0, 4), // تقليل من 5 إلى 4
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.white,
                          AppColors.white.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 35, // تقليل من 45 إلى 35
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: Spacing.md), // تقليل من lg إلى md
              // Name
              Text(
                'mohamed',
                style: AppTextStyles.labelLarge.copyWith(
                  // تغيير من h4 إلى labelLarge
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: Spacing.xs), // تقليل من sm إلى xs
              // Email
              Directionality(
                textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
                child: Text(
                  'mohamedAli123@gmail.com',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelMedium.copyWith(
                    // تغيير من bodyMedium إلى labelMedium
                    color: AppColors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
