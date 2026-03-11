import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';

class CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}