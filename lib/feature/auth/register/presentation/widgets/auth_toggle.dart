import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/constants/register_constants.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_event.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';

/// Toggle widget for switching between login and signup
/// Following requirements:
/// - Uses ColorScheme only
/// - Uses context.textTheme
/// - No hardcoded colors
/// - Dispatches events to ViewModel
class AuthToggle extends StatelessWidget {
  const AuthToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<RegisterViewModel, RegisterState>(
      builder: (context, state) {
        return _AuthToggleContent(
          isSignUp: state.isSignUp,
          loginLabel: locale.toggle_login,
          signUpLabel: locale.toggle_signup,
          colorScheme: colorScheme,
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
      height: RegisterConstants.toggleHeight,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: 
          BorderRadius.circular(Spacing.buttonRadius),
      ),
      padding: const EdgeInsets.all(
        RegisterConstants.togglePadding
      ),
      child: Stack(
        children: [
          // Sliding pill
          AnimatedAlign(
            duration: 
              RegisterConstants.pillAnimationDuration,
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
          
          // Labels
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
    final textTheme = context.textTheme;
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: 
              RegisterConstants.pillAnimationDuration,
            curve: Curves.easeInOut,
            style: textTheme.labelLarge!.copyWith(
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
