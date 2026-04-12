import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/pages/forget_password_screen.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_view_model.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/pages/login_screen.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/pages/register_screen.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/pages/reset_password_screen.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/pages/verify_reset_otp_screen.dart';
import 'package:zadana_user_v3/feature/home/presentation/pages/home_screen.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/select_address_from_map_page.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/start_select_location_page.dart';
import 'package:zadana_user_v3/feature/onboarding/presentation/splash_page.dart';
import 'package:zadana_user_v3/feature/onboarding/presentation/on_boarding_page.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/profile_details_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/edit_profile_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/about_app_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/faq_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/help_support_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/privacy_policy_screen.dart';
import 'package:zadana_user_v3/feature/profile/presentation/pages/terms_conditions_screen.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/pages/verify_otp_screen.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/manual_address_entry_page.dart';
import 'package:zadana_user_v3/feature/location/presentation/pages/building_details_page.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/pages/product_details_screen.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_success_screen.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/pages/track_order_screen.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/my_orders_page.dart';
import 'package:zadana_user_v3/feature/notifications/presentation/pages/notifications_screen.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/pages/delivery_otp_screen.dart';
import 'package:zadana_user_v3/feature/delivery_verification/presentation/pages/success_order_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginViewModel>(),
            child: const LoginScreen(),
          ),
        );
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case AppRoutes.startPage:
        return MaterialPageRoute(builder: (_) => StartPage());
      case AppRoutes.signUp:
        final locationEntity = settings.arguments as LocationEntity?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<RegisterViewModel>(),
            child: RegisterScreen(locationEntity: locationEntity),
          ),
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
        final initialIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              MainShell(key: mainShellKey, initialIndex: initialIndex),
        );
      case AppRoutes.selectAddress:
        return MaterialPageRoute(builder: (_) => SelectAddressFromMapPage());
      case AppRoutes.startSelectLocationPage:
        return MaterialPageRoute(builder: (_) => StartSelectLocationPage());
      case AppRoutes.verifyOtp:
        final identifier = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(identifier: identifier),
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
        final product = settings.arguments as ProductModel;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProductDetailsScreen(product: product),
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                ),
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
                child: child,
              ),
            );
          },
        );
      case AppRoutes.paymentSuccess:
        final orderId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(orderId: orderId),
        );
      case AppRoutes.orders:
        return MaterialPageRoute(builder: (_) => const MyOrdersPage());
      case AppRoutes.trackOrder:
        return MaterialPageRoute(builder: (_) => const TrackOrderScreen());

      case AppRoutes.myOrdersPage:
        return MaterialPageRoute(builder: (_) => const MyOrdersPage());
      case AppRoutes.aboutApp:
        return MaterialPageRoute(builder: (_) => const AboutAppScreen());
      case AppRoutes.helpSupport:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case AppRoutes.faq:
        return MaterialPageRoute(builder: (_) => const FaqScreen());
      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case AppRoutes.termsConditions:
        return MaterialPageRoute(builder: (_) => const TermsConditionsScreen());
      case AppRoutes.deliveryOtp:
        final arguments = settings.arguments as Map<String, String?>?;
        final orderId = arguments?['orderId'] ?? '';
        final phoneNumber = arguments?['phoneNumber'] ?? '';
        final courierName = arguments?['courierName'];
        return MaterialPageRoute(
          builder: (_) => DeliveryOtpScreen(
            orderId: orderId,
            phoneNumber: phoneNumber,
            courierName: courierName,
          ),
        );
      case AppRoutes.successOrder:
        final arguments = settings.arguments as Map<String, String?>?;
        return MaterialPageRoute(
          builder: (_) => SuccessOrderScreen(
            orderId: arguments?['orderId'],
            courierName: arguments?['courierName'],
          ),
        );
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

