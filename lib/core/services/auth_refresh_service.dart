import 'package:dio/dio.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';

class AuthRefreshService {
  AuthRefreshService({
    Dio? dio,
    TokenService? tokenService,
    LanguageService? languageService,
    DeviceIdService? deviceIdService,
  }) : _dio = dio ?? Dio(),
       _tokenService = tokenService ?? getIt<TokenService>(),
       _languageService = languageService ?? getIt<LanguageService>(),
       _deviceIdService = deviceIdService ?? getIt<DeviceIdService>();

  final Dio _dio;
  final TokenService _tokenService;
  final LanguageService _languageService;
  final DeviceIdService _deviceIdService;

  static const List<String> _refreshEndpoints = <String>[
    '/customers/auth/refresh-token',
    '/customers/auth/refresh',
  ];

  Future<String?> refreshAccessToken() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final deviceId = await _deviceIdService.getOrCreateDeviceId();
    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': _languageService.getLanguageCode(),
      NetworkConstants.deviceIdHeader: deviceId,
    };

    DioException? lastError;
    for (final endpoint in _refreshEndpoints) {
      try {
        final response = await _dio.post<Map<String, dynamic>>(
          '${NetworkConstants.baseUrl}$endpoint',
          data: {'refreshToken': refreshToken},
          options: Options(headers: headers),
        );

        final tokens = _parseTokens(
          response.data,
          fallbackRefreshToken: refreshToken,
        );
        final accessToken = tokens.$1;
        final nextRefreshToken = tokens.$2;

        if (accessToken == null || accessToken.isEmpty) {
          continue;
        }

        await _tokenService.saveAccessToken(accessToken);
        if (nextRefreshToken != null && nextRefreshToken.isNotEmpty) {
          await _tokenService.saveRefreshToken(nextRefreshToken);
        }
        return accessToken;
      } on DioException catch (error) {
        lastError = error;
        final statusCode = error.response?.statusCode;
        if (statusCode != 404 && statusCode != 405) {
          break;
        }
      }
    }

    if (lastError != null) {
      throw lastError;
    }

    return null;
  }

  (String?, String?) _parseTokens(
    Map<String, dynamic>? data, {
    required String fallbackRefreshToken,
  }) {
    if (data == null) {
      return (null, fallbackRefreshToken);
    }

    final dynamic nestedTokens = data['tokens'];
    if (nestedTokens is Map<String, dynamic>) {
      return (
        nestedTokens['accessToken'] as String?,
        nestedTokens['refreshToken'] as String? ?? fallbackRefreshToken,
      );
    }

    return (
      data['accessToken'] as String?,
      data['refreshToken'] as String? ?? fallbackRefreshToken,
    );
  }
}
