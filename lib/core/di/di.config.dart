// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart' as _i695;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../feature/addresses/data/data_source/customer_addresses_remote_data_source.dart'
    as _i564;
import '../../feature/addresses/data/data_source/customer_addresses_remote_data_source_impl.dart'
    as _i1065;
import '../../feature/addresses/data/repo/customer_addresses_repository_impl.dart'
    as _i237;
import '../../feature/addresses/domain/repo/customer_addresses_repository.dart'
    as _i230;
import '../../feature/addresses/domain/usecase/add_customer_address_usecase.dart'
    as _i95;
import '../../feature/addresses/domain/usecase/delete_customer_address_usecase.dart'
    as _i557;
import '../../feature/addresses/domain/usecase/get_customer_addresses_usecase.dart'
    as _i525;
import '../../feature/addresses/domain/usecase/set_customer_address_as_default_usecase.dart'
    as _i175;
import '../../feature/addresses/domain/usecase/update_customer_address_usecase.dart'
    as _i563;
import '../../feature/addresses/presentation/manager/customer_addresses_view_model.dart'
    as _i720;
import '../../feature/app_section/manager/app_section_global_cubit.dart'
    as _i162;
import '../../feature/auth/forget_password/data/data_source/forget_password_remote_data_source.dart'
    as _i596;
import '../../feature/auth/forget_password/data/data_source/forget_password_remote_data_source_impl.dart'
    as _i570;
import '../../feature/auth/forget_password/data/repo/forget_password_repository_impl.dart'
    as _i384;
import '../../feature/auth/forget_password/domain/repo/forget_password_repository.dart'
    as _i881;
import '../../feature/auth/forget_password/domain/usecase/forget_password_usecase.dart'
    as _i732;
import '../../feature/auth/forget_password/presentation/manager/forget_password_view_model.dart'
    as _i934;
import '../../feature/auth/login/data/data_source/login_remote_data_source.dart'
    as _i952;
import '../../feature/auth/login/data/data_source/login_remote_data_source_impl.dart'
    as _i912;
import '../../feature/auth/login/data/repo/login_repository_impl.dart' as _i94;
import '../../feature/auth/login/domain/repo/login_repository.dart' as _i558;
import '../../feature/auth/login/domain/usecase/login_usecase.dart' as _i248;
import '../../feature/auth/login/presentation/manager/login_view_model.dart'
    as _i955;
import '../../feature/auth/logout/data/data_source/logout_remote_data_source.dart'
    as _i609;
import '../../feature/auth/logout/data/data_source/logout_remote_data_source_impl.dart'
    as _i692;
import '../../feature/auth/logout/data/repo/logout_repository_impl.dart'
    as _i691;
import '../../feature/auth/logout/domain/repo/logout_repository.dart' as _i31;
import '../../feature/auth/logout/domain/usecase/logout_usecase.dart' as _i426;
import '../../feature/auth/register/data/data_source/register_remote_data_source.dart'
    as _i334;
import '../../feature/auth/register/data/data_source/register_remote_data_source_impl.dart'
    as _i168;
import '../../feature/auth/register/data/repo/register_repository_impl.dart'
    as _i466;
import '../../feature/auth/register/domain/repo/register_repository.dart'
    as _i399;
import '../../feature/auth/register/domain/usecase/register_usecase.dart'
    as _i166;
import '../../feature/auth/register/presentation/manager/register_view_model.dart'
    as _i330;
import '../../feature/auth/reset_password/data/data_source/reset_password_remote_data_source.dart'
    as _i122;
import '../../feature/auth/reset_password/data/data_source/reset_password_remote_data_source_impl.dart'
    as _i992;
import '../../feature/auth/reset_password/data/repo/reset_password_repository_impl.dart'
    as _i670;
import '../../feature/auth/reset_password/domain/repo/reset_password_repository.dart'
    as _i491;
import '../../feature/auth/reset_password/domain/usecase/reset_password_usecase.dart'
    as _i996;
import '../../feature/auth/reset_password/domain/usecase/verify_reset_otp_usecase.dart'
    as _i23;
import '../../feature/auth/reset_password/presentation/manager/reset_password_view_model.dart'
    as _i910;
import '../../feature/auth/verify_otp/data/data_source/verify_otp_remote_data_source.dart'
    as _i698;
import '../../feature/auth/verify_otp/data/data_source/verify_otp_remote_data_source_impl.dart'
    as _i285;
import '../../feature/auth/verify_otp/data/repo/verify_otp_repository_impl.dart'
    as _i548;
import '../../feature/auth/verify_otp/domain/repo/verify_otp_repository.dart'
    as _i415;
import '../../feature/auth/verify_otp/domain/usecase/resend_otp_usecase.dart'
    as _i62;
import '../../feature/auth/verify_otp/domain/usecase/verify_otp_usecase.dart'
    as _i851;
import '../../feature/auth/verify_otp/presentation/manager/verify_otp_view_model.dart'
    as _i718;
import '../../feature/best_selling/presentation/manager/best_selling_products_cubit.dart'
    as _i908;
import '../../feature/brand/data/data_source/brand_remote_data_source.dart'
    as _i484;
import '../../feature/brand/data/data_source/brand_remote_data_source_impl.dart'
    as _i1061;
import '../../feature/brand/data/repo/brand_repository_impl.dart' as _i982;
import '../../feature/brand/domain/entities/brand_model.dart' as _i1044;
import '../../feature/brand/domain/repo/brand_repository.dart' as _i2;
import '../../feature/brand/domain/usecase/get_brand_filters_usecase.dart'
    as _i504;
import '../../feature/brand/domain/usecase/get_brand_products_usecase.dart'
    as _i296;
import '../../feature/brand/presentation/brand/manager/brands_listing_cubit.dart'
    as _i372;
import '../../feature/brand/presentation/brand_details/manager/brand_details_cubit.dart'
    as _i1008;
import '../../feature/cart/data/data_source/cart_remote_data_source.dart'
    as _i1034;
import '../../feature/cart/data/data_source/cart_remote_data_source_impl.dart'
    as _i640;
import '../../feature/cart/data/repo/cart_repository_impl.dart' as _i132;
import '../../feature/cart/domain/repo/cart_repository.dart' as _i435;
import '../../feature/cart/domain/usecase/add_cart_item_usecase.dart' as _i448;
import '../../feature/cart/domain/usecase/check_delivery_usecase.dart' as _i262;
import '../../feature/cart/domain/usecase/clear_cart_usecase.dart' as _i327;
import '../../feature/cart/domain/usecase/get_cart_usecase.dart' as _i925;
import '../../feature/cart/domain/usecase/get_cart_vendors_usecase.dart'
    as _i1065;
import '../../feature/cart/domain/usecase/remove_cart_item_usecase.dart'
    as _i483;
