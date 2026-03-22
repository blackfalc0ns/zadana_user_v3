import 'package:flutter/material.dart';

mixin PaymentAnimationsMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  void initializePaymentAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void disposePaymentAnimations() {
    _fadeController.dispose();
    _slideController.dispose();
  }
}
