import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/pages/sign_up_screen.dart';
import 'package:zadana_user_v3/feature/category/presentaion/pages/category_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/select_address_from_map_page.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/start_select_location_page.dart';
import 'package:zadana_user_v3/feature/onbarding/presentation/splash_page.dart';
import 'package:zadana_user_v3/feature/onbarding/presentation/start_page.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case AppRoutes.startPage:
        return MaterialPageRoute(builder: (_) => StartPage());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
        case AppRoutes.mainShell:
        return MaterialPageRoute(builder: (_) => MainShell());
        // case AppRoutes.category:
        // return  MaterialPageRoute(builder: (_) => CategoryScreen());
        case AppRoutes.selectAddress:
      return  MaterialPageRoute(builder: (_)=>SelectAddressFromMapPage() );
      case AppRoutes.startSelectLocationPage:
      return MaterialPageRoute(builder: (_)=>StartSelectLocationPage());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}
