import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class CartBottomBar extends StatelessWidget {
  final int itemCount;
  final int totalQuantity;
  final double totalPrice;
  final String selectedVendorName;
  final VoidCallback onCheckout;
  final VoidCallback onCompare;

  const CartBottomBar({
    super.key,
    required this.itemCount,
    required this.totalQuantity,
    required this.totalPrice,
    required this.selectedVendorName,
    required this.onCheckout,
    required this.onCompare,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(Spacing.screenH, Spacing.md, Spacing.screenH,
          Spacing.screenH + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, -4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$itemCount ${l10n.item} • $totalQuantity ${l10n.product}',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.textSecondary)),
              Row(
                children: [
                  Text('${l10n.total}: ',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.textSecondary)),
                  Text('${totalPrice.toStringAsFixed(0)} ج',
                      style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              GestureDetector(
                onTap: onCompare,
                child: Container(
                  height: Spacing.buttonHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(Spacing.buttonRadius),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Text('📊', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(l10n.compare,
                          style: AppTextStyles.button
                              .copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: SizedBox(
                  height: Spacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: onCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Spacing.buttonRadius)),
                      elevation: 0,
                    ),
                    child: Text('${l10n.complete_from} $selectedVendorName',
                        style: AppTextStyles.button),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class CartEmptyState extends StatelessWidget {
//   final VoidCallback onStartShopping;

//   const CartEmptyState({super.key, required this.onStartShopping});

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
    
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: const BoxDecoration(
//                   color: Color(0xFFE0F4F7), shape: BoxShape.circle),
//               child: const Icon(Icons.shopping_cart_outlined,
//                   size: 48, color: AppColors.primary),
//             ),
//             const SizedBox(height: Spacing.lg),
//             Text(l10n.cart_empty,
//                 style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary)),
//             const SizedBox(height: Spacing.sm),
//             Text(l10n.start_shopping_message,
//                 style: AppTextStyles.bodySmall
//                     .copyWith(color: AppColors.textSecondary),
//                 textAlign: TextAlign.center),
//             const SizedBox(height: Spacing.xl),
//             SizedBox(
//               width: 200,
//               height: Spacing.buttonHeight,
//               child: ElevatedButton(
//                 onPressed: onStartShopping,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   foregroundColor: AppColors.textOnPrimary,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(Spacing.buttonRadius)),
//                   elevation: 0,
//                 ),
//                 child: Text(l10n.start_shopping, style: AppTextStyles.button),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
