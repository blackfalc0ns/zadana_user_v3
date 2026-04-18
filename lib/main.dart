import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_generator.dart';
import 'package:zadana_user_v3/config/theme/app_theme.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/general_cubit/general_state.dart';
import 'package:zadana_user_v3/core/general_cubit/local_cubit.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';

import 'package:zadana_user_v3/core/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  PushNotificationService.init();
  runApp(DevicePreview(builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleThemeCubit(getIt<LanguageService>()),
      child: BlocBuilder<LocaleThemeCubit, LocaleThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: DevicePreview.appBuilder,
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
