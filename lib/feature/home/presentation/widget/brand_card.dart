import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.emoji,
    this.onTap,
    this.isCompact = false,
    this.compactFontSize,
  });

  final String name;
  final String imageUrl;
  final String emoji;
  final VoidCallback? onTap;
  final bool isCompact;
  final double? compactFontSize;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final horizontalPadding = isCompact ? 6.0 : Spacing.xs;
    final verticalPadding = isCompact ? 8.0 : Spacing.sm;
    final imageSpacing = isCompact ? 6.0 : Spacing.xs;
    final fontSize = isCompact
        ? (compactFontSize ?? FontSize.size10)
        : FontSize.size11;
    final maxLines = isCompact ? 2 : 1;

    return Material(
      color: color.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(Spacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _BrandImage(imageUrl: imageUrl, emoji: emoji),
              ),
              SizedBox(height: imageSpacing),
              Text(
                name,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: fontSize,
                  color: color.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandImage extends StatelessWidget {
  const _BrandImage({required this.imageUrl, required this.emoji});

  final String imageUrl;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    if (imageUrl.trim().isEmpty) {
      return _FallbackBrandImage(emoji: emoji);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
     fit: BoxFit.contain,

      placeholder: (context, url) =>
          Center(
            child: CircularProgressIndicator(
            strokeWidth: .5,
              valueColor: AlwaysStoppedAnimation(color.primary),
            ),
          ),
      errorWidget: (context, url, error) =>
          Image.asset(Assets.notFound, fit: BoxFit.cover),
    );
  }
}

class _FallbackBrandImage extends StatelessWidget {
  const _FallbackBrandImage({required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      color: color.primaryContainer.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 14)),
    );
  }
}
