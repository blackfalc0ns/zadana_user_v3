import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/usecase/verify_reset_otp_usecase.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/domain/usecase/resend_reset_otp_usecase.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/widget/otp_cooldown_button.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/widget/otp_input_field.dart';

class VerifyResetOtpForm extends StatefulWidget {
  const VerifyResetOtpForm({
    super.key,
    required this.identifier,
    required this.onSuccess,
    this.onLoadingChanged,
  });

  final String identifier;
  final void Function(String resetToken) onSuccess;
  final ValueChanged<bool>? onLoadingChanged;

  @override
  State<VerifyResetOtpForm> createState() => _VerifyResetOtpFormState();
}

class _VerifyResetOtpFormState extends State<VerifyResetOtpForm> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;
  bool _isResending = false;

  final VerifyResetOtpUseCase _verifyResetOtpUseCase =
      getIt<VerifyResetOtpUseCase>();
  final ResendResetOtpUseCase _resendResetOtpUseCase =
      getIt<ResendResetOtpUseCase>();

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _setupListeners() {
    controllers[0].addListener(_handlePaste);
    for (int i = 0; i < 4; i++) {
      focusNodes[i].addListener(() => _handleFocusChange(i));
    }
  }

  void _disposeControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
  }

  void _handlePaste() {
    final text = controllers[0].text;
    if (text.length > 1) {
      _distributePastedText(text);
    }
  }

  void _distributePastedText(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < 4 && i < digits.length; i++) {
      controllers[i].text = digits[i];
    }
    final lastIndex = digits.length < 4 ? digits.length : 3;
    focusNodes[lastIndex].requestFocus();
    setState(() {});
  }

  void _handleFocusChange(int index) {
    if (focusNodes[index].hasFocus && controllers[index].text.isEmpty) {
      focusNodes[index].onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          if (index > 0 && controllers[index].text.isEmpty) {
            focusNodes[index - 1].requestFocus();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      };
    }
  }

  String get otpCode => controllers.map((c) => c.text).join();
  bool get isOtpComplete => otpCode.length == 4;

  Future<void> _submitOtp(BuildContext context) async {
    if (!isOtpComplete) {
      _showIncompleteOtpError(context);
      return;
    }

    setState(() => _isLoading = true);
    widget.onLoadingChanged?.call(true);

    final result = await _verifyResetOtpUseCase.call(
      identifier: widget.identifier,
      otpCode: otpCode,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);
    widget.onLoadingChanged?.call(false);

    switch (result) {
      case ApiSuccessResult():
        if (context.mounted && result.data.message != null) {
          CustomSnackbar.showSuccess(
            context: context,
            message: result.data.message!,
          );
        }
        widget.onSuccess(result.data.resetToken);
      case ApiErrorResult():
        if (context.mounted) {
          CustomSnackbar.showError(
            context: context,
            message: result.failure.errorMessage,
          );
        }
    }
  }

  Future<void> _resendOtp(BuildContext context) async {
    setState(() => _isResending = true);

    final result = await _resendResetOtpUseCase.call(widget.identifier);

    if (!mounted) return;

    setState(() => _isResending = false);

    switch (result) {
      case ApiSuccessResult():
        if (context.mounted) {
          CustomSnackbar.showSuccess(
            context: context,
            message: AppLocalizations.of(context)!.otp_resend_success,
          );
        }
      case ApiErrorResult():
        if (context.mounted) {
          CustomSnackbar.showError(
            context: context,
            message: result.failure.errorMessage,
          );
        }
    }
  }

  void _showIncompleteOtpError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.otp_complete_code_required),
        backgroundColor: context.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return AbsorbPointer(
      absorbing: _isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${localizations.otp_code_sent_to} ${widget.identifier}',
            style: getMediumStyle(
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            textDirection: TextDirection.ltr,
            children: List.generate(4, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: index > 0 ? 4.0 : 0.0),
                  child: OtpInputField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    nextFocusNode: index < 3 ? focusNodes[index + 1] : null,
                    previousFocusNode: index > 0 ? focusNodes[index - 1] : null,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: Spacing.lg),
          AppButtonSwitch(
            label: localizations.otp_verify_button,
            onPressed: isOtpComplete ? () => _submitOtp(context) : () {},
            isLoading: _isLoading,
          ),
          const SizedBox(height: Spacing.lg),
          Center(
            child: OtpCooldownButton(
              isResending: _isResending,
              cooldownSeconds: 60,
              startWithCooldown: true,
              onResend: () => _resendOtp(context),
            ),
          ),
          const SizedBox(height: Spacing.base),
        ],
      ),
    );
  }
}
