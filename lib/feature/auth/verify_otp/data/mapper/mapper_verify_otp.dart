import 'package:zadana_user_v3/feature/auth/verify_otp/data/models/verify_otp_request_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/models/verify_otp_response_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/domain/entities/verify_otp_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/domain/entities/verify_otp_response_entity.dart';

extension VerifyOtpRequestEntityMapper on VerifyOtpRequestEntity {
  VerifyOtpRequestModelDto toDto() {
    return VerifyOtpRequestModelDto(
      identifier: identifier,
      otpCode: otpCode,
      registrationToken: registrationToken,
    );
  }
}

extension VerifyOtpResponseModelMapper on VerifyOtpResponseModelDto {
  VerifyOtpResponseEntity toEntity() {
    return VerifyOtpResponseEntity(
      user: user?.toEntity(),
      isVerified: isVerified ?? false,
      message: message ?? '',
    );
  }
}
