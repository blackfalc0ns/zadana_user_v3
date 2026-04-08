abstract class NetworkConstants {
  static const String baseUrl = "https://zadana.runasp.net/api";
  static const String authorization = 'Authorization';
  static const String bearer = "Bearer";
}

abstract class EndPoints {
  static const String home = '/home';
  static const String homeBanners = '/home/banners';
  static const String homeCategories = '/home/categories';
  static const String homeBestSelling = '/home/best-selling';
  static const String homeBrands = '/home/brands';
  static const String homeRecommended = '/home/recommended';
  static const String homeFeaturedProducts = '/home/featured-products';
  static const String homeSpecialOffers = '/home/special-offers';
  static const String homeExploreMore = '/home/explore-more';
  static const String register = "/customers/auth/register";
  static const String login = '/customers/auth/login';
  static const String forgetPassword = '/customers/auth/forgot-password';
  static const String resetPassword = '/customers/auth/reset-password';
  static const String verifyOtp = '/customers/auth/verify-otp';
  static const String getProfile = '/customers/auth/me';
  static const String getAddress = '/location/address';
  static const String searchLocations = '/location/search';
  static const String sendDeliveryOtp = '/delivery/otp/send';
  static const String verifyDeliveryOtp = '/delivery/otp/verify';
  static const String resendDeliveryOtp = '/delivery/otp/resend';
}
