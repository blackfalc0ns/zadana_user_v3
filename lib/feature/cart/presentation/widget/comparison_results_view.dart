import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/comparison_buttons.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/comparison_widgets.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_result_card.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

class ComparisonResultsView extends StatelessWidget {
  final List<MapEntry<VendorModel, double>> results;
  final String currentVendorId;
  final double savings;
  final VoidCallback onBack;
  final void Function(String) onSelect;

  const ComparisonResultsView({
    super.key,
    required this.results,
    required this.currentVendorId,
    required this.savings,
    required this.onBack,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cheapest = results.first;

    return Column(
      children: [
        const ComparisonHandle(),
        ResultsHeader(onBack: onBack),
        if (savings > 0 && currentVendorId != cheapest.key.id)
          SavingsBanner(savings: savings, vendorName: cheapest.key.name),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => VendorResultCard(
              vendor: results[i].key,
              total: results[i].value,
              rank: i + 1,
              isCheapest: i == 0,
              isCurrent: results[i].key.id == currentVendorId,
              savings: i == 0 ? 0 : results[i].value - cheapest.value,
              onSelect: () => onSelect(results[i].key.id),
            ),
          ),
        ),
        SelectCheapestButton(
          vendorName: cheapest.key.name,
          onPressed: () => onSelect(cheapest.key.id),
        ),
      ],
    );
  }
}
