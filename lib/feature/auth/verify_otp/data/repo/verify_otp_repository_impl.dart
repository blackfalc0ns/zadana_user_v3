import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/notification_device_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/auth/data/helpers/post_auth_side_effects.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/mapper/mapper_verify_otp.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/models/resend_otp_request_model_dto.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import '../../domain/entities/verify_otp_request_entity.dart';
import '../../domain/entities/verify_otp_response_entity.dart';
import '../../domain/repo/verify_otp_repository.dart';
import '../data_source/verify_otp_remote_data_source.dart';

/// Verify OTP repository implementation
/// Data layer - Repository implementation
@Injectable(as: VerifyOtpRepository)
class VerifyOtpRepositoryImpl implements VerifyOtpRepository {
  const VerifyOtpRepositoryImpl(
    this._remoteDataSource,
    this._tokenService,
    this._notificationDeviceService,
  );

  final VerifyOtpRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;
  final NotificationDeviceService _notificationDeviceService;
  CartRepository get _cartRepository => GetIt.instance<CartRepository>();
  FavoritesRepository get _favoritesRepository =>
      GetIt.instance<FavoritesRepository>();
  NotificationsSignalRService get _notificationsSignalRService =>
      GetIt.instance<NotificationsSignalRService>();

  @override
  Future<ApiResult<VerifyOtpResponseEntity>> verifyOtp(
    VerifyOtpRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final dto = request.toDto();
      final result = await _remoteDataSource.verifyOtp(dto);
      final accessToken = result.tokens?.accessToken;
      final refreshToken = result.tokens?.refreshToken;
      if (result.isVerified != true ||
          accessToken == null ||
          accessToken.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
        throw StateError(
          'OTP verification did not create an authenticated session.',
        );
      }

      await _tokenService.saveAccessToken(accessToken);
      await _tokenService.saveRefreshToken(refreshToken);
      final customerId = result.user?.id?.trim() ?? '';
      if (customerId.isNotEmpty) {
        await _tokenService.saveCurrentUserId(customerId);
      }
      runPostAuthSideEffects(
        logName: 'VerifyOtpRepositoryImpl',
        cartRepository: _cartRepository,
        favoritesRepository: _favoritesRepository,
        notificationsSignalRService: _notificationsSignalRService,
        notificationDeviceService: _notificationDeviceService,
        customerId: customerId,
      );
      await _tokenService.deleteRegistrationToken();

      return result.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> resendOtp(String identifier) async {
    return safeApiCall(() async {
      final registrationToken = await _tokenService.getRegistrationToken();
      if (registrationToken == null || registrationToken.isEmpty) {
        throw StateError(
          'Registration session has expired. Please register again.',
        );
      }
      final dto = ResendOtpRequestModelDto(
        identifier: identifier,
        registrationToken: registrationToken,
      );
      final response = await _remoteDataSource.resendOtp(dto);
      await _tokenService.saveRegistrationToken(response.registrationToken);
    });
  }

  @override
  Future<ApiResult<void>> resendResetOtp(String identifier) async {
    return safeApiCall(() async {
      final dto = ResendOtpRequestModelDto(identifier: identifier);
      await _remoteDataSource.resendResetOtp(dto);
    });
  }
}
