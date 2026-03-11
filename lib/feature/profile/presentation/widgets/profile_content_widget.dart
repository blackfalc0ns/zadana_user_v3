import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_header.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_logout_button.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_menu_item_data.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_menu_section.dart';

class ProfileContentWidget extends StatelessWidget {
  final ProfileResponseEntity profile;
  final VoidCallback onHeaderTap;

  const ProfileContentWidget({
    super.key,
    required this.profile,
    required this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(Spacing.base),
            child: ProfileHeader(
              onSettingsTap: () {},
              fullName: profile.fullName,
              email: profile.email,
              avatarUrl: null,
              onTap: onHeaderTap,
            ),
          ),

          const SizedBox(height: Spacing.base),

          // Account Section
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.xs,
            ),
            child: Text(locale.account, style: AppTextStyles.h3),
          ),
          ProfileMenuSection(
            items: [
              ProfileMenuItemData(
                icon: Icons.lock_outline,
                title: locale.change_password,
                onTap: () => _showComingSoon(context),
              ),
              ProfileMenuItemData(
                icon: Icons.help_outline,
                title: locale.help_support,
                onTap: () => _showComingSoon(context),
              ),
              ProfileMenuItemData(
                icon: Icons.info_outline,
                title: locale.about_app,
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),

          // Legal Section
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.xs,
            ),
            child: Text(locale.legal, style: AppTextStyles.h3),
          ),
          ProfileMenuSection(
            items: [
              ProfileMenuItemData(
                icon: Icons.description_outlined,
                title: locale.terms_conditions,
                onTap: () => _showComingSoon(context),
              ),
              ProfileMenuItemData(
                icon: Icons.privacy_tip_outlined,
                title: locale.privacy_policy,
                onTap: () => _showComingSoon(context),
              ),
              ProfileMenuItemData(
                icon: Icons.quiz_outlined,
                title: locale.faq,
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),

          // Logout Button
          const ProfileLogoutButton(),

          const SizedBox(height: Spacing.base),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    CustomSnackbar.showInfo(context: context, message: 'Coming soon');
  }
}
