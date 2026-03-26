import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/constants/durations.dart';

/// ─────────────────────────────────────────────────────────────
/// Generic page transition helper for consistent animations
/// 
/// Provides reusable page transitions for different screens
/// ─────────────────────────────────────────────────────────────
class PageTransitionHelper {
  static Route<T> createSlideTransition<T>({
    required Widget page,
    SlideDirection direction = SlideDirection.left,
    Duration duration = AppDurations.pageTransition,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = switch (direction) {
          SlideDirection.left => const Offset(-1.0, 0.0),
          SlideDirection.right => const Offset(1.0, 0.0),
          SlideDirection.top => const Offset(0.0, -1.0),
          SlideDirection.bottom => const Offset(0.0, 1.0),
        };

        const end = Offset.zero;

        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  static Route<T> createFadeTransition<T>({
    required Widget page,
    Duration duration = AppDurations.pageTransition,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    );
  }

  static Route<T> createScaleTransition<T>({
    required Widget page,
    Duration duration = AppDurations.pageTransition,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
            reverseCurve: Curves.easeInBack,
          ),
          child: child,
        );
      },
    );
  }
}

enum SlideDirection { left, right, top, bottom }
