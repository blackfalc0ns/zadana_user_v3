import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/user_avatar_widget.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/user_info_widget.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.editProfile);
        },
        child: Container(
          padding: const EdgeInsets.all(Spacing.sm),
          child: Row(
            children: [
              UserAvatarWidget(),
              const SizedBox(width: Spacing.md),
              const Expanded(child: UserInfoWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
