import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/pages/forget_password_screen.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/pages/register_screen.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/pages/reset_password_screen.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/pages/verify_reset_otp_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/select_address_from_map_page.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/start_select_location_page.dart';
import 'package:zadana_user_v3/feature/onbarding/presentation/splash_page.dart';
import 'package:zadana_user_v3/feature/onbarding/presentation/on_boarding_page.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/profile_details_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/edit_profile_screen.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/pages/verify_otp_screen.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/manual_address_entry_page.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/building_details_page.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/pages/product_details_screen.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case AppRoutes.startPage:
        return MaterialPageRoute(builder: (_) => StartPage());
      case AppRoutes.signUp:
        final locationEntity = settings.arguments as LocationEntity?;
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(locationEntity: locationEntity),
        );
      case AppRoutes.forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      case AppRoutes.verifyResetOtp:
        final identifier = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VerifyResetOtpScreen(identifier: identifier),
        );
      case AppRoutes.resetPassword:
        final arguments = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(arguments: arguments),
        );
      case AppRoutes.profileDetails:
        final profile = settings.arguments as ProfileResponseEntity;
        return MaterialPageRoute(
          builder: (_) => ProfileDetailsScreen(profile: profile),
        );
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
        case AppRoutes.mainShell:
        return MaterialPageRoute(builder: (_) => MainShell(key: mainShellKey));
        // case AppRoutes.category:
        // return  MaterialPageRoute(builder: (_) => CategoryScreen());
        case AppRoutes.selectAddress:
      return  MaterialPageRoute(builder: (_)=>SelectAddressFromMapPage() );
      case AppRoutes.startSelectLocationPage:
      return MaterialPageRoute(builder: (_)=>StartSelectLocationPage());
      case AppRoutes.verifyOtp:
      //  final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(
            
          //  identifier: email
            ),
        );
      case AppRoutes.manualAddressEntry:
        return MaterialPageRoute(
          builder: (_) => const ManualAddressEntryPage(),
        );
      case AppRoutes.buildingDetails:
        final locationEntity = settings.arguments as LocationEntity?;
        return MaterialPageRoute(
          builder: (_) => BuildingDetailsPage(initialLocation: locationEntity),
        );
      case AppRoutes.productDetails:
        final product = settings.arguments as CategoryProductModel;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProductDetailsScreen(product: product),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Custom slide transition مع Hero Animation
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0), // يدخل من اليمين
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
                  ),
                ),
                child: child,
              ),
            );
          },
        );
      // case AppRoutes.cart:
      //   return PageRouteBuilder(
      //     opaque: false,
      //     pageBuilder: (context, animation, secondaryAnimation) => const CartScreen(),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //       const begin = Offset(0.0, 1.0);
      //       const end = Offset.zero;
      //       const curve = Curves.fastOutSlowIn;

      //       var tween = Tween(begin: begin, end: end).chain(
      //         CurveTween(curve: curve),
      //       );

      //       return SlideTransition(
      //         position: animation.drive(tween),
      //         child: child,
      //       );
      //     },
      //     transitionDuration: const Duration(milliseconds: 250),
      //     reverseTransitionDuration: const Duration(milliseconds: 200),
      //   );


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