import '../../feature/cart/domain/usecase/update_cart_item_quantity_usecase.dart'
    as _i8;
import '../../feature/cart/presentation/manager/cart_view_model.dart' as _i341;
import '../../feature/category/data/data_source/category_remote_data_source.dart'
    as _i601;
import '../../feature/category/data/data_source/category_remote_data_source_impl.dart'
    as _i642;
import '../../feature/category/data/repo/category_repository_impl.dart'
    as _i473;
import '../../feature/category/domain/repo/category_repository.dart' as _i131;
import '../../feature/category/domain/usecase/get_categories_usecase.dart'
    as _i17;
import '../../feature/category/domain/usecase/get_category_filters_usecase.dart'
    as _i91;
import '../../feature/category/domain/usecase/get_category_products_usecase.dart'
    as _i127;
import '../../feature/category/domain/usecase/get_category_subcategories_usecase.dart'
    as _i737;
import '../../feature/category/domain/usecase/get_shopping_products_usecase.dart'
    as _i45;
import '../../feature/category/presentation/manager/category_view_model.dart'
    as _i228;
import '../../feature/delivery_verification/data/data_source/delivery_verification_remote_data_source.dart'
    as _i691;
import '../../feature/delivery_verification/data/data_source/delivery_verification_remote_data_source_impl.dart'
    as _i19;
import '../../feature/delivery_verification/data/repo/delivery_verification_repo_impl.dart'
    as _i1023;
import '../../feature/delivery_verification/domain/repo/delivery_verification_repo.dart'
    as _i891;
import '../../feature/delivery_verification/domain/usecase/resend_delivery_otp_usecase.dart'
    as _i882;
import '../../feature/delivery_verification/domain/usecase/send_delivery_otp_usecase.dart'
    as _i475;
import '../../feature/delivery_verification/domain/usecase/verify_delivery_otp_usecase.dart'
    as _i8;
import '../../feature/delivery_verification/presentation/manager/delivery_otp_view_model.dart'
    as _i796;
import '../../feature/favorites/data/data_source/favorites_remote_data_source.dart'
    as _i480;
import '../../feature/favorites/data/data_source/favorites_remote_data_source_impl.dart'
    as _i346;
import '../../feature/favorites/data/repo/favorites_repository.dart' as _i140;
import '../../feature/favorites/domain/usecase/clear_favorites_usecase.dart'
    as _i954;
import '../../feature/favorites/domain/usecase/get_favorites_usecase.dart'
    as _i253;
import '../../feature/favorites/domain/usecase/remove_favorite_usecase.dart'
    as _i314;
import '../../feature/favorites/presentation/manager/favorites_view_model.dart'
    as _i190;
import '../../feature/home/data/data_source/home_remote_data_source.dart'
    as _i730;
import '../../feature/home/data/data_source/home_remote_data_source_impl.dart'
    as _i1072;
import '../../feature/home/data/repo/home_repository_impl.dart' as _i311;
import '../../feature/home/domain/repo/home_repository.dart' as _i227;
import '../../feature/home/domain/usecase/get_home_app_bar_usecase.dart'
    as _i699;
import '../../feature/home/domain/usecase/get_home_banners_usecase.dart'
    as _i1034;
import '../../feature/home/domain/usecase/get_home_best_selling_usecase.dart'
    as _i652;
import '../../feature/home/domain/usecase/get_home_brands_usecase.dart'
    as _i446;
import '../../feature/home/domain/usecase/get_home_categories_usecase.dart'
    as _i1020;
import '../../feature/home/domain/usecase/get_home_dynamic_sections_usecase.dart'
    as _i840;
import '../../feature/home/domain/usecase/get_home_featured_products_usecase.dart'
    as _i327;
import '../../feature/home/domain/usecase/get_home_recommended_usecase.dart'
    as _i394;
import '../../feature/home/domain/usecase/get_home_special_offers_usecase.dart'
    as _i342;
import '../../feature/home/presentation/manager/all_categories/all_categories_view_model.dart'
    as _i305;
import '../../feature/home/presentation/manager/home_view_model.dart' as _i495;
import '../../feature/location/data/datasources/location_data_source.dart'
    as _i408;
import '../../feature/location/data/datasources/location_data_source_imp.dart'
    as _i1072;
import '../../feature/location/data/repo/location_repo_imp.dart' as _i232;
import '../../feature/location/domain/repo/location_repo.dart' as _i912;
import '../../feature/location/domain/usecase/get_address_from_coordinates_use_case.dart'
    as _i1061;
import '../../feature/location/domain/usecase/get_current_location_with_address_use_case.dart'
    as _i117;
import '../../feature/location/domain/usecase/search_locations_usecase.dart'
    as _i903;
import '../../feature/location/presentation/manager/location_view_model.dart'
    as _i343;
import '../../feature/my_orders/data/data_source/my_orders_remote_data_source.dart'
    as _i739;
import '../../feature/my_orders/data/data_source/my_orders_remote_data_source_impl.dart'
    as _i635;
import '../../feature/my_orders/data/repo/my_orders_repository_impl.dart'
    as _i871;
import '../../feature/my_orders/domain/repo/my_orders_repository.dart' as _i858;
import '../../feature/my_orders/domain/usecase/cancel_order_usecase.dart'
    as _i890;
import '../../feature/my_orders/domain/usecase/delete_order_usecase.dart'
    as _i631;
import '../../feature/my_orders/domain/usecase/get_active_orders_usecase.dart'
    as _i149;
import '../../feature/my_orders/domain/usecase/get_completed_orders_usecase.dart'
    as _i166;
import '../../feature/my_orders/domain/usecase/get_order_cancellation_reasons_usecase.dart'
    as _i40;
import '../../feature/my_orders/domain/usecase/get_order_details_usecase.dart'
    as _i372;
import '../../feature/my_orders/domain/usecase/get_order_support_reasons_usecase.dart'
    as _i365;
import '../../feature/my_orders/domain/usecase/get_returned_orders_usecase.dart'
    as _i816;
import '../../feature/my_orders/domain/usecase/retry_order_payment_usecase.dart'
    as _i842;
import '../../feature/my_orders/presentation/manager/my_orders_view_model.dart'
    as _i398;
import '../../feature/my_orders/presentation/manager/order_details_view_model.dart'
    as _i393;
import '../../feature/notifications/data/data_source/notifications_remote_data_source.dart'
    as _i1071;
import '../../feature/notifications/data/data_source/notifications_remote_data_source_impl.dart'
    as _i559;
import '../../feature/notifications/data/repo/notifications_repository_impl.dart'
    as _i319;
import '../../feature/notifications/data/services/notifications_signalr_service.dart'
    as _i425;
import '../../feature/notifications/domain/repo/notifications_repository.dart'
    as _i916;
import '../../feature/notifications/domain/usecase/delete_all_notifications_usecase.dart'
    as _i751;
