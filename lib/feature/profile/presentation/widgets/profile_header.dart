import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String? avatarUrl;
  final VoidCallback onSettingsTap;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Spacing.cardRadius),
          bottomRight: Radius.circular(Spacing.cardRadius),
        ),
      ),
      child: Row(
        children: [
          // ── Avatar ──────────────────────────────────
          CircleAvatar(
            radius: Spacing.avatarLg / 2,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Icon(Icons.person,
                    size: Spacing.iconXl, color: AppColors.primary)
                : null,
          ),

          const SizedBox(width: Spacing.md),

          // ── Name & Email ─────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName, style: AppTextStyles.h3),
                const SizedBox(height: Spacing.xs),
                Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // ── Settings Icon ────────────────────────────
          IconButton(
            onPressed: onSettingsTap,
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}