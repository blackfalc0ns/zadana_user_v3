import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

enum ErrorVisualType {
  generic,
  network,
  timeout,
  server,
  client,
  empty,
  location,
}

class BaseErrorWidget extends StatelessWidget {
  const BaseErrorWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onRetry,
    this.onSecondaryAction,
    this.secondaryActionText,
    this.primaryColor,
    this.visualType = ErrorVisualType.generic,
    this.retryIcon = Icons.refresh_rounded,
    this.secondaryActionIcon,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onRetry;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionText;
  final Color? primaryColor;
  final ErrorVisualType visualType;
  final IconData retryIcon;
  final IconData? secondaryActionIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final accent = primaryColor ?? colorScheme.primary;
    final onSurface = colorScheme.onSurface;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxWidth = screenWidth < 430 ? double.infinity : 390.0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: colorScheme.surface,
              border: Border.all(color: accent.withValues(alpha: 0.18)),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned.fill(
                    child: _ErrorBackgroundPattern(
                      color: accent,
                      visualType: visualType,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ErrorVisual(
                          accent: accent,
                          icon: icon,
                          visualType: visualType,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          title,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: onSurface,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          description,
                          style: textTheme.bodyLarge?.copyWith(
                            color: onSurface.withValues(alpha: 0.68),
                            height: 1.55,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (onRetry != null ||
                            (onSecondaryAction != null &&
                                secondaryActionText != null)) ...[
                          const SizedBox(height: 24),
                          _ErrorActions(
                            accent: accent,
                            onRetry: onRetry,
                            retryText: getRetryButtonText(context),
                            retryIcon: retryIcon,
                            onSecondaryAction: onSecondaryAction,
                            secondaryActionText: secondaryActionText,
                            secondaryActionIcon: secondaryActionIcon,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}

class _ErrorVisual extends StatelessWidget {
  const _ErrorVisual({
    required this.accent,
    required this.icon,
    required this.visualType,
  });

  final Color accent;
  final IconData icon;
  final ErrorVisualType visualType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 148,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 6,
            child: Container(
              width: 118,
              height: 24,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned(
            top: 8,
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface,
                border: Border.all(
                  color: accent.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 19,
            child: Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.12),
              ),
              child: Icon(icon, size: 46, color: accent),
            ),
          ),
          ..._buildSignals(),
        ],
      ),
    );
  }

  List<Widget> _buildSignals() {
    switch (visualType) {
      case ErrorVisualType.network:
        return [
          _SignalPill(
            left: 7,
            top: 32,
            color: accent,
            icon: Icons.signal_wifi_0_bar_rounded,
          ),
          _SignalPill(
            right: 10,
            bottom: 36,
            color: accent,
            icon: Icons.close_rounded,
          ),
        ];
      case ErrorVisualType.timeout:
        return [
          _SignalPill(
            left: 10,
            bottom: 36,
            color: accent,
            icon: Icons.hourglass_empty_rounded,
          ),
          Positioned(right: 16, top: 20, child: _TickMarks(color: accent)),
        ];
      case ErrorVisualType.server:
        return [
          _SignalPill(
            left: 3,
            top: 38,
            color: accent,
            icon: Icons.storage_rounded,
          ),
          _SignalPill(
            right: 4,
            bottom: 30,
            color: accent,
            icon: Icons.bolt_rounded,
          ),
        ];
      case ErrorVisualType.client:
        return [
          _SignalPill(
            left: 8,
            bottom: 28,
            color: accent,
            icon: Icons.edit_note_rounded,
          ),
          _SignalPill(
            right: 8,
            top: 30,
            color: accent,
            icon: Icons.priority_high_rounded,
          ),
        ];
      case ErrorVisualType.empty:
        return [
          _SignalPill(
            left: 5,
            bottom: 33,
            color: accent,
            icon: Icons.inbox_rounded,
          ),
          _SignalPill(
            right: 5,
            top: 32,
            color: accent,
            icon: Icons.add_rounded,
          ),
        ];
      case ErrorVisualType.location:
        return [
          _SignalPill(
            left: 9,
            bottom: 34,
            color: accent,
            icon: Icons.map_rounded,
          ),
          _SignalPill(
            right: 7,
            top: 30,
            color: accent,
            icon: Icons.my_location_rounded,
          ),
        ];
      case ErrorVisualType.generic:
        return [
          _SignalPill(
            left: 8,
            bottom: 30,
            color: accent,
            icon: Icons.question_mark_rounded,
          ),
          _SignalPill(
            right: 9,
            top: 31,
            color: accent,
            icon: Icons.auto_fix_high_rounded,
          ),
        ];
    }
  }
}

class _SignalPill extends StatelessWidget {
  const _SignalPill({
    required this.color,
    required this.icon,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  final Color color;
  final IconData icon;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class _TickMarks extends StatelessWidget {
  const _TickMarks({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          width: 24.0 - (index * 4),
          height: 4,
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.55 - (index * 0.12)),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}

class _ErrorBackgroundPattern extends StatelessWidget {
  const _ErrorBackgroundPattern({
    required this.color,
    required this.visualType,
  });

  final Color color;
  final ErrorVisualType visualType;

  @override
  Widget build(BuildContext context) {
    final alignment = Directionality.of(context) == TextDirection.rtl
        ? Alignment.topLeft
        : Alignment.topRight;

    return CustomPaint(
      painter: _ErrorPatternPainter(
        color: color,
        alignment: alignment,
        visualType: visualType,
      ),
    );
  }
}

class _ErrorPatternPainter extends CustomPainter {
  const _ErrorPatternPainter({
    required this.color,
    required this.alignment,
    required this.visualType,
  });

  final Color color;
  final Alignment alignment;
  final ErrorVisualType visualType;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = alignment.alongSize(size) + const Offset(0, 8);
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(center, 46.0 + (i * 34), paint);
    }

    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.11)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 7; i++) {
      final x = 26.0 + (i * 43);
      final y = size.height - 34 - ((i % 3) * 16);
      canvas.drawCircle(Offset(x, y), i.isEven ? 3.5 : 2.2, dotPaint);
    }

    if (visualType == ErrorVisualType.server ||
        visualType == ErrorVisualType.network) {
      final linePaint = Paint()
        ..color = color.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final path = Path()
        ..moveTo(26, size.height - 82)
        ..quadraticBezierTo(
          size.width * 0.34,
          size.height - 118,
          size.width * 0.54,
          size.height - 78,
        )
        ..quadraticBezierTo(
          size.width * 0.72,
          size.height - 42,
          size.width - 30,
          size.height - 76,
        );
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ErrorPatternPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.alignment != alignment ||
        oldDelegate.visualType != visualType;
  }
}

class _ErrorActions extends StatelessWidget {
  const _ErrorActions({
    required this.accent,
    required this.onRetry,
    required this.retryText,
    required this.retryIcon,
    required this.onSecondaryAction,
    required this.secondaryActionText,
    required this.secondaryActionIcon,
  });

  final Color accent;
  final VoidCallback? onRetry;
  final String retryText;
  final IconData retryIcon;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionText;
  final IconData? secondaryActionIcon;

  @override
  Widget build(BuildContext context) {
    final hasSecondary =
        onSecondaryAction != null && secondaryActionText != null;

    return Column(
      children: [
        if (onRetry != null)
          AppButton.filled(
            onPressed: onRetry,
            text: retryText,
            icon: retryIcon,
            color: accent,
            borderRadius: 18,
          ),
        if (hasSecondary) ...[
          SizedBox(height: onRetry == null ? 0 : 12),
          AppButton.outlined(
            onPressed: onSecondaryAction,
            text: secondaryActionText!,
            icon: secondaryActionIcon ?? Icons.arrow_back_rounded,
            color: accent,
            borderRadius: 18,
          ),
        ],
      ],
    );
  }
}
