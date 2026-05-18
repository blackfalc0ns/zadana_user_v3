import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/routing_generator.dart';
import 'package:zadana_user_v3/config/theme/app_theme.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/general_cubit/general_state.dart';
import 'package:zadana_user_v3/core/general_cubit/local_cubit.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/services/app_navigator_service.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import 'package:zadana_user_v3/feature/notifications/presentation/services/realtime_notification_overlay_service.dart';
import 'package:zadana_user_v3/feature/onboarding/presentation/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  );
//  const enableDevicePreview = bool.fromEnvironment('ENABLE_DEVICE_PREVIEW');
  runApp(
   // kReleaseMode || !enableDevicePreview? const AppBootstrapper():
    DevicePreview(builder: (context) => const AppBootstrapper()),
  );
}

class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({super.key});

  @override
  State<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  late final Future<void> _bootstrapFuture;
  String? _initialRoute;
  Object? _bootstrapError;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = configureDependencies();
    _bootstrapFuture.catchError((error) {
      if (!mounted) return;
      setState(() {
        _bootstrapError = error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_bootstrapError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text('App initialization failed: $_bootstrapError'),
          ),
        ),
      );
    }

    if (_initialRoute == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: DevicePreview.appBuilder,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        home: SplashPage(
          initializationFuture: _bootstrapFuture,
          onInitializationComplete: _handleInitializationComplete,
        ),
      );
    }

    return MyApp(initialRoute: _initialRoute!);
  }

  void _handleInitializationComplete(String initialRoute) {
    if (!mounted) return;
    setState(() {
      _initialRoute = initialRoute;
    });
  }
}

class MyApp extends StatefulWidget {
  const MyApp({required this.initialRoute, super.key});

  final String initialRoute;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<RealtimeNotificationOverlayService>().startListening();
      unawaited(
        getIt<NotificationsSignalRService>()
            .activateAuthenticatedConnectionIfPossible(),
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    unawaited(
      getIt<NotificationsSignalRService>().handleAppLifecycleState(state),
    );
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
            initialRoute: widget.initialRoute,
          );
        },
      ),
    );
  }
}
