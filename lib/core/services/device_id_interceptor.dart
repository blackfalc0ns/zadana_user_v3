import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';

@injectable
class DeviceIdInterceptor extends Interceptor {
  DeviceIdInterceptor(this._tokenService, this._deviceIdService);
  static const String forceDeviceIdKey = 'forceDeviceId';

  final TokenService _tokenService;
  final DeviceIdService _deviceIdService;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final shouldForceDeviceId = options.extra[forceDeviceIdKey] == true;
    final token = await _tokenService.getToken();
    if (shouldForceDeviceId || token == null || token.isEmpty) {
      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      options.headers[NetworkConstants.deviceIdHeader] = deviceId;
    } else {
      options.headers.remove(NetworkConstants.deviceIdHeader);
    }

    handler.next(options);
  }
}
