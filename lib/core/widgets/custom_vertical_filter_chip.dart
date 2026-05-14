import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CustomVerticalFilterChip extends StatelessWidget {
  const CustomVerticalFilterChip({
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

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth;
        final itemHeight = constraints.maxHeight;
        final compact = itemWidth < 84;
        final ultraCompact = itemHeight.isFinite && itemHeight < 68;
        final iconSize = ultraCompact ? 16.0 : (compact ? 18.0 : 22.0);
        final imageSize = ultraCompact ? 22.0 : (compact ? 26.0 : 32.0);
        final labelFontSize = ultraCompact
            ? FontSize.size10
            : (compact ? FontSize.size11 : FontSize.size12);
        final contentPadding = EdgeInsets.symmetric(
          horizontal: ultraCompact ? 3 : (compact ? 4 : 6),
          vertical: ultraCompact ? 4 : (compact ? 6 : 8),
        );
        final spacing = ultraCompact ? 2.0 : (compact ? 4.0 : 6.0);
        final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
        final shouldShowFallbackImage = !hasImage && icon == null;

        Widget fallbackImage() {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              Assets.notFound,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          );
        }

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: contentPadding,
            decoration: BoxDecoration(
              color: isSelected
                  ? (selectedColor ?? color.primary)
                  : (backgroundColor ?? color.surfaceContainerLowest),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? (selectedColor ?? color.primary)
                    : color.outlineVariant,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(
                    alpha: isSelected ? 0.12 : 0.06,
                  ),
                  blurRadius: isSelected ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasImage) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!.trim(),
                      width: imageSize,
                      height: imageSize,
                      //fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        Assets.notFound,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        Assets.notFound,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),
                ] else if (shouldShowFallbackImage) ...[
                  fallbackImage(),
                  SizedBox(height: spacing),
                ] else if (icon != null) ...[
                  Text(
                    icon!,
                    style: TextStyle(
                      fontSize: iconSize,
                      color: isSelected ? color.onPrimary : color.primary,
                    ),
                  ),
                  SizedBox(height: spacing),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: labelFontSize,
                      color: isSelected ? color.onPrimary : color.onSurface,
                    ).copyWith(height: ultraCompact ? 1.15 : 1.25),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
