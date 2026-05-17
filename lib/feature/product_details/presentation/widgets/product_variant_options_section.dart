import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_variant_option_entity.dart';

class ProductVariantOptionsSection extends StatelessWidget {
  const ProductVariantOptionsSection({
    super.key,
    required this.variantOptions,
    this.onVariantSelected,
  });

  final List<ProductVariantOptionEntity> variantOptions;
  final ValueChanged<ProductVariantOptionEntity>? onVariantSelected;

  @override
  Widget build(BuildContext context) {
    if (variantOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = context.colorScheme;
    final isArabic = Localizations.localeOf(
      context,
    ).languageCode.startsWith('ar');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.straighten_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              context.localization.select_size,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
                fontSize: FontSize.size14,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.base),
        Wrap(
          spacing: Spacing.sm,
          runSpacing: Spacing.sm,
          children: variantOptions.map((variant) {
            final isCurrent = variant.isCurrent;
            final label = _buildSizeLabel(variant, isArabic);

            return GestureDetector(
              onTap: isCurrent ? null : () => onVariantSelected?.call(variant),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isCurrent ? AppColors.primary : color.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.primary
                        : color.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  label,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: isCurrent ? Colors.white : color.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Builds a short size label like "زجاجة 1 لتر" or "200 مل"
  String _buildSizeLabel(ProductVariantOptionEntity variant, bool isArabic) {
    final value = variant.measurementValue;
    final unitName = isArabic
        ? variant.measurementUnitNameAr
        : variant.measurementUnitNameEn;

    if (value != null && unitName != null && unitName.isNotEmpty) {
      final formattedValue = value == value.truncateToDouble()
          ? value.toInt().toString()
          : value.toString();

      final displaySize = isArabic
          ? variant.displaySizeAr
          : variant.displaySizeEn;

      // If displaySize already contains the measurement info, use it directly
      if (displaySize.isNotEmpty) {
        return displaySize;
      }

      return '$formattedValue $unitName';
    }

    return isArabic ? variant.displaySizeAr : variant.displaySizeEn;
  }
}
