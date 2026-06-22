import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/data_source/reset_password_remote_data_source.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/mapper/reset_password_mapper.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/request/verify_reset_otp_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/verify_reset_otp_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/repo/reset_password_repository.dart';

@Injectable(as: ResetPasswordRepository)
class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  ResetPasswordRepositoryImpl(this.remoteDataSource);
  final ResetPasswordRemoteDataSource remoteDataSource;

  @override
  Future<ApiResult<VerifyResetOtpResponseEntity>> verifyResetOtp({
    required String identifier,
    required String otpCode,
  }) async {
    return await safeApiCall<VerifyResetOtpResponseEntity>(() async {
      final requestDto = VerifyResetOtpRequestDto(
        identifier: identifier,
        otpCode: otpCode,
      );
      final responseDto = await remoteDataSource.verifyResetOtp(requestDto);
      return VerifyResetOtpResponseEntity(
        resetToken: responseDto.resetToken,
        message: responseDto.message,
      );
    });
  }

  @override
  Future<ApiResult<ResetPasswordResponseEntity>> resetPassword(
    ResetPasswordRequestEntity entity,
  ) async {
    return await safeApiCall<ResetPasswordResponseEntity>(() async {
      final requestDto = ResetPasswordMapper.toDto(entity);
      final responseDto = await remoteDataSource.resetPassword(requestDto);
      return ResetPasswordMapper.toEntity(responseDto);
    });
  }
}
