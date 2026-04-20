import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double size;

  const CustomProgressIndicator({super.key, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.grey[650],
        margin: const EdgeInsets.all(16),
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Transform.scale(
            scale: 2.99,
            child: Lottie.asset(
              Assets.loading,
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
