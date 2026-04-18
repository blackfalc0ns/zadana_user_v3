import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_user_v3/core/services/device_id_interceptor.dart';
import 'package:zadana_user_v3/core/services/language_interceptor.dart';

import '../services/token_interceptor.dart';
import 'network_constants.dart';
import 'no_op_cache_store.dart';

@module
abstract class ExternalModules {
  @preResolve
  Future<CacheStore> get provideCacheStore async {
    return NoOpCacheStore();
  }

  @lazySingleton
  Dio provideDio(
    PrettyDioLogger prettyDioLogger,
    TokenInterceptor tokenInterceptor,
    DeviceIdInterceptor deviceIdInterceptor,
    LanguageInterceptor languageInterceptor,
    CacheStore _,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(languageInterceptor);
    dio.interceptors.add(tokenInterceptor);
    dio.interceptors.add(deviceIdInterceptor);
    dio.interceptors.add(prettyDioLogger);

    return dio;
  }

  @Named('osmDio')
  @lazySingleton
  Dio provideOsmDio(PrettyDioLogger prettyDioLogger) {
    final dio = Dio();

    dio.options.baseUrl = 'https://nominatim.openstreetmap.org';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'zadana-user-app',
    };

    dio.interceptors.add(prettyDioLogger);

    return dio;
  }

  @lazySingleton
  PrettyDioLogger providePrettyDioLogger() {
    return PrettyDioLogger(requestHeader: true, requestBody: true);
  }

  @preResolve
  Future<SharedPreferences> get provideSharedPreferences async {
    return SharedPreferences.getInstance();
  }

  @lazySingleton
  FlutterSecureStorage flutterSecureStorage() {
    return const FlutterSecureStorage();
  }
}
