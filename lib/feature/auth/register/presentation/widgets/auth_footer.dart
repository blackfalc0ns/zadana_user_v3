import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_event.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';

/// Footer widget with toggle text
/// Following requirements:
/// - Uses context.textTheme
/// - Uses ColorScheme
/// - No hardcoded colors
/// - Dispatches events to ViewModel
class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

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
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
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
