import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';

class LogoWidget extends StatelessWidget {
  final String logoAsset;
  final double width;
  final double height;

  const LogoWidget({
    super.key,
    required this.logoAsset,
    this.width = 80,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      logoAsset,
      width: width,
      height: height,
    );
  }
}
