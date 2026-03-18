import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int itemCount;
  final int totalQuantity;
  final VoidCallback? onClearAll;
  final VoidCallback? onBack;
  const CartAppBar({
    super.key,
    required this.itemCount,
    required this.totalQuantity,
    this.onClearAll,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return AppBar(
      centerTitle: true,
      title: Column(
        children: [
          Text(
            locale.cart,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: color.onSurface,
            ),
          ),
          if (itemCount > 0)
            Text(
              '$totalQuantity ${locale.product}',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ),
            ),
        ],
      ),
      actions: [
        if (onClearAll != null)
          TextButton(
            onPressed: onClearAll,
            child: Text(
              locale.clear_all,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: color.error,
              ),
            ),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: color.outlineVariant),
      ),
    );
  }
}
