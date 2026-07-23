import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/logout_helper.dart';
import 'package:zadana_user_v3/core/utils/app_package_info.dart';

void showDeveloperDialog(BuildContext context) {
  final color = context.colorScheme;
  showDialog<void>(
    context: context,
    barrierColor: AppColors.black.withValues(alpha: 0.45),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              28,
              Spacing.lg,
              Spacing.lg,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Assets.blackFalcons,
                  height: 72,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  'Black Falcons',
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontSize: FontSize.size20,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'for technical Solution',
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<String>(
                  future: AppPackageInfo.versionName,
                  builder: (context, snapshot) {
                    final version = snapshot.data ?? '...';
                    return Text(
                      'Version $version',
                      style: getRegularStyle(
                        fontSize: FontSize.size13,
                        fontFamily: FontConstant.cairo,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: Spacing.lg),
                const DeveloperInfoCard(
                  icon: Icons.phone_in_talk_rounded,
                  title: 'Phone',
                  value: '+20 101 555 9674',
                ),
                const SizedBox(height: Spacing.sm),
                const DeveloperInfoCard(
                  icon: Icons.language_rounded,
                  title: 'Website',
                  value: 'www.blackfalcons.dev',
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  'Thanks for using Zadna',
                  style: getMediumStyle(
                    fontSize: FontSize.size13,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: InkWell(
              onTap: () => Navigator.pop(dialogContext),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showLogoutDialog(BuildContext context) {
  final color = context.colorScheme;
  final locale = context.localization;
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: color.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsPadding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        0,
        Spacing.lg,
        Spacing.lg,
      ),
      title: Text(
        locale.logout,
        textAlign: TextAlign.center,
        style: getBoldStyle(
          fontSize: FontSize.size18,
          fontFamily: FontConstant.cairo,
          color: color.onSurface,
        ),
      ),
      content: Text(
        locale.logout_confirm,
        textAlign: TextAlign.center,
        style: getRegularStyle(
          fontSize: FontSize.size14,
          fontFamily: FontConstant.cairo,
          color: color.onSurfaceVariant,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  side: BorderSide(
                    color: color.outline.withValues(alpha: 0.35),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  locale.cancel,
                  style: getMediumStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await LogoutHelper.performLogout(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  backgroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  locale.logout,
                  style: getMediumStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class FooterInfoTile extends StatelessWidget {
  const FooterInfoTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(Spacing.md),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(Spacing.md),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              Image.asset(Assets.blackFalcons, height: 30, fit: BoxFit.contain),
              const SizedBox(width: Spacing.sm),
              Flexible(
                child: Align(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Developed by',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: getRegularStyle(
                          fontSize: FontSize.size11,
                          fontFamily: FontConstant.cairo,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 3),
                      FutureBuilder<String>(
                        future: AppPackageInfo.versionName,
                        builder: (context, snapshot) {
                          final version = snapshot.data ?? '...';
                          return Text(
                            'Black Falcons v $version',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: getMediumStyle(
                              fontSize: FontSize.size13,
                              fontFamily: FontConstant.cairo,
                              color: color.onSurface,
                            ),
                          );
                        },
                      ),
                    ],
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

class DeveloperInfoCard extends StatelessWidget {
  const DeveloperInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outline.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 18, color: color.primary),
          ),
        ],
      ),
    );
  }
}
