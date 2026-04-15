import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class ProductBottomActions extends StatelessWidget {
  const ProductBottomActions({
    super.key,
    this.onAddToCart,
    this.onGoToCart,
    this.cartCount = 0,
    this.isAddingToCart = false,
  });

  final VoidCallback? onAddToCart;
  final VoidCallback? onGoToCart;
  final int cartCount;
  final bool isAddingToCart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = context.colorScheme;
    final cartButtonBackground = Color.alphaBlend(
      color.primary.withValues(alpha: 0.06),
      color.surface,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
      ), //padding: const EdgeInsets.all(Spacing.base),

      decoration: BoxDecoration(color: color.surface),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isAddingToCart ? null : onAddToCart,
                icon: isAddingToCart
                    ? SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color.onPrimary,
                        ),
                      )
                    : const FaIcon(FontAwesomeIcons.cartPlus, size: 17),
                label: Text(l10n.add_to_cart_button),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.primary,
                  foregroundColor: color.onPrimary,
                  disabledBackgroundColor: color.primary.withValues(
                    alpha: 0.72,
                  ),
                  disabledForegroundColor: color.onPrimary,
                  minimumSize: const Size.fromHeight(46),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: OutlinedButton(
                onPressed: onGoToCart,
                style: OutlinedButton.styleFrom(
                  foregroundColor: color.onSurface,
                  side: BorderSide(
                    color: color.primary.withValues(alpha: 0.45),
                  ),
                  backgroundColor: cartButtonBackground,
                  minimumSize: const Size.fromHeight(48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 28,
                      height: 24,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.cartShopping, size: 17),
                          if (cartCount > 0)
                            PositionedDirectional(
                              top: -3,
                              end: -1,
                              child: _CartCountBadge(count: cartCount),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      l10n.nav_cart,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartCountBadge extends StatelessWidget {
  const _CartCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final displayCount = count > 99 ? '99+' : '$count';
    final color = context.colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.error,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.surface, width: 1.2),
      ),
      child: Center(
        child: Text(
          displayCount,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
