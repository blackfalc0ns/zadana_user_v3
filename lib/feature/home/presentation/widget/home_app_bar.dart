import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_search_bar.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.deliverToLabel,
    required this.location,
    this.onMenuTap,
    this.onLocationTap,
    this.onNotificationsTap,
    this.onSearchTap,
    this.onSearchChanged,
    this.searchController,
  });

  final String deliverToLabel;
  final String location;
  final VoidCallback? onMenuTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSearchTap;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;

  @override
  Size get preferredSize => const Size.fromHeight(156);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _ActionButton(icon: Icons.menu_rounded, onTap: onMenuTap),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _LocationCard(
                      deliverToLabel: deliverToLabel,
                      location: location,
                      onTap: onLocationTap,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  _ActionButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: onNotificationsTap ?? onLocationTap,
                    isPrimary: true,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              HomeSearchBar(
                controller: searchController,
                onChanged: onSearchChanged,
                onTap: onSearchTap,
                readOnly: onSearchTap != null,
                padding: EdgeInsets.zero,

                onFilterTap: () {},
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, this.onTap, this.isPrimary = false});

  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1393A8)],
                )
              : null,
          color: isPrimary ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isPrimary ? 0.08 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.deliverToLabel,
    required this.location,
    this.onTap,
  });

  final String deliverToLabel;
  final String location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              AppConstants.logoLight,
              fit: BoxFit.contain,
              width: 50,
              height: 50,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deliverToLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            color: AppColors.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.sm),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
