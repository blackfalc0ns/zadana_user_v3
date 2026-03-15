import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

class SelectVendorBar extends StatelessWidget {
  final List<CartItemModel> items;

  const SelectVendorBar({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('select_bottom'),
      padding: const EdgeInsets.all(8),
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
            _buildInfoRow(),
            const SizedBox(height: 8),
            _buildSelectButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Icon(Icons.shopping_cart_outlined,
            color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 5),
        Text(
          '${items.length} منتج في السلة',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          'اختر متجر لمشاهدة الأسعار',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton() {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'يرجى اختيار متجر أولاً',
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}