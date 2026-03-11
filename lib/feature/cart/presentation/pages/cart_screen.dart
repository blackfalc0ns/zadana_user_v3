import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/cart/data/dummy_cart_data.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_app_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_dialogs.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_empty_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_item_card.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_widgets.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_comparison_sheet.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItemModel> _items;
  late String _selectedVendorId;

  @override
  void initState() {
    super.initState();
    _items = List.from(dummyCartItems);
    _selectedVendorId = dummyVendors.first.id;
  }

  // ══════════════════════════════════════════════
  // GETTERS
  // ══════════════════════════════════════════════

  int get _totalQuantity => _items.fold(0, (sum, i) => sum + i.quantity);

  double get _totalPrice => _items.fold(0.0, (sum, item) {
        try {
          final vp = item.vendorPrices.firstWhere((v) => v.id == _selectedVendorId);
          return sum + (vp.price * item.quantity);
        } catch (_) {
          return sum;
        }
      });

  String get _selectedVendorName =>
      dummyVendors.firstWhere((v) => v.id == _selectedVendorId).name;

  bool get _isEmpty => _items.isEmpty;

  // ══════════════════════════════════════════════
  // ACTIONS
  // ══════════════════════════════════════════════

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

  void _showComparison() => showVendorComparisonSheet(
        context: context,
        vendors: dummyVendors,
        items: _items,
        currentVendorId: _selectedVendorId,
        onVendorSelected: _onVendorSelected,
      );

  void _onVendorSelected(String id) => setState(() => _selectedVendorId = id);

  void _onCheckout() {
    // TODO: Implement checkout logic
  }

  // ══════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: _isEmpty ? _buildEmptyState() : _buildCartContent(),
        bottomNavigationBar: _isEmpty ? null : _buildBottomBar(),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // WIDGETS
  // ══════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar() => CartAppBar(
        itemCount: _items.length,
        totalQuantity: _totalQuantity,
        onClearAll: _isEmpty ? null : _showClearDialog,
      );

  Widget _buildEmptyState() => CartEmptyState(
        onStartShopping: () => Navigator.pop(context),
      );

  Widget _buildCartContent() => Column(
        children: [
          _buildVendorSelector(),
          const Divider(height: 1),
          Expanded(child: _buildItemsList()),
        ],
      );

  Widget _buildVendorSelector() => VendorSelector(
        vendors: dummyVendors,
        selectedVendorId: _selectedVendorId,
        onVendorSelected: _onVendorSelected,
      );

  Widget _buildItemsList() => ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.base,
        ),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
        itemBuilder: (_, index) => _buildCartItem(_items[index]),
      );

  Widget _buildCartItem(CartItemModel item) => CartItemCard(
        item: item,
        selectedVendorId: _selectedVendorId,
        onIncrement: () => _updateQuantity(item, true),
        onDecrement: () => _updateQuantity(item, false),
        onDelete: () => _showDeleteDialog(item),
      );

  Widget _buildBottomBar() => CartBottomBar(
        itemCount: _items.length,
        totalQuantity: _totalQuantity,
        totalPrice: _totalPrice,
        selectedVendorName: _selectedVendorName,
        onCheckout: _onCheckout,
        onCompare: _showComparison,
      );
}
