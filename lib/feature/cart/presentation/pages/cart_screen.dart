import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/checkout_flow_service.dart';
import 'package:zadana_user_v3/core/services/cart_navigation_service.dart';
import 'package:zadana_user_v3/core/services/saved_location_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_event.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_view_model.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_app_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_bottom_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_content.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_dialogs.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_empty_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_comparison_sheet.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenProviderState();
}

class _CartScreenProviderState extends State<CartScreen> {
  late final CartViewModel _viewModel;
  late final CartNavigationService _cartNavigationService;

  @override
  void initState() {
    super.initState();
    _cartNavigationService = CartNavigationService()
      ..addListener(_handleCartTabChanged);
    _viewModel = getIt<CartViewModel>()
      ..doIntent(const CartLoadVendorsEvent())
      ..doIntent(const CartLoadItemsEvent());
  }

  void _handleCartTabChanged() {
    _viewModel
      ..doIntent(const CartLoadVendorsEvent())
      ..doIntent(const CartLoadItemsEvent());
  }

  @override
  void dispose() {
    _cartNavigationService.removeListener(_handleCartTabChanged);
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: const _CartScreenView(),
    );
  }
}

class _CartScreenView extends StatefulWidget {
  const _CartScreenView();

  @override
  State<_CartScreenView> createState() => _CartScreenState();
}

