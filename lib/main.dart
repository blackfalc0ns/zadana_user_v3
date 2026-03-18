import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_generator.dart';
import 'package:zadana_user_v3/config/theme/app_theme.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // Ensure Arabic language is set by default
  final languageService = getIt<LanguageService>();
  final currentLang = languageService.getLanguageCode();
  if (currentLang.isEmpty || currentLang != 'ar') {
    await languageService.saveLanguageCode('ar');
  }

  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('ar')],
      theme: AppTheme.light,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: AppRoutes.mainShell,
      //  home: VerifyOtpScreen(),
    );
  }
}
