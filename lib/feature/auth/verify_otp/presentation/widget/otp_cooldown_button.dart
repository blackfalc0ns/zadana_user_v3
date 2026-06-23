import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

/// Reusable OTP resend button with 60-second cooldown timer.
///
/// Shows a countdown when the cooldown is active, otherwise
/// shows a "Resend Code" button.
class OtpCooldownButton extends StatefulWidget {
  const OtpCooldownButton({
    super.key,
    required this.onResend,
    required this.isResending,
    this.cooldownSeconds = 60,
    this.startWithCooldown = true,
  });

  /// Called when the user taps "Resend" (only when cooldown is inactive).
  final VoidCallback onResend;

  /// Whether a resend network call is in progress.
  final bool isResending;

  /// Cooldown duration in seconds.
  final int cooldownSeconds;

  /// Whether to start with cooldown active immediately (e.g. after
  /// navigating to the OTP screen for the first time).
  final bool startWithCooldown;

  @override
  State<OtpCooldownButton> createState() => OtpCooldownButtonState();
}

class OtpCooldownButtonState extends State<OtpCooldownButton> {
  Timer? _timer;
  int _remainingSeconds = 0;

  bool get _isCooldownActive => _remainingSeconds > 0;

  @override
  void initState() {
    super.initState();
    if (widget.startWithCooldown) {
      _startCooldown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Public method so parent widgets can trigger cooldown after
  /// a successful resend response.
  void startCooldown() => _startCooldown();

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _remainingSeconds = widget.cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 1) {
        _timer?.cancel();
        if (mounted) setState(() => _remainingSeconds = 0);
      } else {
        if (mounted) setState(() => _remainingSeconds--);
      }
    });
  }

  void _handleTap() {
    if (_isCooldownActive || widget.isResending) return;
    widget.onResend();
    _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    if (widget.isResending) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_isCooldownActive) {
      return Text(
        _cooldownText(locale),
        style: getMediumStyle(
          fontSize: FontSize.size14,
          fontFamily: FontConstant.cairo,
          color: color.onSurface.withValues(alpha: 0.5),
        ),
      );
    }

    return TextButton(
      onPressed: _handleTap,
      child: Text(
        locale.otp_resend_code,
        style: getMediumStyle(
          fontSize: FontSize.size14,
          fontFamily: FontConstant.cairo,
          color: color.primary,
        ),
      ),
    );
  }

  String _cooldownText(AppLocalizations locale) {
    return locale.otp_resend_cooldown(_remainingSeconds);
  }
}
