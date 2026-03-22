import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';

mixin PaymentOrderMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  void handlePlaceOrder() {
    HapticFeedback.mediumImpact();
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showOrderSuccess();
      }
    });
  }

  void showOrderSuccess() {
    HapticFeedback.heavyImpact();
    
    // Navigate to payment success screen
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.paymentSuccess,
      arguments: '#ZD12345', // Order ID
    );
  }
}
