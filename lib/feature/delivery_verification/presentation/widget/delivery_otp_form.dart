import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/manager/delivery_otp_event.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/manager/delivery_otp_state.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/manager/delivery_otp_view_model.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/delivery_otp_input_field.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/delivery_otp_header.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/widget/delivery_otp_resend_button.dart';

class DeliveryOtpForm extends StatefulWidget {
  const DeliveryOtpForm({
    super.key,
    required this.orderId,
    required this.phoneNumber,
  });

  final String orderId;
  final String phoneNumber;

  @override
  State<DeliveryOtpForm> createState() => _DeliveryOtpFormState();
}

class _DeliveryOtpFormState extends State<DeliveryOtpForm> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _controllers[0].addListener(_handlePaste);
    for (int i = 0; i < 4; i++) {
      _focusNodes[i].addListener(() => _handleFocusChange(i));
    }
    
    Future.microtask(() {
      context.read<DeliveryOtpViewModel>().doIntent(
        SendOtpEvent(
          orderId: widget.orderId,
          phoneNumber: widget.phoneNumber,
        ),
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handlePaste() {
    final text = _controllers[0].text;
    if (text.length > 1) {
      final digits = text.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < 4 && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final lastIndex = digits.length < 4 ? digits.length : 3;
      _focusNodes[lastIndex].requestFocus();
      setState(() {});
    }
  }

  void _handleFocusChange(int index) {
    if (_focusNodes[index].hasFocus && _controllers[index].text.isEmpty) {
      _focusNodes[index].onKeyEvent = (node, event) {
        if (event is KeyDownEvent && 
            event.logicalKey == LogicalKeyboardKey.backspace &&
            index > 0 && 
            _controllers[index].text.isEmpty) {
          _focusNodes[index - 1].requestFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }
  }

  String get _otpCode => _controllers.map((c) => c.text).join();
  bool get _isOtpComplete => _otpCode.length == 4;

  void _submitOtp(BuildContext context) {
    if (!_isOtpComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.delivery_otp_required),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    context.read<DeliveryOtpViewModel>().doIntent(
      VerifyOtpEvent(
        orderId: widget.orderId,
        otpCode: _otpCode,
      ),
    );
  }

  void _resendOtp(BuildContext context) {
    context.read<DeliveryOtpViewModel>().doIntent(
      ResendOtpEvent(orderId: widget.orderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme;

    return BlocBuilder<DeliveryOtpViewModel, DeliveryOtpState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DeliveryOtpHeader(phoneNumber: widget.phoneNumber),
            const SizedBox(height: Spacing.lg),
            _buildOtpRow(),
            const SizedBox(height: Spacing.md),
            if (state.errorMessage != null) _buildErrorMessage(state, color),
            if (state.remainingAttempts < 3) _buildRemainingAttempts(state, locale, color),
            const SizedBox(height: Spacing.sm),
            AppButton(
              text: locale.delivery_otp_verify_button,
              onPressed: _isOtpComplete && !state.isLoading
                  ? () => _submitOtp(context)
                  : () {},
              isLoading: state.isLoading,
              color: color.primary,
              textColor: color.onPrimary,
            ),
            const SizedBox(height: Spacing.base),
            DeliveryOtpResendButton(
              canResend: state.canResend,
              resendTimer: state.resendTimer,
              onResend: () => _resendOtp(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOtpRow() {
    return Row(
      textDirection: TextDirection.ltr,
      children: List.generate(4, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: index > 0 ? 4.0 : 0.0),
            child: DeliveryOtpInputField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              nextFocusNode: index < 3 ? _focusNodes[index + 1] : null,
              previousFocusNode: index > 0 ? _focusNodes[index - 1] : null,
              onChanged: (_) => setState(() {}),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorMessage(DeliveryOtpState state, ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Text(
        state.errorMessage!,
        style: getRegularStyle(
          fontSize: FontSize.size14,
          fontFamily: FontConstant.cairo,
          color: color.error,
        ),
      ),
    );
  }

  Widget _buildRemainingAttempts(DeliveryOtpState state, AppLocalizations locale, ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Text(
        '${locale.delivery_otp_remaining_attempts}: ${state.remainingAttempts}',
        style: getRegularStyle(
          fontSize: FontSize.size14,
          fontFamily: FontConstant.cairo,
          color: color.error,
        ),
      ),
    );
  }
}

