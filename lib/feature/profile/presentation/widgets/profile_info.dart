import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

/// Profile info (name and phone)
class ProfileInfo extends StatelessWidget {
  final String userName;
  final String userPhone;

  const ProfileInfo({
    super.key,
    required this.userName,
    required this.userPhone,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            userPhone,
            style: getMediumStyle(
              fontSize: FontSize.size13,
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
