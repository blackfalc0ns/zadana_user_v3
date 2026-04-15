import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';

class SuccessAnimationWidget extends StatelessWidget {
  const SuccessAnimationWidget({
    super.key,
    required ConfettiController confettiController,
  }) : _confettiController = confettiController;

  final ConfettiController _confettiController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Image.asset(
            Assets.successOrderAnimation,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.background,
                child: const Icon(
                  Icons.celebration,
                  size: 80,
                  color: AppColors.primary,
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                Color(0xFF4CAF50),
                Color(0xFF2196F3),
                Color(0xFFFFC107),
                Color(0xFFFF5722),
                Color(0xFF9C27B0),
              ],
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}
