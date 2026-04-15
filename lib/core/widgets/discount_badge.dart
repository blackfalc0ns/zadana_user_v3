import 'dart:math' as math;

import 'package:flutter/material.dart';

class DiscountBadge extends StatelessWidget {
  const DiscountBadge({
    super.key,
    required this.discountText,
    this.color = Colors.red,
    this.topRightRadius = 0.0,
    this.bottomLeftRadius = 8.0,
    this.trianglesize = 45.0,
    this.cornerRadius = 10.0,
    this.fontSize = 14.0,
    required this.shadowColor,
  });
  final String discountText;
  final Color color;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double trianglesize;
  final double cornerRadius;
  final double fontSize;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    final badgeExtent = trianglesize.clamp(18.0, 60.0);
    final contentPadding = (badgeExtent * 0.06).clamp(1.0, 3.0);
    final labelOffset = -(badgeExtent * 0.16);

    return CustomPaint(
      painter: TrianglePainter(
        shadowColor: shadowColor.withValues(alpha: 0.5),
        color: color,
        trianglesize: trianglesize,
        cornerRadius: cornerRadius,
      ),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(contentPadding),
        width: badgeExtent,
        height: badgeExtent,
        child: Transform.translate(
          offset: Offset(labelOffset, labelOffset),
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                discountText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize + 0.5,
                  fontWeight: FontWeight.bold,
                  height: 1,
                  letterSpacing: 0,
                  shadows: const [
                    Shadow(
                      color: Color(0x55000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    required this.color,
    this.trianglesize = 45.0,
    required this.cornerRadius,
    required this.shadowColor,
  });
  final Color color;
  final Color shadowColor;
  final double trianglesize;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw shadow
    final shadowPaint = Paint()
      ..color = shadowColor.withAlpha(40)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();

    // Start from top edge, near the corner
    path.moveTo(cornerRadius, 0);

    // Top edge to diagonal
    path.lineTo(trianglesize, 0);

    // Diagonal edge to left
    path.lineTo(0, trianglesize);

    // Left edge up to near the corner
    path.lineTo(0, cornerRadius);

    // Rounded corner at top-left (outer radius)
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );

    path.close();

    // Draw shadow with offset
    canvas.save();
    canvas.translate(2, 2);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Draw main triangle
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is TrianglePainter &&
        (oldDelegate.color != color ||
            oldDelegate.trianglesize != trianglesize ||
            oldDelegate.cornerRadius != cornerRadius);
  }
}
