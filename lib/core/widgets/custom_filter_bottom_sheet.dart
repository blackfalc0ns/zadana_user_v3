import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CustomFilterBottomSheet extends StatefulWidget {
  const CustomFilterBottomSheet({
    super.key,
    this.title,
    this.cancelLabel,
    this.clearAllLabel,
    this.applyLabel,
    this.children = const [],
    this.scrollController,
    this.onApply,
    this.onClearAll,
  });

  final String? title;
  final String? cancelLabel;
  final String? clearAllLabel;
  final String? applyLabel;
  final List<Widget> children;
  final ScrollController? scrollController;
  final VoidCallback? onApply;
  final VoidCallback? onClearAll;

  @override
  State<CustomFilterBottomSheet> createState() =>
      _CustomFilterBottomSheetState();
}

class _CustomFilterBottomSheetState extends State<CustomFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final l10n = context.localization;
    final resolvedTitle = widget.title ?? l10n.filter_title;
    final resolvedCancelLabel = widget.cancelLabel ?? l10n.cancel;
    final resolvedClearAllLabel = widget.clearAllLabel ?? l10n.clear_all;
    final resolvedApplyLabel = widget.applyLabel ?? l10n.apply;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SelectionArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.78,
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.sm,
                    Spacing.lg,
                    Spacing.sm,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: color.outlineVariant,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              resolvedCancelLabel,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: color.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              resolvedTitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.h3.copyWith(
                                color: color.onSurface,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: widget.onClearAll,
                            child: Text(
                              resolvedClearAllLabel,
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                color: color.error,
                                fontSize: FontSize.size14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: widget.scrollController,
                    padding: EdgeInsets.fromLTRB(
                      Spacing.lg,
                      Spacing.md,
                      Spacing.lg,
                      110 + bottomInset,
                    ),
                    children: widget.children,
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  Spacing.lg,
                  Spacing.md,
                  Spacing.lg,
                  Spacing.md + bottomInset,
                ),
                decoration: BoxDecoration(
                  color: color.surface,
                  border: Border(
                    top: BorderSide(
                      color: color.outlineVariant.withValues(alpha: 0.45),
                    ),
                  ),
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
                    resolvedApplyLabel,
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
