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
import '../../feature/auth/verify_otp/domain/usecase/verify_otp_usecase.dart'
    as _i851;
import '../../feature/auth/verify_otp/presentation/manager/verify_otp_view_model.dart'
    as _i718;
import '../../feature/best_selling/presentation/manager/best_selling_products_cubit.dart'
    as _i908;
import '../../feature/brands_listing/presentation/manager/brands_listing_cubit.dart'
    as _i7;
import '../../feature/cart/data/data_source/cart_remote_data_source.dart'
    as _i1034;
import '../../feature/cart/data/data_source/cart_remote_data_source_impl.dart'
    as _i640;
import '../../feature/cart/data/repo/cart_repository_impl.dart' as _i132;
import '../../feature/cart/data/services/guest_cart_sync_service.dart' as _i219;
import '../../feature/cart/domain/repo/cart_repository.dart' as _i435;
import '../../feature/cart/domain/usecase/add_cart_item_usecase.dart' as _i448;
import '../../feature/cart/domain/usecase/clear_cart_usecase.dart' as _i327;
import '../../feature/cart/domain/usecase/get_cart_usecase.dart' as _i925;
import '../../feature/cart/domain/usecase/get_cart_vendors_usecase.dart'
    as _i1065;
import '../../feature/cart/domain/usecase/remove_cart_item_usecase.dart'
    as _i483;
import '../../feature/cart/domain/usecase/update_cart_item_quantity_usecase.dart'
    as _i8;
import '../../feature/cart/presentation/manager/cart_view_model.dart' as _i341;
import '../../feature/favorites/data/services/guest_favorites_sync_service.dart'
    as _i1114;
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
import '../../feature/profile/data/data_source/profile_remote_data_source.dart'
    as _i371;
import '../../feature/profile/data/data_source/profile_remote_data_source_impl.dart'
    as _i544;
