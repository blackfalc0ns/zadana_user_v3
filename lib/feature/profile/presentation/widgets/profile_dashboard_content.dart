import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_action_tile.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_summary_card.dart';

class ProfileDashboardContent extends StatelessWidget {
  const ProfileDashboardContent({
    super.key,
    required this.l10n,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.onLogout,
  });

  final AppLocalizations l10n;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ProfileSummaryCard(
            name: 'محمد أحمد',
            phone: '+966 50 123 4567',
            email: 'mohamed@example.com',
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
                const Expanded(
                  child: _StatCard(
                    iconColor: AppColors.primary,
                    icon: Icons.receipt_long_outlined,
                    value: '24',
                    label: 'الطلبات',
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                const Expanded(
                  child: _StatCard(
                    iconColor: AppColors.secondary,
                    icon: Icons.location_on_outlined,
                    value: '3',
                    label: 'العناوين',
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                const Expanded(
                  child: _StatCard(
                    iconColor: AppColors.success,
                    icon: Icons.verified_user_outlined,
                    value: 'مكتمل',
                    label: 'الملف الشخصي',
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: Spacing.base)),
        SliverToBoxAdapter(
          child: _ProfileSection(
            title: 'الحساب',
            child: Column(
              children: [
                ProfileActionTile(
                  icon: Icons.person_outline_rounded,
                  title: 'تعديل الملف الشخصي',
                  subtitle: 'حدّث اسمك ورقمك والبريد الإلكتروني',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.editProfile),
                ),
                ProfileActionTile(
                  icon: Icons.location_on_outlined,
                  title: l10n.addresses,
                  subtitle: 'إدارة عناوين التوصيل والموقع المحفوظ',
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.startSelectLocationPage),
                ),
                ProfileActionTile(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.nav_orders,
                  subtitle: 'راجع طلباتك الحالية والسابقة بسهولة',
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
            title: 'التفضيلات',
            child: Column(
              children: [
                ProfileActionTile(
                  icon: Icons.language_rounded,
                  title: l10n.language,
                  subtitle: 'العربية',
                  trailing: const Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () {},
                ),
                ProfileActionTile(
                  icon: Icons.notifications_none_rounded,
                  title: l10n.notifications,
                  subtitle: 'تحكم في الإشعارات والتنبيهات',
                  trailing: Switch(
                    value: notificationsEnabled,
                    onChanged: onNotificationsChanged,
                  ),
                  onTap: () => onNotificationsChanged(!notificationsEnabled),
                ),
                ProfileActionTile(
                  icon: Icons.lock_outline_rounded,
                  title: l10n.change_password,
                  subtitle: 'حدث كلمة المرور لحماية حسابك',
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
            title: 'الدعم والمعلومات',
            child: Column(
              children: [
                ProfileActionTile(
                  icon: Icons.support_agent_rounded,
                  title: l10n.help_support,
                  subtitle: 'تواصل معنا أو اطّلع على المساعدة',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.helpSupport),
                ),
                ProfileActionTile(
                  icon: Icons.quiz_outlined,
                  title: 'الأسئلة الشائعة',
                  subtitle: 'أسئلة وإجابات سريعة تساعدك',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.faq),
                ),
                ProfileActionTile(
                  icon: Icons.info_outline_rounded,
                  title: l10n.about_app,
                  subtitle: 'اعرف أكثر عن التطبيق والإصدار الحالي',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.aboutApp),
                ),
                ProfileActionTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'سياسة الخصوصية',
                  subtitle: 'الخصوصية والشروط والأحكام',
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
            title: 'الحساب',
            child: ProfileActionTile(
              icon: Icons.logout_rounded,
              title: l10n.logout,
              subtitle: 'تسجيل الخروج من هذا الجهاز',
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
  final Color? iconColor;
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
        border: Border.all(color: iconColor!.withValues(alpha: 0.3)),
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
