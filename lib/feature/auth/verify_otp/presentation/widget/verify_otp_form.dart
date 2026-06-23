import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/domain/entities/verify_otp_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_event.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_state.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_view_model.dart';
import 'otp_cooldown_button.dart';
import 'otp_input_field.dart';

class VerifyOtpForm extends StatefulWidget {
  const VerifyOtpForm({super.key, required this.identifier});

  final String identifier;

  @override
  State<VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _controllers[0].addListener(_handlePaste);
    for (int i = 0; i < 4; i++) {
      _focusNodes[i].addListener(() => _handleFocusChange(i));
    }
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
          content: Text(
            AppLocalizations.of(context)!.otp_complete_code_required,
          ),
          backgroundColor: context.colorScheme.error,
        ),
      );
      return;
    }

    context.read<VerifyOtpViewModel>().doIntent(
      VerifyOtpSubmitEvent(
        requestEntity: VerifyOtpRequestEntity(
          identifier: widget.identifier,
          otpCode: _otpCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = context.colorScheme;

    return BlocBuilder<VerifyOtpViewModel, VerifyOtpState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.otp_description,
              style: getRegularStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
                color: color.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              '${locale.otp_code_sent_to} ${widget.identifier}',
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
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      nextFocusNode: index < 3 ? _focusNodes[index + 1] : null,
                      previousFocusNode: index > 0
                          ? _focusNodes[index - 1]
                          : null,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: Spacing.lg),
            AppButtonSwitch(
              label: locale.otp_verify_button,
              onPressed: _isOtpComplete ? () => _submitOtp(context) : () {},
              isLoading: state.isLoading,
            ),
            const SizedBox(height: Spacing.lg),
            Center(
              child: OtpCooldownButton(
                isResending: state.isResending,
                cooldownSeconds: 60,
                startWithCooldown: true,
                onResend: () {
                  context.read<VerifyOtpViewModel>().doIntent(
                    ResendOtpCodeEvent(identifier: widget.identifier),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
