import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class DrawerDialogs {
  static void showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: Spacing.md),
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Text('اختر اللغة', style: AppTextStyles.h4),
            const SizedBox(height: Spacing.lg),
            
            // Language options
            ListTile(
              title: Text('العربية', style: AppTextStyles.labelMedium),
              leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              trailing: Icon(Icons.check, color: AppColors.primary),
              onTap: () {
                Navigator.pop(context);
                // TODO: Change language to Arabic
              },
            ),
            ListTile(
              title: Text('English', style: AppTextStyles.labelMedium),
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Change language to English
              },
            ),
            
            const SizedBox(height: Spacing.md),
          ],
        ),
      ),
    );
  }

  static void showAboutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: Spacing.md),
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Text('عن التطبيق', style: AppTextStyles.h4),
            const SizedBox(height: Spacing.lg),
            
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تطبيق زدانة للتسوق الذكي', style: AppTextStyles.labelMedium),
                const SizedBox(height: Spacing.sm),
                Text('الإصدار: v1.0.0', style: AppTextStyles.bodySmall),
                Text('تاريخ الإصدار: 2024', style: AppTextStyles.bodySmall),
                const SizedBox(height: Spacing.sm),
                Text(
                  'تطبيق متكامل للتسوق الإلكتروني يوفر تجربة تسوق مميزة وسهلة.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            
            const SizedBox(height: Spacing.lg),
            
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Spacing.cardRadius),
                  ),
                ),
                child: Text(
                  'حسناً',
                  style: AppTextStyles.button.copyWith(color: AppColors.white),
                ),
              ),
            ),
            
            const SizedBox(height: Spacing.md),
          ],
        ),
      ),
    );
  }
}