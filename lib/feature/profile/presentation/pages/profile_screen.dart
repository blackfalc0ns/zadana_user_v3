import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.profile_title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.base),
        child: Column(
          children: [
            _buildProfileHeader(l10n),
            const SizedBox(height: Spacing.lg),
            _buildInfoSection(l10n),
            const SizedBox(height: Spacing.lg),
            _buildSettingsSection(l10n),
            const SizedBox(height: Spacing.lg),
            _buildLogoutButton(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: Text(
              'م',
              style: AppTextStyles.h2.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(width: Spacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('محمد أحمد', style: AppTextStyles.h4),
                const SizedBox(height: 4),
                Text(
                  'mohamed@example.com',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+966 50 123 4567',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildListTile(
            icon: Icons.location_on_outlined,
            title: l10n.addresses,
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildListTile(
            icon: Icons.receipt_long_outlined,
            title: l10n.nav_orders,
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildListTile(
            icon: Icons.favorite_outline,
            title: 'المفضلة',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildListTile(
            icon: Icons.language_outlined,
            title: l10n.language,
            trailing: Text('العربية', style: AppTextStyles.bodyMedium),
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildListTile(
            icon: Icons.notifications_outlined,
            title: l10n.notifications,
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildListTile(
            icon: Icons.lock_outline,
            title: l10n.change_password,
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildListTile(
            icon: Icons.help_outline,
            title: l10n.help_support,
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildListTile(
            icon: Icons.info_outline,
            title: l10n.about_app,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(AppLocalizations l10n) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.logout),
      label: Text(l10n.logout),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
