import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_option_item.dart';

class CustomSortBottomSheet extends StatefulWidget {
  const CustomSortBottomSheet({
    super.key,
    this.selectedSortOption,
    required this.sortOptions,
    this.title,
    this.cancelLabel,
    this.applyLabel,
  });

  final String? selectedSortOption;
  final List<Map<String, dynamic>> sortOptions;
  final String? title;
  final String? cancelLabel;
  final String? applyLabel;

  @override
  State<CustomSortBottomSheet> createState() => _CustomSortBottomSheetState();
}

class _CustomSortBottomSheetState extends State<CustomSortBottomSheet> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedSortOption;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final l10n = context.localization;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final resolvedTitle = widget.title ?? l10n.sort_title;
    final resolvedCancelLabel = widget.cancelLabel ?? l10n.cancel;
    final resolvedApplyLabel = widget.applyLabel ?? l10n.apply;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final startAction = Expanded(
      child: Align(
        alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            resolvedCancelLabel,
            style: AppTextStyles.bodyMedium.copyWith(
              color: color.onSurface,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
    final endAction = Expanded(
      child: Align(
        alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
        child: TextButton(
          onPressed: () => Navigator.pop(context, selectedOption),
          child: Text(
            resolvedApplyLabel,
            style: AppTextStyles.bodyMedium.copyWith(
              color: color.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.58,
          minHeight: screenHeight * 0.36,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 52,
              height: 6,
              decoration: BoxDecoration(
                color: color.surfaceContainerHighest.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.lg, 14, Spacing.lg, 6),
              child: Row(
                children: [
                  if (!isRtl) startAction else endAction,
                  Expanded(
                    flex: 2,
                    child: Text(
                      resolvedTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h3.copyWith(
                        color: color.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (!isRtl) endAction else startAction,
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  Spacing.xl,
                  8,
                  Spacing.xl,
                  bottomInset + Spacing.lg,
                ),
                itemCount: widget.sortOptions.length,
                itemBuilder: (context, index) {
                  final option = widget.sortOptions[index];
                  final isSelected = selectedOption == option['value'];

                  return CustomSortOptionItem(
                    title: option['title'] ?? '',
                    subtitle: option['subtitle'],
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedOption = option['value'];
                      });
                    },
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
