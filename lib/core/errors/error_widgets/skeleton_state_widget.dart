import 'package:flutter/material.dart';

class SkeletonStateWidget extends StatefulWidget {
  const SkeletonStateWidget({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  State<SkeletonStateWidget> createState() => _SkeletonStateWidgetState();
}

class _SkeletonStateWidgetState extends State<SkeletonStateWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? const Color(0xFFEAEAEA);
    final highlightColor = widget.highlightColor ?? const Color(0xFFF8F8F8);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.6 + (_controller.value * 3.2), 0),
              end: Alignment(-0.6 + (_controller.value * 3.2), 0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.1, 0.45, 0.9],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
