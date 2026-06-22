import 'package:zadana_user_v3/feature/auth/reset_password/data/models/request/reset_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/response/reset_password_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_response_entity.dart';

class ResetPasswordMapper {
  static ResetPasswordRequestDto toDto(ResetPasswordRequestEntity entity) {
    return ResetPasswordRequestDto(
      identifier: entity.identifier,
      resetToken: entity.resetToken,
      newPassword: entity.newPassword,
    );
  }

  static ResetPasswordResponseEntity toEntity(ResetPasswordResponseDto dto) {
    return ResetPasswordResponseEntity(message: dto.message);
  }
}
