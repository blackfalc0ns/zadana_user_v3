import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/data/dummy_cart_data.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_app_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_empty_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_content.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_bottom_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_dialogs.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_comparison_sheet.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late List<CartItemModel> _items;
  String? _selectedVendorId;
  late CartAnimations _animations;

  @override
  void initState() {
    super.initState();
    _items = List.from(dummyCartItems);
    _selectedVendorId = null;
    _animations = CartAnimations(this);
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  // Getters
  int get _totalQuantity => _items.fold(0, (sum, i) => sum + i.quantity);
  bool get _isEmpty => _items.isEmpty;

  double get _totalPrice => _selectedVendorId == null
      ? 0.0
      : _items.fold(0.0, (sum, item) {
          try {
            final vp = item.vendorPrices.firstWhere(
              (v) => v.id == _selectedVendorId,
            );
            return sum + (vp.price * item.quantity);
          } catch (_) {
            return sum;
          }
        });

  String _selectedVendorName(BuildContext context) {
    final locale = context.localization;
    return _selectedVendorId == null
        ? locale.select_vendor_to_show_price
        : dummyVendors.firstWhere((v) => v.id == _selectedVendorId).name;
  }

  // Actions
  void _updateQuantity(CartItemModel item, bool increment) {
    setState(() {
      if (increment) {
        item.quantity++;
      } else if (item.quantity > 1) {
        item.quantity--;
      } else {
        _showDeleteDialog(item);
      }
    });
  }

  void _showDeleteDialog(CartItemModel item) => showDeleteItemDialog(
    context: context,
    itemName: item.name,
    onConfirm: () => setState(() => _items.remove(item)),
  );

  void _showClearDialog() => showClearCartDialog(
    context: context,
    onConfirm: () => setState(() => _items.clear()),
  );

  void _showComparison() {
    final locale = context.localization;
    if (_selectedVendorId == null) {
      _showSnackBar(locale.select_vendor_to_show_price);
      return;
    }

    showVendorComparisonSheet(
      context: context,
      vendors: dummyVendors,
      items: _items,
      currentVendorId: _selectedVendorId!,
      onVendorSelected: _onVendorSelected,
    );
  }

  void _onVendorSelected(String id) {
    setState(() => _selectedVendorId = id);
    _animations.playPriceAnimation();
  }

  void _onCheckout() {
    final locale = context.localization;
    if (_selectedVendorId == null) {
      _showSnackBar(locale.select_vendor_to_show_price);
      return;
    }
    // TODO: Implement checkout logic
  }

  void _showSnackBar(String message) {
    final color = context.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CartAppBar(
          itemCount: _items.length,
          totalQuantity: _totalQuantity,
          onClearAll: _isEmpty ? null : _showClearDialog,
        ),
        body: _isEmpty
            ? CartEmptyState(onStartShopping: () => Navigator.pop(context))
            : CartContent(
                items: _items,
                selectedVendorId: _selectedVendorId,
                onVendorSelected: _onVendorSelected,
                onUpdateQuantity: _updateQuantity,
                onDeleteItem: _showDeleteDialog,
              ),
        bottomNavigationBar: _isEmpty
            ? null
            : CartBottomBar(
                selectedVendorId: _selectedVendorId,
                items: _items,
                totalPrice: _totalPrice,
                selectedVendorName: _selectedVendorName(context),
                animations: _animations,
                onComparison: _showComparison,
                onCheckout: _onCheckout,
              ),
      ),
    );
  }
}
