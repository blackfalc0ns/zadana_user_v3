import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/network/failuer_mapper.dart';

class CustomSnackbar {
  static OverlayEntry? _currentEntry;
  static AnimationController? _animationController;
  static const Duration _defaultDuration = Duration(milliseconds: 1800);

  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: const Color(0xFF1F9D67),
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: const Color(0xFFC85A54),
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: const Color(0xFFD08A2E),
      icon: Icons.warning_amber_outlined,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    final localizedMessage = mapFailureMessage(context, message);
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    _removeCurrent(immediate: true);
    HapticFeedback.lightImpact();

    final controller = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 360),
      reverseDuration: const Duration(milliseconds: 260),
    );
    _animationController = controller;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (entryContext) {
        final mediaQuery = MediaQuery.of(entryContext);
        final opacityAnimation = CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        );
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1.05),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );
        final scaleAnimation = Tween<double>(
          begin: 0.98,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

        return Positioned(
          left: 16,
          right: 16,
          bottom: mediaQuery.padding.bottom + 12,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: FadeTransition(
                    opacity: opacityAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: _SnackbarCard(
                          message: localizedMessage,
                          backgroundColor: backgroundColor,
                          icon: icon,
                          duration: duration,
                          onClose: _removeCurrent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);

    controller.forward();
    Future<void>.delayed(duration, _removeCurrent);
  }

  static void _removeCurrent({bool immediate = false}) {
    final entry = _currentEntry;
    final controller = _animationController;

    if (entry == null) {
      return;
    }

    _currentEntry = null;
    _animationController = null;

    if (controller == null || immediate) {
      entry.remove();
      controller?.dispose();
      return;
    }

    if (controller.status == AnimationStatus.dismissed) {
      entry.remove();
      controller.dispose();
      return;
    }

    controller.reverse().whenCompleteOrCancel(() {
      entry.remove();
      controller.dispose();
    });
  }
}

class _SnackbarCard extends StatelessWidget {
  const _SnackbarCard({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.duration,
    required this.onClose,
  });

  final String message;
  final Color backgroundColor;
  final IconData icon;
  final Duration duration;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final progressColor = Colors.white.withValues(alpha: 0.9);
    final surfaceColor = Color.lerp(backgroundColor, Colors.black, 0.12)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor.withValues(alpha: 0.96),
            surfaceColor.withValues(alpha: 0.98),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: getBoldStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: FontConstant.cairo,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 16,
                  ),
                ],
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1, end: 0),
              duration: duration,
              builder: (context, value, child) {
                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    widthFactor: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                height: 2.5,
                color: progressColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
