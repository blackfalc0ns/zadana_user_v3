import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/sign_in/presentation/widget/sign_in_form.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/auth_toggle.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// false = Log In  active → pill شمال  (default)
  /// true  = Sign Up active → pill يمين
  bool _isSignUp = false;

  void _switchTab(bool toSignUp) {
    if (_isSignUp == toSignUp) return;
    setState(() => _isSignUp = toSignUp);
  }

  @override
  Widget build(BuildContext context) {
    // ── Localization ──────────────────────────────────────────────
    final locale = context.localization;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.screenV,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppConstants.logoDark,
                      height: 52,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: Spacing.md),

                    Text(
                      locale.auth_title,
                      style: AppTextStyles.h2,
                    ),

                    const SizedBox(height: Spacing.sm),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        _isSignUp
                            ? locale.auth_subtitle_signup
                            : locale.auth_subtitle_login,
                        key: ValueKey(_isSignUp),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Spacing.xl),

              // ── Toggle ────────────────────────────────────────
              AuthToggle(
                isSignUp:    _isSignUp,
                onSignUp:    () => _switchTab(true),
                onLogIn:     () => _switchTab(false),
                loginLabel:  locale.toggle_login,
                signUpLabel: locale.toggle_signup,
              ),

              const SizedBox(height: Spacing.xl),

              // ── Forms ─────────────────────────────────────────
              // كل form عندها state وkey منفصلين تماماً
              // لما بتعمل switch الـ errors بتاعت الـ form التانية بتتمسح
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: _isSignUp
                    ? const SignUpForm(key: ValueKey('signup'))
                    : const LoginForm(key: ValueKey('login')),
              ),

              const SizedBox(height: Spacing.lg),

              // ── Footer ────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => _switchTab(!_isSignUp),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodySmall,
                      children: [
                        TextSpan(
                          text: _isSignUp
                              ? locale.footer_have_account
                              : locale.footer_no_account,
                        ),
                        TextSpan(
                          text: _isSignUp
                              ? locale.footer_action_login
                              : locale.footer_action_signup,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}