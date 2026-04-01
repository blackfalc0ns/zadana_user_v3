// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryOtpResponseModel _$DeliveryOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => DeliveryOtpResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String?,
);

Map<String, dynamic> _$DeliveryOtpResponseModelToJson(
  DeliveryOtpResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
