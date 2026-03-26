import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locale.footer_have_account,
            style: getRegularStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: () => context.pushNamed(AppRoutes.signIn),
            child: Text(
              locale.toggle_login,
              style: getMediumStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
