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
    required this.totalSavings,
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
    final availableItems = _availableItems(
      items: items,
      selectedVendorId: selectedVendorId,
      loadedVendorId: loadedVendorId,
    );

    return CartScreenViewData(
      vendors: vendors,
      items: items,
      loadedVendorId: loadedVendorId,
      totalQuantity:
          state.summary?.totalQuantity ??
          items.fold(0, (sum, item) => sum + item.quantity),
      isEmpty: items.isEmpty,
      isLoadingSelectedVendorPrices:
          selectedVendorId != null && isRefreshingSelectedVendorPrices,
      selectedVendorName: _selectedVendorName(
        vendors: vendors,
        localization: localization,
        selectedVendorId: selectedVendorId,
      ),
      totalPrice: _totalPrice(
        availableItems: availableItems,
        selectedVendorId: selectedVendorId,
        loadedVendorId: loadedVendorId,
      ),
      totalOldPrice: _totalOldPrice(
        availableItems: availableItems,
        selectedVendorId: selectedVendorId,
        loadedVendorId: loadedVendorId,
      ),
      totalSavings:
          _totalOldPrice(
            availableItems: availableItems,
            selectedVendorId: selectedVendorId,
            loadedVendorId: loadedVendorId,
          ) -
          _totalPrice(
            availableItems: availableItems,
            selectedVendorId: selectedVendorId,
            loadedVendorId: loadedVendorId,
          ),
      hasDiscounts: _hasDiscounts(
        availableItems: availableItems,
        selectedVendorId: selectedVendorId,
        loadedVendorId: loadedVendorId,
      ),
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
  final double totalSavings;
  final bool hasDiscounts;

  static List<CartItemModel> _availableItems({
    required List<CartItemModel> items,
    required String? selectedVendorId,
    required String? loadedVendorId,
  }) {
    if (selectedVendorId == null) return const [];

    return items
        .where(
          (item) => item.isAvailableAt(
            selectedVendorId,
            loadedVendorId: loadedVendorId,
          ),
        )
        .toList();
  }

  static double _totalPrice({
    required List<CartItemModel> availableItems,
    required String? selectedVendorId,
    required String? loadedVendorId,
  }) {
    if (selectedVendorId == null) return 0.0;

    return availableItems.fold(0.0, (sum, item) {
      final vendorPrice = item.getPriceForVendor(
        selectedVendorId,
        loadedVendorId: loadedVendorId,
      );
      if (vendorPrice == null) return sum;
      return sum + (vendorPrice.price * item.quantity);
    });
  }

  static double _totalOldPrice({
    required List<CartItemModel> availableItems,
    required String? selectedVendorId,
    required String? loadedVendorId,
  }) {
    if (selectedVendorId == null) return 0.0;

    return availableItems.fold(0.0, (sum, item) {
      final vendorPrice = item.getPriceForVendor(
        selectedVendorId,
        loadedVendorId: loadedVendorId,
      );
      if (vendorPrice == null) return sum;

      final priceToUse =
          vendorPrice.isDiscounted && vendorPrice.oldPrice != null
          ? vendorPrice.oldPrice!
          : vendorPrice.price;
      return sum + (priceToUse * item.quantity);
    });
  }

  static bool _hasDiscounts({
    required List<CartItemModel> availableItems,
    required String? selectedVendorId,
    required String? loadedVendorId,
  }) {
    if (selectedVendorId == null) return false;

    return availableItems.any((item) {
      final vendorPrice = item.getPriceForVendor(
        selectedVendorId,
        loadedVendorId: loadedVendorId,
      );
      return vendorPrice != null &&
          vendorPrice.isDiscounted &&
          vendorPrice.oldPrice != null &&
          vendorPrice.oldPrice! > vendorPrice.price;
    });
  }

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
