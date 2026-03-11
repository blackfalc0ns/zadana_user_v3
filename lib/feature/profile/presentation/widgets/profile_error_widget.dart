// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/spacing.dart';

// class ProfileErrorWidget extends StatelessWidget {
//   final String errorMessage;
//   final VoidCallback onRetry;

//   const ProfileErrorWidget({
//     super.key,
//     required this.errorMessage,
//     required this.onRetry,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 64,
//             color: colorScheme.error,
//           ),
//           const SizedBox(height: Spacing.base),
//           Text(
//             errorMessage,
//             style: Theme.of(context).textTheme.bodyMedium,
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: Spacing.base),
//           ElevatedButton(
//             onPressed: onRetry,
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }
// }
