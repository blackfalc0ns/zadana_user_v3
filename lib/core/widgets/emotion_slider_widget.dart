import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ═══════════════════════════════════════════════════════════════
/// DUYGU DEĞERLENDİRME WIDGET'I
/// CustomPainter ile çizilmiş yüz animasyonları + RTL slider
/// ═══════════════════════════════════════════════════════════════

class EmotionSliderWidget extends StatefulWidget {
  final Function(int emotionIndex, String emotionLabel) onEmotionChanged;

  const EmotionSliderWidget({
    super.key,
    required this.onEmotionChanged,
  });

  @override
  State<EmotionSliderWidget> createState() => _EmotionSliderWidgetState();
}

class _EmotionSliderWidgetState extends State<EmotionSliderWidget>
    with TickerProviderStateMixin {
  // Duygu durumu (0-4)
  // 0 = ممتاز (en iyi), 4 = سيئ جداً (en kötü)
  int _emotion = 0;

  // Slider pozisyonu (0.0 - 1.0)
  // 0.0 = sağ uç (ممتاز), 1.0 = sol uç (سيئ جداً)
  double _sliderValue = 0.0;

  // Animasyon controller'ları
  late AnimationController _floatController;
  late AnimationController _bounceController;
  late AnimationController _blinkController;
  late AnimationController _titleScaleController;

  late Animation<double> _floatAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _titleScaleAnimation;

  // Göz kırpma için scale değeri
  double _eyeScale = 1.0;

  // Renkler (duygu durumlarına göre)
  static const List<Color> _emotionColors = [
    Color(0xFF4CAF50), // ممتاز - Çok iyi
    Color(0xFF8BC34A), // جيد - İyi
    Color(0xFFFFC107), // متوسط - Orta
    Color(0xFFFF7043), // سيئ - Kötü
    Color(0xFFEF5350), // سيئ جداً - Çok kötü
  ];

  // Etiketler (Arapça, RTL)
  static const List<String> _emotionLabels = [
    'ممتاز',
    'جيد',
    'متوسط',
    'سيئ',
    'سيئ جداً',
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Float animasyonu (sürekli yukarı-aşağı)
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _floatController.repeat(reverse: true);

    // Bounce animasyonu (duygu değişiminde)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Göz kırpma animasyonu
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _blinkController.addListener(() {
      setState(() {
        _eyeScale = _blinkController.value;
      });
    });

    // Başlık scale animasyonu
    _titleScaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _titleScaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleScaleController,
        curve: Curves.easeOutBack,
      ),
    );

    // Periyodik göz kırpma (4 saniyede bir)
    _startBlinking();
  }

  void _startBlinking() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));
      if (mounted && _emotion == 2) { // Sadece متوسط (orta) duygu durumunda
        _blinkController.forward().then((_) => _blinkController.reverse());
      }
      return mounted;
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bounceController.dispose();
    _blinkController.dispose();
    _titleScaleController.dispose();
    super.dispose();
  }

  void _updateEmotion(double value) {
    setState(() {
      _sliderValue = value.clamp(0.0, 1.0);
      // 5 duygu durumu için hesaplama (RTL: sağdan sola)
      // Slider 0.0 (sağ) = ممتاز (index 0), 1.0 (sol) = سيئ جداً (index 4)
      final newIndex = (_sliderValue * 4).round().clamp(0, 4);

      if (newIndex != _emotion) {
        // Duygu değiştiğinde bounce animasyonu tetikle
        _floatController.stop();
        _bounceController.forward().then((_) {
          _bounceController.reset();
          _floatController.repeat(reverse: true);
        });

        // Başlık scale animasyonu
        _titleScaleController.forward().then((_) {
          _titleScaleController.reverse();
        });

        _emotion = newIndex;
        widget.onEmotionChanged(_emotion, _emotionLabels[_emotion]);
      }
    });
  }

  void _snapToNearest() {
    final positions = [0.0, 0.25, 0.50, 0.75, 1.0];
    double minDiff = 1.0;
    double snapValue = _sliderValue;

    for (var pos in positions) {
      final diff = (_sliderValue - pos).abs();
      if (diff < minDiff) {
        minDiff = diff;
        snapValue = pos;
      }
    }

    if (snapValue != _sliderValue) {
      setState(() {
        _sliderValue = snapValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    final sliderWidth = isSmallScreen ? 270.0 : 320.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Başlık (Duygu metni)
        AnimatedBuilder(
          animation: _titleScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _titleScaleAnimation.value,
              child: child,
            );
          },
          child: Text(
            _emotionLabels[_emotion],
            style: GoogleFonts.notoKufiArabic(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: _emotionColors[_emotion],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),

        // Yüz (CustomPainter ile)
        AnimatedBuilder(
          animation: Listenable.merge([_floatAnimation, _bounceAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: Transform.scale(
                scale: _bounceController.isAnimating
                    ? _bounceAnimation.value
                    : 1.0,
                child: child,
              ),
            );
          },
          child: CustomPaint(
            size: const Size(100, 100),
            painter: FacePainter(
              emotion: _emotion,
              color: _emotionColors[_emotion],
              eyeScale: _eyeScale,
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Slider
        SizedBox(
          width: sliderWidth,
          child: Column(
            children: [
              // Slider track ve thumb
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final renderBox = context.findRenderObject() as RenderBox;
                  final localPosition = renderBox.globalToLocal(
                    details.globalPosition,
                  );
                  // RTL: sağdan (0) sola (1.0) doğru artar
                  final newValue = 1.0 - (localPosition.dx / sliderWidth);
                  _updateEmotion(newValue.clamp(0.0, 1.0));
                },
                onHorizontalDragEnd: (_) {
                  _snapToNearest();
                },
                onTapDown: (details) {
                  final renderBox = context.findRenderObject() as RenderBox;
                  final localPosition = renderBox.globalToLocal(
                    details.globalPosition,
                  );
                  // RTL: sağdan (0) sola (1.0) doğru artar
                  final newValue = 1.0 - (localPosition.dx / sliderWidth);
                  _updateEmotion(newValue.clamp(0.0, 1.0));
                  _snapToNearest();
                },
                child: SizedBox(
                  height: 40,
                  child: CustomPaint(
                    painter: SliderTrackPainter(
                      sliderValue: _sliderValue,
                      activeColor: _emotionColors[_emotion],
                    ),
                    child: Container(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Etiketler (RTL: sağdan sola)
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  final isActive = index == _emotion;
                  return AnimatedScale(
                    scale: isActive ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _emotionLabels[index],
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                        color: isActive
                            ? _emotionColors[index]
                            : const Color(0xFFBBBBBB),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ═══════════════════════════════════════════════════════════════
/// YÜZ ÇİZİMİ - CustomPainter
/// ═══════════════════════════════════════════════════════════════
class FacePainter extends CustomPainter {
  final int emotion;
  final Color color;
  final double eyeScale;

  FacePainter({
    required this.emotion,
    required this.color,
    required this.eyeScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Arka plan dairesi (duygu rengine göre)
    final bgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Glow efekti (üst-sol)
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(Offset(center.dx - 20, center.dy - 20), radius, glowPaint);
    canvas.drawCircle(center, radius, bgPaint);

    // Gözler ve ağız çizimi
    _drawEyes(canvas, center, radius);
    _drawMouth(canvas, center, radius);
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyeOffset = radius * 0.30;
    final eyeY = center.dy - radius * 0.10;

    switch (emotion) {
      case 0: // ممتاز - Kavisli mutlu gözler
        _drawCurvedEyes(canvas, center, eyeOffset, eyeY, 2.5, 0.6);
        break;
      case 1: // جيد - Daha düz kavisli gözler
        _drawCurvedEyes(canvas, center, eyeOffset, eyeY, 2.5, 0.3);
        break;
      case 2: // متوسط - Beyaz dolu daireler
        _drawCircleEyes(canvas, center, eyeOffset, eyeY, 8, true);
        break;
      case 3: // سيئ - Küçük beyaz daireler
        _drawCircleEyes(canvas, center, eyeOffset, eyeY, 5, true);
        break;
      case 4: // سيئ جداً - X işareti
        _drawXEyes(canvas, center, eyeOffset, eyeY, 2);
        break;
    }
  }

  void _drawCurvedEyes(
    Canvas canvas,
    Offset center,
    double eyeOffset,
    double eyeY,
    double strokeWidth,
    double curveFactor,
  ) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Sol göz
    final leftPath = Path();
    final leftStart = Offset(center.dx - eyeOffset - 10, eyeY);
    final leftEnd = Offset(center.dx - eyeOffset + 10, eyeY);
    final leftControl = Offset(
      center.dx - eyeOffset,
      eyeY - (15 * curveFactor),
    );
    leftPath.moveTo(leftStart.dx, leftStart.dy);
    leftPath.quadraticBezierTo(
      leftControl.dx,
      leftControl.dy,
      leftEnd.dx,
      leftEnd.dy,
    );
    canvas.drawPath(leftPath, paint);

    // Sağ göz
    final rightPath = Path();
    final rightStart = Offset(center.dx + eyeOffset - 10, eyeY);
    final rightEnd = Offset(center.dx + eyeOffset + 10, eyeY);
    final rightControl = Offset(
      center.dx + eyeOffset,
      eyeY - (15 * curveFactor),
    );
    rightPath.moveTo(rightStart.dx, rightStart.dy);
    rightPath.quadraticBezierTo(
      rightControl.dx,
      rightControl.dy,
      rightEnd.dx,
      rightEnd.dy,
    );
    canvas.drawPath(rightPath, paint);
  }

  void _drawCircleEyes(
    Canvas canvas,
    Offset center,
    double eyeOffset,
    double eyeY,
    double radius,
    bool filled,
  ) {
    final paint = Paint()
      ..color = Colors.white
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2;

    // Göz kırpma animasyonu için scale hesaplama
    // eyeScale 0.0 - 1.0 arasında, 0.0'a yaklaştıkça göz küçülür ama tamamen kaybolmaz
    final animatedRadius = radius * (0.2 + (eyeScale * 0.8)); // Minimum %20 kalır

    // Sol göz
    canvas.drawCircle(
      Offset(center.dx - eyeOffset, eyeY),
      animatedRadius,
      paint,
    );

    // Sağ göz
    canvas.drawCircle(
      Offset(center.dx + eyeOffset, eyeY),
      animatedRadius,
      paint,
    );
  }

  void _drawXEyes(
    Canvas canvas,
    Offset center,
    double eyeOffset,
    double eyeY,
    double strokeWidth,
  ) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final size = 12.0;

    // Sol X
    _drawX(
      canvas,
      Offset(center.dx - eyeOffset, eyeY),
      size,
      paint,
    );

    // Sağ X
    _drawX(
      canvas,
      Offset(center.dx + eyeOffset, eyeY),
      size,
      paint,
    );
  }

  void _drawX(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - size, center.dy - size);
    path.lineTo(center.dx + size, center.dy + size);
    path.moveTo(center.dx + size, center.dy - size);
    path.lineTo(center.dx - size, center.dy + size);
    canvas.drawPath(path, paint);
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthY = center.dy + radius * 0.35;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    switch (emotion) {
      case 0: // ممتاز - Geniş yarım daire
        final mouthRect = Rect.fromCenter(
          center: Offset(center.dx, mouthY),
          width: 30,
          height: 18,
        );
        canvas.drawArc(
          mouthRect,
          0,
          3.14159,
          true,
          paint,
        );
        break;

      case 1: // جيد - Dar yarım daire
        final mouthRect = Rect.fromCenter(
          center: Offset(center.dx, mouthY),
          width: 22,
          height: 14,
        );
        canvas.drawArc(
          mouthRect,
          0,
          3.14159,
          true,
          paint,
        );
        break;

      case 2: // متوسط - Yatay çizgi
        final mouthRect = Rect.fromCenter(
          center: Offset(center.dx, mouthY),
          width: 25,
          height: 2,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(mouthRect, const Radius.circular(1)),
          paint,
        );
        break;

      case 3: // سيئ - Ters U (küçük)
        final mouthPath = Path();
        final mouthRect = Rect.fromCenter(
          center: Offset(center.dx, mouthY),
          width: 22,
          height: 16,
        );
        mouthPath.addArc(mouthRect, 3.14159, 3.14159);
        canvas.drawPath(mouthPath, strokePaint);
        break;

      case 4: // سيئ جداً - Ters U (geniş)
        final mouthPath = Path();
        final mouthRect = Rect.fromCenter(
          center: Offset(center.dx, mouthY),
          width: 30,
          height: 20,
        );
        mouthPath.addArc(mouthRect, 3.14159, 3.14159);
        canvas.drawPath(mouthPath, strokePaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) {
    return oldDelegate.emotion != emotion ||
        oldDelegate.color != color ||
        oldDelegate.eyeScale != eyeScale;
  }
}

/// ═══════════════════════════════════════════════════════════════
/// SLİDER ÇİZİMİ - CustomPainter
/// ═══════════════════════════════════════════════════════════════
class SliderTrackPainter extends CustomPainter {
  final double sliderValue;
  final Color activeColor;

  SliderTrackPainter({
    required this.sliderValue,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final trackHeight = 6.0;
    final stationRadius = 6.0;
    final thumbRadius = 14.0;
    // sliderValue 0.0 = sağ (ممتاز), 1.0 = sol (سيئ جداً)
    // Thumb sağdan sola hareket eder
    final thumbX = size.width * (1.0 - sliderValue);

    // Track arka plan (#eee)
    final trackPaint = Paint()
      ..color = const Color(0xFFEEEEEE)
      ..style = PaintingStyle.fill;

    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height / 2 - trackHeight / 2, size.width, trackHeight),
      const Radius.circular(3),
    );
    canvas.drawRRect(trackRect, trackPaint);

    // Track dolgu - sağdan sola doğru dolar
    final fillWidth = size.width * sliderValue;
    final fillPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final fillRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width - fillWidth,
        size.height / 2 - trackHeight / 2,
        fillWidth,
        trackHeight,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(fillRect, fillPaint);

    // İstasyon noktaları (5 adet, eşit aralıklı, sağdan sola)
    final stationPositions = [0.0, 0.25, 0.50, 0.75, 1.0];
    for (int i = 0; i < stationPositions.length; i++) {
      // Sağdan sola doğru pozisyonlar
      final x = size.width * (1.0 - stationPositions[i]);
      final center = Offset(x, size.height / 2);

      // Aktif istasyon
      final currentStation = (sliderValue * 4 + 0.5).round().clamp(0, 4);
      final isActive = i == currentStation;

      final stationPaint = Paint()
        ..color = isActive ? activeColor : const Color(0xFFDDDDDD)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      if (isActive) {
        canvas.scale(1.4);
      }
      canvas.drawCircle(Offset.zero, stationRadius, stationPaint);
      canvas.restore();
    }

    // Thumb - sağdan sola hareket eder
    final thumbCenter = Offset(thumbX, size.height / 2);

    // Gölge efekti
    final shadowPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(thumbCenter, thumbRadius + 4, shadowPaint);

    // Thumb dış daire
    final thumbOuterPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(thumbCenter, thumbRadius, thumbOuterPaint);

    // Thumb iç parlama (beyaz)
    final thumbInnerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(thumbCenter.dx - 3, thumbCenter.dy - 3),
      thumbRadius * 0.4,
      thumbInnerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SliderTrackPainter oldDelegate) {
    return oldDelegate.sliderValue != sliderValue ||
        oldDelegate.activeColor != activeColor;
  }
}
