import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/notification_device_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/auth/data/helpers/post_auth_side_effects.dart';
import 'package:zadana_user_v3/feature/auth/login/data/mapper/mapper_login.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/repo/login_repository.dart';
import '../data_source/login_remote_data_source.dart';

/// Login repository implementation
/// Data layer - Repository implementation
@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  const LoginRepositoryImpl(
    this._remoteDataSource,
    this._tokenService,
    this._notificationDeviceService,
  );

  final LoginRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;
  final NotificationDeviceService _notificationDeviceService;
  CartRepository get _cartRepository => GetIt.instance<CartRepository>();
  FavoritesRepository get _favoritesRepository =>
      GetIt.instance<FavoritesRepository>();
  NotificationsSignalRService get _notificationsSignalRService =>
      GetIt.instance<NotificationsSignalRService>();

  @override
  Future<ApiResult<LoginResponseEntity>> login(
    LoginRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final dto = request.toDto();
      final result = await _remoteDataSource.login(dto);
      await _tokenService.saveAccessToken(result.tokens.accessToken);
      await _tokenService.saveRefreshToken(result.tokens.refreshToken);
      await _tokenService.saveCurrentUserId(result.user.id);
      runPostAuthSideEffects(
        logName: 'LoginRepositoryImpl',
        cartRepository: _cartRepository,
        favoritesRepository: _favoritesRepository,
        notificationsSignalRService: _notificationsSignalRService,
        notificationDeviceService: _notificationDeviceService,
        customerId: result.user.id,
      );

      return result.toEntity();
    });
  }
}
