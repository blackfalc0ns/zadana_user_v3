import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/comparison_results_view.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/comparison_selection_view.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

void showVendorComparisonSheet({
  required BuildContext context,
  required List<VendorModel> vendors,
  required List<CartItemModel> items,
  required String currentVendorId,
  required void Function(String vendorId) onVendorSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _VendorComparisonSheet(
      vendors: vendors,
      items: items,
      currentVendorId: currentVendorId,
      onVendorSelected: onVendorSelected,
    ),
  );
}

class _VendorComparisonSheet extends StatefulWidget {
  final List<VendorModel> vendors;
  final List<CartItemModel> items;
  final String currentVendorId;
  final void Function(String vendorId) onVendorSelected;

  const _VendorComparisonSheet({
    required this.vendors,
    required this.items,
    required this.currentVendorId,
    required this.onVendorSelected,
  });

  @override
  State<_VendorComparisonSheet> createState() => _VendorComparisonSheetState();
}

class _VendorComparisonSheetState extends State<_VendorComparisonSheet> {
  bool _showResults = false;
  late Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = {widget.currentVendorId};
  }

  double _totalFor(String vendorId) {
    double total = 0;
    for (final item in widget.items) {
      try {
        final vp = item.vendorPrices.firstWhere((v) => v.id == vendorId);
        total += vp.price * item.quantity;
      } catch (_) {}
    }
    return total;
  }

  List<MapEntry<VendorModel, double>> get _sortedResults {
    return _selectedIds
        .map((id) => MapEntry(
            widget.vendors.firstWhere((v) => v.id == id), _totalFor(id)))
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));
  }

  void _toggleVendor(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        if (_selectedIds.length > 1) _selectedIds.remove(id);
      } else {
        if (_selectedIds.length < 3) _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showResults ? _buildResults() : _buildSelection(),
        ),
      ),
    );
  }

  Widget _buildSelection() {
    return ComparisonSelectionView(
      key: const ValueKey('selection'),
      vendors: widget.vendors,
      selectedIds: _selectedIds,
      currentVendorId: widget.currentVendorId,
      onToggle: _toggleVendor,
      onCompare: () => setState(() => _showResults = true),
      totalFor: _totalFor,
    );
  }

  Widget _buildResults() {
    final results = _sortedResults;
    final cheapest = results.first;
    final savings = _totalFor(widget.currentVendorId) - cheapest.value;

    return ComparisonResultsView(
      key: const ValueKey('results'),
      results: results,
      currentVendorId: widget.currentVendorId,
      savings: savings,
      onBack: () => setState(() => _showResults = false),
      onSelect: (id) {
        widget.onVendorSelected(id);
        Navigator.pop(context);
      },
    );
  }
}
