import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import '../di/di.dart';
import '../network/network_constants.dart';

@injectable
class TokenInterceptor extends Interceptor {
  static const String skipAuthKey = 'skipAuth';

  final TokenService tokenService = getIt.get<TokenService>();
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuthKey] == true) {
      options.headers.remove(NetworkConstants.authorization);
      handler.next(options);
      return;
    }

    final String? token = await tokenService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers[NetworkConstants.authorization] =
          "${NetworkConstants.bearer} $token";
          print(' token to request: $token');
    }
    handler.next(options);
  }
}
