import 'package:json_annotation/json_annotation.dart';

part 'resend_otp_request_model_dto.g.dart';

@JsonSerializable()
class ResendOtpRequestModelDto {
  const ResendOtpRequestModelDto({
    required this.identifier,
    this.registrationToken,
  });

  factory ResendOtpRequestModelDto.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpRequestModelDtoFromJson(json);
  final String identifier;
  @JsonKey(includeIfNull: false)
  final String? registrationToken;

  Map<String, dynamic> toJson() => _$ResendOtpRequestModelDtoToJson(this);
}
