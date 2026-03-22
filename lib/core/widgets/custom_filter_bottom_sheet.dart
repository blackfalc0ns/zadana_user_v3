import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CustomFilterBottomSheet extends StatefulWidget {
  const CustomFilterBottomSheet({
    super.key,
    this.title = 'فلتر المنتجات',
    this.cancelLabel = 'إلغاء',
    this.clearAllLabel = 'مسح الكل',
    this.applyLabel = 'تطبيق',
    this.children = const [],
    this.scrollController,
    this.onApply,
    this.onClearAll,
  });

  final String title;
  final String cancelLabel;
  final String clearAllLabel;
  final String applyLabel;
  final List<Widget> children;
  final ScrollController? scrollController;
  final VoidCallback? onApply;
  final VoidCallback? onClearAll;

  @override
  State<CustomFilterBottomSheet> createState() => _CustomFilterBottomSheetState();
}

class _CustomFilterBottomSheetState extends State<CustomFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SelectionArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          widget.cancelLabel,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(widget.title, style: AppTextStyles.h3),
                      TextButton(
                        onPressed: widget.onClearAll,
                        child: Text(
                          widget.clearAllLabel,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: color.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.all(Spacing.lg),
                    children: [
                      ...widget.children,
                      const SizedBox(height: 120), // مساحة للزر
                    ],
                  ),
                ),
              ],
            ),

            // Apply Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  color: color.surface,
                ),
                child: ElevatedButton(
                  onPressed: widget.onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: color.onPrimary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.applyLabel,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: color.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
