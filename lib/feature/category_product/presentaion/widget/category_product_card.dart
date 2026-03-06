import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'category_product_model.dart';

class CategoryProductCard extends StatefulWidget {
  const CategoryProductCard({
    super.key,
    required this.product,
    this.onAddTap,
    this.onFavTap,
    this.onCardTap,
  });

  final CategoryProductModel product;
  final VoidCallback? onAddTap;
  final VoidCallback? onFavTap;
  final VoidCallback? onCardTap;

  @override
  State<CategoryProductCard> createState() => _CategoryProductCardState();
}

class _CategoryProductCardState extends State<CategoryProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onCardTap?.call();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(color: AppColors.border),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image + fav ───────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    // White background image
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Spacing.cardRadius),
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          product.emoji,
                          style: const TextStyle(fontSize: 52),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Image.network(
                      //   product.imageUrl,
                      //   fit: BoxFit.contain,
                      //   loadingBuilder: (_, child, progress) => progress == null
                      //       ? child
                      //       : const Center(
                      //           child: SizedBox(
                      //             width: 24,
                      //             height: 24,
                      //             child: CircularProgressIndicator(
                      //               strokeWidth: 2,
                      //               color: AppColors.primary,
                      //             ),
                      //           ),
                      //         ),
                      //   errorBuilder: (_, __, ___) => const Center(
                      //     child: Icon(
                      //       Icons.image_not_supported_outlined,
                      //       color: AppColors.textHint,
                      //       size: 36,
                      //     ),
                      //   ),
                      // ),
                    ),

                    // Favorite
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: widget.onFavTap,
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: product.isFavorite
                              ? AppColors.error
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.sm,
                  Spacing.xs,
                  Spacing.sm,
                  Spacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.labelMedium.copyWith(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Prices
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${product.price.toStringAsFixed(2)} ريال',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              if (product.oldPrice != null)
                                Text(
                                  '${product.oldPrice!.toStringAsFixed(2)} ريال',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.textHint,
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Add button
                        GestureDetector(
                          onTap: widget.onAddTap,
                          child: Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child:  FaIcon(
                              FontAwesomeIcons.cartPlus,
                              color: AppColors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
