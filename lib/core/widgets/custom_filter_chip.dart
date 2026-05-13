import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CustomFilterChip extends StatelessWidget {
  const CustomFilterChip({
    super.key,
    required this.label,
    this.icon,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.borderColor,
    this.textStyle,
  });

  final String label;
  final String? icon;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  String? _normalizedImageUrl() {
    final rawUrl = imageUrl?.trim();
    if (rawUrl == null || rawUrl.isEmpty) {
      return null;
    }

    return Uri.encodeFull(rawUrl);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final normalizedImageUrl = _normalizedImageUrl();
    final hasImage = normalizedImageUrl != null;
    final shouldShowFallbackImage = !hasImage && icon == null;

    Widget fallbackImage() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Image.asset(
          Assets.notFound,
          width: 18,
          height: 18,
          fit: BoxFit.cover,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),

          color: isSelected
              ? (selectedColor ?? color.primary)
              : (backgroundColor ?? AppColors.white),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: CachedNetworkImage(
                  imageUrl: normalizedImageUrl,
                  width: 30,
                  height: 30,
                
                  placeholder: (context, url) => SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color.primary,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    Assets.notFound,
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ] else if (shouldShowFallbackImage) ...[
              fallbackImage(),
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              Text(icon!, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 3),
            ],
            Text(
              label,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                color: isSelected ? color.onPrimary : color.onSurface,
              ).merge(textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
