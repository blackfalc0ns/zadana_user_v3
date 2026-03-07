// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/config/theme/spacing.dart';
// import 'package:zadana_user_v3/config/theme/text_styles.dart';
// import 'package:zadana_user_v3/feature/category/domain/entities/category_model.dart';

// class CategoryCard extends StatefulWidget {
//   const CategoryCard({
//     super.key,
//     required this.category,
//     required this.onTap,
//     required this.animationDelay,
//     required this.parentAnimation,
//   });

//   final CategoryModel category;
//   final VoidCallback onTap;
//   final Duration animationDelay;
//   final AnimationController parentAnimation;

//   @override
//   State<CategoryCard> createState() => _CategoryCardState();
// }

// class _CategoryCardState extends State<CategoryCard>
//     with SingleTickerProviderStateMixin {
//   // ── Press animation ───────────────────────────────────────────
//   late final AnimationController _pressCtrl;
//   late final Animation<double> _scaleAnim;

//   // ── Stagger animation ─────────────────────────────────────────
//   late final Animation<double> _fadeAnim;
//   late final Animation<Offset> _slideAnim;

//   @override
//   void initState() {
//     super.initState();

//     // Press
//     _pressCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//       lowerBound: 0.0,
//       upperBound: 1.0,
//     );
//     _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
//       CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
//     );

//     // Stagger — delay based on card index
//     final start = widget.animationDelay.inMilliseconds / 800.0;
//     final end = (start + 0.4).clamp(0.0, 1.0);

//     _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: widget.parentAnimation,
//         curve: Interval(start, end, curve: Curves.easeOut),
//       ),
//     );
//     _slideAnim = Tween<Offset>(
//       begin: const Offset(0, 0.12),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: widget.parentAnimation,
//         curve: Interval(start, end, curve: Curves.easeOut),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _pressCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fadeAnim,
//       child: SlideTransition(
//         position: _slideAnim,
//         child: GestureDetector(
//           onTapDown: (_) => _pressCtrl.forward(),
//           onTapUp: (_) {
//             _pressCtrl.reverse();
//             widget.onTap();
//           },
//           onTapCancel: () => _pressCtrl.reverse(),
//           child: ScaleTransition(
//             scale: _scaleAnim,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(Spacing.cardRadius),
//               child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.surface,
//                 borderRadius: BorderRadius.circular(Spacing.cardRadius),
//                 border: Border.all(
//                   color: AppColors.border,
//                   width: 1,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.shadow,
//                     blurRadius: 6,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // ── Image area — white background ─────────────
//                   Expanded(
//                     child: Container(
//                       color: AppColors.white,
//                       child: _buildImage(),
//                     ),
//                   ),

//                   // ── Label ─────────────────────────────────────
//                   Container(
//                     color: AppColors.surface,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: Spacing.sm,
//                       vertical: Spacing.sm,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           widget.category.name,
//                           style: AppTextStyles.labelMedium,
//                           textAlign: TextAlign.center,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ));
//   }

//   Widget _buildImage() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Center(
//           child: Text(
//             widget.category.emoji,
//             style: TextStyle(
//               fontSize: (constraints.maxHeight * 0.50).clamp(40, 72),
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       },
//     );
//   }
// }