import '../../feature/notifications/domain/usecase/delete_notification_usecase.dart'
    as _i481;
import '../../feature/notifications/domain/usecase/get_notification_devices_usecase.dart'
    as _i570;
import '../../feature/notifications/domain/usecase/get_notification_preferences_usecase.dart'
    as _i80;
import '../../feature/notifications/domain/usecase/get_notification_unread_count_usecase.dart'
    as _i850;
import '../../feature/notifications/domain/usecase/get_notifications_usecase.dart'
    as _i519;
import '../../feature/notifications/domain/usecase/mark_all_notifications_as_read_usecase.dart'
    as _i690;
import '../../feature/notifications/domain/usecase/mark_notification_as_read_usecase.dart'
    as _i138;
import '../../feature/notifications/domain/usecase/register_notification_device_usecase.dart'
    as _i296;
import '../../feature/notifications/domain/usecase/unregister_notification_device_usecase.dart'
    as _i1029;
import '../../feature/notifications/domain/usecase/update_notification_device_preferences_usecase.dart'
    as _i439;
import '../../feature/notifications/domain/usecase/update_notification_preferences_usecase.dart'
    as _i958;
import '../../feature/notifications/domain/usecase/watch_realtime_notifications_usecase.dart'
    as _i1040;
import '../../feature/notifications/presentation/manager/notifications_view_model.dart'
    as _i683;
import '../../feature/notifications/presentation/services/realtime_notification_overlay_service.dart'
    as _i1050;
import '../../feature/payment/data/data_source/payment_remote_data_source.dart'
    as _i844;
import '../../feature/payment/data/data_source/payment_remote_data_source_impl.dart'
    as _i311;
import '../../feature/payment/data/repo/payment_repository_impl.dart' as _i562;
import '../../feature/payment/domain/repo/payment_repository.dart' as _i420;
import '../../feature/payment/domain/usecase/apply_checkout_promo_code_usecase.dart'
    as _i492;
import '../../feature/payment/domain/usecase/confirm_moyasar_payment_usecase.dart'
    as _i450;
import '../../feature/payment/domain/usecase/get_checkout_summary_usecase.dart'
    as _i867;
import '../../feature/payment/domain/usecase/place_order_usecase.dart' as _i859;
import '../../feature/payment/domain/usecase/remove_checkout_promo_code_usecase.dart'
    as _i1066;
import '../../feature/payment/presentation/manager/payment_view_model.dart'
    as _i566;
import '../../feature/product_details/data/data_source/product_details_remote_data_source.dart'
    as _i304;
import '../../feature/product_details/data/data_source/product_details_remote_data_source_impl.dart'
    as _i704;
import '../../feature/product_details/data/repo/product_details_repository_impl.dart'
    as _i1028;
import '../../feature/product_details/domain/repo/product_details_repository.dart'
    as _i888;
import '../../feature/product_details/domain/usecase/product_details_usecase.dart'
    as _i875;
import '../../feature/product_details/presentation/manager/product_details_cubit.dart'
    as _i31;
import '../../feature/profile/data/data_source/profile_remote_data_source.dart'
    as _i371;
import '../../feature/profile/data/data_source/profile_remote_data_source_impl.dart'
    as _i544;
import '../../feature/profile/data/repo/profile_repository_impl.dart' as _i771;
import '../../feature/profile/domain/repo/profile_repository.dart' as _i1006;
import '../../feature/profile/domain/usecase/delete_profile_photo_usecase.dart'
    as _i601;
import '../../feature/profile/domain/usecase/profile_usecase.dart' as _i766;
import '../../feature/profile/domain/usecase/update_profile_photo_usecase.dart'
    as _i698;
import '../../feature/profile/domain/usecase/update_profile_usecase.dart'
    as _i477;
import '../../feature/profile/presentation/manager/profile_view_model.dart'
    as _i701;
import '../../feature/recommended/presentation/manager/recommended_products_cubit.dart'
    as _i122;
import '../../feature/search/data/data_source/product_search_remote_data_source.dart'
    as _i1069;
import '../../feature/search/data/data_source/product_search_remote_data_source_impl.dart'
    as _i324;
import '../../feature/search/data/repo/product_search_repository_impl.dart'
    as _i333;
import '../../feature/search/domain/entities/product_search_params.dart'
    as _i771;
import '../../feature/search/domain/repo/product_search_repository.dart'
    as _i685;
import '../../feature/search/domain/usecase/search_products_usecase.dart'
    as _i552;
import '../../feature/search/presentation/manager/product_search_cubit.dart'
    as _i655;
import '../../feature/special_offers/presentation/manager/special_offers_products_cubit.dart'
    as _i110;
import '../../feature/track_order/data/data_source/track_order_remote_data_source.dart'
    as _i58;
import '../../feature/track_order/data/data_source/track_order_remote_data_source_impl.dart'
    as _i695;
import '../../feature/track_order/data/repo/track_order_repository_impl.dart'
    as _i672;
import '../../feature/track_order/data/services/track_order_signalr_service.dart'
    as _i914;
import '../../feature/track_order/domain/repo/track_order_repository.dart'
    as _i556;
import '../../feature/track_order/domain/usecase/get_order_tracking_usecase.dart'
    as _i633;
import '../../feature/track_order/presentation/manager/track_order_view_model.dart'
    as _i341;
