import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_action_tile.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_summary_card.dart';

class ProfileDashboardContent extends StatelessWidget {
  const ProfileDashboardContent({
    super.key,
    required this.l10n,
    required this.profile,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.onLogout,
  });

  final AppLocalizations l10n;
  final ProfileResponseEntity profile;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ProfileSummaryCard(
            title: l10n.profile_title,
            name: profile.fullName,
            phone: profile.phone,
            email: profile.email,
            onEditTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.editProfile),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: Spacing.lg)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    iconColor: AppColors.primary,
                    icon: Icons.favorite_border_rounded,
                    value: profile.favoritesCount.toString(),
                    label: l10n.favorites,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: _StatCard(
                    iconColor: AppColors.secondary,
                    icon: Icons.badge_outlined,
                    value: profile.role,
                    label: l10n.profile_role_label,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: _StatCard(
                    iconColor: AppColors.success,
                    icon: Icons.verified_user_outlined,
                    value: l10n.profile_status_active,
                    label: l10n.profile_status_label,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: Spacing.base)),
        SliverToBoxAdapter(
          child: _ProfileSection(
            title: l10n.account,
            child: Column(
              children: [
                ProfileActionTile(
                  icon: Icons.person_outline_rounded,
                  title: l10n.personal_info,
                  subtitle: l10n.profile_edit_subtitle,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.editProfile),
                ),
                ProfileActionTile(
                  icon: Icons.location_on_outlined,
                  title: l10n.addresses,
                  subtitle: l10n.profile_addresses_subtitle,
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.startSelectLocationPage),
                ),
                ProfileActionTile(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.nav_orders,
                  subtitle: l10n.profile_orders_subtitle,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.myOrdersPage),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: Spacing.base)),
        SliverToBoxAdapter(
          child: _ProfileSection(
            title: l10n.settings,
            child: Column(
              children: [
                ProfileActionTile(
                  icon: Icons.language_rounded,
                  title: l10n.language,
                  subtitle: l10n.profile_language_subtitle,
                  onTap: () {},
                ),
                ProfileActionTile(
                  icon: Icons.notifications_none_rounded,
                  title: l10n.notifications,
                  subtitle: l10n.profile_notifications_subtitle,
                  trailing: Switch(
                    value: notificationsEnabled,
                    onChanged: onNotificationsChanged,
                  ),
                  onTap: () => onNotificationsChanged(!notificationsEnabled),
                ),
                ProfileActionTile(
                  icon: Icons.lock_outline_rounded,
                  title: l10n.change_password,
                  subtitle: l10n.profile_password_subtitle,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.forgetPassword),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: Spacing.base)),
        SliverToBoxAdapter(
          child: _ProfileSection(
            title: l10n.help_support,
            child: Column(
              children: [
                ProfileActionTile(
                  icon: Icons.support_agent_rounded,
                  title: l10n.help_support,
                  subtitle: l10n.profile_help_subtitle,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.helpSupport),
                ),
                ProfileActionTile(
                  icon: Icons.quiz_outlined,
                  title: l10n.faq,
                  subtitle: l10n.profile_faq_subtitle,
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.faq),
                ),
                ProfileActionTile(
                  icon: Icons.info_outline_rounded,
                  title: l10n.about_app,
                  subtitle: l10n.profile_about_subtitle,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.aboutApp),
                ),
                ProfileActionTile(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.privacy_policy,
                  subtitle: l10n.profile_privacy_subtitle,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.privacyPolicy),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: Spacing.base)),
        SliverToBoxAdapter(
          child: _ProfileSection(
            title: l10n.account,
            child: ProfileActionTile(
              icon: Icons.logout_rounded,
              title: l10n.logout,
              subtitle: l10n.profile_logout_subtitle,
              iconColor: AppColors.error,
              titleColor: AppColors.error,
              onTap: onLogout,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

class GuestProfileDashboardContent extends StatelessWidget {
  const GuestProfileDashboardContent({
    super.key,
    required this.l10n,
    required this.onLogin,
    required this.onSignUp,
  });

  final AppLocalizations l10n;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _GuestProfileHeader(
            l10n: l10n,
            onLogin: onLogin,
            onSignUp: onSignUp,
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: Spacing.base)),
        SliverToBoxAdapter(
          child: _ProfileSection(
            title: l10n.profile_guest_explore_title,
            child: Column(
              children: [
                ProfileActionTile(
                  icon: Icons.language_rounded,
                  title: l10n.language,
                  subtitle: l10n.profile_language_subtitle,
                  onTap: () {},
                ),
                ProfileActionTile(
                  icon: Icons.location_on_outlined,
                  title: l10n.addresses,
                  subtitle: l10n.profile_guest_addresses_subtitle,
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.startSelectLocationPage),
                ),
                ProfileActionTile(
                  icon: Icons.support_agent_rounded,
                  title: l10n.help_support,
                  subtitle: l10n.profile_help_subtitle,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.helpSupport),
                ),
                ProfileActionTile(
                  icon: Icons.info_outline_rounded,
                  title: l10n.about_app,
                  subtitle: l10n.profile_about_subtitle,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.aboutApp),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

class _GuestProfileHeader extends StatelessWidget {
  const _GuestProfileHeader({
    required this.l10n,
    required this.onLogin,
    required this.onSignUp,
  });

  final AppLocalizations l10n;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        Spacing.base,
        topInset + Spacing.sm,
        Spacing.base,
        Spacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primarygradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: Column(
        children: [
          Text(
            l10n.profile_title,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.20),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            l10n.profile_guest_title,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.profile_guest_subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSignUp,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: Text(l10n.btn_signup),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: Text(l10n.btn_login),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: Spacing.xs,
              bottom: 10,
            ),
            child: Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              color: iconColor,
              fontSize: 14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getMediumStyle(fontSize: 12, fontFamily: FontConstant.cairo),
          ),
        ],
      ),
    );
  }
}
