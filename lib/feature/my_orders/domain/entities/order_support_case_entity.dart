enum OrderSupportCaseType {
  complaint,
  returnRequest,
  unknown;

  static OrderSupportCaseType fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'complaint':
        return OrderSupportCaseType.complaint;
      case 'return_request':
        return OrderSupportCaseType.returnRequest;
      default:
        return OrderSupportCaseType.unknown;
    }
  }

  String get apiValue {
    switch (this) {
      case OrderSupportCaseType.complaint:
        return 'complaint';
      case OrderSupportCaseType.returnRequest:
        return 'return_request';
      case OrderSupportCaseType.unknown:
        return 'complaint';
    }
  }
}

enum OrderSupportCaseStatus {
  submitted,
  inReview,
  awaitingCustomerEvidence,
  approved,
  rejected,
  resolved,
  unknown;

  static OrderSupportCaseStatus fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'submitted':
        return OrderSupportCaseStatus.submitted;
      case 'in_review':
        return OrderSupportCaseStatus.inReview;
      case 'awaiting_customer_evidence':
        return OrderSupportCaseStatus.awaitingCustomerEvidence;
      case 'approved':
        return OrderSupportCaseStatus.approved;
      case 'rejected':
        return OrderSupportCaseStatus.rejected;
      case 'resolved':
        return OrderSupportCaseStatus.resolved;
      default:
        return OrderSupportCaseStatus.unknown;
    }
  }

  bool get isOpen =>
      this == OrderSupportCaseStatus.submitted ||
      this == OrderSupportCaseStatus.inReview ||
      this == OrderSupportCaseStatus.awaitingCustomerEvidence;
}

class OrderSupportCaseAttachmentEntity {
  const OrderSupportCaseAttachmentEntity({
    required this.fileName,
    required this.fileUrl,
  });

  final String fileName;
  final String fileUrl;
}

class OrderSupportCaseActivityEntity {
  const OrderSupportCaseActivityEntity({
    required this.action,
    required this.title,
    required this.note,
    required this.actorRole,
    required this.visibleToCustomer,
    required this.createdAt,
  });

  final String action;
  final String title;
  final String? note;
  final String actorRole;
  final bool visibleToCustomer;
  final DateTime? createdAt;
}

class OrderSupportCaseSummaryEntity {
  const OrderSupportCaseSummaryEntity({
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

  final String id;
  final OrderSupportCaseType type;
  final OrderSupportCaseStatus status;
  final String queue;
  final String priority;
  final String reasonCode;
  final String message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class OrderSupportCaseEntity {
  const OrderSupportCaseEntity({
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

  final String id;
  final String orderId;
  final OrderSupportCaseType type;
  final OrderSupportCaseStatus status;
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
  final List<OrderSupportCaseAttachmentEntity> attachments;
  final List<OrderSupportCaseActivityEntity> activities;
}
