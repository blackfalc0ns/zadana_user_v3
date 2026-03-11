import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/category_circle_row.dart';

/// Bottom sheet لاستكشاف الفئات (صورة 3)
class CategoryBrowserSheet extends StatelessWidget {
  const CategoryBrowserSheet({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  final List<CategoryCircleModel> categories;
  final ValueChanged<CategoryCircleModel> onCategorySelected;

  static Future<void> show(
    BuildContext context, {
    required List<CategoryCircleModel> categories,
    required ValueChanged<CategoryCircleModel> onCategorySelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (_) => CategoryBrowserSheet(
        categories: categories,
        onCategorySelected: onCategorySelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: screenH * 0.80,
        child: Column(
          children: [
            // ── Handle ────────────────────────────────────────
            const SizedBox(height: Spacing.sm),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ── Header ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.screenH, Spacing.base,
                Spacing.screenH, Spacing.base,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('استكشف الفئات', style: AppTextStyles.h4),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── Grid of categories ────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(Spacing.base),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: Spacing.base,
                  crossAxisSpacing: Spacing.base,
                  childAspectRatio: 0.85,
                ),
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onCategorySelected(cat);
                    },
                    child: Column(
                      children: [
                        // Image tile
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(Spacing.cardRadius),
                              border: Border.all(color: AppColors.border),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                cat.emoji,
                                style: const TextStyle(fontSize: 36),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat.name,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}