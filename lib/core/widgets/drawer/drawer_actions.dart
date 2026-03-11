import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/drawer/drawer_dialogs.dart';

class DrawerActions {
  static void handleNotifications(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to notifications screen
    print('Navigate to notifications');
  }

  static void handleFavorites(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to favorites screen
    print('Navigate to favorites');
  }

  static void handleCategories(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to categories screen
    print('Navigate to categories');
  }

  static void handleMyOrders(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to my orders screen
    print('Navigate to my orders');
  }

  static void handleLanguage(BuildContext context) {
    Navigator.pop(context);
    DrawerDialogs.showLanguageDialog(context);
  }

  static void handlePrivacyPolicy(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to privacy policy screen
    print('Navigate to privacy policy');
  }

  static void handleAboutApp(BuildContext context) {
    Navigator.pop(context);
    DrawerDialogs.showAboutDialog(context);
  }

  static void handleDeveloper(BuildContext context) {
    Navigator.pop(context);
    _showDeveloperDialog(context);
  }

  static void handleContactUs(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to contact us screen
    print('Navigate to contact us');
  }

  static void handleSupport(BuildContext context) {
    Navigator.pop(context);
    // TODO: Navigate to support screen
    print('Navigate to support');
  }

  static void handleLogout(BuildContext context) {
    Navigator.pop(context);
    _showLogoutDialog(context);
  }

  static void _showDeveloperDialog(BuildContext context) {
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
            Text('المطور', style: AppTextStyles.h4),
            const SizedBox(height: Spacing.lg),
            
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('فريق زدانة للتطوير', style: AppTextStyles.labelMedium),
                const SizedBox(height: 8),
                Text('تطوير تطبيقات الجوال', style: AppTextStyles.bodySmall),
                Text('Flutter & Dart', style: AppTextStyles.bodySmall),
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

  static void _showLogoutDialog(BuildContext context) {
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
            Text('تسجيل الخروج', style: AppTextStyles.h4),
            const SizedBox(height: Spacing.lg),
            
            // Content
            Text(
              'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: Spacing.lg),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Spacing.cardRadius),
                      ),
                      side: BorderSide(color: AppColors.textSecondary),
                    ),
                    child: Text(
                      'إلغاء',
                      style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Perform logout
                      print('User logged out');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Spacing.cardRadius),
                      ),
                    ),
                    child: Text(
                      'تسجيل الخروج',
                      style: AppTextStyles.button.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: Spacing.md),
          ],
        ),
      ),
    );
  }
}