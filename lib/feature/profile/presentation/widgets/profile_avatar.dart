import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

/// Profile avatar with edit badge
class ProfileAvatar extends StatelessWidget {
  final String userName;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.userName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.primaryContainer.withOpacity(0.1),
          child: Center(
            child: Text(
            userName.isNotEmpty ? userName[0] : 'م',
            style: getBoldStyle(
              fontSize: FontSize.size20,
              fontFamily: FontConstant.cairo,
              color: color.primary,
            ),
          ),
        ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: color.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.surface,
                  width: 1.5,
                ),
              ),
              child: const FaIcon(
                FontAwesomeIcons.pen,
                size: 8,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
