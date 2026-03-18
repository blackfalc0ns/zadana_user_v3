import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_event.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';

class AuthToggle extends StatelessWidget {
  const AuthToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocBuilder<RegisterViewModel, RegisterState>(
      builder: (context, state) {
        return _AuthToggleContent(
          isSignUp: state.isSignUp,
          loginLabel: locale.toggle_login,
          signUpLabel: locale.toggle_signup,
          colorScheme: color,
          onSignUp: () => context
            .read<RegisterViewModel>()
            .doIntent(const SwitchToSignUpEvent()),
          onLogIn: () => context
            .read<RegisterViewModel>()
            .doIntent(const SwitchToLoginEvent()),
        );
      },
    );
  }
}

class _AuthToggleContent extends StatelessWidget {
  const _AuthToggleContent({
    required this.isSignUp,
    required this.loginLabel,
    required this.signUpLabel,
    required this.colorScheme,
    required this.onSignUp,
    required this.onLogIn,
  });

  final bool isSignUp;
  final String loginLabel;
  final String signUpLabel;
  final ColorScheme colorScheme;
  final VoidCallback onSignUp;
  final VoidCallback onLogIn;

  Alignment _pillAlignment(BuildContext context) {
    final isRtl = 
      Directionality.of(context) == TextDirection.rtl;
    if (isRtl) {
      return isSignUp 
        ? Alignment.centerLeft 
        : Alignment.centerRight;
    } else {
      return isSignUp 
        ? Alignment.centerRight 
        : Alignment.centerLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.toggleHeight,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: 
          BorderRadius.circular(Spacing.buttonRadius),
      ),
      padding: const EdgeInsets.all(AppConstants.togglePadding),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: 
              AppConstants.pillAnimationDuration,
            curve: Curves.easeInOut,
            alignment: _pillAlignment(context),
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(
                    Spacing.buttonRadius - 2
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary
                        .withValues(alpha: 0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Row(
            children: [
              _TabLabel(
                label: loginLabel,
                active: !isSignUp,
                onTap: onLogIn,
                colorScheme: colorScheme,
              ),
              _TabLabel(
                label: signUpLabel,
                active: isSignUp,
                onTap: onSignUp,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.active,
    required this.onTap,
    required this.colorScheme,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: 
              AppConstants.pillAnimationDuration,
            curve: Curves.easeInOut,
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: active 
                ? colorScheme.onPrimary 
                : colorScheme.onSurfaceVariant,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
