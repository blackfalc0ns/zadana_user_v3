import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
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
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final shouldShowFallbackImage = !hasImage && icon == null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? color.primary)
              : (backgroundColor ?? color.surfaceContainerLowest),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? color.primary)
                : color.outlineVariant.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: isSelected ? 0.1 : 0.04),
              blurRadius: isSelected ? 6 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasImage) ...[
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: imageUrl!.trim(),
                  //  fit: BoxFit.contain,
                  placeholder: (_, _) => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                  errorWidget: (_, _, _) =>
                      Image.asset(Assets.notFound, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 4),
            ] else if (shouldShowFallbackImage) ...[
              Expanded(
                child: Image.asset(Assets.notFound, fit: BoxFit.contain),
              ),
              const SizedBox(height: 4),
            ] else if (icon != null) ...[
              Text(
                icon!,
                style: TextStyle(
                  fontSize: 22,
                  color: isSelected ? color.onPrimary : color.primary,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              label,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: isSelected ? color.onPrimary : color.onSurface,
              ).copyWith(height: 1.2),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