import '../../feature/profile/data/repo/profile_repository_impl.dart' as _i771;
import '../../feature/profile/domain/repo/profile_repository.dart' as _i1006;
import '../../feature/profile/domain/usecase/profile_usecase.dart' as _i766;
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
import '../general_cubit/local_cubit.dart' as _i794;
import '../helpers/permision_service.dart' as _i367;
import '../helpers/shared_pref.dart' as _i42;
import '../network/api_services.dart' as _i804;
import '../network/external_modules.dart' as _i576;
import '../network/osm_api_services.dart' as _i777;
import '../services/device_id_interceptor.dart' as _i930;
import '../services/device_id_service.dart' as _i148;
import '../services/language_interceptor.dart' as _i32;
import '../services/language_service.dart' as _i819;
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
    gh.factory<_i1056.TokenInterceptor>(() => _i1056.TokenInterceptor());
    gh.lazySingleton<_i528.PrettyDioLogger>(
      () => externalModules.providePrettyDioLogger(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModules.flutterSecureStorage(),
    );
    gh.factory<_i42.SharedPrefHelper>(
      () => _i42.SharedPrefHelper(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideOsmDio(gh<_i528.PrettyDioLogger>()),
      instanceName: 'osmDio',
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
    gh.factory<_i408.LocationDataSource>(
      () => _i1072.LocationDataSourceImpl(
        gh<_i777.OsmApiServices>(),
        gh<_i367.LocationPermissionService>(),
      ),
    );
    gh.factory<_i930.DeviceIdInterceptor>(
      () => _i930.DeviceIdInterceptor(
        gh<_i227.TokenService>(),
        gh<_i148.DeviceIdService>(),
      ),
    );
    gh.lazySingleton<_i794.LocaleThemeCubit>(
      () => _i794.LocaleThemeCubit(gh<_i819.LanguageService>()),
    );
    gh.factory<_i32.LanguageInterceptor>(
      () => _i32.LanguageInterceptor(gh<_i819.LanguageService>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideDio(
        gh<_i528.PrettyDioLogger>(),
        gh<_i1056.TokenInterceptor>(),
        gh<_i930.DeviceIdInterceptor>(),
        gh<_i32.LanguageInterceptor>(),
        gh<_i695.CacheStore>(),
      ),
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
    gh.factory<_i804.ApiServices>(() => _i804.ApiServices(gh<_i361.Dio>()));
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
    gh.factory<_i698.VerifyOtpRemoteDataSource>(
      () => _i285.VerifyOtpRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i952.LoginRemoteDataSource>(
      () => _i912.LoginRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i304.ProductDetailsRemoteDataSource>(
      () => _i704.ProductDetailsRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i730.HomeRemoteDataSource>(
      () => _i1072.HomeRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i371.ProfileRemoteDataSource>(
      () => _i544.ProfileRemoteDataSourceImpl(gh<_i804.ApiServices>()),
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
    gh.factory<_i881.ForgetPasswordRepository>(
      () => _i384.ForgetPasswordRepositoryImpl(
        gh<_i596.ForgetPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i1069.ProductSearchRemoteDataSource>(
      () => _i324.ProductSearchRemoteDataSourceImpl(gh<_i804.ApiServices>()),
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
    gh.factory<_i1034.CartRemoteDataSource>(
      () => _i640.CartRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
        gh<_i361.Dio>(),
        gh<_i227.TokenService>(),
        gh<_i148.DeviceIdService>(),
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
    gh.factory<_i426.LogoutUseCase>(
      () => _i426.LogoutUseCase(repository: gh<_i31.LogoutRepository>()),
    );
    gh.factory<_i227.HomeRepository>(
      () => _i311.HomeRepositoryImpl(gh<_i730.HomeRemoteDataSource>()),
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
    gh.factory<_i875.ProductDetailsUseCase>(
      () => _i875.ProductDetailsUseCase(gh<_i888.ProductDetailsRepository>()),
    );
    gh.factory<_i891.DeliveryVerificationRepo>(
      () => _i1023.DeliveryVerificationRepoImpl(
        gh<_i691.DeliveryVerificationRemoteDataSource>(),
      ),
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
    gh.factoryParam<_i7.BrandsListingCubit, String, dynamic>(
      (title, _) =>
          _i7.BrandsListingCubit(gh<_i446.GetHomeBrandsUseCase>(), title),
    );
    gh.factory<_i732.ForgetPasswordUseCase>(
      () => _i732.ForgetPasswordUseCase(
        repository: gh<_i881.ForgetPasswordRepository>(),
      ),
    );
    gh.factory<_i766.ProfileUseCase>(
      () => _i766.ProfileUseCase(gh<_i1006.ProfileRepository>()),
    );
    gh.factory<_i477.UpdateProfileUseCase>(
      () => _i477.UpdateProfileUseCase(gh<_i1006.ProfileRepository>()),
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
    gh.factory<_i720.CustomerAddressesViewModel>(
      () => _i720.CustomerAddressesViewModel(
        gh<_i525.GetCustomerAddressesUseCase>(),
        gh<_i557.DeleteCustomerAddressUseCase>(),
        gh<_i175.SetCustomerAddressAsDefaultUseCase>(),
        gh<_i563.UpdateCustomerAddressUseCase>(),
      ),
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
    gh.factory<_i435.CartRepository>(
      () => _i132.CartRepositoryImpl(gh<_i1034.CartRemoteDataSource>()),
    );
    gh.factoryParam<_i122.RecommendedProductsCubit, String, dynamic>(
      (title, _) => _i122.RecommendedProductsCubit(
        gh<_i394.GetHomeRecommendedUseCase>(),
        title,
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
    gh.factory<_i448.AddCartItemUseCase>(
      () => _i448.AddCartItemUseCase(gh<_i435.CartRepository>()),
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
    gh.factory<_i166.RegisterUseCase>(
      () => _i166.RegisterUseCase(repository: gh<_i399.RegisterRepository>()),
    );
    gh.lazySingleton<_i219.GuestCartSyncService>(
      () => _i219.GuestCartSyncService(
        gh<_i460.SharedPreferences>(),
        gh<_i227.TokenService>(),
        gh<_i448.AddCartItemUseCase>(),
      ),
    );
    gh.lazySingleton<_i1114.GuestFavoritesSyncService>(
      () => _i1114.GuestFavoritesSyncService(),
    );
    gh.factory<_i796.DeliveryOtpViewModel>(
      () => _i796.DeliveryOtpViewModel(
        gh<_i475.SendDeliveryOtpUseCase>(),
        gh<_i8.VerifyDeliveryOtpUseCase>(),
        gh<_i882.ResendDeliveryOtpUseCase>(),
      ),
    );
    gh.factory<_i701.ProfileViewModel>(
      () => _i701.ProfileViewModel(
        gh<_i766.ProfileUseCase>(),
        gh<_i477.UpdateProfileUseCase>(),
      ),
    );
    gh.factory<_i996.ResetPasswordUseCase>(
      () => _i996.ResetPasswordUseCase(
        repository: gh<_i491.ResetPasswordRepository>(),
      ),
    );
    gh.factory<_i415.VerifyOtpRepository>(
      () => _i548.VerifyOtpRepositoryImpl(
        gh<_i698.VerifyOtpRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i219.GuestCartSyncService>(),
        gh<_i1114.GuestFavoritesSyncService>(),
      ),
    );
    gh.factory<_i558.LoginRepository>(
      () => _i94.LoginRepositoryImpl(
        gh<_i952.LoginRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i219.GuestCartSyncService>(),
        gh<_i1114.GuestFavoritesSyncService>(),
      ),
    );
    gh.factory<_i248.LoginUseCase>(
      () => _i248.LoginUseCase(gh<_i558.LoginRepository>()),
    );
    gh.factory<_i330.RegisterViewModel>(
      () => _i330.RegisterViewModel(gh<_i166.RegisterUseCase>()),
    );
    gh.factory<_i851.VerifyOtpUseCase>(
      () => _i851.VerifyOtpUseCase(gh<_i415.VerifyOtpRepository>()),
    );
    gh.factory<_i341.CartViewModel>(
      () => _i341.CartViewModel(
        gh<_i1065.GetCartVendorsUseCase>(),
        gh<_i925.GetCartUseCase>(),
        gh<_i327.ClearCartUseCase>(),
        gh<_i483.RemoveCartItemUseCase>(),
        gh<_i8.UpdateCartItemQuantityUseCase>(),
        gh<_i219.GuestCartSyncService>(),
      ),
    );
    gh.factory<_i910.ResetPasswordViewModel>(
      () => _i910.ResetPasswordViewModel(gh<_i996.ResetPasswordUseCase>()),
    );
    gh.factory<_i955.LoginViewModel>(
      () => _i955.LoginViewModel(gh<_i248.LoginUseCase>()),
    );
    gh.factory<_i718.VerifyOtpViewModel>(
      () => _i718.VerifyOtpViewModel(gh<_i851.VerifyOtpUseCase>()),
    );
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
