import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key, this.size = 100.0});
  final double size;

  @override
  Widget build(BuildContext context) {
    final double effectiveSize = size * 2.6;

    return Center(
      child: Lottie.asset(
        Assets.loading,
        width: effectiveSize,
        height: effectiveSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
