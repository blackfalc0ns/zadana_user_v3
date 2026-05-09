enum OrderSupportCaseType {
  complaint,
  returnRequest,
  driverReport,
  driverDispute,
  unknown;

  static OrderSupportCaseType fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'complaint':
        return OrderSupportCaseType.complaint;
      case 'return_request':
        return OrderSupportCaseType.returnRequest;
      case 'driver_report':
        return OrderSupportCaseType.driverReport;
      case 'driver_dispute':
        return OrderSupportCaseType.driverDispute;
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
      case OrderSupportCaseType.driverReport:
        return 'driver_report';
      case OrderSupportCaseType.driverDispute:
        return 'driver_dispute';
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

enum OrderSupportCompensationType {
  cashRefund,
  couponCompensation,
  unknown;

  static OrderSupportCompensationType fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'cash_refund':
        return OrderSupportCompensationType.cashRefund;
      case 'coupon_compensation':
        return OrderSupportCompensationType.couponCompensation;
      default:
        return OrderSupportCompensationType.unknown;
    }
  }
}

enum OrderSupportSettlementStatus {
  pendingReview,
  cashRefunded,
  couponIssued,
  couponRedeemed,
  rejected,
  approved,
  unknown;

  static OrderSupportSettlementStatus fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'pending_review':
        return OrderSupportSettlementStatus.pendingReview;
      case 'cash_refunded':
        return OrderSupportSettlementStatus.cashRefunded;
      case 'coupon_issued':
        return OrderSupportSettlementStatus.couponIssued;
      case 'coupon_redeemed':
        return OrderSupportSettlementStatus.couponRedeemed;
      case 'rejected':
        return OrderSupportSettlementStatus.rejected;
      case 'approved':
        return OrderSupportSettlementStatus.approved;
      default:
        return OrderSupportSettlementStatus.unknown;
    }
  }
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
    required this.localizedTitle,
    required this.note,
    required this.localizedNote,
    required this.actorRole,
    required this.visibleToCustomer,
    required this.createdAt,
  });

  final String action;
  final String title;
  final String? localizedTitle;
  final String? note;
  final String? localizedNote;
  final String actorRole;
  final bool visibleToCustomer;
  final DateTime? createdAt;

  String get displayTitle {
    final localized = localizedTitle?.trim() ?? '';
    if (localized.isNotEmpty) return localized;
    return title;
  }

  String? get displayNote {
    final localized = localizedNote?.trim() ?? '';
    if (localized.isNotEmpty) return localized;
    return note;
  }
}

class OrderSupportCaseMessageEntity {
  const OrderSupportCaseMessageEntity({
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
  final List<OrderSupportCaseAttachmentEntity> attachments;

  bool get isVisibleToCustomer =>
      !isInternalOnly &&
      (visibleTo.isEmpty ||
          visibleTo.any((role) => role.trim().toLowerCase() == 'customer'));

  String get displayTitle {
    final localized = localizedTitle?.trim() ?? '';
    if (localized.isNotEmpty) return localized;
    return title;
  }

  String get displayBody {
    final localized = localizedBody?.trim() ?? '';
    if (localized.isNotEmpty) return localized;
    return body.trim();
  }
}

class OrderSupportCaseSummaryEntity {
  const OrderSupportCaseSummaryEntity({
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

  final String id;
  final String orderNumber;
  final OrderSupportCaseType type;
  final String? typeLabel;
  final OrderSupportCaseStatus status;
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

  String get displayOrderNumber {
    final normalized = orderNumber.trim();
    if (normalized.isNotEmpty) return normalized;
    return id;
  }

  String get displayType => _displayValue(typeLabel, type.apiValue);
  String get displayStatus =>
      _displayValue(statusLabel, _statusApiValue(status));
  String get displayQueue => _displayValue(queueLabel, queue);
  String get displayPriority => _displayValue(priorityLabel, priority);
  String get displayReason => _displayValue(reasonLabel, reasonCode);
}

class OrderRefundStatusEntity {
  const OrderRefundStatusEntity({
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
  });

  final bool hasActiveCase;
  final OrderSupportCaseStatus? caseStatus;
  final OrderSupportCaseType? caseType;
  final double? requestedAmount;
  final double? approvedAmount;
  final String? refundMethod;
  final OrderSupportCompensationType compensationType;
  final OrderSupportSettlementStatus settlementStatus;
  final String? couponCode;
  final DateTime? couponExpiresAt;
  final bool couponRedeemed;
  final String? refundStatus;
  final String? customerNote;
}

class OrderSupportCaseEntity {
  const OrderSupportCaseEntity({
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

  final String id;
  final String orderId;
  final String orderNumber;
  final OrderSupportCaseType type;
  final String? typeLabel;
  final OrderSupportCaseStatus status;
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
  final OrderSupportCompensationType compensationType;
  final OrderSupportSettlementStatus settlementStatus;
  final String? couponCode;
  final DateTime? couponExpiresAt;
  final bool couponRedeemed;
  final String? initiatorRole;
  final String? waitingOnRole;
  final List<String> allowedActions;
  final String? costBearer;
  final List<OrderSupportCaseAttachmentEntity> attachments;
  final List<OrderSupportCaseActivityEntity> activities;
  final List<OrderSupportCaseMessageEntity> messages;

  String get displayOrderNumber {
    final normalized = orderNumber.trim();
    if (normalized.isNotEmpty) return normalized;
    return orderId;
  }

  bool get canSendMessage =>
      allowedActions.any((action) => action.trim().toLowerCase() == 'message');

  bool get isWaitingOnCustomer =>
      waitingOnRole?.trim().toLowerCase() == 'customer';

  String get displayType => _displayValue(typeLabel, type.apiValue);
  String get displayStatus =>
      _displayValue(statusLabel, _statusApiValue(status));
  String get displayQueue => _displayValue(queueLabel, queue);
  String get displayPriority => _displayValue(priorityLabel, priority);
  String get displayReason => _displayValue(reasonLabel, reasonCode);
}

String _displayValue(String? localized, String fallback) {
  final preferred = localized?.trim() ?? '';
  if (preferred.isNotEmpty) return preferred;

  final raw = fallback.trim();
  if (raw.isNotEmpty) return raw;

  return '';
}

String _statusApiValue(OrderSupportCaseStatus status) {
  switch (status) {
    case OrderSupportCaseStatus.submitted:
      return 'submitted';
    case OrderSupportCaseStatus.inReview:
      return 'in_review';
    case OrderSupportCaseStatus.awaitingCustomerEvidence:
      return 'awaiting_customer_evidence';
    case OrderSupportCaseStatus.approved:
      return 'approved';
    case OrderSupportCaseStatus.rejected:
      return 'rejected';
    case OrderSupportCaseStatus.resolved:
      return 'resolved';
    case OrderSupportCaseStatus.unknown:
      return '';
  }
}
