import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_avatar.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_info.dart';

/// Profile card widget - displays user avatar and info
class ProfileCard extends StatelessWidget {
  final String userName;
  final String userPhone;
  final VoidCallback onEditTap;

  const ProfileCard({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: GestureDetector(
        onTap: onEditTap,
        child: Row(
          children: [
            ProfileAvatar(
              userName: userName,
              onTap: onEditTap,
            ),
            const SizedBox(width: Spacing.md),
            ProfileInfo(
              userName: userName,
              userPhone: userPhone,
            ),
          ],
        ),
      ),
    );
  }
}
