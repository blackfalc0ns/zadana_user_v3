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
    required this.note,
    required this.actorRole,
    required this.visibleToCustomer,
    required this.createdAt,
  });

  factory OrderSupportCaseActivityDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCaseActivityDto(
      action: json['action']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      note: json['note']?.toString(),
      actorRole: json['actor_role']?.toString() ?? '',
      visibleToCustomer: json['visible_to_customer'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  final String action;
  final String title;
  final String? note;
  final String actorRole;
  final bool visibleToCustomer;
  final DateTime? createdAt;

  OrderSupportCaseActivityEntity toEntity() {
    return OrderSupportCaseActivityEntity(
      action: action,
      title: title,
      note: note,
      actorRole: actorRole,
      visibleToCustomer: visibleToCustomer,
      createdAt: createdAt,
    );
  }
}

class OrderSupportCaseSummaryDto {
  const OrderSupportCaseSummaryDto({
    required this.id,
    required this.type,
    required this.status,
    required this.queue,
    required this.priority,
    required this.reasonCode,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderSupportCaseSummaryDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCaseSummaryDto(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      queue: json['queue']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      reasonCode: json['reason_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  final String id;
  final String type;
  final String status;
  final String queue;
  final String priority;
  final String reasonCode;
  final String message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderSupportCaseSummaryEntity toEntity() {
    return OrderSupportCaseSummaryEntity(
      id: id,
      type: OrderSupportCaseType.fromApi(type),
      status: OrderSupportCaseStatus.fromApi(status),
      queue: queue,
      priority: priority,
      reasonCode: reasonCode,
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
    required this.type,
    required this.status,
    required this.queue,
    required this.priority,
    required this.reasonCode,
    required this.message,
    required this.customerVisibleNote,
    required this.decisionNotes,
    required this.createdAt,
    required this.updatedAt,
    required this.slaDueAtUtc,
    required this.requestedRefundAmount,
    required this.approvedRefundAmount,
    required this.refundMethod,
    required this.costBearer,
    required this.attachments,
    required this.activities,
  });

  factory OrderSupportCaseDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCaseDto(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      queue: json['queue']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      reasonCode: json['reason_code']?.toString() ?? '',
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
      costBearer: json['cost_bearer']?.toString(),
      attachments: _list(json['attachments'])
          .map((item) => OrderSupportCaseAttachmentDto.fromJson(_map(item)))
          .toList(growable: false),
      activities: _list(json['activities'])
          .map((item) => OrderSupportCaseActivityDto.fromJson(_map(item)))
          .toList(growable: false),
    );
  }

  final String id;
  final String orderId;
  final String type;
  final String status;
  final String queue;
  final String priority;
  final String reasonCode;
  final String message;
  final String? customerVisibleNote;
  final String? decisionNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? slaDueAtUtc;
  final double? requestedRefundAmount;
  final double? approvedRefundAmount;
  final String? refundMethod;
  final String? costBearer;
  final List<OrderSupportCaseAttachmentDto> attachments;
  final List<OrderSupportCaseActivityDto> activities;

  OrderSupportCaseEntity toEntity() {
    return OrderSupportCaseEntity(
      id: id,
      orderId: orderId,
      type: OrderSupportCaseType.fromApi(type),
      status: OrderSupportCaseStatus.fromApi(status),
      queue: queue,
      priority: priority,
      reasonCode: reasonCode,
      message: message,
      customerVisibleNote: customerVisibleNote,
      decisionNotes: decisionNotes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      slaDueAtUtc: slaDueAtUtc,
      requestedRefundAmount: requestedRefundAmount,
      approvedRefundAmount: approvedRefundAmount,
      refundMethod: refundMethod,
      costBearer: costBearer,
      attachments: attachments.map((item) => item.toEntity()).toList(
        growable: false,
      ),
      activities: activities.map((item) => item.toEntity()).toList(
        growable: false,
      ),
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
      orderSupportCase: OrderSupportCaseDto.fromJson(
        _map(json['case']),
      ),
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

  factory OrderSupportCaseDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderSupportCaseDetailsResponseDto(
      orderSupportCase: OrderSupportCaseDto.fromJson(_map(json['case'])),
    );
  }

  final OrderSupportCaseDto orderSupportCase;
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
