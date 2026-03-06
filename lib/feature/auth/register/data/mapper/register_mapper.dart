import 'package:zadana_user_v3/feature/auth/register/data/models/request/register_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/response/register_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_response_entity.dart';

class RegisterMapper {
  static RegisterRequestDto toDto(RegisterEntity entity) {
    return RegisterRequestDto(
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      password: entity.password,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  static RegisterResponseEntity toEntity(
    RegisterResponseDto dto,
  ) {
    return RegisterResponseEntity(
      message: dto.message,
      userId: dto.userId,
    );
  }
}
