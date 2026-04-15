import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    super.key,
    required this.isGuest,
    this.displayName,
    this.secondaryText,
  });

  final bool isGuest;
  final String? displayName;
  final String? secondaryText;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final title = isGuest
        ? locale.profile_guest_title
        : (displayName?.trim().isNotEmpty == true
              ? displayName!.trim()
              : locale.nav_profile);
    final subtitle = isGuest
        ? locale.profile_guest_subtitle
        : secondaryText?.trim();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.md,
            Spacing.lg,
            Spacing.lg,
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.6,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isGuest ? Icons.person_outline_rounded : Icons.person_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: Spacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isGuest ? locale.profile_guest_title : locale.nav_profile,
                  textAlign: TextAlign.center,
                  style: getSemiBoldStyle(
                    fontSize: FontSize.size11,
                    fontFamily: FontConstant.cairo,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                title,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontSize: FontSize.size18,
                  fontFamily: FontConstant.cairo,
                  color: Colors.white,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                const SizedBox(height: Spacing.xs),
                Text(
                  subtitle,
                  maxLines: isGuest ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    color: color.onPrimary.withValues(alpha: 0.92),
                  ).copyWith(height: 1.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
