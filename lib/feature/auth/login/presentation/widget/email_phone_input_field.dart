// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/font_manger.dart';
// import 'package:zadana_user_v3/config/theme/spacing.dart';
// import 'package:zadana_user_v3/config/theme/styles_manger.dart';
// import 'package:zadana_user_v3/core/extensions/extensions.dart';
// import 'package:zadana_user_v3/core/helpers/validators.dart';
// import 'package:zadana_user_v3/core/widgets/custom_text_field.dart';

// class EmailPhoneInputField extends StatefulWidget {
//   const EmailPhoneInputField({
//     super.key,
//     required this.controller,
//     this.validator,
//     this.textInputAction = TextInputAction.done,
//   });

//   final TextEditingController controller;
//   final String? Function(String?)? validator;
//   final TextInputAction textInputAction;

//   @override
//   State<EmailPhoneInputField> createState() => _EmailPhoneInputFieldState();
// }

// class _EmailPhoneInputFieldState extends State<EmailPhoneInputField> {
//   bool _isPhone = false;
//   String? _errorText;
//   final FocusNode _focusNode = FocusNode();
//   bool _isFocused = false;

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_onTextChanged);
//     _focusNode.addListener(_onFocusChanged);
//   }

//   @override
//   void dispose() {
//     widget.controller.removeListener(_onTextChanged);
//     _focusNode.removeListener(_onFocusChanged);
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _onFocusChanged() {
//     setState(() {
//       _isFocused = _focusNode.hasFocus;
//     });
//   }

//   void _onTextChanged() {
//     final text = widget.controller.text;

//     if (text.isEmpty) {
//       if (_isPhone) {
//         setState(() {
//           _isPhone = false;
//           _errorText = null;
//         });
//       }
//       return;
//     }

//     final isNumeric = RegExp(r'^[0-9+]+$').hasMatch(text);

//     if (isNumeric != _isPhone) {
//       setState(() => _isPhone = isNumeric);

//       if (isNumeric && !text.startsWith('+966')) {
//         final newText = '+966$text';
//         widget.controller.value = TextEditingValue(
//           text: newText,
//           selection: TextSelection.collapsed(offset: newText.length),
//         );
//       }

//       Future.microtask(() {
//         if (mounted) _focusNode.requestFocus();
//       });
//     }
//   }

//   BoxDecoration _getCountrySelectorDecoration(BuildContext context) {
//     final color = context.colorScheme;
//     Color borderColor;
//     double borderWidth;

//     if (_errorText != null) {
//       borderColor = color.error;
//       borderWidth = _isFocused ? 1.5 : 1.0;
//     } else if (_isFocused) {
//       borderColor = color.primary;
//       borderWidth = 1.5;
//     } else {
//       borderColor = color.outline.withValues(alpha: 0.2);
//       borderWidth = 1.0;
//     }

//     return BoxDecoration(
//       color: color.surface,
//       borderRadius: BorderRadius.circular(Spacing.inputRadius),
//       border: Border.all(color: borderColor, width: borderWidth),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = context.colorScheme;
//     final locale = context.localization;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         IntrinsicHeight(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                 child: Directionality(
//                   textDirection: _isPhone
//                       ? TextDirection.ltr
//                       : TextDirection.rtl,
//                   child: CustomTextField(
//                     focusNode: _focusNode,
//                     controller: widget.controller,
//                     keyboardType: _isPhone
//                         ? TextInputType.phone
//                         : TextInputType.emailAddress,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (_isPhone && _errorText != null) ...[
//           const SizedBox(height: Spacing.xs),
//           Padding(
//             padding: const EdgeInsetsDirectional.only(start: Spacing.base),
//             child: Text(
//               _errorText!,
//               style: getRegularStyle(
//                 fontSize: FontSize.size12,
//                 fontFamily: FontConstant.cairo,
//                 color: color.error,
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }
