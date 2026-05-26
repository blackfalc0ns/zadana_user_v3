import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/uploaded_support_case_attachment_entity.dart';

class UploadedSupportCaseAttachmentDto {
  const UploadedSupportCaseAttachmentDto({
    required this.fileName,
    required this.url,
  });

  factory UploadedSupportCaseAttachmentDto.fromJson(Map<String, dynamic> json) {
    return UploadedSupportCaseAttachmentDto(
      fileName: json['file_name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  final String fileName;
  final String url;

  UploadedSupportCaseAttachmentEntity toEntity() {
    return UploadedSupportCaseAttachmentEntity(fileName: fileName, url: url);
  }
}

class OrderSupportCaseAttachmentDto {
  const OrderSupportCaseAttachmentDto({
    required this.fileName,
    required this.fileUrl,
  });

  factory OrderSupportCaseAttachmentDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCaseAttachmentDto(
      fileName: json['file_name']?.toString() ?? '',
      fileUrl: json['file_url']?.toString() ?? '',
    );
  }

  final String fileName;
  final String fileUrl;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'file_name': fileName, 'file_url': fileUrl};
  }

  OrderSupportCaseAttachmentEntity toEntity() {
    return OrderSupportCaseAttachmentEntity(
      fileName: fileName,
      fileUrl: fileUrl,
    );
  }
}

class OrderSupportCaseActivityDto {
  const OrderSupportCaseActivityDto({
    required this.action,
    required this.title,
    required this.localizedTitle,
    required this.note,
    required this.localizedNote,
    required this.actorRole,
    required this.visibleToCustomer,
    required this.createdAt,
  });

  factory OrderSupportCaseActivityDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCaseActivityDto(
      action: json['action']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      localizedTitle: json['localized_title']?.toString(),
      note: json['note']?.toString(),
      localizedNote: json['localized_note']?.toString(),
      actorRole: json['actor_role']?.toString() ?? '',
      visibleToCustomer: json['visible_to_customer'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  final String action;
  final String title;
  final String? localizedTitle;
  final String? note;
  final String? localizedNote;
  final String actorRole;
  final bool visibleToCustomer;
  final DateTime? createdAt;

  OrderSupportCaseActivityEntity toEntity() {
    return OrderSupportCaseActivityEntity(
      action: action,
      title: title,
      localizedTitle: localizedTitle,
      note: note,
      localizedNote: localizedNote,
      actorRole: actorRole,
      visibleToCustomer: visibleToCustomer,
      createdAt: createdAt,
    );
  }
}

class OrderSupportCaseMessageDto {
  const OrderSupportCaseMessageDto({
    required this.id,
    required this.action,
    required this.messageType,
    required this.title,
    required this.localizedTitle,
    required this.body,
    required this.localizedBody,
    required this.authorRole,
    required this.visibleTo,
    required this.isInternalOnly,
    required this.createdAt,
    required this.attachments,
  });

  factory OrderSupportCaseMessageDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCaseMessageDto(
      id: json['id']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      messageType: json['message_type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      localizedTitle: json['localized_title']?.toString(),
      body: json['body']?.toString() ?? '',
      localizedBody: json['localized_body']?.toString(),
      authorRole: json['author_role']?.toString() ?? '',
      visibleTo: _list(
        json['visible_to'],
      ).map((item) => item.toString()).toList(growable: false),
      isInternalOnly: json['is_internal_only'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      attachments: _list(json['attachments'])
          .map((item) => OrderSupportCaseAttachmentDto.fromJson(_map(item)))
          .toList(growable: false),
    );
  }

  final String id;
  final String action;
  final String messageType;
  final String title;
  final String? localizedTitle;
  final String body;
  final String? localizedBody;
  final String authorRole;
  final List<String> visibleTo;
  final bool isInternalOnly;
  final DateTime? createdAt;
  final List<OrderSupportCaseAttachmentDto> attachments;

  OrderSupportCaseMessageEntity toEntity() {
    return OrderSupportCaseMessageEntity(
      id: id,
      action: action,
      messageType: messageType,
      title: title,
      localizedTitle: localizedTitle,
      body: body,
      localizedBody: localizedBody,
      authorRole: authorRole,
      visibleTo: visibleTo,
      isInternalOnly: isInternalOnly,
      createdAt: createdAt,
      attachments: attachments
          .map((item) => item.toEntity())
          .toList(growable: false),
    );
  }
}

class OrderSupportCaseSummaryDto {
  const OrderSupportCaseSummaryDto({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.typeLabel,
    required this.status,
    required this.statusLabel,
    required this.queue,
    required this.queueLabel,
    required this.priority,
    required this.priorityLabel,
    required this.reasonCode,
    required this.reasonLabel,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderSupportCaseSummaryDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCaseSummaryDto(
      id: json['id']?.toString() ?? '',
      orderNumber:
          json['order_number']?.toString() ?? json['order_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      typeLabel: json['type_label']?.toString(),
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString(),
      queue: json['queue']?.toString() ?? '',
      queueLabel: json['queue_label']?.toString(),
      priority: json['priority']?.toString() ?? '',
      priorityLabel: json['priority_label']?.toString(),
      reasonCode: json['reason_code']?.toString() ?? '',
      reasonLabel: json['reason_label']?.toString(),
      message: json['message']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  final String id;
  final String orderNumber;
  final String type;
  final String? typeLabel;
  final String status;
  final String? statusLabel;
  final String queue;
  final String? queueLabel;
  final String priority;
  final String? priorityLabel;
  final String reasonCode;
  final String? reasonLabel;
  final String message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderSupportCaseSummaryEntity toEntity() {
    return OrderSupportCaseSummaryEntity(
      id: id,
      orderNumber: orderNumber,
      type: OrderSupportCaseType.fromApi(type),
      typeLabel: typeLabel,
      status: OrderSupportCaseStatus.fromApi(status),
      statusLabel: statusLabel,
      queue: queue,
      queueLabel: queueLabel,
      priority: priority,
      priorityLabel: priorityLabel,
      reasonCode: reasonCode,
      reasonLabel: reasonLabel,
      message: message,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class OrderSupportCaseDto {
  const OrderSupportCaseDto({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.type,
    required this.typeLabel,
    required this.status,
    required this.statusLabel,
    required this.queue,
    required this.queueLabel,
    required this.priority,
    required this.priorityLabel,
    required this.reasonCode,
    required this.reasonLabel,
    required this.message,
    required this.customerVisibleNote,
    required this.decisionNotes,
    required this.createdAt,
    required this.updatedAt,
    required this.slaDueAtUtc,
    required this.requestedRefundAmount,
    required this.approvedRefundAmount,
    required this.refundMethod,
    required this.compensationType,
    required this.settlementStatus,
    required this.couponCode,
    required this.couponExpiresAt,
    required this.couponRedeemed,
    required this.initiatorRole,
    required this.waitingOnRole,
    required this.allowedActions,
    required this.costBearer,
    required this.attachments,
    required this.activities,
    required this.messages,
  });

  factory OrderSupportCaseDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCaseDto(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      orderNumber:
          json['order_number']?.toString() ?? json['order_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      typeLabel: json['type_label']?.toString(),
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString(),
      queue: json['queue']?.toString() ?? '',
      queueLabel: json['queue_label']?.toString(),
      priority: json['priority']?.toString() ?? '',
      priorityLabel: json['priority_label']?.toString(),
      reasonCode: json['reason_code']?.toString() ?? '',
      reasonLabel: json['reason_label']?.toString(),
      message: json['message']?.toString() ?? '',
      customerVisibleNote: json['customer_visible_note']?.toString(),
      decisionNotes: json['decision_notes']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      slaDueAtUtc: DateTime.tryParse(json['sla_due_at_utc']?.toString() ?? ''),
      requestedRefundAmount: (json['requested_refund_amount'] as num?)
          ?.toDouble(),
      approvedRefundAmount: (json['approved_refund_amount'] as num?)
          ?.toDouble(),
      refundMethod: json['refund_method']?.toString(),
      compensationType: json['compensation_type']?.toString(),
      settlementStatus: json['settlement_status']?.toString(),
      couponCode: json['coupon_code']?.toString(),
      couponExpiresAt: DateTime.tryParse(
        json['coupon_expires_at']?.toString() ?? '',
      ),
      couponRedeemed: json['coupon_redeemed'] as bool? ?? false,
      initiatorRole: json['initiator_role']?.toString(),
      waitingOnRole: json['waiting_on_role']?.toString(),
      allowedActions: _list(
        json['allowed_actions'],
      ).map((item) => item.toString()).toList(growable: false),
      costBearer: json['cost_bearer']?.toString(),
      attachments: _list(json['attachments'])
          .map((item) => OrderSupportCaseAttachmentDto.fromJson(_map(item)))
          .toList(growable: false),
      activities: _list(json['activities'])
          .map((item) => OrderSupportCaseActivityDto.fromJson(_map(item)))
          .toList(growable: false),
      messages: _list(json['messages'])
          .map((item) => OrderSupportCaseMessageDto.fromJson(_map(item)))
          .toList(growable: false),
    );
  }

  final String id;
  final String orderId;
  final String orderNumber;
  final String type;
  final String? typeLabel;
  final String status;
  final String? statusLabel;
  final String queue;
  final String? queueLabel;
  final String priority;
  final String? priorityLabel;
  final String reasonCode;
  final String? reasonLabel;
  final String message;
  final String? customerVisibleNote;
  final String? decisionNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? slaDueAtUtc;
  final double? requestedRefundAmount;
  final double? approvedRefundAmount;
  final String? refundMethod;
  final String? compensationType;
  final String? settlementStatus;
  final String? couponCode;
  final DateTime? couponExpiresAt;
  final bool couponRedeemed;
  final String? initiatorRole;
  final String? waitingOnRole;
  final List<String> allowedActions;
  final String? costBearer;
  final List<OrderSupportCaseAttachmentDto> attachments;
  final List<OrderSupportCaseActivityDto> activities;
  final List<OrderSupportCaseMessageDto> messages;

  OrderSupportCaseEntity toEntity() {
    return OrderSupportCaseEntity(
      id: id,
      orderId: orderId,
      orderNumber: orderNumber,
      type: OrderSupportCaseType.fromApi(type),
      typeLabel: typeLabel,
      status: OrderSupportCaseStatus.fromApi(status),
      statusLabel: statusLabel,
      queue: queue,
      queueLabel: queueLabel,
      priority: priority,
      priorityLabel: priorityLabel,
      reasonCode: reasonCode,
      reasonLabel: reasonLabel,
      message: message,
      customerVisibleNote: customerVisibleNote,
      decisionNotes: decisionNotes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      slaDueAtUtc: slaDueAtUtc,
      requestedRefundAmount: requestedRefundAmount,
      approvedRefundAmount: approvedRefundAmount,
      refundMethod: refundMethod,
      compensationType: OrderSupportCompensationType.fromApi(compensationType),
      settlementStatus: OrderSupportSettlementStatus.fromApi(settlementStatus),
      couponCode: couponCode,
      couponExpiresAt: couponExpiresAt,
      couponRedeemed: couponRedeemed,
      initiatorRole: initiatorRole,
      waitingOnRole: waitingOnRole,
      allowedActions: allowedActions,
      costBearer: costBearer,
      attachments: attachments
          .map((item) => item.toEntity())
          .toList(growable: false),
      activities: activities
          .map((item) => item.toEntity())
          .toList(growable: false),
      messages: messages.map((item) => item.toEntity()).toList(growable: false),
    );
  }
}

class OrderRefundStatusDto {
  const OrderRefundStatusDto({
    required this.hasActiveCase,
    required this.caseStatus,
    required this.caseType,
    required this.requestedAmount,
    required this.approvedAmount,
    required this.refundMethod,
    required this.compensationType,
    required this.settlementStatus,
    required this.couponCode,
    required this.couponExpiresAt,
    required this.couponRedeemed,
    required this.refundStatus,
    required this.customerNote,
    required this.refundLifecycleStatus,
    required this.refundProvider,
    required this.refundFailureMessage,
  });

  factory OrderRefundStatusDto.fromJson(Map<String, dynamic> json) {
    return OrderRefundStatusDto(
      hasActiveCase: json['has_active_case'] as bool? ?? false,
      caseStatus: json['case_status']?.toString(),
      caseType: json['case_type']?.toString(),
      requestedAmount: (json['requested_amount'] as num?)?.toDouble(),
      approvedAmount: (json['approved_amount'] as num?)?.toDouble(),
      refundMethod: json['refund_method']?.toString(),
      compensationType: json['compensation_type']?.toString(),
      settlementStatus: json['settlement_status']?.toString(),
      couponCode: json['coupon_code']?.toString(),
      couponExpiresAt: DateTime.tryParse(
        json['coupon_expires_at']?.toString() ?? '',
      ),
      couponRedeemed: json['coupon_redeemed'] as bool? ?? false,
      refundStatus: json['refund_status']?.toString(),
      customerNote: json['customer_note']?.toString(),
      refundLifecycleStatus: json['refund_lifecycle_status']?.toString(),
      refundProvider: json['refund_provider']?.toString(),
      refundFailureMessage: json['refund_failure_message']?.toString(),
    );
  }

  final bool hasActiveCase;
  final String? caseStatus;
  final String? caseType;
  final double? requestedAmount;
  final double? approvedAmount;
  final String? refundMethod;
  final String? compensationType;
  final String? settlementStatus;
  final String? couponCode;
  final DateTime? couponExpiresAt;
  final bool couponRedeemed;
  final String? refundStatus;
  final String? customerNote;
  final String? refundLifecycleStatus;
  final String? refundProvider;
  final String? refundFailureMessage;

  OrderRefundStatusEntity toEntity() {
    return OrderRefundStatusEntity(
      hasActiveCase: hasActiveCase,
      caseStatus: caseStatus == null
          ? null
          : OrderSupportCaseStatus.fromApi(caseStatus),
      caseType: caseType == null
          ? null
          : OrderSupportCaseType.fromApi(caseType),
      requestedAmount: requestedAmount,
      approvedAmount: approvedAmount,
      refundMethod: refundMethod,
      compensationType: OrderSupportCompensationType.fromApi(compensationType),
      settlementStatus: OrderSupportSettlementStatus.fromApi(settlementStatus),
      couponCode: couponCode,
      couponExpiresAt: couponExpiresAt,
      couponRedeemed: couponRedeemed,
      refundStatus: refundStatus,
      customerNote: customerNote,
      refundLifecycleStatus: OrderRefundLifecycleStatus.fromApi(
        refundLifecycleStatus,
      ),
      refundProvider: refundProvider,
      refundFailureMessage: refundFailureMessage,
    );
  }
}

class CreateOrderSupportCaseResponseDto {
  const CreateOrderSupportCaseResponseDto({
    required this.message,
    required this.orderSupportCase,
  });

  factory CreateOrderSupportCaseResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateOrderSupportCaseResponseDto(
      message: json['message']?.toString() ?? '',
      orderSupportCase: OrderSupportCaseDto.fromJson(_map(json['case'])),
    );
  }

  final String message;
  final OrderSupportCaseDto orderSupportCase;
}

class OrderSupportCasesResponseDto {
  const OrderSupportCasesResponseDto({required this.items});

  factory OrderSupportCasesResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCasesResponseDto(
      items: _list(json['items'])
          .map((item) => OrderSupportCaseDto.fromJson(_map(item)))
          .toList(growable: false),
    );
  }

  final List<OrderSupportCaseDto> items;
}

class OrderSupportCaseDetailsResponseDto {
  const OrderSupportCaseDetailsResponseDto({required this.orderSupportCase});

  factory OrderSupportCaseDetailsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderSupportCaseDetailsResponseDto(
      orderSupportCase: OrderSupportCaseDto.fromJson(_map(json['case'])),
    );
  }

  final OrderSupportCaseDto orderSupportCase;
}

class OrderRefundStatusResponseDto {
  const OrderRefundStatusResponseDto({required this.refundStatus});

  factory OrderRefundStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderRefundStatusResponseDto(
      refundStatus: OrderRefundStatusDto.fromJson(json),
    );
  }

  final OrderRefundStatusDto refundStatus;
}

Map<String, dynamic> _map(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return const <String, dynamic>{};
}

List<dynamic> _list(dynamic value) {
  if (value is List) {
    return value;
  }
  return const <dynamic>[];
}
