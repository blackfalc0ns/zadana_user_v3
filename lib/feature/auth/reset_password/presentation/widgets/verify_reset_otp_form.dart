import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/widget/otp_input_field.dart';

class VerifyResetOtpForm extends StatefulWidget {
  const VerifyResetOtpForm({
    super.key,
    required this.identifier,
    required this.onSuccess,
  });

  final String identifier;
  final void Function(String otpCode) onSuccess;

  @override
  State<VerifyResetOtpForm> createState() => _VerifyResetOtpFormState();
}

class _VerifyResetOtpFormState extends State<VerifyResetOtpForm> {
  final List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;

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
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
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

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      widget.onSuccess(otpCode);
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

    return Column(
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
      ],
    );
  }
}
