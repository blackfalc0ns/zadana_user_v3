import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({
    super.key,
    required this.title,
    required this.name,
    required this.phone,
    required this.email,
    this.profilePhotoUrl,
    this.onEditTap,
    this.showEditButton = true,
  });

  final String title;
  final String name;
  final String phone;
  final String email;
  final String? profilePhotoUrl;
  final VoidCallback? onEditTap;
  final bool showEditButton;

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
          Row(
            children: [
              if (showEditButton && onEditTap != null)
                _TopIconButton(icon: Icons.edit_outlined, onTap: onEditTap!)
              else
                const SizedBox(width: 42, height: 42),
              const Spacer(),
              Text(
                title,
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 42),
            ],
          ),
          const SizedBox(height: Spacing.sm),
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
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: profilePhotoUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 44)
                : CachedNetworkImage(
                    imageUrl: profilePhotoUrl??"",
                    width: 86,
                    height: 86,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) =>
                        const Icon(Icons.person, color: Colors.white, size: 44),
                  ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            email,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.90),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            phone,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }
}
