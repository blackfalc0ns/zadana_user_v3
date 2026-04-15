import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';

class FavoritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavoritesAppBar({super.key, this.onClearAll, this.itemCount = 0});
  final VoidCallback? onClearAll;
  final int itemCount;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return CustomAppBar(
      showShadow: false,
      showBackButton: false,
      backgroundColor: color.surface,
      titleWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(locale.favorites),
          if (itemCount > 0)
            Text(
              '$itemCount ${locale.product}',
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
          IconButton(
            onPressed: onClearAll,
            icon: Icon(Iconsax.trash, size: 20, color: color.error),
          ),
      ],
    );
  }
}
