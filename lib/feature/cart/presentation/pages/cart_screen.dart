import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/cart_navigation_service.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/feature/cart/data/dummy_cart_data.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_app_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_bottom_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_content.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_dialogs.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_empty_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_comparison_sheet.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late List<CartItemModel> _items;
  String? _selectedVendorId;
  String? _activeHeroProductId;
  String? _animatingPriceItemId;
  late CartAnimations _animations;
  bool _isLoading = true;
  Timer? _loadingTimer;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _items = List.from(dummyCartItems);
    _selectedVendorId = null;
    _animations = CartAnimations(this);
    CartNavigationService().addListener(_startFakeLoading);
    _startFakeLoading();
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _animationTimer?.cancel();
    CartNavigationService().removeListener(_startFakeLoading);
    _animations.dispose();
    super.dispose();
  }

  void _startFakeLoading() {
    _loadingTimer?.cancel();
    if (mounted) {
      setState(() => _isLoading = true);
    }
    _loadingTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

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

  Future<void> _openProductDetails(CartItemModel item) async {
    final vendorPrice = _selectedVendorId == null
        ? item.cheapest
        : item.vendorPrices.firstWhere(
            (vendor) => vendor.id == _selectedVendorId,
            orElse: () => item.cheapest,
          );

    final product = ProductModel(
      id: item.id,
      name: item.name,
      store: vendorPrice.name,
      price: vendorPrice.price,
      imageUrl: '',
      unit: item.unit,
      emoji: item.imageUrl,
      isDiscounted: false,
    );

    // Start price animation for this specific item
    setState(() {
      _activeHeroProductId = item.id;
      _animatingPriceItemId = item.id;
    });

    // Reset animation flag after animation completes
    _animationTimer?.cancel();
    _animationTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _animatingPriceItemId = null);
      }
    });

    await WidgetsBinding.instance.endOfFrame;

    if (!mounted) return;

    await ProductNavigationHelper.navigateToProductDetails(
      context,
      product,
      activeProductId: item.id,
    );

    if (!mounted) return;
    setState(() {
      _activeHeroProductId = null;
      _animatingPriceItemId = null;
    });
  }

  void _onCheckout() {
    final locale = context.localization;
    if (_selectedVendorId == null) {
      _showSnackBar(locale.select_vendor_to_show_price);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentScreen()),
    );
  }

  void _showSnackBar(String message) {
    final color = context.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    const bottomNavHeight = 90.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CartAppBar(
          itemCount: _items.length,
          totalQuantity: _totalQuantity,
          onClearAll: _isEmpty ? null : _showClearDialog,
        ),
        body: _isLoading
            ? const CartLoadingSkeleton()
            : _isEmpty
            ? CartEmptyState(onStartShopping: () => Navigator.pop(context))
            : Column(
                children: [
                  // ── Cart content (scrollable) ──
                  Expanded(
                    child: CartContent(
                      items: _items,
                      selectedVendorId: _selectedVendorId,
                      activeHeroProductId: _activeHeroProductId,
                      animatingPriceItemId: _animatingPriceItemId,
                      onVendorSelected: _onVendorSelected,
                      onItemTap: _openProductDetails,
                      onUpdateQuantity: _updateQuantity,
                      onDeleteItem: _showDeleteDialog,
                    ),
                  ),
                  // ── Bottom bar ──
                  CartBottomBar(
                    selectedVendorId: _selectedVendorId,
                    items: _items,
                    totalPrice: _totalPrice,
                    selectedVendorName: _selectedVendorName(context),
                    animations: _animations,
                    onComparison: _showComparison,
                    onCheckout: _onCheckout,
                  ),
                  SizedBox(height: bottomNavHeight),
                ],
              ),
      ),
    );
  }
}
