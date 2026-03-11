import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/mapper/mapper_verify_otp.dart';
import '../../domain/entities/verify_otp_request_entity.dart';
import '../../domain/entities/verify_otp_response_entity.dart';
import '../../domain/repo/verify_otp_repository.dart';
import '../data_source/verify_otp_remote_data_source.dart';

/// Verify OTP repository implementation
/// Data layer - Repository implementation
@Injectable(as: VerifyOtpRepository)
class VerifyOtpRepositoryImpl implements VerifyOtpRepository {
  final VerifyOtpRemoteDataSource _remoteDataSource;
  final TokenService _tokenService;

  const VerifyOtpRepositoryImpl(this._remoteDataSource, this._tokenService);

  @override
  Future<ApiResult<VerifyOtpResponseEntity>> verifyOtp(
    VerifyOtpRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final dto = request.toDto();
      final result = await _remoteDataSource.verifyOtp(dto);
      final accessToken = result.tokens?.accessToken;
      final refreshToken = result.tokens?.refreshToken;
      if (accessToken != null && refreshToken != null) {
        await _tokenService.saveAccessToken(accessToken);
        await _tokenService.saveRefreshToken(refreshToken);
      }

      return result.toEntity();
    });
  }
}
