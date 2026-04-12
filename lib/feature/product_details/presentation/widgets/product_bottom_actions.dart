import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/cart_count_sync_service.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_usecase.dart';

class ProductBottomActions extends StatefulWidget {
  const ProductBottomActions({super.key, this.onAddToCart, this.onGoToCart});

  final VoidCallback? onAddToCart;
  final VoidCallback? onGoToCart;

  @override
  State<ProductBottomActions> createState() => _ProductBottomActionsState();
}

class _ProductBottomActionsState extends State<ProductBottomActions> {
  late final CartCountSyncService _cartCountSyncService;
  late final GetCartUseCase _getCartUseCase;
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _cartCountSyncService = CartCountSyncService();
    _getCartUseCase = getIt<GetCartUseCase>();
    _cartCountSyncService.addListener(_handleCartCountChanged);
    _loadInitialCartCount();
  }

  @override
  void dispose() {
    _cartCountSyncService.removeListener(_handleCartCountChanged);
    super.dispose();
  }

  Future<void> _loadInitialCartCount() async {
    final result = await _getCartUseCase.call();
    if (!mounted) return;

    switch (result) {
      case ApiSuccessResult():
        setState(() => _cartCount = result.data.summary.totalQuantity);
      case ApiErrorResult():
        break;
    }
  }

  void _handleCartCountChanged() {
    final absoluteCount = _cartCountSyncService.absoluteCount;
    if (absoluteCount != null) {
      if (!mounted) return;
      setState(() => _cartCount = math.max(0, absoluteCount));
      return;
    }

    if (_cartCountSyncService.refreshRequested) {
      _loadInitialCartCount();
      return;
    }

    if (!mounted) return;
    setState(() {
      _cartCount = math.max(0, _cartCount + _cartCountSyncService.delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.md,
        Spacing.base,
        Spacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.onAddToCart,
                icon: const FaIcon(FontAwesomeIcons.cartPlus, size: 17),
                label: Text(l10n.add_to_cart_button),
                style: ElevatedButton.styleFrom(
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
                onPressed: widget.onGoToCart,
                style: OutlinedButton.styleFrom(
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
                          if (_cartCount > 0)
                            PositionedDirectional(
                              top: -3,
                              end: -1,
                              child: _CartCountBadge(count: _cartCount),
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

    return Container(
      constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.surface, width: 1.2),
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
