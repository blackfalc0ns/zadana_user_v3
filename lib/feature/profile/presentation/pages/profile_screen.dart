import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'الحساب',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: Spacing.sm),
            _buildProfileCard(context),
            const SizedBox(height: Spacing.sm),
            _buildMenuList(l10n, context),
            const SizedBox(height: Spacing.base),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final color = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.editProfile);
        },
        child: Container(
          padding: const EdgeInsets.all(Spacing.sm),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      'م',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface,
                          width: 1.5,
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.pen,
                        size: 8,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'محمد أحمد',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+966 50 123 4567',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(AppLocalizations l10n, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Iconsax.location,
            title: l10n.addresses,
            iconColor: AppColors.textPrimary,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Iconsax.shopping_cart,
            title: l10n.nav_orders,
            iconColor: AppColors.textPrimary,
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.myOrdersPage);
            },
          ),
          const SizedBox(height: Spacing.xs),
          _buildMenuTile(
            icon: Iconsax.global,
            title: l10n.language,
            iconColor: AppColors.textPrimary,
            trailing: Text(
              'العربية',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            onTap: () => _showLanguageBottomSheet(context),
          ),
          _buildMenuTile(
            icon: Iconsax.notification,
            title: l10n.notifications,
            iconColor: AppColors.textPrimary,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Iconsax.lock,
            title: l10n.change_password,
            iconColor: AppColors.textPrimary,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Iconsax.info_circle,
            title: l10n.help_support,
            iconColor: AppColors.textPrimary,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Iconsax.document,
            title: l10n.about_app,
            iconColor: AppColors.textPrimary,
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Iconsax.logout,
            title: l10n.logout,
            iconColor: AppColors.error,
            onTap: () {},
          ),
          SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.xs),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: 2,
        ),
        leading: FaIcon(icon, color: iconColor, size: 18),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),

        trailing: trailing,
      ),
    );
  }

  Widget _buildLogoutButton(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: 2,
          ),
          leading: const FaIcon(
            FontAwesomeIcons.rightFromBracket,
            color: AppColors.error,
            size: 18,
          ),
          title: Text(
            l10n.logout,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Spacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: Spacing.base),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
              child: Text(
                'اختر اللغة',
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: Spacing.base),
            _buildLanguageOption(
              context: context,
              title: 'العربية',
              subtitle: 'Arabic',
              isSelected: true,
              onTap: () {
                Navigator.pop(context);
                // TODO: Change language to Arabic
              },
            ),
            const Divider(height: 1),
            _buildLanguageOption(
              context: context,
              title: 'English',
              subtitle: 'الإنجليزية',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                // TODO: Change language to English
              },
            ),
            const SizedBox(height: Spacing.base),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.xs,
      ),
      leading: Container(
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(Spacing.sm),
        ),
        child: FaIcon(
          FontAwesomeIcons.globe,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: isSelected
          ? const FaIcon(
              FontAwesomeIcons.circleCheck,
              color: AppColors.primary,
              size: 20,
            )
          : null,
    );
  }
}
