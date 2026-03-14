import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/category/presentation/widgets/filter_button.dart';

class BottomFilterButtons extends StatelessWidget {
  const BottomFilterButtons({
    super.key,
    this.onSortPressed,
    this.onCategoryPressed,
    this.hasActiveFilters = false,
    required this.locale,
  });

  final VoidCallback? onSortPressed;
  final VoidCallback? onCategoryPressed;
  final bool hasActiveFilters;
  final AppLocalizations locale;

  @override
  Widget build(BuildContext context) {
    return _FloatingFilterSortBar(
      onFilterTap: onCategoryPressed ?? () {},
      onSortTap: onSortPressed ?? () {},
      locale: locale,
    );
  }
}

class _FloatingFilterSortBar extends StatelessWidget {
  const _FloatingFilterSortBar({
    required this.onFilterTap,
    required this.onSortTap,
    required this.locale,
  });

  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;
  final AppLocalizations locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
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
              child: FilterButton(
                icon: Icons.tune_rounded,
                label: 'التصنيف',
                onTap: onFilterTap,
              ),
            ),
            Container(
              width: 1,
              height: 22,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            Expanded(
              child: FilterButton(
                icon: Icons.sort_rounded,
                label: 'ترتيب',
                onTap: onSortTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}