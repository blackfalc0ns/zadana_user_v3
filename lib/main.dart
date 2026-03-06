import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_generator.dart';
import 'package:zadana_user_v3/config/theme/app_theme.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp( DevicePreview(
    enabled: true,
    builder: (context) => MyApp(), 
  ),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('ar'),
      ],
      theme: AppTheme.light,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}