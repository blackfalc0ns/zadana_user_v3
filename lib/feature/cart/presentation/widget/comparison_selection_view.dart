import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/comparison_buttons.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/comparison_cards.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/comparison_widgets.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

class ComparisonSelectionView extends StatelessWidget {
  final List<VendorModel> vendors;
  final Set<String> selectedIds;
  final String currentVendorId;
  final void Function(String) onToggle;
  final VoidCallback onCompare;
  final double Function(String) totalFor;

  const ComparisonSelectionView({
    super.key,
    required this.vendors,
    required this.selectedIds,
    required this.currentVendorId,
    required this.onToggle,
    required this.onCompare,
    required this.totalFor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        const ComparisonHandle(),
        ComparisonTitle(l10n.select_vendors_to_compare),
        ComparisonSubtitle(l10n.select_2_to_3_vendors),
        const SizedBox(height: 16),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vendors.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => VendorSelectionCard(
              vendor: vendors[i],
              total: totalFor(vendors[i].id),
              isSelected: selectedIds.contains(vendors[i].id),
              isCurrent: vendors[i].id == currentVendorId,
              onTap: () => onToggle(vendors[i].id),
            ),
          ),
        ),
        CompareButton(
          selectedCount: selectedIds.length,
          onPressed: selectedIds.length >= 2 ? onCompare : null,
        ),
      ],
    );
  }
}
