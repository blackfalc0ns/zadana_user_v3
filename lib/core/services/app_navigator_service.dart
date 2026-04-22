import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppNavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get currentContext => navigatorKey.currentContext;

  NavigatorState? get navigator => navigatorKey.currentState;

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    final navigatorState = navigator;
    if (navigatorState == null) {
      return Future<T?>.value();
    }

    return navigatorState.pushNamed<T>(routeName, arguments: arguments);
  }
}
