import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/domain/entities/verify_otp_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_event.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_state.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_view_model.dart';
import 'otp_input_field.dart';

/// Verify OTP form widget with 4-digit OTP input
class VerifyOtpForm extends StatefulWidget {
  const VerifyOtpForm({super.key, required this.identifier});

  final String identifier;

  @override
  State<VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<VerifyOtpForm> with _OtpFormMixin {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<VerifyOtpViewModel, VerifyOtpState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OtpDescription(
              identifier: widget.identifier,
              localizations: localizations,
            ),
            const SizedBox(height: Spacing.lg),
            _OtpInputRow(
              controllers: controllers,
              focusNodes: focusNodes,
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: Spacing.lg),
            _VerifyButton(
              isEnabled: isOtpComplete,
              isLoading: state.isLoading,
              onPressed: () => _submitOtp(context),
              localizations: localizations,
            ),
          ],
        );
      },
    );
  }

  void _submitOtp(BuildContext context) {
    if (!isOtpComplete) {
      _showIncompleteOtpError(context);
      return;
    }

    final requestEntity = VerifyOtpRequestEntity(
      identifier: widget.identifier,
      otpCode: otpCode,
    );

    context.read<VerifyOtpViewModel>().doIntent(
      VerifyOtpSubmitEvent(requestEntity: requestEntity),
    );
  }

  void _showIncompleteOtpError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.otp_complete_code_required),
        backgroundColor: context.colorScheme.error,
      ),
    );
  }
}

/// OTP description and identifier display
class _OtpDescription extends StatelessWidget {
  const _OtpDescription({
    required this.identifier,
    required this.localizations,
  });

  final String identifier;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.otp_description,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          '${localizations.otp_code_sent_to} $identifier',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Row of OTP input fields
class _OtpInputRow extends StatelessWidget {
  const _OtpInputRow({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              onChanged: (_) => onChanged(),
            ),
          ),
        );
      }),
    );
  }
}

/// Verify button with loading state
class _VerifyButton extends StatelessWidget {
  const _VerifyButton({
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
    required this.localizations,
  });

  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return AppButtonSwitch(
      label: localizations.otp_verify_button,
      onPressed: isEnabled ? onPressed : () {},
      isLoading: isLoading,
    );
  }
}

/// Mixin for OTP form logic
mixin _OtpFormMixin<T extends StatefulWidget> on State<T> {
  final List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

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
}