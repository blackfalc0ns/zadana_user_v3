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
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Wrap(
        spacing: Spacing.sm,
        runSpacing: Spacing.sm,
        children: variantOptions.map((variant) {
          final displaySize =
              isArabic ? variant.displaySizeAr : variant.displaySizeEn;
          final isCurrent = variant.isCurrent;

          return GestureDetector(
            onTap: isCurrent ? null : () => onVariantSelected?.call(variant),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.sm,
              ),
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : color.surface,
                borderRadius: BorderRadius.circular(Spacing.sm + 2),
                border: Border.all(
                  color: isCurrent
                      ? AppColors.primary
                      : color.outline.withValues(alpha: 0.3),
                  width: isCurrent ? 1.5 : 1,
                ),
              ),
              child: Text(
                displaySize,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: isCurrent ? AppColors.primary : color.onSurface,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
