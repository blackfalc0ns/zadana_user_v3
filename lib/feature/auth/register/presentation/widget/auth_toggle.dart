import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class AuthToggle extends StatelessWidget {
  const AuthToggle({
    super.key,
    required this.isSignUp,
    required this.onSignUp,
    required this.onLogIn,
    required this.loginLabel,
    required this.signUpLabel,
  });

  final bool isSignUp;
  final VoidCallback onSignUp;
  final VoidCallback onLogIn;
  final String loginLabel;
  final String signUpLabel;

  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.easeInOut;
  static const _kPadding = 3.0;
  static const _kHeight = 50.0;

  Alignment _pillAlignment(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    if (isRtl) {
      return isSignUp ? Alignment.centerLeft : Alignment.centerRight;
    } else {
      return isSignUp ? Alignment.centerRight : Alignment.centerLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kHeight,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(Spacing.buttonRadius),
      ),
      padding: const EdgeInsets.all(_kPadding),
      child: Stack(
        children: [
          // ── Sliding pill ──────────────────────────────────────
          AnimatedAlign(
            duration: _kDuration,
            curve: _kCurve,
            alignment: _pillAlignment(context),
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(Spacing.buttonRadius - 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Labels ───────────────────────────────────────────
          Row(
            children: [
              _TabLabel(
                label: loginLabel,
                active: !isSignUp,
                onTap: onLogIn,
                duration: _kDuration,
              ),
              _TabLabel(
                label: signUpLabel,
                active: isSignUp,
                onTap: onSignUp,
                duration: _kDuration,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.active,
    required this.onTap,
    required this.duration,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: duration,
            curve: Curves.easeInOut,
            style: AppTextStyles.labelLarge.copyWith(
              color: active ? AppColors.textOnPrimary : AppColors.textSecondary,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
