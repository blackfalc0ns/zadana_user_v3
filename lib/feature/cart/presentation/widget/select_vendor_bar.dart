import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

class SelectVendorBar extends StatelessWidget {
  final List<CartItemModel> items;

  const SelectVendorBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      key: const ValueKey('select_bottom'),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      decoration: BoxDecoration(
        color: color.surface,
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow(context),
            const SizedBox(height: 8),
            _buildSelectButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        Icon(
          Icons.shopping_cart_outlined,
          color: color.onSurfaceVariant,
          size: 16,
        ),
        const SizedBox(width: 5),
        Text(
          '${items.length} ${locale.product}',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: color.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          locale.select_vendor_to_show_price,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: color.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: double.infinity,
      height: 36,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          locale.select_vendor_to_show_price,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.shimmerHighlightDark,
          ),
        ),
      ),
    );
  }
}
