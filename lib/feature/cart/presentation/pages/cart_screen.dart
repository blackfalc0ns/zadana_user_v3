import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/cart/data/dummy_cart_data.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_app_bar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_dialogs.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_empty_state.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_item_card.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_comparison_sheet.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late List<CartItemModel> _items;
  String? _selectedVendorId;
  late AnimationController _priceAnimationController;
  late Animation<Offset> _priceSlideAnimation;
  late Animation<double> _priceFadeAnimation;

  @override
  void initState() {
    super.initState();
    _items = List.from(dummyCartItems);
    _selectedVendorId = null;

    // إعداد انيميشن السعر
    _priceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _priceSlideAnimation =
        Tween<Offset>(
          begin: const Offset(1.0, 0.0), // يبدأ من اليمين
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _priceAnimationController,
            curve: Curves.easeOutBack,
          ),
        );

    _priceFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _priceAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _priceAnimationController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════
  // GETTERS
  // ══════════════════════════════════════════════

  int get _totalQuantity => _items.fold(0, (sum, i) => sum + i.quantity);

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

  String get _selectedVendorName => _selectedVendorId == null
      ? 'لم يتم اختيار متجر'
      : dummyVendors.firstWhere((v) => v.id == _selectedVendorId).name;

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

  void _showComparison() {
    if (_selectedVendorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار متجر أولاً'),
          backgroundColor: AppColors.error,
        ),
      );
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

    // تشغيل انيميشن السعر
    _priceAnimationController.forward(from: 0.0);
  }

  void _onCheckout() {
    if (_selectedVendorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار متجر أولاً'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
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
        bottomNavigationBar: _isEmpty
            ? null
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.0, 1.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutQuart,
                          ),
                        ),
                    child: child,
                  );
                },
                child: _buildBottomBar(),
              ),
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

  Widget _buildEmptyState() =>
      CartEmptyState(onStartShopping: () => Navigator.pop(context));

  Widget _buildCartContent() => Column(
    children: [
      _buildVendorSelector(),
      if (_selectedVendorId == null)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSelectVendorPrompt(),
          ),
        ),
      const Divider(height: 12),
      Expanded(
        child: _buildItemsList(), // إظهار المنتجات دائماً
      ),
    ],
  );

  Widget _buildVendorSelector() => VendorSelector(
    vendors: dummyVendors,
    selectedVendorId: _selectedVendorId,
    onVendorSelected: _onVendorSelected,
  );

  Widget _buildSelectVendorPrompt() => Container(
    key: const ValueKey('select_prompt'),
    width: double.infinity,

    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
              width: 0.8,
            ),
          ),
          child: Icon(Icons.store, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر متجر لعرض الأسعار',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'اختر من المتاجر أعلاه لمشاهدة أسعار المنتجات والمتابعة للدفع',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.touch_app, color: AppColors.primary, size: 24),
      ],
    ),
  );

  Widget _buildItemsList() => ListView.separated(
    key: ValueKey('items_list_${_selectedVendorId ?? "no_vendor"}'),
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
    selectedVendorId: _selectedVendorId, // يمكن أن يكون null
    onIncrement: () => _updateQuantity(item, true),
    onDecrement: () => _updateQuantity(item, false),
    onDelete: () => _showDeleteDialog(item),
  );

  Widget _buildBottomBar() => _selectedVendorId == null
      ? _buildSelectVendorBottomBar()
      : _buildSelectedVendorBottomBar();

  Widget _buildSelectedVendorBottomBar() => Container(
    key: ValueKey('selected_bottom_$_selectedVendorId'),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // معلومات المتجر والسعر مع انيميشن
          Row(
            children: [
              // معلومات المتجر
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dummyVendors
                          .firstWhere((v) => v.id == _selectedVendorId)
                          .emoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedVendorName,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${_items.length} منتج',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // السعر مع انيميشن
              AnimatedBuilder(
                animation: _priceAnimationController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _priceSlideAnimation,
                    child: FadeTransition(
                      opacity: _priceFadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${_totalPrice.toStringAsFixed(2)} ريال',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // أزرار العمليات
          Row(
            children: [
              // زر المقارنة
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: _showComparison,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.compare_arrows,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'مقارنة',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // زر الدفع
              Expanded(
                flex: 2,
                child: AppButton(
                  height: 45,
                  onPressed: _onCheckout,
                  text: 'متابعة الدفع',
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildSelectVendorBottomBar() => Container(
    key: const ValueKey('select_bottom'),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${_items.length} منتج في السلة',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                'اختر متجر لمشاهدة الأسعار',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'يرجى اختيار متجر أولاً',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
