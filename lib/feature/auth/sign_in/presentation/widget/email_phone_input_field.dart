// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/config/theme/spacing.dart';
// import 'package:zadana_user_v3/config/theme/text_styles.dart';
// import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

// class EmailPhoneInputField extends StatefulWidget {
//   final TextEditingController controller;
//   final String? Function(String?)? validator;

//   const EmailPhoneInputField({
//     super.key,
//     required this.controller,
//     this.validator,
//   });

//   @override
//   State<EmailPhoneInputField> createState() => 
//       _EmailPhoneInputFieldState();
// }
//   State<EmailPhoneInputField> createState() => _EmailPhoneInputFieldState();

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
//     if (t(_isPhone) setState(() => _isPhone = false);
//       return;
//     }
//     final isNumeric = RegExp(r'^[0-9+]+$').hasMatch(text);
//     if (isNumeric != _isPhone) {
//       setState(() => _isPhone = isNumeric);
//       if (isNumeric && !text.startsWith('+962')) {
//         final newText = '+962$text';
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
//     final l10n = AppLocalizations.of(context)!;

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
//                   style: AppTextStyles.bodyMedium,
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
//                         : l10n.label_email,
//                     hintStyle: AppTextStyles.inputHint,
//                     prefixIcon: _isPhone
//                         ? null
//                         : const Padding(
//                             padding: EdgeInsets.all(Spacing.md),
//                             child: Icon(
//                               Icons.email_outlined,
//                               color: AppColors.textSecondary,
//                               size: 22,
//                             ),
//                           ),
//                     filled: true,
//                     fillColor: AppColors.surface,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                         Spacing.inputRadius,
//                       ),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                         Spacing.inputRadius,
//                       ),
//                       borderSide: const BorderSide(
//                         color: AppColors.border,
//                         width: 1,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                         Spacing.inputRadius,
//                       ),
//                       borderSide: const BorderSide(
//                         color: AppColors.primary,
//                         width: 2,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                         Spacing.inputRadius,
//                       ),
//                       borderSide: const BorderSide(
//                         color: AppColors.error,
//                         width: 1,
//                       ),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                         Spacing.inputRadius,
//                       ),
//                       borderSide: const BorderSide(
//                         color: AppColors.error,
//                         width: 2,
//                       ),
//                     ),
//                     errorStyle: _isPhone
//                         ? const TextStyle(height: 0, fontSize: 0)
//                         : AppTextStyles.inputError,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: Spacing.base,
//                       vertical: Spacing.md,
//                     ),
//                   ),
//                 ),
//               ),
//               if (_isPhone) ...[
//                 const SizedBox(width: Spacing.sm),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: Spacing.md,
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: _errorText != null
//                           ? AppColors.error
//                           : AppColors.border,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(
//                       Spacing.inputRadius,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.arrow_drop_down,
//                         size: 24,
//                         color: AppColors.textSecondary,
//                       ),
//                       const SizedBox(width: Spacing.xs),
//                       // Jordan flag placeholder
//                       Container(
//                         width: 24,
//                         height: 24,
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.2),
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
//           const SizedBox(height: Spacing.xs),
//           Padding(
//             padding: const EdgeInsets.only(left: Spacing.md),
//             child: Text(
//               _errorText!,
//               style: AppTextStyles.inputError,
//             ),
//           ),
//         ],
//       ],
//     );
//   }

