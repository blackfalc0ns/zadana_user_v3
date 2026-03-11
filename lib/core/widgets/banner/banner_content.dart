import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_data.dart';
import 'package:zadana_user_v3/core/widgets/banner/banner_text_widgets.dart';

class BannerContent extends StatelessWidget {
  const BannerContent({
    super.key,
    required this.banner,
    this.onActionTap,
    this.padding,
  });

  final BannerData banner;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 40,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            BannerTag(text: banner.tag),
            const SizedBox(height: 6),
            BannerTitle(text: banner.title),
            const SizedBox(height: 3),
            BannerSubtitle(text: banner.subtitle),
            const SizedBox(height: 8),
            BannerActionButton(
              text: banner.actionLabel,
              onTap: onActionTap ?? () => _handleDefaultAction(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDefaultAction() {
    debugPrint('Banner action tapped: ${banner.actionLabel}');
  }
}