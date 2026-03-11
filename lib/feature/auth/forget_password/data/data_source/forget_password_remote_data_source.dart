import 'package:zadana_user_v3/feature/auth/forget_password/data/models/request/forget_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/models/response/forget_password_response_dto.dart';

abstract class ForgetPasswordRemoteDataSource {
  Future<ForgetPasswordResponseDto> forgetPassword(
    ForgetPasswordRequestDto requestDto,
  );
}
