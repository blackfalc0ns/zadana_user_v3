abstract class NetworkConstants {
  static const String baseUrl = "https://zadana.runasp.net/api";
  static const String notificationsSignalRHubPath = '/hubs/notifications';
  static const String customerPresenceSignalRHubPath =
      '/hubs/customer-presence';
  static const String receiveNotificationSignalREvent = 'ReceiveNotification';
  static const String receiveOrderStatusChangedSignalREvent =
      'ReceiveOrderStatusChanged';
  static const String receiveOrderSupportCaseChangedSignalREvent =
      'ReceiveOrderSupportCaseChanged';
  static const String receiveDriverArrivalStateChangedSignalREvent =
      'ReceiveDriverArrivalStateChanged';
  static const String receiveBroadcastSignalREvent = 'ReceiveBroadcast';
  static const String customerPresenceUpdatedSignalREvent =
      'customerPresenceUpdated';
  static const String customerPresenceAppForegroundMethod = 'AppForeground';
  static const String customerPresenceAppBackgroundMethod = 'AppBackground';
  static const String customerPresenceHeartbeatMethod = 'Heartbeat';
  static const String ordersSignalRHubPath = notificationsSignalRHubPath;
  static const String ordersSignalRMethods =
      receiveOrderStatusChangedSignalREvent;
  static const String authorization = 'Authorization';
  static const String bearer = "Bearer";
  static const String deviceIdHeader = 'X-Device-Id';
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
  static const String homeExploreMore = '/home/dynamic-sections';
  static const String brandProducts = '/brands/{brandId}/products';
  static const String brandFilters = '/brands/{brandId}/filters';
  static const String categorySubcategories =
      '/categories/{categoryId}/subcategories';
  static const String categoryFilters = '/categories/{categoryId}/filters';
  static const String categoryProducts = '/categories/{subCategoryId}/products';
  static const String shoppingProducts = '/categories/products';
  static const String productsSearch = '/products/search';
  static const String productDetails = '/products/{productId}';
  static const String register = "/customers/auth/register";
  static const String login = '/customers/auth/login';
  static const String logout = '/customers/auth/logout';
  static const String forgetPassword = '/customers/auth/forgot-password';
  static const String resetPassword = '/customers/auth/reset-password';
  static const String verifyOtp = '/customers/auth/verify-otp';
  static const String getProfile = '/customers/auth/me';
  static const String updateProfile = '/customers/auth/me';
  static const String customerAddresses = '/customers/addresses';
  static const String getAddress = '/location/address';
  static const String searchLocations = '/location/search';
  static const String sendDeliveryOtp = '/delivery/otp/send';
  static const String verifyDeliveryOtp = '/delivery/otp/verify';
  static const String resendDeliveryOtp = '/delivery/otp/resend';
  static const String favorites = '/favorites';
  static const String cartVendors = '/cart/vendors';
  static const String cartItems = '/cart/items';
  static const String cart = '/cart';
  static const String activeOrders = '/orders/active';
  static const String completedOrders = '/orders/completed';
  static const String returnedOrders = '/orders/returns';
  static const String orderDetails = '/orders/{orderId}';
  static const String orderSupportCases = '/orders/{orderId}/cases';
  static const String orderSupportCaseAttachments =
      '/orders/{orderId}/cases/attachments';
  static const String orderSupportReasons = '/orders/support-reasons/{type}';
  static const String orderTracking = '/orders/{orderId}/tracking';
  static const String orderCancellationReasons = '/orders/cancellation-reasons';
  static const String cancelOrder = '/orders/{orderId}/cancel';
  static const String retryOrderPayment = '/orders/{orderId}/retry-payment';
  static const String deleteOrder = '/orders/{orderId}';
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsReadAll = '/notifications/read-all';
  static const String notificationDevices = '/notifications/devices';
  static const String notificationDevicesRegister =
      '/notifications/devices/register';
  static const String notificationDevicesPreferences =
      '/notifications/devices/preferences';
  static const String notificationDevicesUnregister =
      '/notifications/devices/unregister';
}
