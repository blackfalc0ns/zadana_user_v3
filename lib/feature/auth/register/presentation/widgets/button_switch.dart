import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class AppButtonSwitch extends StatelessWidget {
  const AppButtonSwitch({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      
      child: isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: color.onPrimary,
              ),
            )
          : Text(label),
    );
  }
}