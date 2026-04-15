import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/auth/login/data/mapper/mapper_login.dart';
import 'package:zadana_user_v3/feature/cart/data/services/guest_cart_sync_service.dart';
import 'package:zadana_user_v3/feature/favorites/data/services/guest_favorites_sync_service.dart';
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
    this._guestCartSyncService,
    this._guestFavoritesSyncService,
  );

  final LoginRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;
  final GuestCartSyncService _guestCartSyncService;
  final GuestFavoritesSyncService _guestFavoritesSyncService;

  @override
  Future<ApiResult<LoginResponseEntity>> login(
    LoginRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final dto = request.toDto();
      final result = await _remoteDataSource.login(dto);
      await _tokenService.saveAccessToken(result.tokens.accessToken);
      await _tokenService.saveRefreshToken(result.tokens.refreshToken);
      await _guestCartSyncService.syncPendingItemsIfAuthenticated();
      await _guestFavoritesSyncService.syncPendingFavoritesIfAuthenticated();

      return result.toEntity();
    });
  }
}