class _CartScreenState extends State<_CartScreenView>
    with TickerProviderStateMixin {
  static const double _cartBottomBarGap = 8.0;
  static const double _cartBottomBarReservedHeight = 96.0;

  String? _selectedVendorId;
  String? _activeHeroProductId;
  String? _animatingPriceItemId;
  bool _isRefreshingSelectedVendorPrices = false;
  int _priceAnimationVersion = 0;
  final Map<String, Timer> _quantityDebouncers = {};
  final Map<String, int> _pendingQuantityBaselines = {};
  late final CartNavigationService _cartNavigationService;
  late CartAnimations _animations;

  @override
  void initState() {
    super.initState();
    _cartNavigationService = CartNavigationService()
      ..addListener(_resetVendorSelection);
    _selectedVendorId = null;
    _animations = CartAnimations(this);
  }

  @override
  void dispose() {
    _cartNavigationService.removeListener(_resetVendorSelection);
    for (final timer in _quantityDebouncers.values) {
      timer.cancel();
    }
    _animations.dispose();
    super.dispose();
  }

  void _resetVendorSelection() {
    if (!mounted) return;
    setState(() {
      _selectedVendorId = null;
      _activeHeroProductId = null;
      _animatingPriceItemId = null;
      _isRefreshingSelectedVendorPrices = false;
      _priceAnimationVersion = 0;
    });
  }

  List<CartVendorEntity> get _vendors =>
      context.read<CartViewModel>().state.vendors;
  List<CartItemModel> get _items => context.read<CartViewModel>().state.items;
  String? get _loadedVendorId =>
      context.read<CartViewModel>().state.loadedVendorId;
  bool get _isLoadingSelectedVendorPrices {
    if (_selectedVendorId == null) return false;
    return _isRefreshingSelectedVendorPrices;
  }

  int get _totalQuantity =>
      context.read<CartViewModel>().state.summary?.totalQuantity ??
      _items.fold(0, (sum, i) => sum + i.quantity);
  bool get _isEmpty => _items.isEmpty;

  List<CartItemModel> _getAvailableItems() {
    if (_selectedVendorId == null) return [];
    return _items
        .where(
          (item) => item.isAvailableAt(
            _selectedVendorId!,
            loadedVendorId: _loadedVendorId,
          ),
        )
        .toList();
  }

  double get _totalPrice {
    if (_selectedVendorId == null) return 0.0;

    final availableItems = _getAvailableItems();
    return availableItems.fold(0.0, (sum, item) {
      final vp = item.getPriceForVendor(
        _selectedVendorId!,
        loadedVendorId: _loadedVendorId,
      );
      if (vp != null) {
        return sum + (vp.price * item.quantity);
      }
      return sum;
    });
  }

  double get _totalOldPrice {
    if (_selectedVendorId == null) return 0.0;

    final availableItems = _getAvailableItems();
    return availableItems.fold(0.0, (sum, item) {
      final vp = item.getPriceForVendor(
        _selectedVendorId!,
        loadedVendorId: _loadedVendorId,
      );
      if (vp != null) {
        final priceToUse = vp.isDiscounted && vp.oldPrice != null
            ? vp.oldPrice!
            : vp.price;
        return sum + (priceToUse * item.quantity);
      }
      return sum;
    });
  }

  double get _totalSavings => _totalOldPrice - _totalPrice;

  bool get _hasDiscounts {
    if (_selectedVendorId == null) return false;

    final availableItems = _getAvailableItems();
    return availableItems.any((item) {
      final vp = item.getPriceForVendor(
        _selectedVendorId!,
        loadedVendorId: _loadedVendorId,
      );
      return vp != null &&
          vp.isDiscounted &&
          vp.oldPrice != null &&
          vp.oldPrice! > vp.price;
    });
  }

  String _selectedVendorName(BuildContext context) {
    final locale = context.localization;
    final selectedVendor = _vendors
        .where((vendor) => vendor.id == _selectedVendorId)
        .firstOrNull;

    return _selectedVendorId == null
        ? locale.select_vendor_to_show_price
        : selectedVendor?.name ?? locale.select_vendor_to_show_price;
  }

  void _updateQuantity(CartItemModel item, bool increment) {
    if (!increment && item.quantity <= 1) {
      _showDeleteDialog(item);
      return;
    }

    final previousQuantity = item.quantity;
    final nextQuantity = increment
        ? previousQuantity + 1
        : previousQuantity - 1;

    _pendingQuantityBaselines.putIfAbsent(item.id, () => previousQuantity);

    setState(() {
      item.quantity = nextQuantity;
    });

    _quantityDebouncers[item.id]?.cancel();
    _quantityDebouncers[item.id] = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final baselineQuantity =
          _pendingQuantityBaselines.remove(item.id) ?? previousQuantity;
      _quantityDebouncers.remove(item.id);
      context.read<CartViewModel>().doIntent(
        CartUpdateQuantityEvent(
          itemId: item.id,
          productId: item.productId,
          quantity: item.quantity,
          previousQuantity: baselineQuantity,
          vendorId: _loadedVendorId,
        ),
      );
    });
  }

  void _showDeleteDialog(CartItemModel item) => showDeleteItemDialog(
    context: context,
    itemName: item.name,
    onConfirm: () {
      _quantityDebouncers.remove(item.id)?.cancel();
      _pendingQuantityBaselines.remove(item.id);
      context.read<CartViewModel>().doIntent(CartRemoveItemEvent(item));
    },
  );

  void _showClearDialog() => showClearCartDialog(
    context: context,
    onConfirm: () {
      for (final timer in _quantityDebouncers.values) {
        timer.cancel();
      }
      _quantityDebouncers.clear();
      _pendingQuantityBaselines.clear();
      context.read<CartViewModel>().doIntent(const CartClearAllEvent());
    },
  );

  void _showComparison() {
    final locale = context.localization;
    if (_selectedVendorId == null) {
      _showSnackBar(locale.select_vendor_to_show_price);
      return;
    }

    showVendorComparisonSheet(
      context: context,
      vendors: _vendors,
      items: _items,
      currentVendorId: _selectedVendorId!,
      onVendorSelected: _onVendorSelected,
    );
  }

  Future<void> _onVendorSelected(String id) async {
    if (_selectedVendorId == id) return;

    setState(() {
      _selectedVendorId = id;
      _animatingPriceItemId = null;
      _isRefreshingSelectedVendorPrices = true;
    });

    context.read<CartViewModel>().doIntent(CartLoadItemsEvent(vendorId: id));

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!mounted || _selectedVendorId != id) return;
    _animations.playPriceAnimation();
  }

  Future<void> _openProductDetails(CartItemModel item) async {
    final vendorPrice = _selectedVendorId == null
        ? item.cheapest
        : item.vendorPrices.firstWhere(
            (vendor) => vendor.id == _selectedVendorId,
            orElse: () =>
                item.getPriceForVendor(
                  _selectedVendorId!,
                  loadedVendorId: _loadedVendorId,
                ) ??
                item.cheapest,
          );

    final product = ProductModel(
      id: item.productId,
      name: item.name,
      store: vendorPrice.name,
      price: vendorPrice.price,
      imageUrl: item.imageUrl,
      unit: item.unit,
      emoji: '',
      isDiscounted: false,
    );

    setState(() {
      _activeHeroProductId = item.id;
      _animatingPriceItemId = item.id;
    });

    await WidgetsBinding.instance.endOfFrame;

    if (!mounted) return;

    await ProductNavigationHelper.navigateToProductDetails(
      context,
      product,
      activeProductId: item.productId,
      heroTag: productHeroTag(item.productId, source: 'cart-item'),
    );

    if (!mounted) return;
    setState(() {
      _activeHeroProductId = null;
      _animatingPriceItemId = null;
    });
  }

  Future<void> _onCheckout() async {
    final locale = context.localization;
    if (_selectedVendorId == null) {
      _showSnackBar(locale.select_vendor_to_show_price);
      return;
    }

    final token = await getIt<TokenService>().getToken();
    if (!mounted) return;

    final isGuest = token == null || token.isEmpty;
    if (isGuest) {
      final shouldRegister = await _showCheckoutAuthDialog();
      if (!mounted || shouldRegister != true) return;

      CheckoutFlowService().markPendingCheckout();
      Navigator.pushNamed(
        context,
        AppRoutes.signUp,
        arguments: SavedLocationService.getSavedLocation(),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentScreen()),
    );
  }

  Future<bool?> _showCheckoutAuthDialog() {
    final color = context.colorScheme;
    final locale = context.localization;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: color.surface,
          title: Text(
            locale.checkout,
            style: TextStyle(color: color.onSurface),
          ),
          content: Text(
            'لازم تكمل التسجيل الأول عشان تقدر تتم الطلب.',
            style: TextStyle(color: color.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(locale.no),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('إكمال التسجيل'),
            ),
          ],
        ),
      ),
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
    final cartState = context.watch<CartViewModel>().state;
    final color = context.colorScheme;
    final bottomNavReservedSpace = mainShellBottomNavReservedSpace(context);
    final cartBottomOffset = bottomNavReservedSpace + _cartBottomBarGap;
    final contentBottomPadding =
        cartBottomOffset + _cartBottomBarReservedHeight;
    final isInitialLoading =
        (cartState.isLoadingVendors && cartState.vendors.isEmpty) ||
        (cartState.isLoadingItems && cartState.items.isEmpty);

    return BlocListener<CartViewModel, CartState>(
      listenWhen: (previous, current) =>
          previous.isLoadingItems != current.isLoadingItems ||
          previous.loadedVendorId != current.loadedVendorId ||
          previous.clearCartSuccessMessage != current.clearCartSuccessMessage ||
          previous.clearCartErrorMessage != current.clearCartErrorMessage ||
          previous.removeItemSuccessMessage !=
              current.removeItemSuccessMessage ||
          previous.removeItemErrorMessage != current.removeItemErrorMessage ||
          previous.updateQuantityErrorMessage !=
              current.updateQuantityErrorMessage,
      listener: (_, state) {
        if (!mounted) return;

        final hasUpdatedSelectedVendorPrices =
            state.loadedVendorId == _selectedVendorId &&
            state.loadedVendorId != null &&
            !state.isLoadingItems;
        if (hasUpdatedSelectedVendorPrices) {
          setState(() {
            _isRefreshingSelectedVendorPrices = false;
            _priceAnimationVersion++;
          });
          _animations.playPriceAnimation();
        }

        if (state.clearCartSuccessMessage != null) {
          for (final timer in _quantityDebouncers.values) {
            timer.cancel();
          }
          _quantityDebouncers.clear();
          _pendingQuantityBaselines.clear();
          setState(() {
            _selectedVendorId = null;
            _activeHeroProductId = null;
            _animatingPriceItemId = null;
            _isRefreshingSelectedVendorPrices = false;
          });
          CustomSnackbar.showSuccess(
            context: context,
            message: state.clearCartSuccessMessage!,
          );
          context.read<CartViewModel>().clearCartFeedback();
        }

        if (state.clearCartErrorMessage != null) {
          CustomSnackbar.showError(
            context: context,
            message: state.clearCartErrorMessage!,
          );
          context.read<CartViewModel>().clearCartFeedback();
        }

        if (state.removeItemSuccessMessage != null) {
          _quantityDebouncers.remove(state.removedItemId)?.cancel();
          _pendingQuantityBaselines.remove(state.removedItemId);
          if (state.items.isEmpty) {
            setState(() {
              _selectedVendorId = null;
              _activeHeroProductId = null;
              _animatingPriceItemId = null;
              _isRefreshingSelectedVendorPrices = false;
            });
          }
          CustomSnackbar.showSuccess(
            context: context,
            message: state.removeItemSuccessMessage!,
          );
          context.read<CartViewModel>().clearRemoveItemFeedback();
        }

        if (state.removeItemErrorMessage != null) {
          CustomSnackbar.showError(
            context: context,
            message: state.removeItemErrorMessage!,
          );
          context.read<CartViewModel>().clearRemoveItemFeedback();
        }

        if (state.updateQuantityErrorMessage != null) {
          CustomSnackbar.showError(
            context: context,
            message: state.updateQuantityErrorMessage!,
          );
          _pendingQuantityBaselines.remove(state.updatedQuantityItemId);
          context.read<CartViewModel>().clearUpdateQuantityFeedback();
        }

        if (!state.isLoadingItems && _isRefreshingSelectedVendorPrices) {
          setState(() {
            _isRefreshingSelectedVendorPrices = false;
          });
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: color.surface,
          appBar: CartAppBar(
            itemCount: _items.length,
            totalQuantity: _totalQuantity,
            onClearAll: _isEmpty ? null : _showClearDialog,
          ),
          body: isInitialLoading
              ? const CartLoadingSkeleton()
              : _isEmpty
              ? CartEmptyState(
                  onStartShopping: () =>
                      mainShellKey.currentState?.jumpToTab(0),
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: contentBottomPadding),
                        child: CartContent(
                          items: _items,
                          vendors: cartState.vendors,
                          selectedVendorId: _selectedVendorId,
                          loadedVendorId: cartState.loadedVendorId,
                          isLoadingSelectedVendorPrices:
                              _isLoadingSelectedVendorPrices,
                          priceAnimationVersion: _priceAnimationVersion,
                          activeHeroProductId: _activeHeroProductId,
                          animatingPriceItemId: _animatingPriceItemId,
                          onVendorSelected: _onVendorSelected,
                          onItemTap: _openProductDetails,
                          onUpdateQuantity: _updateQuantity,
                          onDeleteItem: _showDeleteDialog,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: cartBottomOffset,
                      child: CartBottomBar(
                        selectedVendorId: _selectedVendorId,
                        items: _items,
                        totalPrice: _totalPrice,
                        totalOldPrice: _totalOldPrice,
                        totalSavings: _totalSavings,
                        hasDiscounts: _hasDiscounts,
                        selectedVendorName: _selectedVendorName(context),
                        animations: _animations,
                        onComparison: _showComparison,
                        onCheckout: _onCheckout,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