import '../general_cubit/local_cubit.dart' as _i794;
import '../helpers/permision_service.dart' as _i367;
import '../helpers/shared_pref.dart' as _i42;
import '../network/api_services.dart' as _i804;
import '../network/external_modules.dart' as _i576;
import '../network/osm_api_services.dart' as _i777;
import '../services/app_navigator_service.dart' as _i179;
import '../services/captcha_service.dart' as _i118;
import '../services/category_navigation_service.dart' as _i900;
import '../services/device_id_interceptor.dart' as _i930;
import '../services/device_id_service.dart' as _i148;
import '../services/guest_cart_signature_interceptor.dart' as _i955;
import '../services/guest_cart_signature_service.dart' as _i1021;
import '../services/language_interceptor.dart' as _i32;
import '../services/language_service.dart' as _i819;
import '../services/local_notification_service.dart' as _i762;
import '../services/notification_device_service.dart' as _i823;
import '../services/push_token_service.dart' as _i92;
import '../services/retry_interceptor.dart' as _i844;
import '../services/session_expiry_service.dart' as _i486;
import '../services/token_interceptor.dart' as _i1056;
import '../services/token_service.dart' as _i227;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModules = _$ExternalModules();
    gh.factory<_i367.LocationPermissionService>(
      () => _i367.LocationPermissionService(),
    );
    await gh.factoryAsync<_i695.CacheStore>(
      () => externalModules.provideCacheStore,
      preResolve: true,
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModules.provideSharedPreferences,
      preResolve: true,
    );
    gh.factory<_i844.RetryInterceptor>(() => _i844.RetryInterceptor());
    gh.factory<_i1056.TokenInterceptor>(() => _i1056.TokenInterceptor());
    gh.lazySingleton<_i528.PrettyDioLogger>(
      () => externalModules.providePrettyDioLogger(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModules.flutterSecureStorage(),
    );
    gh.lazySingleton<_i179.AppNavigatorService>(
      () => _i179.AppNavigatorService(),
    );
    gh.lazySingleton<_i118.CaptchaService>(() => _i118.CaptchaService());
    gh.lazySingleton<_i900.CategoryNavigationService>(
      () => _i900.CategoryNavigationService(),
    );
    gh.factory<_i118.CaptchaInterceptor>(
      () => _i118.CaptchaInterceptor(gh<_i118.CaptchaService>()),
    );
    gh.factory<_i42.SharedPrefHelper>(
      () => _i42.SharedPrefHelper(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideOsmDio(gh<_i528.PrettyDioLogger>()),
      instanceName: 'osmDio',
    );
    gh.lazySingleton<_i762.LocalNotificationService>(
      () => _i762.LocalNotificationService(gh<_i179.AppNavigatorService>()),
    );
    gh.factory<_i227.TokenService>(
      () => _i227.TokenService(
        prefs: gh<_i558.FlutterSecureStorage>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i777.OsmApiServices>(
      () => _i777.OsmApiServices(gh<_i361.Dio>(instanceName: 'osmDio')),
    );
    gh.factory<_i819.LanguageService>(
      () => _i819.LanguageService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i148.DeviceIdService>(
      () => _i148.DeviceIdService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i92.PushTokenService>(
      () => _i92.PushTokenService(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i408.LocationDataSource>(
      () => _i1072.LocationDataSourceImpl(
        gh<_i777.OsmApiServices>(),
        gh<_i367.LocationPermissionService>(),
      ),
    );
    gh.lazySingleton<_i486.SessionExpiryService>(
      () => _i486.SessionExpiryService(
        gh<_i227.TokenService>(),
        gh<_i179.AppNavigatorService>(),
      ),
    );
    gh.factory<_i930.DeviceIdInterceptor>(
      () => _i930.DeviceIdInterceptor(
        gh<_i227.TokenService>(),
        gh<_i148.DeviceIdService>(),
      ),
    );
    gh.lazySingleton<_i425.NotificationsSignalRService>(
      () => _i425.NotificationsSignalRService(gh<_i227.TokenService>()),
    );
    gh.lazySingleton<_i914.TrackOrderSignalRService>(
      () => _i914.TrackOrderSignalRService(gh<_i227.TokenService>()),
    );
    gh.lazySingleton<_i794.LocaleThemeCubit>(
      () => _i794.LocaleThemeCubit(gh<_i819.LanguageService>()),
    );
    gh.factory<_i32.LanguageInterceptor>(
      () => _i32.LanguageInterceptor(gh<_i819.LanguageService>()),
    );
    gh.lazySingleton<_i1021.GuestCartSignatureService>(
      () => _i1021.GuestCartSignatureService(gh<_i148.DeviceIdService>()),
    );
    gh.factory<_i912.LocationRepository>(
      () => _i232.LocationRepositoryImpl(gh<_i408.LocationDataSource>()),
    );
    gh.factory<_i1061.GetAddressFromCoordinatesUseCase>(
      () => _i1061.GetAddressFromCoordinatesUseCase(
        gh<_i912.LocationRepository>(),
      ),
    );
    gh.factory<_i117.GetCurrentLocationWithAddressUseCase>(
      () => _i117.GetCurrentLocationWithAddressUseCase(
        gh<_i912.LocationRepository>(),
      ),
    );
    gh.factory<_i903.SearchLocationsUseCase>(
      () => _i903.SearchLocationsUseCase(gh<_i912.LocationRepository>()),
    );
    gh.factory<_i955.GuestCartSignatureInterceptor>(
      () => _i955.GuestCartSignatureInterceptor(
        gh<_i227.TokenService>(),
        gh<_i1021.GuestCartSignatureService>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideDio(
        gh<_i528.PrettyDioLogger>(),
        gh<_i1056.TokenInterceptor>(),
        gh<_i930.DeviceIdInterceptor>(),
        gh<_i32.LanguageInterceptor>(),
        gh<_i955.GuestCartSignatureInterceptor>(),
        gh<_i118.CaptchaInterceptor>(),
        gh<_i844.RetryInterceptor>(),
        gh<_i695.CacheStore>(),
      ),
    );
    gh.factory<_i804.ApiServices>(() => _i804.ApiServices(gh<_i361.Dio>()));
    gh.factory<_i844.PaymentRemoteDataSource>(
      () => _i311.PaymentRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i596.ForgetPasswordRemoteDataSource>(
      () => _i570.ForgetPasswordRemoteDataSourceImpl(
        apiServices: gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i691.DeliveryVerificationRemoteDataSource>(
      () => _i19.DeliveryVerificationRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i58.TrackOrderRemoteDataSource>(
      () => _i695.TrackOrderRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i601.CategoryRemoteDataSource>(
      () => _i642.CategoryRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i698.VerifyOtpRemoteDataSource>(
      () => _i285.VerifyOtpRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i952.LoginRemoteDataSource>(
      () => _i912.LoginRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i484.BrandRemoteDataSource>(
      () => _i1061.BrandRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i739.MyOrdersRemoteDataSource>(
      () => _i635.MyOrdersRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i304.ProductDetailsRemoteDataSource>(
      () => _i704.ProductDetailsRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i1071.NotificationsRemoteDataSource>(
      () => _i559.NotificationsRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i730.HomeRemoteDataSource>(
      () => _i1072.HomeRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i556.TrackOrderRepository>(
      () => _i672.TrackOrderRepositoryImpl(
        gh<_i58.TrackOrderRemoteDataSource>(),
        gh<_i914.TrackOrderSignalRService>(),
      ),
    );
    gh.factory<_i371.ProfileRemoteDataSource>(
      () => _i544.ProfileRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i858.MyOrdersRepository>(
      () => _i871.MyOrdersRepositoryImpl(gh<_i739.MyOrdersRemoteDataSource>()),
    );
    gh.factory<_i888.ProductDetailsRepository>(
      () => _i1028.ProductDetailsRepositoryImpl(
        gh<_i304.ProductDetailsRemoteDataSource>(),
      ),
    );
    gh.factory<_i609.LogoutRemoteDataSource>(
      () => _i692.LogoutRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i564.CustomerAddressesRemoteDataSource>(
      () =>
          _i1065.CustomerAddressesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i1034.CartRemoteDataSource>(
      () => _i640.CartRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
        gh<_i361.Dio>(),
        gh<_i695.CacheStore>(),
        gh<_i227.TokenService>(),
        gh<_i148.DeviceIdService>(),
      ),
    );
    gh.factory<_i881.ForgetPasswordRepository>(
      () => _i384.ForgetPasswordRepositoryImpl(
        gh<_i596.ForgetPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i1069.ProductSearchRemoteDataSource>(
      () => _i324.ProductSearchRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.lazySingleton<_i435.CartRepository>(
      () => _i132.CartRepositoryImpl(gh<_i1034.CartRemoteDataSource>()),
    );
    gh.factory<_i230.CustomerAddressesRepository>(
      () => _i237.CustomerAddressesRepositoryImpl(
        gh<_i564.CustomerAddressesRemoteDataSource>(),
      ),
    );
    gh.factory<_i95.AddCustomerAddressUseCase>(
      () => _i95.AddCustomerAddressUseCase(
        gh<_i230.CustomerAddressesRepository>(),
      ),
    );
    gh.factory<_i557.DeleteCustomerAddressUseCase>(
      () => _i557.DeleteCustomerAddressUseCase(
        gh<_i230.CustomerAddressesRepository>(),
      ),
    );
    gh.factory<_i525.GetCustomerAddressesUseCase>(
      () => _i525.GetCustomerAddressesUseCase(
        gh<_i230.CustomerAddressesRepository>(),
      ),
    );
    gh.factory<_i175.SetCustomerAddressAsDefaultUseCase>(
      () => _i175.SetCustomerAddressAsDefaultUseCase(
        gh<_i230.CustomerAddressesRepository>(),
      ),
    );
    gh.factory<_i563.UpdateCustomerAddressUseCase>(
      () => _i563.UpdateCustomerAddressUseCase(
        gh<_i230.CustomerAddressesRepository>(),
      ),
    );
    gh.factory<_i31.LogoutRepository>(
      () => _i691.LogoutRepositoryImpl(gh<_i609.LogoutRemoteDataSource>()),
    );
    gh.factory<_i122.ResetPasswordRemoteDataSource>(
      () => _i992.ResetPasswordRemoteDataSourceImpl(
        apiServices: gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i633.GetOrderTrackingUseCase>(
      () => _i633.GetOrderTrackingUseCase(gh<_i556.TrackOrderRepository>()),
    );
    gh.factory<_i426.LogoutUseCase>(
      () => _i426.LogoutUseCase(repository: gh<_i31.LogoutRepository>()),
    );
    gh.factory<_i448.AddCartItemUseCase>(
      () => _i448.AddCartItemUseCase(gh<_i435.CartRepository>()),
    );
    gh.factory<_i262.CheckDeliveryUseCase>(
      () => _i262.CheckDeliveryUseCase(gh<_i435.CartRepository>()),
    );
    gh.factory<_i327.ClearCartUseCase>(
      () => _i327.ClearCartUseCase(gh<_i435.CartRepository>()),
    );
    gh.factory<_i925.GetCartUseCase>(
      () => _i925.GetCartUseCase(gh<_i435.CartRepository>()),
    );
    gh.factory<_i1065.GetCartVendorsUseCase>(
      () => _i1065.GetCartVendorsUseCase(gh<_i435.CartRepository>()),
    );
    gh.factory<_i483.RemoveCartItemUseCase>(
      () => _i483.RemoveCartItemUseCase(gh<_i435.CartRepository>()),
    );
    gh.factory<_i8.UpdateCartItemQuantityUseCase>(
      () => _i8.UpdateCartItemQuantityUseCase(gh<_i435.CartRepository>()),
    );
    gh.factory<_i227.HomeRepository>(
      () => _i311.HomeRepositoryImpl(gh<_i730.HomeRemoteDataSource>()),
    );
    gh.factory<_i420.PaymentRepository>(
      () => _i562.PaymentRepositoryImpl(gh<_i844.PaymentRemoteDataSource>()),
    );
    gh.factory<_i699.GetHomeAppBarUseCase>(
      () => _i699.GetHomeAppBarUseCase(gh<_i227.HomeRepository>()),
    );
    gh.factory<_i1034.GetHomeBannersUseCase>(
      () => _i1034.GetHomeBannersUseCase(gh<_i227.HomeRepository>()),
    );
    gh.factory<_i652.GetHomeBestSellingUseCase>(
      () => _i652.GetHomeBestSellingUseCase(gh<_i227.HomeRepository>()),
    );
    gh.factory<_i446.GetHomeBrandsUseCase>(
      () => _i446.GetHomeBrandsUseCase(gh<_i227.HomeRepository>()),
    );
    gh.factory<_i1020.GetHomeCategoriesUseCase>(
      () => _i1020.GetHomeCategoriesUseCase(gh<_i227.HomeRepository>()),
    );
    gh.factory<_i840.GetHomeDynamicSectionsUseCase>(
      () => _i840.GetHomeDynamicSectionsUseCase(gh<_i227.HomeRepository>()),
    );
    gh.factory<_i327.GetHomeFeaturedProductsUseCase>(
      () => _i327.GetHomeFeaturedProductsUseCase(gh<_i227.HomeRepository>()),
    );
    gh.factory<_i394.GetHomeRecommendedUseCase>(
      () => _i394.GetHomeRecommendedUseCase(gh<_i227.HomeRepository>()),
    );
    gh.factory<_i342.GetHomeSpecialOffersUseCase>(
      () => _i342.GetHomeSpecialOffersUseCase(gh<_i227.HomeRepository>()),
    );
    gh.factory<_i334.RegisterRemoteDataSource>(
      () => _i168.RegisterRemoteDataSourceImpl(
        apiServices: gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i2.BrandRepository>(
      () => _i982.BrandRepositoryImpl(gh<_i484.BrandRemoteDataSource>()),
    );
    gh.factory<_i916.NotificationsRepository>(
      () => _i319.NotificationsRepositoryImpl(
        gh<_i1071.NotificationsRemoteDataSource>(),
        gh<_i425.NotificationsSignalRService>(),
      ),
    );
    gh.factory<_i875.ProductDetailsUseCase>(
      () => _i875.ProductDetailsUseCase(gh<_i888.ProductDetailsRepository>()),
    );
    gh.factory<_i891.DeliveryVerificationRepo>(
      () => _i1023.DeliveryVerificationRepoImpl(
        gh<_i691.DeliveryVerificationRemoteDataSource>(),
      ),
    );
    gh.factory<_i480.FavoritesRemoteDataSource>(
      () => _i346.FavoritesRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
        gh<_i361.Dio>(),
        gh<_i227.TokenService>(),
        gh<_i148.DeviceIdService>(),
      ),
    );
    gh.factory<_i131.CategoryRepository>(
      () => _i473.CategoryRepositoryImpl(gh<_i601.CategoryRemoteDataSource>()),
    );
    gh.factory<_i685.ProductSearchRepository>(
      () => _i333.ProductSearchRepositoryImpl(
        gh<_i1069.ProductSearchRemoteDataSource>(),
      ),
    );
    gh.factory<_i1006.ProfileRepository>(
      () => _i771.ProfileRepositoryImpl(gh<_i371.ProfileRemoteDataSource>()),
    );
    gh.factory<_i552.SearchProductsUseCase>(
      () => _i552.SearchProductsUseCase(gh<_i685.ProductSearchRepository>()),
    );
    gh.factory<_i751.DeleteAllNotificationsUseCase>(
      () => _i751.DeleteAllNotificationsUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i481.DeleteNotificationUseCase>(
      () =>
          _i481.DeleteNotificationUseCase(gh<_i916.NotificationsRepository>()),
    );
    gh.factory<_i570.GetNotificationDevicesUseCase>(
      () => _i570.GetNotificationDevicesUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i80.GetNotificationPreferencesUseCase>(
      () => _i80.GetNotificationPreferencesUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i850.GetNotificationUnreadCountUseCase>(
      () => _i850.GetNotificationUnreadCountUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i519.GetNotificationsUseCase>(
      () => _i519.GetNotificationsUseCase(gh<_i916.NotificationsRepository>()),
    );
    gh.factory<_i690.MarkAllNotificationsAsReadUseCase>(
      () => _i690.MarkAllNotificationsAsReadUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i138.MarkNotificationAsReadUseCase>(
      () => _i138.MarkNotificationAsReadUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i296.RegisterNotificationDeviceUseCase>(
      () => _i296.RegisterNotificationDeviceUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i1029.UnregisterNotificationDeviceUseCase>(
      () => _i1029.UnregisterNotificationDeviceUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i439.UpdateNotificationDevicePreferencesUseCase>(
      () => _i439.UpdateNotificationDevicePreferencesUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i958.UpdateNotificationPreferencesUseCase>(
      () => _i958.UpdateNotificationPreferencesUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factory<_i1040.WatchRealtimeNotificationsUseCase>(
      () => _i1040.WatchRealtimeNotificationsUseCase(
        gh<_i916.NotificationsRepository>(),
      ),
    );
    gh.factoryParam<
      _i655.ProductSearchViewModel,
      _i771.ProductSearchParams,
      dynamic
    >(
      (_params, _) => _i655.ProductSearchViewModel(
        gh<_i552.SearchProductsUseCase>(),
        _params,
      ),
    );
    gh.factoryParam<_i372.BrandsListingCubit, String, dynamic>(
      (title, _) =>
          _i372.BrandsListingCubit(gh<_i446.GetHomeBrandsUseCase>(), title),
    );
    gh.factory<_i890.CancelOrderUseCase>(
      () => _i890.CancelOrderUseCase(gh<_i858.MyOrdersRepository>()),
    );
    gh.factory<_i631.DeleteOrderUseCase>(
      () => _i631.DeleteOrderUseCase(gh<_i858.MyOrdersRepository>()),
    );
    gh.factory<_i149.GetActiveOrdersUseCase>(
      () => _i149.GetActiveOrdersUseCase(gh<_i858.MyOrdersRepository>()),
    );
    gh.factory<_i166.GetCompletedOrdersUseCase>(
      () => _i166.GetCompletedOrdersUseCase(gh<_i858.MyOrdersRepository>()),
    );
    gh.factory<_i40.GetOrderCancellationReasonsUseCase>(
      () => _i40.GetOrderCancellationReasonsUseCase(
        gh<_i858.MyOrdersRepository>(),
      ),
    );
    gh.factory<_i372.GetOrderDetailsUseCase>(
      () => _i372.GetOrderDetailsUseCase(gh<_i858.MyOrdersRepository>()),
    );
    gh.factory<_i365.GetOrderSupportReasonsUseCase>(
      () => _i365.GetOrderSupportReasonsUseCase(gh<_i858.MyOrdersRepository>()),
    );
    gh.factory<_i816.GetReturnedOrdersUseCase>(
      () => _i816.GetReturnedOrdersUseCase(gh<_i858.MyOrdersRepository>()),
    );
    gh.factory<_i842.RetryOrderPaymentUseCase>(
      () => _i842.RetryOrderPaymentUseCase(gh<_i858.MyOrdersRepository>()),
    );
    gh.factory<_i732.ForgetPasswordUseCase>(
      () => _i732.ForgetPasswordUseCase(
        repository: gh<_i881.ForgetPasswordRepository>(),
      ),
    );
    gh.factory<_i601.DeleteProfilePhotoUseCase>(
      () => _i601.DeleteProfilePhotoUseCase(gh<_i1006.ProfileRepository>()),
    );
    gh.factory<_i766.ProfileUseCase>(
      () => _i766.ProfileUseCase(gh<_i1006.ProfileRepository>()),
    );
    gh.factory<_i698.UpdateProfilePhotoUseCase>(
      () => _i698.UpdateProfilePhotoUseCase(gh<_i1006.ProfileRepository>()),
    );
    gh.factory<_i477.UpdateProfileUseCase>(
      () => _i477.UpdateProfileUseCase(gh<_i1006.ProfileRepository>()),
    );
    gh.factory<_i31.ProductDetailsCubit>(
      () => _i31.ProductDetailsCubit(
        productDetailsUseCase: gh<_i875.ProductDetailsUseCase>(),
        addCartItemUseCase: gh<_i448.AddCartItemUseCase>(),
        languageService: gh<_i819.LanguageService>(),
      ),
    );
    gh.factory<_i341.CartViewModel>(
      () => _i341.CartViewModel(
        gh<_i1065.GetCartVendorsUseCase>(),
        gh<_i925.GetCartUseCase>(),
        gh<_i327.ClearCartUseCase>(),
        gh<_i483.RemoveCartItemUseCase>(),
        gh<_i8.UpdateCartItemQuantityUseCase>(),
      ),
    );
    gh.factory<_i683.NotificationsViewModel>(
      () => _i683.NotificationsViewModel(
        gh<_i519.GetNotificationsUseCase>(),
        gh<_i850.GetNotificationUnreadCountUseCase>(),
        gh<_i138.MarkNotificationAsReadUseCase>(),
        gh<_i690.MarkAllNotificationsAsReadUseCase>(),
        gh<_i1040.WatchRealtimeNotificationsUseCase>(),
        gh<_i481.DeleteNotificationUseCase>(),
        gh<_i751.DeleteAllNotificationsUseCase>(),
        gh<_i80.GetNotificationPreferencesUseCase>(),
        gh<_i958.UpdateNotificationPreferencesUseCase>(),
      ),
    );
    gh.factory<_i398.MyOrdersViewModel>(
      () => _i398.MyOrdersViewModel(
        gh<_i149.GetActiveOrdersUseCase>(),
        gh<_i166.GetCompletedOrdersUseCase>(),
        gh<_i816.GetReturnedOrdersUseCase>(),
      ),
    );
    gh.factoryParam<_i110.SpecialOffersProductsCubit, String, dynamic>(
      (title, _) => _i110.SpecialOffersProductsCubit(
        gh<_i342.GetHomeSpecialOffersUseCase>(),
        title,
      ),
    );
    gh.factory<_i882.ResendDeliveryOtpUseCase>(
      () =>
          _i882.ResendDeliveryOtpUseCase(gh<_i891.DeliveryVerificationRepo>()),
    );
    gh.factory<_i475.SendDeliveryOtpUseCase>(
      () => _i475.SendDeliveryOtpUseCase(gh<_i891.DeliveryVerificationRepo>()),
    );
    gh.factory<_i8.VerifyDeliveryOtpUseCase>(
      () => _i8.VerifyDeliveryOtpUseCase(gh<_i891.DeliveryVerificationRepo>()),
    );
    gh.lazySingleton<_i823.NotificationDeviceService>(
      () => _i823.NotificationDeviceService(
        gh<_i460.SharedPreferences>(),
        gh<_i227.TokenService>(),
        gh<_i92.PushTokenService>(),
        gh<_i148.DeviceIdService>(),
        gh<_i819.LanguageService>(),
        gh<_i296.RegisterNotificationDeviceUseCase>(),
        gh<_i439.UpdateNotificationDevicePreferencesUseCase>(),
        gh<_i1029.UnregisterNotificationDeviceUseCase>(),
      ),
    );
    gh.factory<_i558.LoginRepository>(
      () => _i94.LoginRepositoryImpl(
        gh<_i952.LoginRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i823.NotificationDeviceService>(),
      ),
    );
    gh.factory<_i720.CustomerAddressesViewModel>(
      () => _i720.CustomerAddressesViewModel(
        gh<_i525.GetCustomerAddressesUseCase>(),
        gh<_i557.DeleteCustomerAddressUseCase>(),
        gh<_i175.SetCustomerAddressAsDefaultUseCase>(),
        gh<_i563.UpdateCustomerAddressUseCase>(),
      ),
    );
    gh.factory<_i341.TrackOrderViewModel>(
      () => _i341.TrackOrderViewModel(gh<_i633.GetOrderTrackingUseCase>()),
    );
    gh.factory<_i491.ResetPasswordRepository>(
      () => _i670.ResetPasswordRepositoryImpl(
        gh<_i122.ResetPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i343.LocationViewModel>(
      () => _i343.LocationViewModel(
        gh<_i903.SearchLocationsUseCase>(),
        gh<_i117.GetCurrentLocationWithAddressUseCase>(),
        gh<_i1061.GetAddressFromCoordinatesUseCase>(),
        gh<_i95.AddCustomerAddressUseCase>(),
        gh<_i766.ProfileUseCase>(),
        gh<_i227.TokenService>(),
      ),
    );
    gh.factory<_i504.GetBrandFiltersUseCase>(
      () => _i504.GetBrandFiltersUseCase(gh<_i2.BrandRepository>()),
    );
    gh.factory<_i296.GetBrandProductsUseCase>(
      () => _i296.GetBrandProductsUseCase(gh<_i2.BrandRepository>()),
    );
    gh.factoryParam<_i122.RecommendedProductsCubit, String, dynamic>(
      (title, _) => _i122.RecommendedProductsCubit(
        gh<_i394.GetHomeRecommendedUseCase>(),
        title,
      ),
    );
    gh.factory<_i701.ProfileViewModel>(
      () => _i701.ProfileViewModel(
        gh<_i766.ProfileUseCase>(),
        gh<_i477.UpdateProfileUseCase>(),
        gh<_i698.UpdateProfilePhotoUseCase>(),
        gh<_i601.DeleteProfilePhotoUseCase>(),
      ),
    );
    gh.factory<_i495.HomeViewModel>(
      () => _i495.HomeViewModel(
        gh<_i699.GetHomeAppBarUseCase>(),
        gh<_i1034.GetHomeBannersUseCase>(),
        gh<_i1020.GetHomeCategoriesUseCase>(),
        gh<_i652.GetHomeBestSellingUseCase>(),
        gh<_i446.GetHomeBrandsUseCase>(),
        gh<_i394.GetHomeRecommendedUseCase>(),
        gh<_i327.GetHomeFeaturedProductsUseCase>(),
        gh<_i342.GetHomeSpecialOffersUseCase>(),
        gh<_i840.GetHomeDynamicSectionsUseCase>(),
      ),
    );
    gh.factory<_i492.ApplyCheckoutPromoCodeUseCase>(
      () => _i492.ApplyCheckoutPromoCodeUseCase(gh<_i420.PaymentRepository>()),
    );
    gh.factory<_i450.ConfirmMoyasarPaymentUseCase>(
      () => _i450.ConfirmMoyasarPaymentUseCase(gh<_i420.PaymentRepository>()),
    );
    gh.factory<_i867.GetCheckoutSummaryUseCase>(
      () => _i867.GetCheckoutSummaryUseCase(gh<_i420.PaymentRepository>()),
    );
    gh.factory<_i859.PlaceOrderUseCase>(
      () => _i859.PlaceOrderUseCase(gh<_i420.PaymentRepository>()),
    );
    gh.factory<_i1066.RemoveCheckoutPromoCodeUseCase>(
      () =>
          _i1066.RemoveCheckoutPromoCodeUseCase(gh<_i420.PaymentRepository>()),
    );
    gh.factory<_i17.GetCategoriesUseCase>(
      () => _i17.GetCategoriesUseCase(gh<_i131.CategoryRepository>()),
    );
    gh.factory<_i91.GetCategoryFiltersUseCase>(
      () => _i91.GetCategoryFiltersUseCase(gh<_i131.CategoryRepository>()),
    );
    gh.factory<_i127.GetCategoryProductsUseCase>(
      () => _i127.GetCategoryProductsUseCase(gh<_i131.CategoryRepository>()),
    );
    gh.factory<_i737.GetCategorySubcategoriesUseCase>(
      () =>
          _i737.GetCategorySubcategoriesUseCase(gh<_i131.CategoryRepository>()),
    );
    gh.factory<_i45.GetShoppingProductsUseCase>(
      () => _i45.GetShoppingProductsUseCase(gh<_i131.CategoryRepository>()),
    );
    gh.lazySingleton<_i140.FavoritesRepository>(
      () => _i140.FavoritesRepository(gh<_i480.FavoritesRemoteDataSource>()),
    );
    gh.factoryParam<_i908.BestSellingProductsCubit, String, dynamic>(
      (title, _) => _i908.BestSellingProductsCubit(
        gh<_i652.GetHomeBestSellingUseCase>(),
        title,
      ),
    );
    gh.factory<_i399.RegisterRepository>(
      () => _i466.RegisterRepositoryImpl(gh<_i334.RegisterRemoteDataSource>()),
    );
    gh.factory<_i934.ForgetPasswordViewModel>(
      () => _i934.ForgetPasswordViewModel(gh<_i732.ForgetPasswordUseCase>()),
    );
    gh.factory<_i248.LoginUseCase>(
      () => _i248.LoginUseCase(gh<_i558.LoginRepository>()),
    );
    gh.factory<_i166.RegisterUseCase>(
      () => _i166.RegisterUseCase(repository: gh<_i399.RegisterRepository>()),
    );
    gh.factory<_i393.OrderDetailsViewModel>(
      () => _i393.OrderDetailsViewModel(
        gh<_i372.GetOrderDetailsUseCase>(),
        gh<_i40.GetOrderCancellationReasonsUseCase>(),
        gh<_i365.GetOrderSupportReasonsUseCase>(),
        gh<_i890.CancelOrderUseCase>(),
        gh<_i842.RetryOrderPaymentUseCase>(),
        gh<_i631.DeleteOrderUseCase>(),
      ),
    );
    gh.lazySingleton<_i1050.RealtimeNotificationOverlayService>(
      () => _i1050.RealtimeNotificationOverlayService(
        gh<_i1040.WatchRealtimeNotificationsUseCase>(),
        gh<_i823.NotificationDeviceService>(),
        gh<_i762.LocalNotificationService>(),
        gh<_i179.AppNavigatorService>(),
      ),
    );
    gh.factoryParam<_i1008.BrandDetailsCubit, _i1044.BrandModel, dynamic>(
      (_brand, _) => _i1008.BrandDetailsCubit(
        gh<_i504.GetBrandFiltersUseCase>(),
        gh<_i296.GetBrandProductsUseCase>(),
        _brand,
      ),
    );
    gh.factory<_i796.DeliveryOtpViewModel>(
      () => _i796.DeliveryOtpViewModel(
        gh<_i475.SendDeliveryOtpUseCase>(),
        gh<_i8.VerifyDeliveryOtpUseCase>(),
        gh<_i882.ResendDeliveryOtpUseCase>(),
      ),
    );
    gh.factory<_i954.ClearFavoritesUseCase>(
      () => _i954.ClearFavoritesUseCase(gh<_i140.FavoritesRepository>()),
    );
    gh.factory<_i253.GetFavoritesUseCase>(
      () => _i253.GetFavoritesUseCase(gh<_i140.FavoritesRepository>()),
    );
    gh.factory<_i314.RemoveFavoriteUseCase>(
      () => _i314.RemoveFavoriteUseCase(gh<_i140.FavoritesRepository>()),
    );
    gh.factory<_i566.PaymentViewModel>(
      () => _i566.PaymentViewModel(
        gh<_i867.GetCheckoutSummaryUseCase>(),
        gh<_i492.ApplyCheckoutPromoCodeUseCase>(),
        gh<_i1066.RemoveCheckoutPromoCodeUseCase>(),
        gh<_i859.PlaceOrderUseCase>(),
        gh<_i525.GetCustomerAddressesUseCase>(),
      ),
    );
    gh.factory<_i228.CategoryViewModel>(
      () => _i228.CategoryViewModel(
        getCategoriesUseCase: gh<_i17.GetCategoriesUseCase>(),
        getCategoryFiltersUseCase: gh<_i91.GetCategoryFiltersUseCase>(),
        getCategorySubcategoriesUseCase:
            gh<_i737.GetCategorySubcategoriesUseCase>(),
        getCategoryProductsUseCase: gh<_i127.GetCategoryProductsUseCase>(),
        getShoppingProductsUseCase: gh<_i45.GetShoppingProductsUseCase>(),
        navigationService: gh<_i900.CategoryNavigationService>(),
      ),
    );
    gh.factory<_i996.ResetPasswordUseCase>(
      () => _i996.ResetPasswordUseCase(
        repository: gh<_i491.ResetPasswordRepository>(),
      ),
    );
    gh.factory<_i23.VerifyResetOtpUseCase>(
      () => _i23.VerifyResetOtpUseCase(
        repository: gh<_i491.ResetPasswordRepository>(),
      ),
    );
    gh.factory<_i955.LoginViewModel>(
      () => _i955.LoginViewModel(gh<_i248.LoginUseCase>()),
    );
    gh.factory<_i415.VerifyOtpRepository>(
      () => _i548.VerifyOtpRepositoryImpl(
        gh<_i698.VerifyOtpRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i823.NotificationDeviceService>(),
      ),
    );
    gh.factory<_i305.AllCategoriesViewModel>(
      () => _i305.AllCategoriesViewModel(gh<_i17.GetCategoriesUseCase>()),
    );
    gh.factory<_i190.FavoritesViewModel>(
      () => _i190.FavoritesViewModel(
        gh<_i253.GetFavoritesUseCase>(),
        gh<_i314.RemoveFavoriteUseCase>(),
        gh<_i954.ClearFavoritesUseCase>(),
      ),
    );
    gh.factory<_i330.RegisterViewModel>(
      () => _i330.RegisterViewModel(gh<_i166.RegisterUseCase>()),
    );
    gh.factory<_i62.ResendOtpUseCase>(
      () => _i62.ResendOtpUseCase(gh<_i415.VerifyOtpRepository>()),
    );
    gh.factory<_i851.VerifyOtpUseCase>(
      () => _i851.VerifyOtpUseCase(gh<_i415.VerifyOtpRepository>()),
    );
    gh.factory<_i910.ResetPasswordViewModel>(
      () => _i910.ResetPasswordViewModel(gh<_i996.ResetPasswordUseCase>()),
    );
    gh.factory<_i162.AppSectionGlobalCubit>(
      () => _i162.AppSectionGlobalCubit(
        homeViewModel: gh<_i495.HomeViewModel>(),
        cartViewModel: gh<_i341.CartViewModel>(),
        favoritesViewModel: gh<_i190.FavoritesViewModel>(),
        profileViewModel: gh<_i701.ProfileViewModel>(),
        categoryViewModel: gh<_i228.CategoryViewModel>(),
        tokenService: gh<_i227.TokenService>(),
        favoritesRepository: gh<_i140.FavoritesRepository>(),
        cartRepository: gh<_i435.CartRepository>(),
        productDetailsUseCase: gh<_i875.ProductDetailsUseCase>(),
        addCartItemUseCase: gh<_i448.AddCartItemUseCase>(),
      ),
    );
    gh.factory<_i718.VerifyOtpViewModel>(
      () => _i718.VerifyOtpViewModel(
        gh<_i851.VerifyOtpUseCase>(),
        gh<_i62.ResendOtpUseCase>(),
      ),
    );
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
