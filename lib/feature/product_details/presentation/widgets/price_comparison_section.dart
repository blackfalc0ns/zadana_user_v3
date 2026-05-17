import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/modern_store_card.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';

class PriceComparisonSection extends StatefulWidget {
  const PriceComparisonSection({super.key, required this.vendorPrices});

  final List<ProductVendorPriceEntity> vendorPrices;

  @override
  State<PriceComparisonSection> createState() => _PriceComparisonSectionState();
}

class _PriceComparisonSectionState extends State<PriceComparisonSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -4), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -4, end: 4), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 4, end: -2), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -2, end: 2), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 2, end: 0), weight: 25),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant PriceComparisonSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger shake animation when vendor prices change
    final pricesChanged = _didPricesChange(
      oldWidget.vendorPrices,
      widget.vendorPrices,
    );
    if (pricesChanged) {
      _controller.forward(from: 0);
    }
  }

  bool _didPricesChange(
    List<ProductVendorPriceEntity> oldPrices,
    List<ProductVendorPriceEntity> newPrices,
  ) {
    if (oldPrices.length != newPrices.length) return true;
    for (int i = 0; i < oldPrices.length; i++) {
      if (oldPrices[i].price != newPrices[i].price) return true;
    }
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    if (widget.vendorPrices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.compare_prices,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            color: color.onSurfaceVariant,
            fontSize: FontSize.size15,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 138,
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: child,
              );
            },
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.vendorPrices.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final store = widget.vendorPrices[index];

                return SizedBox(
                  width: 145,
                  child: ModernStoreCard(
                    storeName: store.name,
                    price: store.price,
                    isLowest: false,
                    icon: Icons.store,
                    gradientColors: const [],
                    discountPercentage: 0,
                    isDiscounted: store.isDiscounted,
                    oldPrice: store.oldPrice,
                    storeImage: store.logoUrl,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
