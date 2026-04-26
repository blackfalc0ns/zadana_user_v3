import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/services/local_notification_service.dart';
import 'package:zadana_user_v3/core/services/push_notification_service.dart';
import 'package:zadana_user_v3/core/services/saved_location_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    this.initializationFuture,
    this.onInitializationComplete,
    super.key,
  });

  final Future<void>? initializationFuture;
  final ValueChanged<String>? onInitializationComplete;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startBackgroundServices();
    _navigateToNext();
  }

  Future<void> _startBackgroundServices() async {
    await widget.initializationFuture;
    unawaited(getIt<LocalNotificationService>().init());
    unawaited(PushNotificationService.init());
    unawaited(PushNotificationService.activateAuthenticatedPushIfPossible());
  }

  Future<void> _navigateToNext() async {
    await Future.wait<void>([
      widget.initializationFuture ?? Future<void>.value(),
      Future<void>.delayed(const Duration(seconds: 5)),
    ]);
    if (mounted) {
      final nextRoute = SavedLocationService.hasSavedLocation
          ? AppRoutes.mainShell
          : AppRoutes.startPage;

      final onInitializationComplete = widget.onInitializationComplete;
      if (onInitializationComplete != null) {
        onInitializationComplete(nextRoute);
        return;
      }

      Navigator.pushReplacementNamed(context, nextRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        Assets.splashPageBackground,
        fit: BoxFit.cover,
        height: double.maxFinite,
      ),
    );
  }
}
