import 'package:zadana_user_v3/feature/auth/register/data/models/request/register_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/response/register_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_response_entity.dart';

class RegisterMapper {
  static RegisterRequestDto toDto(RegisterRequestEntity entity) {
    final phone = entity.phone.trim();
    return RegisterRequestDto(
      fullName: entity.fullName,
      email: entity.email,
      phone: phone.isEmpty ? null : phone,
      password: entity.password,
      addressLine: entity.addressLine,
      label: entity.label,
      buildingNo: entity.buildingNo,
      floorNo: entity.floorNo,
      apartmentNo: entity.apartmentNo,
      city: entity.city,
      area: entity.area,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  static RegisterResponseEntity toEntity(RegisterResponseDto dto) {
    return RegisterResponseEntity(
      id: dto.user?.id ?? '',
      fullName: dto.user?.fullName ?? '',
      email: dto.user?.email ?? '',
      phone: dto.user?.phone ?? '',
      role: dto.user?.role ?? '',
      message: dto.message ?? '',
      isVerified: dto.isVerified ?? false,
      registrationToken: dto.registrationToken,
    );
  }
}
