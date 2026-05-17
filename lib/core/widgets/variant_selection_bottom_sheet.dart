import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/product_image.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_variant_option_entity.dart';

/// Bottom sheet that lets the user pick a size/variant before adding to cart.
class VariantSelectionBottomSheet extends StatefulWidget {
  const VariantSelectionBottomSheet({
    super.key,
    required this.productName,
    required this.productImageUrl,
    required this.variants,
    required this.currency,
  });

  final String productName;
  final String productImageUrl;
  final List<ProductVariantOptionEntity> variants;
  final String currency;

  /// Shows the bottom sheet and returns the selected variant, or null if dismissed.
  static Future<ProductVariantOptionEntity?> show(
    BuildContext context, {
    required String productName,
    required String productImageUrl,
    required List<ProductVariantOptionEntity> variants,
    required String currency,
  }) {
    return showModalBottomSheet<ProductVariantOptionEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VariantSelectionBottomSheet(
        productName: productName,
        productImageUrl: productImageUrl,
        variants: variants,
        currency: currency,
      ),
    );
  }

  @override
  State<VariantSelectionBottomSheet> createState() =>
      _VariantSelectionBottomSheetState();
}

class _VariantSelectionBottomSheetState
    extends State<VariantSelectionBottomSheet> {
  ProductVariantOptionEntity? _selected;

  @override
  void initState() {
    super.initState();
    _selected =
        widget.variants.where((v) => v.isCurrent).firstOrNull ??
        widget.variants.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.localization;
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.md,
            Spacing.sm,
            Spacing.md,
            Spacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: Spacing.md),
                  decoration: BoxDecoration(
                    color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Product name
              Text(
                widget.productName,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: 16,
                  color: colors.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                l10n.select_size,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: 13,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.md),
              // Variant list
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.variants.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: Spacing.sm),
                  itemBuilder: (context, index) {
                    final variant = widget.variants[index];
                    final isSelected = _selected?.id == variant.id;
                    final displaySize = isArabic
                        ? variant.displaySizeAr
                        : variant.displaySizeEn;
                    final price = variant.price;

                    return GestureDetector(
                      onTap: () => setState(() => _selected = variant),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.sm + 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : colors.surface,
                          borderRadius: BorderRadius.circular(Spacing.sm + 2),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : colors.outline.withValues(alpha: 0.3),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Radio indicator
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : colors.outline,
                                  width: isSelected ? 6 : 2,
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            // Variant image (small)
                            if (variant.imageUrl != null &&
                                variant.imageUrl!.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: Spacing.sm),
                                child: ProductImage(
                                  url: variant.imageUrl!,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            // Size label
                            Expanded(
                              child: Text(
                                displaySize,
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: 14,
                                  color: isSelected
                                      ? AppColors.primary
                                      : colors.onSurface,
                                ),
                              ),
                            ),
                            // Price
                            if (price != null) ...[
                              if (variant.oldPrice != null &&
                                  variant.isDiscounted)
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    end: Spacing.xs,
                                  ),
                                  child: Text(
                                    '${variant.oldPrice!.toStringAsFixed(variant.oldPrice! == variant.oldPrice!.roundToDouble() ? 0 : 2)} ${widget.currency}',
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: 11,
                                      color: colors.onSurfaceVariant,
                                    ).copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                              Text(
                                '${price.toStringAsFixed(price == price.roundToDouble() ? 0 : 2)} ${widget.currency}',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: 14,
                                  color: isSelected
                                      ? AppColors.primary
                                      : colors.onSurface,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: Spacing.md),
              // Add to cart button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _selected != null
                      ? () => Navigator.of(context).pop(_selected)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.add_to_cart,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 15,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
