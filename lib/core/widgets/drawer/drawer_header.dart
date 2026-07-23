import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class DrawerHeader extends StatefulWidget {
  const DrawerHeader({
    super.key,
    required this.isGuest,
    this.displayName,
    this.secondaryText,
    this.profilePhotoUrl,
  });

  final bool isGuest;
  final String? displayName;
  final String? secondaryText;
  final String? profilePhotoUrl;

  @override
  State<DrawerHeader> createState() => _DrawerHeaderState();
}

class _DrawerHeaderState extends State<DrawerHeader> {
  static const _tapWindow = Duration(seconds: 2);
  int _avatarTapCount = 0;
  Timer? _tapResetTimer;

  @override
  void dispose() {
    _tapResetTimer?.cancel();
    super.dispose();
  }

  void _onAvatarTap() {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    _avatarTapCount++;
    _tapResetTimer?.cancel();
    _tapResetTimer = Timer(_tapWindow, () => _avatarTapCount = 0);
    if (_avatarTapCount != 3) return;

    _avatarTapCount = 0;
    _tapResetTimer?.cancel();
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(AppRoutes.signalrDiagnostics);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final title = widget.isGuest
        ? locale.profile_guest_title
        : (widget.displayName?.trim().isNotEmpty == true
              ? widget.displayName!.trim()
              : locale.nav_profile);
    final subtitle = widget.isGuest
        ? locale.profile_guest_subtitle
        : widget.secondaryText?.trim();

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
              GestureDetector(
                onTap: _onAvatarTap,
                child: Container(
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
                  child: _buildAvatar(),
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
                  widget.isGuest
                      ? locale.profile_guest_title
                      : locale.nav_profile,
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
                  maxLines: widget.isGuest ? 2 : 1,
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

  Widget _buildAvatar() {
    final photoUrl = widget.profilePhotoUrl?.trim();
    if (!widget.isGuest && photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          photoUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            );
          },
          errorBuilder: (_, _, _) => _defaultAvatar(),
        ),
      );
    }

    return _defaultAvatar();
  }

  Widget _defaultAvatar() => Icon(
    widget.isGuest ? Icons.person_outline_rounded : Icons.person_rounded,
    size: 30,
    color: Colors.white,
  );
}
