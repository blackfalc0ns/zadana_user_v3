// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/core/extensions/extensions.dart';

// class EmailPhoneInputField extends StatefulWidget {
//   final TextEditingController controller;
//   final String? Function(String?)? validator;

//   const EmailPhoneInputField({
//     super.key,
//     required this.controller,
//     this.validator,
//   });

//   @override
//   State<EmailPhoneInputField> createState() => _EmailPhoneInputFieldState();
// }

// class _EmailPhoneInputFieldState extends State<EmailPhoneInputField> {
//   bool _isPhone = false;
//   String? _errorText;
//   final FocusNode _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_onTextChanged);
//   }

//   @override
//   void dispose() {
//     widget.controller.removeListener(_onTextChanged);
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _onTextChanged() {
//     final text = widget.controller.text;
//     if (text.isEmpty) {
//       if (_isPhone) setState(() => _isPhone = false);
//       return;
//     }
//     final isNumeric = RegExp(r'^[0-9+]+$').hasMatch(text);
//     if (isNumeric != _isPhone) {
//       setState(() => _isPhone = isNumeric);
//       if (isNumeric && !text.startsWith('+966')) {
//         final newText = '+966$text';
//         widget.controller.value = TextEditingValue(
//           text: newText,
//           selection: TextSelection.fromPosition(
//             TextPosition(offset: newText.length),
//           ),
//         );
//       }
//       Future.microtask(() {
//         if (mounted) _focusNode.requestFocus();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         IntrinsicHeight(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   focusNode: _focusNode,
//                   controller: widget.controller,
//                   keyboardType: _isPhone
//                       ? TextInputType.phone
//                       : TextInputType.emailAddress,
//                   textDirection: _isPhone ? TextDirection.ltr : null,
//                   style: context.textTheme.bodyMedium,
//                   validator: (value) {
//                     final error = widget.validator?.call(value);
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       if (mounted) setState(() => _errorText = error);
//                     });
//                     return error;
//                   },
//                   decoration: InputDecoration(
//                     hintText: _isPhone
//                         ? '7xxxxxxxx'
//                         : context.localization.hint_email,
//                     hintStyle: TextStyle(
//                       color: _isPhone
//                           ? Colors.grey.shade500
//                           : AppColors.textSecondary,
//                     ),
//                     prefixIcon: _isPhone
//                         ? null
//                         : Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Icon(
//                               Icons.email_outlined,
//                               color: context.colorScheme.onSurfaceVariant,
//                               size: 22,
//                             ),
//                           ),
//                     filled: true,
//                     fillColor: context.colorScheme.onPrimary,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: context.colorScheme.outline,
//                         width: 1,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: context.colorScheme.primary,
//                         width: 2,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: context.colorScheme.error,
//                         width: 1,
//                       ),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: context.colorScheme.error,
//                         width: 2,
//                       ),
//                     ),
//                     errorStyle: _isPhone
//                         ? const TextStyle(height: 0, fontSize: 0)
//                         : null,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                   ),
//                 ),
//               ),
//               if (_isPhone) ...[
//                 const SizedBox(width: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: _errorText != null
//                           ? context.colorScheme.error
//                           : context.colorScheme.outline,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.arrow_drop_down,
//                         size: 24,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(width: 6),
//                       Container(
//                         width: 24,
//                         height: 24,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             '🇯🇴',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         if (_isPhone && _errorText != null) ...[
//           const SizedBox(height: 6),
//           Padding(
//             padding: const EdgeInsets.only(left: 12),
//             child: Text(
//               _errorText!,
//               style: context.textTheme.bodySmall?.copyWith(
//                 color: context.colorScheme.error,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class EmailPhoneInputField extends StatefulWidget {
  const EmailPhoneInputField({
    super.key,
    required this.controller,
    this.validator,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  @override
  State<EmailPhoneInputField> createState() => _EmailPhoneInputFieldState();
}

class _EmailPhoneInputFieldState extends State<EmailPhoneInputField> {
  bool _isPhone = false;
  String? _errorText;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    final text = widget.controller.text;

    if (text.isEmpty) {
      if (_isPhone) {
        setState(() {
          _isPhone = false;
          _errorText = null;
        });
      }
      return;
    }

    final isNumeric = RegExp(r'^[0-9+]+$').hasMatch(text);

    if (isNumeric != _isPhone) {
      setState(() => _isPhone = isNumeric);

      if (isNumeric && !text.startsWith('+966')) {
        final newText = '+966$text';
        widget.controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }

      Future.microtask(() {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  /// Get border for country selector matching TextField state
  BoxDecoration _getCountrySelectorDecoration(BuildContext context) {
    Color borderColor;
    double borderWidth;

    if (_errorText != null) {
      // Error state - matches theme errorBorder
      borderColor = AppColors.error;
      borderWidth = _isFocused ? 1.5 : 1.0;
    } else if (_isFocused) {
      // Focused state - matches theme focusedBorder
      borderColor = AppColors.primary;
      borderWidth = 1.5;
    } else {
      // Normal state - matches theme enabledBorder
      borderColor = AppColors.border;
      borderWidth = 1.0;
    }

    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(Spacing.inputRadius),
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Directionality(
                  textDirection: _isPhone ? TextDirection.ltr : TextDirection.rtl,
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: widget.controller,
                    keyboardType: _isPhone
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    textInputAction: widget.textInputAction,
                    style: AppTextStyles.input,
                    validator: (value) {
                      final error = widget.validator?.call(value);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && _errorText != error) {
                          setState(() => _errorText = error);
                        }
                      });

                      return _isPhone ? null : error;
                    },
                    decoration: InputDecoration(
                      hintText: _isPhone
                          ? '5xxxxxxxx'
                          : context.localization.hint_email_or_phone,
                      hintStyle: AppTextStyles.inputHint,
                      prefixIcon: _isPhone
                          ? null
                          : const Icon(
                              Icons.email_outlined,
                              color: AppColors.textSecondary,
                              size: Spacing.iconMd,
                            ),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Spacing.base,
                        vertical: Spacing.md,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Spacing.inputRadius),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Spacing.inputRadius),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Spacing.inputRadius),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Spacing.inputRadius),
                        borderSide: const BorderSide(color: AppColors.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Spacing.inputRadius),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                      ),
                      errorStyle: _isPhone
                          ? const TextStyle(height: 0, fontSize: 0)
                          : AppTextStyles.inputError,
                    ),
                  ),
                ),
              ),
              if (_isPhone) ...[
                const SizedBox(width: Spacing.sm),
                Container(
                  decoration: _getCountrySelectorDecoration(context),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.base,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.textSecondary,
                            size: Spacing.iconMd,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '🇸🇦',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_isPhone && _errorText != null) ...[
          const SizedBox(height: Spacing.xs),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: Spacing.base),
            child: Text(
              _errorText!,
              style: AppTextStyles.inputError,
            ),
          ),
        ],
      ],
    );
  }
}