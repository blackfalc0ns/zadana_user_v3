import 'package:zadana_user_v3/feature/auth/reset_password/data/models/request/reset_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/response/reset_password_response_dto.dart';

abstract class ResetPasswordRemoteDataSource {
  Future<ResetPasswordResponseDto> resetPassword(
    ResetPasswordRequestDto requestDto,
  );
}
