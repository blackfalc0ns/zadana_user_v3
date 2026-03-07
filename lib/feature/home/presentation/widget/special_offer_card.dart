// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/config/theme/spacing.dart';
// import 'package:zadana_user_v3/config/theme/text_styles.dart';
// import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
// import 'package:zadana_user_v3/feature/home/presentation/widget/discount_badge.dart';
// import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';
// import 'package:zadana_user_v3/feature/home/presentation/widget/product_image.dart';

// class SpecialOfferCard extends StatelessWidget {
//   const SpecialOfferCard({
//     super.key,
//     required this.product,
//     this.onAddTap,
//     this.onCardTap,
//   });

//   final ProductModel product;
//   final VoidCallback? onAddTap;
//   final VoidCallback? onCardTap;

//   @override
//   Widget build(BuildContext context) {
//     final cardWidth = MediaQuery.sizeOf(context).width * 0.42;

//     return GestureDetector(
//       onTap: onCardTap,
//       child: SizedBox(
//         width: cardWidth,
//         child: DecoratedBox(
//           decoration: BoxDecoration(
//             color: AppColors.surface,
//             borderRadius: BorderRadius.circular(Spacing.cardRadius),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.shadow,
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(Spacing.cardRadius),
//             child: Column(
//               mainAxisSize: MainAxisSize.min, // ✅ يمنع التمدد الزيادة
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── Image — 1:1 ────────────────────────────────
//                 AspectRatio(
//                   aspectRatio: 1.0,
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       ProductImage(
//                         url: product.imageUrl,
//                         width: double.infinity,
//                         height: double.infinity,
//                         borderRadius: 0,
//                         fit: BoxFit.cover,
//                       ),
//                       if (product.discount != null)
//                         Positioned(
//                           top: 8,
//                           left: 8,
//                           child: DiscountBadge(label: product.discount!),
//                         ),
//                     ],
//                   ),
//                 ),

//                 // ── Info (compact) ─────────────────────────────
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(
//                     Spacing.sm,
//                     6, // كان 4 -> خليه 6 بس بشكل متوازن
//                     Spacing.sm,
//                     6, // ✅ يقلل الفراغ تحت
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         style: AppTextStyles.labelMedium.copyWith(
//                           height: 1.1, // ✅ يقلل ارتفاع السطر
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                       const SizedBox(height: 2),

//                       Text(
//                         product.store,
//                         style: AppTextStyles.bodySmall.copyWith(
//                           fontSize: 10,
//                           height: 1.1, // ✅ يقلل ارتفاع السطر
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                       const SizedBox(height: 6),

//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // ── Prices ─────────────────────────
//                           Expanded(
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 PriceText(
//                                   price: product.price,
//                                   style: AppTextStyles.labelMedium.copyWith(
//                                     color: AppColors.primary,
//                                     fontWeight: FontWeight.w700,
//                                     height: 1.0,
//                                   ),
//                                 ),
//                                 if (product.oldPrice != null) ...[
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     '\$${product.oldPrice!.toStringAsFixed(2)}',
//                                     style: AppTextStyles.bodySmall.copyWith(
//                                       decoration: TextDecoration.lineThrough,
//                                       color: AppColors.textHint,
//                                       fontSize: 10,
//                                       height: 1.0,
//                                     ),
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ),

//                           // ── Cart button ───────────────────
//                           GestureDetector(
//                             onTap: onAddTap,
//                             behavior: HitTestBehavior.opaque,
//                             child: Container(
//                               width: 32,
//                               height: 32,
//                               alignment: Alignment.center,
//                               decoration: const BoxDecoration(
//                                 color: AppColors.primary,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const FaIcon(
//                                 FontAwesomeIcons.cartPlus,
//                                 color: AppColors.white,
//                                 size: 18, // ✅ أكبر شوية ومناسب
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/price_text.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/product_image.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    super.key,
    required this.product,
    this.onAddTap,
    this.onCardTap,
  });

  final ProductModel product;
  final VoidCallback? onAddTap;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
         boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ────────────────────────────────────────────
            ProductImage(
              emoji: product.emoji,       
              url: product.imageUrl,
              width: 150,
              height: 110,
              borderRadius: Spacing.cardRadius,
            ),

            // ── Info ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.sm,
                Spacing.sm,
                Spacing.sm,
                Spacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (product.rating != null)
                  //   RatingRow(
                  //     rating: product.rating!,
                  //     reviewCount: product.reviewCount,
                  //   ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: AppTextStyles.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.store,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriceText(price: product.price, unit: product.unit),
                      GestureDetector(
                        onTap: onAddTap,
                        child: GestureDetector(
                          onTap: onAddTap,
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.cartPlus,
                              color: AppColors.white,
                              size: 15,
                            ),
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
    );
  }
}
