import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_button.dart';

class CustomBottomFilterButtons extends StatelessWidget {
  const CustomBottomFilterButtons({
    super.key,
    this.onSortPressed,
    this.onFilterPressed,
    this.hasActiveFilters = false,
    this.sortLabel,
    this.filterLabel,
  });

  final VoidCallback? onSortPressed;
  final VoidCallback? onFilterPressed;
  final bool hasActiveFilters;
  final String? sortLabel;
  final String? filterLabel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final resolvedFilterLabel =
        filterLabel ?? context.localization.filter_button;
    final resolvedSortLabel = sortLabel ?? context.localization.sort_button;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      width: 240,
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Expanded(
              child: CustomFilterButton(
                icon: Icons.tune_rounded,
                label: resolvedFilterLabel,
                onTap: onFilterPressed ?? () {},
              ),
            ),
            Container(
              width: 1,
              height: 22,
              color: color.onPrimary.withValues(alpha: 0.6),
            ),
            Expanded(
              child: CustomFilterButton(
                icon: Icons.sort_rounded,
                label: resolvedSortLabel,
                onTap: onSortPressed ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
