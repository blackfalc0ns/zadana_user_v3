import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_event.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocBuilder<RegisterViewModel, RegisterState>(
      builder: (context, state) {
        final promptText = state.isSignUp
            ? locale.footer_have_account
            : locale.footer_no_account;
        
        final actionText = state.isSignUp
            ? locale.toggle_login
            : locale.toggle_signup;

        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                promptText,
                style: getRegularStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (state.isSignUp) {
                    context
                      .read<RegisterViewModel>()
                      .doIntent(
                        const SwitchToLoginEvent()
                      );
                  } else {
                    context
                      .read<RegisterViewModel>()
                      .doIntent(
                        const SwitchToSignUpEvent()
                      );
                  }
                },
                child: Text(
                  actionText,
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
      },
    );
  }
}
