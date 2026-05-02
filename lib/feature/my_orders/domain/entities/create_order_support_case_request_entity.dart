import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';

class CreateOrderSupportCaseRequestEntity {
  const CreateOrderSupportCaseRequestEntity({
    required this.type,
    required this.reasonCode,
    required this.message,
    required this.attachments,
  });

  final OrderSupportCaseType type;
  final String reasonCode;
  final String message;
  final List<OrderSupportCaseAttachmentEntity> attachments;
}
