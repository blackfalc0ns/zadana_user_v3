import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int itemCount;
  final int totalQuantity;
  final VoidCallback? onClearAll;
  const CartAppBar({
    super.key,
    required this.itemCount,
    required this.totalQuantity,
    this.onClearAll,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return CustomAppBar(
      showBackButton: false,
      backgroundColor: color.surface,
      titleWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text(locale.cart)],
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
    );
  }
}
