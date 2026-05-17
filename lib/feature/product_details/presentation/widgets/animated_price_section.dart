import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';

/// Displays the product price with a scale + fade animation when the value changes.
class AnimatedPriceSection extends StatefulWidget {
  const AnimatedPriceSection({
    super.key,
    required this.price,
    this.oldPrice,
    required this.currency,
  });

  final double price;
  final double? oldPrice;
  final String currency;

  @override
  State<AnimatedPriceSection> createState() => _AnimatedPriceSectionState();
}

class _AnimatedPriceSectionState extends State<AnimatedPriceSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late double _displayedPrice;

  @override
  void initState() {
    super.initState();
    _displayedPrice = widget.price;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant AnimatedPriceSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.price != widget.price) {
      _controller.forward(from: 0).then((_) {
        if (mounted) setState(() => _displayedPrice = widget.price);
      });
      // Update displayed price at the midpoint of the animation
      Future.delayed(const Duration(milliseconds: 140), () {
        if (mounted) setState(() => _displayedPrice = widget.price);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final hasDiscount =
        widget.oldPrice != null && widget.oldPrice! > widget.price;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          children: [
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value.clamp(0.0, 1.0),
                child: Text(
                  '${PriceFormatter.formatPrice(_displayedPrice)} ${widget.currency}',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
                    fontSize: FontSize.size20,
                  ),
                ),
              ),
            ),
            if (hasDiscount) ...[
              const SizedBox(width: 8),
              Text(
                '${PriceFormatter.formatPrice(widget.oldPrice!)} ${widget.currency}',
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: color.onSurfaceVariant,
                  fontSize: FontSize.size14,
                ).copyWith(decoration: TextDecoration.lineThrough),
              ),
            ],
          ],
        );
      },
    );
  }
}
