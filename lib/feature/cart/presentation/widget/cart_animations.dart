import 'package:flutter/material.dart';

class CartAnimations {
  late AnimationController _priceAnimationController;
  late Animation<Offset> _priceSlideAnimation;
  late Animation<double> _priceFadeAnimation;

  CartAnimations(TickerProvider vsync) {
    _setupAnimations(vsync);
  }

  void _setupAnimations(TickerProvider vsync) {
    _priceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );

    _priceSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _priceAnimationController,
      curve: Curves.easeOutBack,
    ));

    _priceFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _priceAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  Animation<Offset> get priceSlideAnimation => _priceSlideAnimation;
  Animation<double> get priceFadeAnimation => _priceFadeAnimation;

  void playPriceAnimation() {
    _priceAnimationController.forward(from: 0.0);
  }

  void dispose() {
    _priceAnimationController.dispose();
  }

  static Widget buildBottomBarTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
      )),
      child: child,
    );
  }

  static Widget buildVendorPromptTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}