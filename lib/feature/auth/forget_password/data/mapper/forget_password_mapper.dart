import 'package:zadana_user_v3/feature/auth/forget_password/data/models/request/forget_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/models/response/forget_password_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_response_entity.dart';

class ForgetPasswordMapper {
  static ForgetPasswordRequestDto toDto(
    ForgetPasswordRequestEntity entity,
  ) {
    return ForgetPasswordRequestDto(
      identifier: entity.identifier,
    );
  }

  static ForgetPasswordResponseEntity toEntity(
    ForgetPasswordResponseDto dto,
  ) {
    return ForgetPasswordResponseEntity(
      message: dto.message,
    );
  }
}
