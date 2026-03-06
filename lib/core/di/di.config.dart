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
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

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
import '../../feature/auth/register/presentation/manager/register_view_mode.dart'
    as _i5;
import '../helpers/shared_pref.dart' as _i42;
import '../network/api_services.dart' as _i804;
import '../network/external_modules.dart' as _i576;
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
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModules.provideSharedPreferences,
      preResolve: true,
    );
    gh.factory<_i1056.TokenInterceptor>(() => _i1056.TokenInterceptor());
    gh.lazySingleton<_i361.Dio>(() => externalModules.provideDio());
    gh.lazySingleton<_i528.PrettyDioLogger>(
      () => externalModules.providePrettyDioLogger(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModules.flutterSecureStorage(),
    );
    gh.lazySingleton<_i973.InternetConnectionChecker>(
      () => externalModules.provideInternetConnectionChecker(),
    );
    gh.factory<_i42.SharedPrefHelper>(
      () => _i42.SharedPrefHelper(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i804.ApiServices>(() => _i804.ApiServices(gh<_i361.Dio>()));
    gh.factory<_i227.TokenService>(
      () => _i227.TokenService(
        prefs: gh<_i558.FlutterSecureStorage>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i334.RegisterRemoteDataSource>(
      () => _i168.RegisterRemoteDataSourceImpl(
        apiServices: gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i399.RegisterRepository>(
      () => _i466.RegisterRepositoryImpl(
        remoteDataSource: gh<_i334.RegisterRemoteDataSource>(),
      ),
    );
    gh.factory<_i166.RegisterUseCase>(
      () => _i166.RegisterUseCase(repository: gh<_i399.RegisterRepository>()),
    );
    gh.factory<_i5.RegisterViewMode>(
      () => _i5.RegisterViewMode(gh<_i166.RegisterUseCase>()),
    );
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
