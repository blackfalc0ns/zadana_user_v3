import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class DeliveryOtpInputField extends StatelessWidget {
  const DeliveryOtpInputField({
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
    final color = context.colorScheme;

    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: context.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: color.onSurface,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: color.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Spacing.inputRadius),
            borderSide: BorderSide(
              color: color.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Spacing.inputRadius),
            borderSide: BorderSide(
              color: color.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Spacing.inputRadius),
            borderSide: BorderSide(color: color.primary, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Spacing.inputRadius),
            borderSide: BorderSide(color: color.error, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
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