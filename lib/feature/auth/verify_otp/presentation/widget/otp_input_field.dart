
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

/// Single OTP input field
/// Accepts only one numeric digit
class OtpInputField extends StatelessWidget {
  const OtpInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.previousFocusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AspectRatio(
      aspectRatio: 1.0,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: context.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.primary, width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            controller.text = value[value.length - 1];
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
            nextFocusNode?.requestFocus();
          }
          onChanged(value);
        },
        onTap: () {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        },
      ),
    );
  }
}