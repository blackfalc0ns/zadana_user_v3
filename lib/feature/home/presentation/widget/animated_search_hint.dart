import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'home_search_bar_hints.dart';

class AnimatedSearchHint extends StatefulWidget {
  const AnimatedSearchHint({super.key});

  @override
  State<AnimatedSearchHint> createState() => _AnimatedSearchHintState();
}

class _AnimatedSearchHintState extends State<AnimatedSearchHint> {
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final hints = HomeSearchBarHints.resolve(context);
      if (hints.isEmpty) return;

      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % hints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hints = HomeSearchBarHints.resolve(context);
    final currentHint = hints.isEmpty
        ? null
        : hints[_currentIndex % hints.length];

    return IgnorePointer(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.5),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Text(
          currentHint?.$1 ?? context.localization.search_hint,
          key: ValueKey<int>(_currentIndex),
          textDirection: Directionality.of(context),
          overflow: TextOverflow.ellipsis,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            color: AppColors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
