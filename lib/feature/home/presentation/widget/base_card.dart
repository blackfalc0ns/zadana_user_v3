import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

/// Base card with favorite button at top-right
/// and content widget at bottom-left
class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    required this.child,
    this.width,
    this.showFavorite = false,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onCardTap,
  });

  final Widget child;
  final double? width;
  final bool showFavorite;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            // Content at bottom-left
            child,

            // Favorite button at top-right
            if (showFavorite)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16,
                      color: isFavorite
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
