import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class GradientSectionTitle extends StatelessWidget {
  const GradientSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    
    return Text(
      title,
      style: getBoldStyle(
        fontFamily: FontConstant.cairo,
        fontSize: FontSize.size16,
        color: color.primary,
      ),
    );
  }
}
