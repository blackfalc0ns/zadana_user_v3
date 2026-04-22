import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_generator.dart';
import 'package:zadana_user_v3/config/theme/app_theme.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/general_cubit/general_state.dart';
import 'package:zadana_user_v3/core/general_cubit/local_cubit.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/services/app_navigator_service.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:zadana_user_v3/core/services/local_notification_service.dart';
import 'package:zadana_user_v3/core/services/notification_device_service.dart';

import 'package:zadana_user_v3/core/services/push_notification_service.dart';
import 'package:zadana_user_v3/feature/notifications/presentation/services/realtime_notification_overlay_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await configureDependencies();
  runApp(DevicePreview(builder: (context) => const MyApp()));
  unawaited(_bootstrapAppServices());
}

Future<void> _bootstrapAppServices() async {
  await PushNotificationService.init();
  await getIt<LocalNotificationService>().init();
  await getIt<NotificationDeviceService>().syncCurrentDeviceIfAuthenticated();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getIt<RealtimeNotificationOverlayService>().startListening();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleThemeCubit(getIt<LanguageService>()),
      child: BlocBuilder<LocaleThemeCubit, LocaleThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: DevicePreview.appBuilder,
            navigatorKey: getIt<AppNavigatorService>().navigatorKey,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light,
            locale: state.locale,
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
