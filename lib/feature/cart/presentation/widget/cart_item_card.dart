import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

class CartItemCard extends StatefulWidget {
  final CartItemModel item;
  final String? selectedVendorId; // جعلها nullable
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CartItemCard({
    super.key,
    required this.item,
    required this.selectedVendorId,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> with TickerProviderStateMixin {
  late AnimationController _priceAnimationController;
  late Animation<Offset> _priceSlideAnimation;
  late Animation<double> _priceFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // إعداد انيميشن السعر
    _priceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _priceSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // يبدأ من اليمين
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _priceAnimationController,
      curve: Curves.easeOutBack,
    ));
    
    _priceFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _priceAnimationController,
      curve: Curves.easeOut,
    ));
    
    // تشغيل الانيميشن في البداية فقط إذا كان هناك متجر مختار
    if (widget.selectedVendorId != null) {
      _priceAnimationController.forward();
    }
  }

  @override
  void didUpdateWidget(CartItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // إذا تغير المتجر وأصبح غير null، شغل الانيميشن
    if (oldWidget.selectedVendorId != widget.selectedVendorId && 
        widget.selectedVendorId != null) {
      _priceAnimationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _priceAnimationController.dispose();
    super.dispose();
  }

  double? get _currentPrice {
    if (widget.selectedVendorId == null) return null;
    
    try {
      return widget.item.vendorPrices
          .firstWhere((v) => v.id == widget.selectedVendorId)
          .price;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Center(
                child: Text(widget.item.imageUrl, style: const TextStyle(fontSize: 40))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                _buildAnimatedPrice(l10n),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildButton(Icons.remove, widget.onDecrement),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${widget.item.quantity}',
                          style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ),
                    _buildButton(Icons.add, widget.onIncrement),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: widget.onDelete,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_outline, size: 20, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedPrice(AppLocalizations l10n) {
    final price = _currentPrice;
    
    if (price == null) {
      return Text(l10n.select_vendor_to_show_price,
          style: AppTextStyles.labelSmall
              .copyWith(color: AppColors.textSecondary));
    }
    
    return AnimatedBuilder(
      animation: _priceAnimationController,
      builder: (context, child) {
        return SlideTransition(
          position: _priceSlideAnimation,
          child: FadeTransition(
            opacity: _priceFadeAnimation,
            child: Container(
              key: ValueKey('price_${widget.selectedVendorId}_$price'),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_offer,
                    color: AppColors.primary,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${price.toStringAsFixed(0)} ريال/${widget.item.unit}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary, 
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.white),
      ),
    );
  }
}