import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/discount_badge.dart';

class ModernStoreCard extends StatelessWidget {
  final String storeName;
  final double price;
  final double? oldPrice;
  final bool isLowest;
  final IconData icon;
  final List<Color> gradientColors;
  final String? savings;
  final int discountPercentage;
  final bool isDiscounted;
  final String? storeImage;

  const ModernStoreCard({
    super.key,
    required this.storeName,
    required this.price,
    this.oldPrice,
    required this.isLowest,
    required this.icon,
    required this.gradientColors,
    this.savings,
    required this.discountPercentage,
    required this.isDiscounted,
    this.storeImage,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = isDiscounted && oldPrice != null && oldPrice! > price;
    final color = context.colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.outline.withValues(alpha: 0.4),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Store logo/image
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isLowest
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isLowest
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                  child: storeImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            storeImage!,
                            fit: BoxFit.contain,
                            width: 40,
                            height: 40,
                          ),
                        )
                      : Icon(
                          icon,
                          color: isLowest
                              ? AppColors.primary
                              : Colors.grey.shade600,
                          size: 20,
                        ),
                ),

                const SizedBox(height: 10),

                // Store name
                Text(
                  storeName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isLowest ? AppColors.primary : AppColors.textPrimary,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Price section with better layout
                if (hasDiscount) ...[
                  // New price - prominent (on top)
                  Row(
                    spacing: 5,
                    children: [
                      Text(
                        '${oldPrice!.toStringAsFixed(0)} ر.س',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.textSecondary.withValues(
                            alpha: 0.5,
                          ),
                          decorationThickness: 2,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            price.toStringAsFixed(0),
                            style: TextStyle(
                              color: isLowest
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'ر.س',
                            style: TextStyle(
                              color: isLowest
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ] else ...[
                  // Regular price without discount
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        price.toStringAsFixed(0),
                        style: TextStyle(
                          color: isLowest
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'ر.س',
                        style: TextStyle(
                          color: isLowest
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),

        if (hasDiscount)
          Positioned(
            left: 0,
            child: DiscountBadge(
              discountText: '$discountPercentage%',
              shadowColor: color.shadow,
            ),
          ),
      ],
    );
  }
}
