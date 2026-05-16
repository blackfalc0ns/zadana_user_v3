import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/product_display_size_extension.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

/// Displays the product size/package info as a compact tag.
///
/// Shows the resolved display size text (from API or built from components).
/// Returns [SizedBox.shrink] if no size info is available.
class ProductSizeSummary extends StatelessWidget {
  const ProductSizeSummary({
    super.key,
    required this.product,
    this.fontSize = 9.5,
    this.compact = false,
  });

  final ProductModel product;
  final double fontSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    final sizeText =
        isArabic ? product.resolvedDisplaySizeAr : product.resolvedDisplaySizeEn;

    if (sizeText == null || sizeText.isEmpty) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return Text(
        sizeText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: getRegularStyle(
          fontFamily: FontConstant.cairo,
          fontSize: fontSize,
          color: AppColors.textSecondary,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        sizeText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: getMediumStyle(
          fontFamily: FontConstant.cairo,
          fontSize: fontSize,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
