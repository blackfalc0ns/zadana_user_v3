import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
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
    required this.notificationsUpdating,
    required this.onNotificationsChanged,
    required this.onNotificationsTap,
    required this.onLanguageTap,
    required this.onLogout,
    required this.onEditTap,
  });

  final AppLocalizations l10n;
  final ProfileResponseEntity profile;
  final bool notificationsEnabled;
  final bool notificationsUpdating;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onNotificationsTap;
  final VoidCallback onLanguageTap;
  final VoidCallback onLogout;
  final Future<void> Function() onEditTap;

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
            onEditTap: onEditTap,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Spacing.base)),
        _ProfileSectionSliver(
          title: l10n.account,
          items: [
            _ProfileActionItem(
              icon: Icons.person_outline_rounded,
              title: l10n.personal_info,
              subtitle: l10n.profile_edit_subtitle,
              onTap: onEditTap,
            ),
            _ProfileActionItem(
              icon: Icons.location_on_outlined,
              title: l10n.addresses,
              subtitle: l10n.profile_addresses_subtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.customerAddresses),
            ),
            _ProfileActionItem(
              icon: Icons.receipt_long_outlined,
              title: l10n.nav_orders,
              subtitle: l10n.profile_orders_subtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.myOrdersPage),
            ),
          ],
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Spacing.base)),
        _ProfileSectionSliver(
          title: l10n.settings,
          items: [
            _ProfileActionItem(
              icon: Icons.language_rounded,
              title: l10n.language,
              subtitle: l10n.profile_language_subtitle,
              onTap: onLanguageTap,
            ),
            _ProfileActionItem(
              icon: Icons.notifications_none_rounded,
              title: l10n.notifications,
              subtitle: _notificationsStatusText(context, notificationsEnabled),
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: notificationsUpdating
                    ? null
                    : onNotificationsChanged,
              ),
              onTap: onNotificationsTap,
            ),
            _ProfileActionItem(
              icon: Icons.lock_outline_rounded,
              title: l10n.change_password,
              subtitle: l10n.profile_password_subtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.forgetPassword),
            ),
          ],
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Spacing.base)),
        _ProfileSectionSliver(
          title: l10n.help_support,
          items: [
            _ProfileActionItem(
              icon: Icons.support_agent_rounded,
              title: l10n.help_support,
              subtitle: l10n.profile_help_subtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.helpSupport),
            ),
            _ProfileActionItem(
              icon: Icons.quiz_outlined,
              title: l10n.faq,
              subtitle: l10n.profile_faq_subtitle,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.faq),
            ),
            _ProfileActionItem(
              icon: Icons.info_outline_rounded,
              title: l10n.about_app,
              subtitle: l10n.profile_about_subtitle,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.aboutApp),
            ),
            _ProfileActionItem(
              icon: Icons.privacy_tip_outlined,
              title: l10n.privacy_policy,
              subtitle: l10n.profile_privacy_subtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.privacyPolicy),
            ),
          ],
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Spacing.base)),
        _ProfileSectionSliver(
          title: l10n.account,
          items: [
            _ProfileActionItem(
              icon: Icons.logout_rounded,
              title: l10n.logout,
              subtitle: l10n.profile_logout_subtitle,
              iconColor: AppColors.error,
              titleColor: AppColors.error,
              onTap: onLogout,
            ),
          ],
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  String _notificationsStatusText(BuildContext context, bool enabled) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == 'ar') {
      return enabled ? 'مفعل' : 'غير مفعل';
    }
    return enabled ? 'Enabled' : 'Disabled';
  }
}

class GuestProfileDashboardContent extends StatelessWidget {
  const GuestProfileDashboardContent({
    super.key,
    required this.l10n,
    required this.onLogin,
    required this.onSignUp,
    required this.onLanguageTap,
  });

  final AppLocalizations l10n;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;
  final VoidCallback onLanguageTap;

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
        const SliverToBoxAdapter(child: SizedBox(height: Spacing.base)),
        _ProfileSectionSliver(
          title: l10n.profile_guest_explore_title,
          items: [
            _ProfileActionItem(
              icon: Icons.language_rounded,
              title: l10n.language,
              subtitle: l10n.profile_language_subtitle,
              onTap: onLanguageTap,
            ),
            _ProfileActionItem(
              icon: Icons.support_agent_rounded,
              title: l10n.help_support,
              subtitle: l10n.profile_help_subtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.helpSupport),
            ),
            _ProfileActionItem(
              icon: Icons.info_outline_rounded,
              title: l10n.about_app,
              subtitle: l10n.profile_about_subtitle,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.aboutApp),
            ),
          ],
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
      decoration: const BoxDecoration(
        gradient: AppColors.primarygradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
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
    final color = context.colorScheme;

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
                color: color.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: color.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.05),
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

class _ProfileSectionSliver extends StatelessWidget {
  const _ProfileSectionSliver({required this.title, required this.items});

  final String title;
  final List<_ProfileActionItem> items;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: _ProfileSection(
        title: title,
        child: _ProfileActionList(items: items),
      ),
    );
  }
}

class _ProfileActionList extends StatelessWidget {
  const _ProfileActionList({required this.items});

  final List<_ProfileActionItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          ProfileActionTile(
            icon: item.icon,
            title: item.title,
            subtitle: item.subtitle,
            trailing: item.trailing,
            iconColor: item.iconColor,
            titleColor: item.titleColor,
            onTap: item.onTap,
          ),
      ],
    );
  }
}

class _ProfileActionItem {
  const _ProfileActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;
}
