// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/config/theme/spacing.dart';
// import 'package:zadana_user_v3/config/theme/text_styles.dart';
// import 'package:zadana_user_v3/core/constants/app_constants.dart';

// class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const HomeAppBar({
//     super.key,
//     required this.deliverToLabel,
//     required this.location,
//     this.onLocationTap,
//   });

//   final String deliverToLabel;
//   final String location;
//   final VoidCallback? onLocationTap;

//   @override
//   Size get preferredSize => const Size.fromHeight(56);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.surface,
//       elevation: 0,
//       child: SafeArea(
//         bottom: false,
//         child: SizedBox(
//           height: preferredSize.height,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
//             child: Row(
//               children: [
//                 // ── Left: Address (fully left) ─────────────────────
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: GestureDetector(
//                       onTap: onLocationTap,
//                       behavior: HitTestBehavior.opaque,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.location_on_rounded,
//                             color: AppColors.primary,
//                             size: 18,
//                           ),
//                           const SizedBox(width: 6),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 deliverToLabel,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: AppTextStyles.bodySmall.copyWith(
//                                   color: AppColors.textSecondary,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Flexible(
//                                     child: Text(
//                                       location,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: AppTextStyles.labelMedium,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 2),
//                                   const Icon(
//                                     Icons.keyboard_arrow_down_rounded,
//                                     size: 16,
//                                     color: AppColors.textPrimary,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // ── Right: Logo (small, right) ─────────────────────
//                 Align(alignment: AlignmentGeometry.directional(0, 0),
//                  // alignment: Alignment.centerRight,
//                   child: Image.asset(
//                     AppConstants.logoDark,
//                     height: 26, // صغير
//                     fit: BoxFit.contain,
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
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.deliverToLabel,
    required this.location,
    this.onLocationTap,
  });

  final String deliverToLabel;
  final String location;
  final VoidCallback? onLocationTap;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: Spacing.screenH,
            ),
            child: Row(
              children: [
                Image.asset(
                  AppConstants.logoDark,
                  height: 26,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onLocationTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            deliverToLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 140,
                                ),
                                child: Text(
                                  location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.labelMedium,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: AppColors.textPrimary,
                              ),
                            ],
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
      ),
    );
  }
}
