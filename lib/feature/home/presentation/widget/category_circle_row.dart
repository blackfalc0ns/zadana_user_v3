// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/config/theme/spacing.dart';
// import 'package:zadana_user_v3/config/theme/text_styles.dart';

// // ── Model ─────────────────────────────────────────────────────────
// class CategoryCircleModel {
//   final String id;
//   final String name;
//   final String imageAsset;
//   final String emoji; // fallback

//   const CategoryCircleModel({
//     required this.id,
//     required this.name,
//     required this.imageAsset,
//     required this.emoji,
//   });
// }

// // ── Dummy data ────────────────────────────────────────────────────
// const List<CategoryCircleModel> kHomeCategories = [
//   CategoryCircleModel(id: 'hc1', name: 'خضروات',   imageAsset: 'assets/images/categories/vegetables.png',    emoji: '🥦'),
//   CategoryCircleModel(id: 'hc2', name: 'ألبان',     imageAsset: 'assets/images/categories/dairy.png',         emoji: '🥛'),
//   CategoryCircleModel(id: 'hc3', name: 'مخبوزات',   imageAsset: 'assets/images/categories/bakery.png',        emoji: '🍞'),
//   CategoryCircleModel(id: 'hc4', name: 'لحوم',      imageAsset: 'assets/images/categories/meat.png',          emoji: '🥩'),
//   CategoryCircleModel(id: 'hc5', name: 'مشروبات',   imageAsset: 'assets/images/categories/beverages.png',     emoji: '🧃'),
//   CategoryCircleModel(id: 'hc6', name: 'منزلية',    imageAsset: 'assets/images/categories/household.png',     emoji: '🧴'),
//   CategoryCircleModel(id: 'hc7', name: 'عناية',     imageAsset: 'assets/images/categories/personal_care.png', emoji: '🧼'),
//   CategoryCircleModel(id: 'hc8', name: 'سناكس',     imageAsset: 'assets/images/categories/snacks.png',        emoji: '🍿'),
// ];

// // ── Single circle item ────────────────────────────────────────────
// class CategoryCircleItem extends StatelessWidget {
//   const CategoryCircleItem({
//     super.key,
//     required this.category,
//     this.onTap,
//     this.size = 64,
//   });

//   final CategoryCircleModel category;
//   final VoidCallback? onTap;
//   final double size; // قطر الدايرة

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: SizedBox(
//         width: size + 12,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ── Circle ────────────────────────────────────────
//             Container(
//               width: size,
//               height: size,
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: AppColors.border, width: 1),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.shadow,
//                     blurRadius: 6,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(10),
//               child: Image.asset(
//                 category.imageAsset,
//                 fit: BoxFit.contain,
//                 errorBuilder: (_, __, ___) => Center(
//                   child: Text(
//                     category.emoji,
//                     style: TextStyle(fontSize: size * 0.40),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 6),

//             // ── Name ──────────────────────────────────────────
//             Text(
//               category.name,
//               style: AppTextStyles.bodySmall.copyWith(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.textPrimary,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Horizontal row of circles ─────────────────────────────────────
// class CategoryCircleRow extends StatelessWidget {
//   const CategoryCircleRow({
//     super.key,
//     required this.categories,
//     this.onCategoryTap,
//     this.circleSize = 64,
//   });

//   final List<CategoryCircleModel> categories;
//   final void Function(CategoryCircleModel)? onCategoryTap;
//   final double circleSize;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: circleSize + 38, // circle + label + spacing
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
//         itemBuilder: (_, i) => CategoryCircleItem(
//           category: categories[i],
//           size: circleSize,
//           onTap: () => onCategoryTap?.call(categories[i]),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

// ── Model ─────────────────────────────────────────────────────────
class CategoryCircleModel {
  final String id;
  final String name;
  final String imageAsset;
  final String emoji; // fallback

  const CategoryCircleModel({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.emoji,
  });
}

// ── Dummy data ────────────────────────────────────────────────────
const List<CategoryCircleModel> kHomeCategories = [
  CategoryCircleModel(id: 'hc1', name: 'خضروات',   imageAsset: 'assets/images/categories/vegetables.png',    emoji: '🥦'),
  CategoryCircleModel(id: 'hc2', name: 'ألبان',     imageAsset: 'assets/images/categories/dairy.png',         emoji: '🥛'),
  CategoryCircleModel(id: 'hc3', name: 'مخبوزات',   imageAsset: 'assets/images/categories/bakery.png',        emoji: '🍞'),
  CategoryCircleModel(id: 'hc4', name: 'لحوم',      imageAsset: 'assets/images/categories/meat.png',          emoji: '🥩'),
  CategoryCircleModel(id: 'hc5', name: 'مشروبات',   imageAsset: 'assets/images/categories/beverages.png',     emoji: '🧃'),
  CategoryCircleModel(id: 'hc6', name: 'منزلية',    imageAsset: 'assets/images/categories/household.png',     emoji: '🧴'),
  CategoryCircleModel(id: 'hc7', name: 'عناية',     imageAsset: 'assets/images/categories/personal_care.png', emoji: '🧼'),
  CategoryCircleModel(id: 'hc8', name: 'سناكس',     imageAsset: 'assets/images/categories/snacks.png',        emoji: '🍿'),
];

// ── Single circle item ────────────────────────────────────────────
class CategoryCircleItem extends StatelessWidget {
  const CategoryCircleItem({
    super.key,
    required this.category,
    this.onTap,
    this.size = 64,
  });

  final CategoryCircleModel category;
  final VoidCallback? onTap;
  final double size; // قطر الدايرة

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size + 12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Circle ────────────────────────────────────────
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  category.emoji,
                  style: TextStyle(fontSize: size * 0.42),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ── Name ──────────────────────────────────────────
            Text(
              category.name,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Horizontal row of circles ─────────────────────────────────────
class CategoryCircleRow extends StatelessWidget {
  const CategoryCircleRow({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.circleSize = 64,
  });

  final List<CategoryCircleModel> categories;
  final void Function(CategoryCircleModel)? onCategoryTap;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: circleSize + 38, // circle + label + spacing
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
        itemBuilder: (_, i) => CategoryCircleItem(
          category: categories[i],
          size: circleSize,
          onTap: () => onCategoryTap?.call(categories[i]),
        ),
      ),
    );
  }
}