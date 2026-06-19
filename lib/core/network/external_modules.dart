import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_user_v3/core/services/captcha_service.dart';
import 'package:zadana_user_v3/core/services/device_id_interceptor.dart';
import 'package:zadana_user_v3/core/services/guest_cart_signature_interceptor.dart';
import 'package:zadana_user_v3/core/services/language_interceptor.dart';
import 'package:zadana_user_v3/core/services/retry_interceptor.dart';

import '../services/token_interceptor.dart';
import 'network_constants.dart';

@module
abstract class ExternalModules {
  @preResolve
  Future<CacheStore> get provideCacheStore async {
    return MemCacheStore(maxSize: 50 * 1024 * 1024, maxEntrySize: 2 * 1024 * 1024);
  }

  @lazySingleton
  Dio provideDio(
    PrettyDioLogger prettyDioLogger,
    TokenInterceptor tokenInterceptor,
    DeviceIdInterceptor deviceIdInterceptor,
    LanguageInterceptor languageInterceptor,
    GuestCartSignatureInterceptor guestCartSignatureInterceptor,
    CaptchaInterceptor captchaInterceptor,
    RetryInterceptor retryInterceptor,
    CacheStore cacheStore,
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
    dio.interceptors.add(captchaInterceptor);
    dio.interceptors.add(tokenInterceptor);
    dio.interceptors.add(deviceIdInterceptor);
    dio.interceptors.add(guestCartSignatureInterceptor);
    dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: cacheStore,
          policy: CachePolicy.request,
          maxStale: const Duration(minutes: 5),
          hitCacheOnErrorExcept: [401, 403],
        ),
      ),
    );
    dio.interceptors.add(retryInterceptor);
    dio.interceptors.add(prettyDioLogger);

    // Temporary: log the real error behind DioExceptionType.unknown
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.type == DioExceptionType.unknown) {
            // ignore: avoid_print
            print('⚠️ DIO UNKNOWN ERROR ⚠️');
            print('URL: ${error.requestOptions.uri}');
            print('Inner error: ${error.error}');
            print('Inner error type: ${error.error.runtimeType}');
            print('Stack: ${error.stackTrace}');
          }
          handler.next(error);
        },
      ),
    );

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
