// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_otp_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryOtpRequestModel _$DeliveryOtpRequestModelFromJson(
  Map<String, dynamic> json,
) => DeliveryOtpRequestModel(
  orderId: json['orderId'] as String,
  otpCode: json['otpCode'] as String,
);

Map<String, dynamic> _$DeliveryOtpRequestModelToJson(
  DeliveryOtpRequestModel instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'otpCode': instance.otpCode,
};
