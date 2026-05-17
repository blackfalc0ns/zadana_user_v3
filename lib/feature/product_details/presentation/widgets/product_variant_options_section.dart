import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_variant_option_entity.dart';

class ProductVariantOptionsSection extends StatefulWidget {
  const ProductVariantOptionsSection({
    super.key,
    required this.variantOptions,
    this.onVariantSelected,
  });

  final List<ProductVariantOptionEntity> variantOptions;
  final ValueChanged<ProductVariantOptionEntity>? onVariantSelected;

  @override
  State<ProductVariantOptionsSection> createState() =>
      _ProductVariantOptionsSectionState();
}

class _ProductVariantOptionsSectionState
    extends State<ProductVariantOptionsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  int? _tappedIndex;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _onTapDown(int index) {
    setState(() => _tappedIndex = index);
    _bounceController.forward();
  }

  void _onTapUp(int index, ProductVariantOptionEntity variant) {
    _bounceController.reverse().then((_) {
      if (mounted) setState(() => _tappedIndex = null);
    });
    widget.onVariantSelected?.call(variant);
  }

  void _onTapCancel() {
    _bounceController.reverse().then((_) {
      if (mounted) setState(() => _tappedIndex = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variantOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = context.colorScheme;
    final isArabic =
        Localizations.localeOf(context).languageCode.startsWith('ar');
    final currentIndex =
        widget.variantOptions.indexWhere((v) => v.isCurrent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
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
        const SizedBox(height: Spacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.outline.withValues(alpha: 0.08),
                ),
              ),
              child: Stack(
                children: [
                  // Animated sliding indicator
                  if (currentIndex >= 0)
                    AnimatedPositionedDirectional(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutBack,
                      start: currentIndex *
                          ((constraints.maxWidth - 8) /
                              widget.variantOptions.length),
                      top: 0,
                      bottom: 0,
                      width: (constraints.maxWidth - 8) /
                          widget.variantOptions.length,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.85),
                            ],
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Variant labels
                  Row(
                    children: List.generate(
                      widget.variantOptions.length,
                      (index) {
                        final variant = widget.variantOptions[index];
                        final isCurrent = variant.isCurrent;
                        final sizeLabel =
                            _buildSizeLabel(variant, isArabic);
                        final isTapped = _tappedIndex == index;

                        return Expanded(
                          child: GestureDetector(
                            onTapDown: isCurrent
                                ? null
                                : (_) => _onTapDown(index),
                            onTapUp: isCurrent
                                ? null
                                : (_) => _onTapUp(index, variant),
                            onTapCancel: isCurrent ? null : _onTapCancel,
                            child: AnimatedBuilder(
                              animation: _bounceAnimation,
                              builder: (context, child) {
                                final scale =
                                    isTapped ? _bounceAnimation.value : 1.0;
                                return Transform.scale(
                                  scale: scale,
                                  child: child,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Spacing.sm + 4,
                                ),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration:
                                        const Duration(milliseconds: 250),
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.cairo,
                                      color: isCurrent
                                          ? Colors.white
                                          : color.onSurfaceVariant,
                                      fontSize: FontSize.size13,
                                    ),
                                    child: Text(
                                      sizeLabel,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// Builds a short size label like "1 لتر" or "200 مل"
  String _buildSizeLabel(ProductVariantOptionEntity variant, bool isArabic) {
    final value = variant.measurementValue;
    final unitName = isArabic
        ? variant.measurementUnitNameAr
        : variant.measurementUnitNameEn;

    if (value != null && unitName != null && unitName.isNotEmpty) {
      final formattedValue = value == value.truncateToDouble()
          ? value.toInt().toString()
          : value.toString();
      return '$formattedValue $unitName';
    }

    return isArabic ? variant.displaySizeAr : variant.displaySizeEn;
  }
}
