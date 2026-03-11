import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final String selectedVendorId;
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

  double? get _currentPrice {
    try {
      return item.vendorPrices
          .firstWhere((v) => v.id == selectedVendorId)
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
                child: Text(item.imageUrl, style: const TextStyle(fontSize: 40))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                _buildPrice(l10n),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildButton(Icons.remove, onDecrement),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${item.quantity}',
                          style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ),
                    _buildButton(Icons.add, onIncrement),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
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

  Widget _buildPrice(AppLocalizations l10n) {
    final price = _currentPrice;
    return price != null
        ? Text('${price.toStringAsFixed(0)} ج/${item.unit}',
            style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.w700))
        : Text(l10n.select_vendor_to_show_price,
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.textSecondary));
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
