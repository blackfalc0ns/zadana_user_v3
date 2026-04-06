import 'package:flutter/material.dart';
import 'dart:math';

class DiscountBadge extends StatelessWidget {
  final String discountText;
  final Color color;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double trianglesize;
  final double cornerRadius;
  final double fontSize;
  final Color shadowColor;

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

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(
        shadowColor: shadowColor.withValues(alpha: 0.5),
        color: color,
        trianglesize: trianglesize,
        cornerRadius: cornerRadius,
      ),
      child: Container(
        alignment: Alignment(-1, -1),
        padding: EdgeInsets.all(4),
        width: 60,
        height: 60,
        child: Transform.rotate(
          angle: -pi / 4, // Rotate text to fit diagonal
          child: Text(
            discountText,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  final Color shadowColor;
  final double trianglesize;
  final double cornerRadius;

  TrianglePainter({
    required this.color,
    this.trianglesize = 45.0,
    required this.cornerRadius,
     required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw shadow
    final shadowPaint = Paint()
      ..color = shadowColor.withAlpha(40)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

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
      clockwise: true,
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
