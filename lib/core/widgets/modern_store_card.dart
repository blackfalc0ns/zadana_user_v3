import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';
import 'package:zadana_user_v3/core/widgets/discount_badge.dart';

class ModernStoreCard extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final hasDiscount = isDiscounted && oldPrice != null && oldPrice! > price;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: color.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLowest
                  ? color.primary.withValues(alpha: 0.28)
                  : color.outlineVariant,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: color.shadow.withValues(alpha: 0.08),
            //     blurRadius: 8,
            //     offset: const Offset(0, 3),
            //   ),
            // ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StoreLogo(
                storeImage: storeImage,
                icon: icon,
                isLowest: isLowest,
              ),
              const SizedBox(height: 8),
              Text(
                storeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: color.onSurfaceVariant,
                  fontSize: FontSize.size14,
                ),
              ),
              const SizedBox(height: 8),
              if (hasDiscount) ...[
                Text(
                  '${PriceFormatter.formatPrice(oldPrice!)} ${locale.currency}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: color.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                    fontFamily: 'Cairo',
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
              ] else
                const SizedBox(height: 14),
              Text(
                '${PriceFormatter.formatPrice(price)} ${locale.currency}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getBoldStyle(fontFamily: FontConstant.cairo, color: AppColors.primary, fontSize: 14),
              ),
            ],
          ),
        ),
        if (hasDiscount && discountPercentage > 0)
          Positioned(
            left: 0,
            top: 0,
            child: DiscountBadge(
              discountText: '$discountPercentage%',
              color: color.error,
              shadowColor: color.shadow,
              trianglesize: 34,
              fontSize: 10,
              cornerRadius: 8,
              bottomLeftRadius: 6,
            ),
          ),
      ],
    );
  }
}

class _StoreLogo extends StatelessWidget {
  const _StoreLogo({
    required this.storeImage,
    required this.icon,
    required this.isLowest,
  });

  final String? storeImage;
  final IconData icon;
  final bool isLowest;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final hasStoreImage = storeImage?.trim().isNotEmpty ?? false;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isLowest ? color.primaryContainer : color.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isLowest
              ? color.primary.withValues(alpha: 0.24)
              : color.outlineVariant,
        ),
      ),
      child: hasStoreImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: storeImage??"",
                
                width: 36,
                height: 36,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isLowest
                          ? color.primary
                          : color.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  Assets.notFound,
                  fit: BoxFit.cover,
                  width: 36,
                  height: 36,
                ),
              ),
            )
          : Image.asset(
              Assets.notFound,
              fit: BoxFit.cover,
              width: 36,
              height: 36,
            ),
    );
  }
}
