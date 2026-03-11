import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    
    return AppBar(
      centerTitle: true,
      title: Column(
        children: [
          Text(l10n.cart, style: AppTextStyles.h4),
          if (itemCount > 0)
            Text(
              '$totalQuantity ${l10n.product}',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (onClearAll != null)
          TextButton(
            onPressed: onClearAll,
            child: Text(
              l10n.clear_all,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.divider),
      ),
    );
  }
}
