import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'محمد أحمد',
          style: getBoldStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '+966 50 123 4567',
          style: getRegularStyle(
            fontSize: FontSize.size12,
            fontFamily: FontConstant.cairo,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
