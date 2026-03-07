// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/config/theme/text_styles.dart';

// class RatingRow extends StatelessWidget {
//   const RatingRow({
//     super.key,
//     required this.rating,
//     this.reviewCount,
//   });

//   final double rating;
//   final int? reviewCount;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Icon(Icons.star_rounded, color: AppColors.starFilled, size: 14),
//         const SizedBox(width: 2),
//         Text(
//           rating.toStringAsFixed(1),
//           style: AppTextStyles.bodySmall.copyWith(
//             color: AppColors.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 11,
//           ),
//         ),
//         if (reviewCount != null) ...[
//           const SizedBox(width: 2),
//           Text(
//             '($reviewCount)',
//             style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
//           ),
//         ],
//       ],
//     );
//   }
// }
