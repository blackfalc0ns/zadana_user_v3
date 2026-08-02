import 'package:zadana_user_v3/core/utils/localized_api_message.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/confirm_payment_response_entity.dart';

class ConfirmPaymentResponseDto {
  const ConfirmPaymentResponseDto({
    required this.message,
    required this.paymentId,
    required this.paymentStatus,
    required this.userId,
    required this.orderId,
    required this.orderStatus,
    required this.alreadyConfirmed,
  });

  factory ConfirmPaymentResponseDto.fromJson(Map<String, dynamic> json) {
    return ConfirmPaymentResponseDto(
      message: resolveLocalizedApiMessage(json),
      paymentId: (json['paymentId'] ?? json['payment_id'])?.toString() ?? '',
      paymentStatus:
          (json['paymentStatus'] ?? json['payment_status'])?.toString() ?? '',
      userId: (json['userId'] ?? json['user_id'])?.toString() ?? '',
      orderId: (json['orderId'] ?? json['order_id'])?.toString() ?? '',
      orderStatus:
          (json['orderStatus'] ?? json['order_status'])?.toString() ?? '',
      alreadyConfirmed:
          json['alreadyConfirmed'] == true || json['already_confirmed'] == true,
    );
  }

  final String message;
  final String paymentId;
  final String paymentStatus;
  final String userId;
  final String orderId;
  final String orderStatus;
  final bool alreadyConfirmed;

  ConfirmPaymentResponseEntity toEntity() {
    return ConfirmPaymentResponseEntity(
      message: message,
      paymentId: paymentId,
      paymentStatus: paymentStatus,
      userId: userId,
      orderId: orderId,
      orderStatus: orderStatus,
      alreadyConfirmed: alreadyConfirmed,
    );
  }
}
