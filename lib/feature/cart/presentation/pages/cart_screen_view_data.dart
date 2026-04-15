import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_state.dart';

class CartScreenViewData {
  const CartScreenViewData({
    required this.vendors,
    required this.items,
    required this.loadedVendorId,
    required this.totalQuantity,
    required this.isEmpty,
    required this.isLoadingSelectedVendorPrices,
    required this.selectedVendorName,
    required this.totalPrice,
    required this.totalOldPrice,
    required this.hasDiscounts,
  });

  factory CartScreenViewData.fromState({
    required CartState state,
    required AppLocalizations localization,
    required String? selectedVendorId,
    required bool isRefreshingSelectedVendorPrices,
  }) {
    final items = state.items;
    final vendors = state.vendors;
    final loadedVendorId = state.loadedVendorId;
    final summary = state.summary;
    final hasLoadedSelectedVendor =
        selectedVendorId != null && loadedVendorId == selectedVendorId;
    final effectiveTotalPrice = hasLoadedSelectedVendor
        ? (summary?.totalAmount ?? 0.0)
        : 0.0;
    final effectiveTotalOldPrice = hasLoadedSelectedVendor
        ? (summary?.subtotal ?? effectiveTotalPrice)
        : 0.0;
    final effectiveHasDiscounts =
        hasLoadedSelectedVendor && (summary?.discountAmount ?? 0.0) > 0;

    return CartScreenViewData(
      vendors: vendors,
      items: items,
      loadedVendorId: loadedVendorId,
      totalQuantity: summary?.totalQuantity ?? 0,
      isEmpty: items.isEmpty,
      isLoadingSelectedVendorPrices:
          selectedVendorId != null && isRefreshingSelectedVendorPrices,
      selectedVendorName: _selectedVendorName(
        vendors: vendors,
        localization: localization,
        selectedVendorId: selectedVendorId,
      ),
      totalPrice: effectiveTotalPrice,
      totalOldPrice: effectiveTotalOldPrice,
      hasDiscounts: effectiveHasDiscounts,
    );
  }

  final List<CartVendorEntity> vendors;
  final List<CartItemModel> items;
  final String? loadedVendorId;
  final int totalQuantity;
  final bool isEmpty;
  final bool isLoadingSelectedVendorPrices;
  final String selectedVendorName;
  final double totalPrice;
  final double totalOldPrice;
  final bool hasDiscounts;

  static String _selectedVendorName({
    required List<CartVendorEntity> vendors,
    required AppLocalizations localization,
    required String? selectedVendorId,
  }) {
    final selectedVendor = vendors
        .where((vendor) => vendor.id == selectedVendorId)
        .firstOrNull;

    return selectedVendorId == null
        ? localization.select_vendor_to_show_price
        : selectedVendor?.name ?? localization.select_vendor_to_show_price;
  }
}
