import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBar({
    super.key,
    required this.itemCount,
    required this.totalQuantity,
    this.onClearAll,
  });
  final int itemCount;
  final int totalQuantity;
  final VoidCallback? onClearAll;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return CustomAppBar(
      showBackButton: false,

      titleWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text(locale.cart)],
      ),
      actions: [
        if (onClearAll != null)
          IconButton(
            onPressed: onClearAll,
            icon: Icon(Iconsax.trash, size: 20, color: color.error),
          ),
      ],
    );
  }
}
