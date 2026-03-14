// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

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
import '../../feature/profile/data/data_source/profile_remote_data_source.dart'
    as _i371;
import '../../feature/profile/data/data_source/profile_remote_data_source_impl.dart'
    as _i544;
import '../../feature/profile/data/repo/profile_repository_impl.dart' as _i771;
import '../../feature/profile/domain/repo/profile_repository.dart' as _i1006;
import '../../feature/profile/domain/usecase/profile_usecase.dart' as _i766;
import '../../feature/profile/presentation/manager/profile_view_model.dart'
    as _i701;
import '../helpers/permision_service.dart' as _i367;
import '../helpers/shared_pref.dart' as _i42;
import '../network/api_services.dart' as _i804;
import '../network/external_modules.dart' as _i576;
import '../network/osm_api_services.dart' as _i777;
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
    gh.factory<_i408.LocationDataSource>(
      () => _i1072.LocationDataSourceImpl(
        gh<_i777.OsmApiServices>(),
        gh<_i367.LocationPermissionService>(),
      ),
    );
    gh.factory<_i32.LanguageInterceptor>(
      () => _i32.LanguageInterceptor(gh<_i819.LanguageService>()),
    );
    gh.factory<_i912.LocationRepository>(
      () => _i232.LocationRepositoryImpl(gh<_i408.LocationDataSource>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideDio(
        gh<_i528.PrettyDioLogger>(),
        gh<_i1056.TokenInterceptor>(),
        gh<_i32.LanguageInterceptor>(),
      ),
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
    gh.factory<_i698.VerifyOtpRemoteDataSource>(
      () => _i285.VerifyOtpRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i952.LoginRemoteDataSource>(
      () => _i912.LoginRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i415.VerifyOtpRepository>(
      () => _i548.VerifyOtpRepositoryImpl(
        gh<_i698.VerifyOtpRemoteDataSource>(),
        gh<_i227.TokenService>(),
      ),
    );
    gh.factory<_i343.LocationViewModel>(
      () => _i343.LocationViewModel(
        gh<_i903.SearchLocationsUseCase>(),
        gh<_i117.GetCurrentLocationWithAddressUseCase>(),
        gh<_i1061.GetAddressFromCoordinatesUseCase>(),
      ),
    );
    gh.factory<_i371.ProfileRemoteDataSource>(
      () => _i544.ProfileRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i881.ForgetPasswordRepository>(
      () => _i384.ForgetPasswordRepositoryImpl(
        gh<_i596.ForgetPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i122.ResetPasswordRemoteDataSource>(
      () => _i992.ResetPasswordRemoteDataSourceImpl(
        apiServices: gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i558.LoginRepository>(
      () => _i94.LoginRepositoryImpl(
        gh<_i952.LoginRemoteDataSource>(),
        gh<_i227.TokenService>(),
      ),
    );
    gh.factory<_i248.LoginUseCase>(
      () => _i248.LoginUseCase(gh<_i558.LoginRepository>()),
    );
    gh.factory<_i334.RegisterRemoteDataSource>(
      () => _i168.RegisterRemoteDataSourceImpl(
        apiServices: gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i851.VerifyOtpUseCase>(
      () => _i851.VerifyOtpUseCase(gh<_i415.VerifyOtpRepository>()),
    );
    gh.factory<_i1006.ProfileRepository>(
      () => _i771.ProfileRepositoryImpl(gh<_i371.ProfileRemoteDataSource>()),
    );
    gh.factory<_i732.ForgetPasswordUseCase>(
      () => _i732.ForgetPasswordUseCase(
        repository: gh<_i881.ForgetPasswordRepository>(),
      ),
    );
    gh.factory<_i766.ProfileUseCase>(
      () => _i766.ProfileUseCase(gh<_i1006.ProfileRepository>()),
    );
    gh.factory<_i955.LoginViewModel>(
      () => _i955.LoginViewModel(gh<_i248.LoginUseCase>()),
    );
    gh.factory<_i491.ResetPasswordRepository>(
      () => _i670.ResetPasswordRepositoryImpl(
        gh<_i122.ResetPasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i399.RegisterRepository>(
      () => _i466.RegisterRepositoryImpl(gh<_i334.RegisterRemoteDataSource>()),
    );
    gh.factory<_i934.ForgetPasswordViewModel>(
      () => _i934.ForgetPasswordViewModel(gh<_i732.ForgetPasswordUseCase>()),
    );
    gh.factory<_i701.ProfileViewModel>(
      () => _i701.ProfileViewModel(gh<_i766.ProfileUseCase>()),
    );
    gh.factory<_i718.VerifyOtpViewModel>(
      () => _i718.VerifyOtpViewModel(gh<_i851.VerifyOtpUseCase>()),
    );
    gh.factory<_i166.RegisterUseCase>(
      () => _i166.RegisterUseCase(repository: gh<_i399.RegisterRepository>()),
    );
    gh.factory<_i996.ResetPasswordUseCase>(
      () => _i996.ResetPasswordUseCase(
        repository: gh<_i491.ResetPasswordRepository>(),
      ),
    );
    gh.factory<_i330.RegisterViewModel>(
      () => _i330.RegisterViewModel(gh<_i166.RegisterUseCase>()),
    );
    gh.factory<_i910.ResetPasswordViewModel>(
      () => _i910.ResetPasswordViewModel(gh<_i996.ResetPasswordUseCase>()),
    );
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
