import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_view_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_search_bar.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    this.onMenuTap,
    this.onLocationTap,
    this.onNotificationsTap,
    this.onSearchTap,
    this.onSearchChanged,
    this.searchController,
  });

  final VoidCallback? onMenuTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSearchTap;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;

  @override
  Size get preferredSize => const Size.fromHeight(138);

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final homeResponse = state.appBarSection.data;

        return Material(
          child: Container(
            padding: EdgeInsets.only(top: topInset + 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.primary,
                  color.primary.withValues(alpha: 0.92),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _ActionButton(icon: Icons.menu_rounded, onTap: onMenuTap),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _LocationCard(
                        deliverToLabel: locale.deliver_to,
                        location: homeResponse?.location.isNotEmpty == true
                            ? homeResponse!.location
                            : locale.location,
                        addressLine: homeResponse?.addressLine ?? '',
                        onTap: onLocationTap,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    _ActionButton(
                      notificationCount:
                          homeResponse?.notificationsCount ?? 0,
                      onTap: onNotificationsTap ?? onLocationTap,
                      isPrimary: true,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                HomeSearchBar(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  onTap: onSearchTap,
                  readOnly: onSearchTap != null,
                  padding: EdgeInsets.zero,
                  onFilterTap: () {},
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    this.icon,
    this.onTap,
    this.isPrimary = false,
    this.notificationCount = 0,
  });

  final IconData? icon;
  final VoidCallback? onTap;
  final bool isPrimary;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isEnabled = onTap != null;

    return Opacity(
      opacity: isEnabled || isPrimary ? 1 : 0.55,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            border: isPrimary
                ? Border.all(color: color.onPrimary.withValues(alpha: 0.18))
                : null,
            gradient: isPrimary
                ? LinearGradient(
                    colors: [
                      color.primary,
                      color.primary.withValues(alpha: 0.82),
                    ],
                  )
                : null,
            color: isPrimary ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: isPrimary ? 0.12 : 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isPrimary
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          'assets/images/notification.svg',
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            color.onPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 14,
                        right: 0,
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: color.error,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: color.onPrimary,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              notificationCount > 99
                                  ? '99+'
                                  : notificationCount.toString(),
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                color: color.onError,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Icon(icon, color: color.onPrimary),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.deliverToLabel,
    required this.location,
    required this.addressLine,
    this.onTap,
  });

  final String deliverToLabel;
  final String location;
  final String addressLine;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.primary.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.onPrimary.withValues(alpha: 0.14)),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              Assets.logoLight,
              fit: BoxFit.contain,
              width: 80,
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
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.onPrimary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: color.onPrimary,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            color: color.onPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.xs),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: color.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
