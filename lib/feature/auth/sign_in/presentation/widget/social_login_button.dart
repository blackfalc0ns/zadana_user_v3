// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/config/theme/spacing.dart';
// import 'package:zadana_user_v3/config/theme/text_styles.dart';

// enum SocialProvider { google, apple }

// class SocialLoginButton extends StatelessWidget {
//   const SocialLoginButton({
//     super.key,
//     required this.provider,
//     required this.label,
//     required this.onPressed,
//   });

//   final SocialProvider provider;
//   final String         label;
//   final VoidCallback   onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: Spacing.buttonHeight,
//       child: OutlinedButton(
//         onPressed: onPressed,
//         style: OutlinedButton.styleFrom(
//           backgroundColor: AppColors.surface,
//           foregroundColor: AppColors.textPrimary,
//           side: const BorderSide(color: AppColors.border, width: 1.2),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(Spacing.buttonRadius),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildIcon(),
//             const SizedBox(width: Spacing.sm),
//             Text(
//               label,
//               style: AppTextStyles.labelLarge.copyWith(
//                 color: AppColors.textPrimary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildIcon() {
//     switch (provider) {
//       case SocialProvider.google:
//         return Icons.google;
//       case SocialProvider.apple:
//         return const Icon(
//           Icons.apple_rounded,
//           size: 22,
//           color: AppColors.textPrimary,
//         );
//     }
//   }
// }

// // ── Google colored icon ────────────────────────────────────────────
// class _GoogleIcon extends StatelessWidget {
//   const _GoogleIcon();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 20,
//       height: 20,
//       child: CustomPaint(painter: _GooglePainter()),
//     );
//   }
// }

// // class _GooglePainter extends CustomPainter {
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final cx = size.width  / 2;
// //     final cy = size.height / 2;
// //     final r  = size.width  / 2;

// //     final colors = [
// //       const Color(0xFFEA4335), // red
// //       const Color(0xFF4285F4), // blue
// //       const Color(0xFFFBBC05), // yellow
// //       const Color(0xFF34A853), // green
// //     ];

// //     final sweeps = [1.6, 1.5, 1.0, 1.2];
// //     final starts = [-1.1, 2.5, 0.5, -0.55];

// //     for (int i = 0; i < 4; i++) {
// //       canvas.drawArc(
// //         Rect.fromCircle(center: Offset(cx, cy), radius: r),
// //         starts[i],
// //         sweeps[i],
// //         false,
// //         Paint()
// //           ..color       = colors[i]
// //           ..style       = PaintingStyle.stroke
// //           ..strokeWidth = 3.0
// //           ..strokeCap   = StrokeCap.round,
// //       );
// //     }

// //     // horizontal bar (right side — blue)
// //     canvas.drawLine(
// //       Offset(cx, cy),
// //       Offset(size.width, cy),
// //       Paint()
// //         ..color       = colors[1]
// //         ..strokeWidth = 3.0
// //         ..strokeCap   = StrokeCap.round,
// //     );
// //   }

// //   @override
// //   bool shouldRepaint(_) => false;
// // }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

enum SocialProvider { google, apple }

/// زرارين جنب بعض بنفس لون الـ toggle (AppColors.divider)
class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({
    super.key,
    required this.googleLabel,
    required this.appleLabel,
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  final String googleLabel;
  final String appleLabel;
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialBtn(
            provider: SocialProvider.google,
            label: googleLabel,
            onPressed: onGooglePressed,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: _SocialBtn(
            provider: SocialProvider.apple,
            label: appleLabel,
            onPressed: onApplePressed,
          ),
        ),
      ],
    );
  }
}

// ── Single social button ──────────────────────────────────────────
class _SocialBtn extends StatelessWidget {
  const _SocialBtn({
    required this.provider,
    required this.label,
    required this.onPressed,
  });

  final SocialProvider provider;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Spacing.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // نفس لون الـ toggle switch
          backgroundColor: AppColors.divider,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider) {
      case SocialProvider.google:
        return FaIcon(FontAwesomeIcons.google, size: 20);
      case SocialProvider.apple:
        return const Icon(
          Icons.apple_rounded,
          size: 20,
          color: AppColors.textPrimary,
        );
    }
  }
}

// ── Google colored icon ───────────────────────────────────────────
// class _GoogleIcon extends StatelessWidget {
//   const _GoogleIcon();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 18,
//       height: 18,
//       child: CustomPaint(painter: _GooglePainter()),
//     );
//   }
// }

// class _GooglePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width  / 2;
//     final cy = size.height / 2;
//     final r  = size.width  / 2;

//     final colors = [
//       const Color(0xFFEA4335),
//       const Color(0xFF4285F4),
//       const Color(0xFFFBBC05),
//       const Color(0xFF34A853),
//     ];
//     final starts = [-1.1,  2.5,  0.5, -0.55];
//     final sweeps = [ 1.6,  1.5,  1.0,  1.2 ];

//     for (int i = 0; i < 4; i++) {
//       canvas.drawArc(
//         Rect.fromCircle(center: Offset(cx, cy), radius: r),
//         starts[i], sweeps[i], false,
//         Paint()
//           ..color       = colors[i]
//           ..style       = PaintingStyle.stroke
//           ..strokeWidth = 2.8
//           ..strokeCap   = StrokeCap.round,
//       );
//     }

//     canvas.drawLine(
//       Offset(cx, cy),
//       Offset(size.width, cy),
//       Paint()
//         ..color       = colors[1]
//         ..strokeWidth = 2.8
//         ..strokeCap   = StrokeCap.round,
//     );
//   }

//   @override
//   bool shouldRepaint(_) => false;
// }
