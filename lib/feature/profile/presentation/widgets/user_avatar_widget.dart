import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/edit_icon_widget.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.primary.withValues(alpha: 0.1),
          child: Text(
            'م',
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: color.primary,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: EditIconWidget(),
        ),
      ],
    );
  }
}
