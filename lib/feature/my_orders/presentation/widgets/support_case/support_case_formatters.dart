import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';

String supportCaseDisplayValue(String preferred, String fallback) {
  final normalizedPreferred = preferred.trim();
  if (normalizedPreferred.isNotEmpty) return normalizedPreferred;

  final normalizedFallback = fallback.trim();
  if (normalizedFallback.isNotEmpty) return normalizedFallback;

  return '-';
}

String supportCaseReasonFallbackLabel(
  AppLocalizations l10n,
  String reasonCode,
) {
  switch (reasonCode.trim().toLowerCase()) {
    case 'payment_issue':
      return l10n.my_orders_support_case_reason_payment_issue;
    case 'delivery_delay':
      return l10n.my_orders_support_case_reason_delivery_delay;
    case 'prep_delay':
      return l10n.my_orders_support_case_reason_prep_delay;
    case 'fraud':
      return l10n.my_orders_support_case_reason_fraud;
    case 'fraud_suspicion':
      return l10n.my_orders_support_case_reason_fraud_suspicion;
    default:
      return supportCaseHumanize(reasonCode);
  }
}

String supportCaseTypeFallbackLabel(
  AppLocalizations l10n,
  OrderSupportCaseType type,
) {
  final isArabic = l10n.localeName.toLowerCase().startsWith('ar');

  switch (type) {
    case OrderSupportCaseType.complaint:
      return isArabic ? 'شكوى' : 'Complaint';
    case OrderSupportCaseType.returnRequest:
      return isArabic ? 'طلب إرجاع' : 'Return request';
    case OrderSupportCaseType.driverReport:
      return isArabic ? 'بلاغ سائق' : 'Driver report';
    case OrderSupportCaseType.driverDispute:
      return isArabic ? 'نزاع سائق' : 'Driver dispute';
    case OrderSupportCaseType.unknown:
      return '-';
  }
}

String supportCaseMainStatusLabel(
  AppLocalizations l10n,
  OrderSupportCaseStatus status,
) {
  final isArabic = l10n.localeName.toLowerCase().startsWith('ar');

  switch (status) {
    case OrderSupportCaseStatus.submitted:
      return isArabic ? 'مقدمة' : 'Submitted';
    case OrderSupportCaseStatus.inReview:
      return isArabic ? 'قيد المراجعة' : 'In review';
    case OrderSupportCaseStatus.awaitingCustomerEvidence:
      return isArabic ? 'بانتظار الأدلة' : 'Awaiting evidence';
    case OrderSupportCaseStatus.approved:
      return isArabic ? 'تمت الموافقة' : 'Approved';
    case OrderSupportCaseStatus.rejected:
      return isArabic ? 'مرفوضة' : 'Rejected';
    case OrderSupportCaseStatus.resolved:
      return isArabic ? 'مغلقة' : 'Closed';
    case OrderSupportCaseStatus.unknown:
      return '-';
  }
}

String supportCaseStatusFallbackLabel(
  AppLocalizations l10n,
  OrderSupportCaseStatus status,
) {
  return supportCaseMainStatusLabel(l10n, status);
}

String supportCasePriorityFallbackLabel(
  AppLocalizations l10n,
  String priority,
) {
  switch (priority.trim().toLowerCase()) {
    case 'high':
      return l10n.my_orders_support_case_priority_high;
    case 'medium':
      return l10n.my_orders_support_case_priority_medium;
    case 'low':
      return l10n.my_orders_support_case_priority_low;
    default:
      return supportCaseHumanize(priority);
  }
}

String supportCaseQueueFallbackLabel(AppLocalizations l10n, String queue) {
  switch (queue.trim().toLowerCase()) {
    case 'finance':
      return l10n.my_orders_support_case_queue_finance;
    case 'support':
      return l10n.my_orders_support_case_queue_support;
    case 'operations':
      return l10n.my_orders_support_case_queue_operations;
    default:
      return supportCaseHumanize(queue);
  }
}

String supportCaseSettlementLabel(
  AppLocalizations l10n,
  OrderSupportSettlementStatus status,
) {
  final isArabic = l10n.localeName.toLowerCase().startsWith('ar');

  switch (status) {
    case OrderSupportSettlementStatus.pendingReview:
      return isArabic ? 'قيد المراجعة' : 'Pending review';
    case OrderSupportSettlementStatus.cashRefunded:
      return isArabic ? 'تم استرداد المبلغ' : 'Cash refunded';
    case OrderSupportSettlementStatus.couponIssued:
      return isArabic ? 'تم إصدار كوبون' : 'Coupon issued';
    case OrderSupportSettlementStatus.couponRedeemed:
      return isArabic ? 'تم استخدام الكوبون' : 'Coupon redeemed';
    case OrderSupportSettlementStatus.rejected:
      return isArabic ? 'مرفوضة' : 'Rejected';
    case OrderSupportSettlementStatus.approved:
      return isArabic ? 'تمت الموافقة وبانتظار التسوية' : 'Approved, awaiting settlement';
    case OrderSupportSettlementStatus.unknown:
      return '-';
  }
}

String supportCaseOperationalTypeLabel(
  AppLocalizations l10n, {
  required OrderSupportCaseType type,
  required OrderSupportCaseStatus status,
  required OrderSupportSettlementStatus settlementStatus,
}) {
  final isArabic = l10n.localeName.toLowerCase().startsWith('ar');

  if (type == OrderSupportCaseType.returnRequest) {
    if (status == OrderSupportCaseStatus.rejected) {
      return isArabic ? 'طلب إرجاع مرفوض' : 'Rejected return request';
    }

    if (status == OrderSupportCaseStatus.resolved) {
      switch (settlementStatus) {
        case OrderSupportSettlementStatus.cashRefunded:
          return isArabic ? 'طلب إرجاع مسترد' : 'Refunded return request';
        case OrderSupportSettlementStatus.couponIssued:
          return isArabic
              ? 'طلب إرجاع معوّض بكوبون'
              : 'Coupon-compensated return request';
        case OrderSupportSettlementStatus.couponRedeemed:
          return isArabic ? 'طلب إرجاع مغلق' : 'Closed return request';
        default:
          return isArabic ? 'طلب إرجاع' : 'Return request';
      }
    }

    if (status == OrderSupportCaseStatus.approved) {
      if (settlementStatus == OrderSupportSettlementStatus.couponIssued) {
        return isArabic
            ? 'طلب إرجاع معوّض بكوبون'
            : 'Coupon-compensated return request';
      }

      return isArabic ? 'طلب إرجاع معتمد' : 'Approved return request';
    }

    return isArabic ? 'طلب إرجاع' : 'Return request';
  }

  return supportCaseTypeFallbackLabel(l10n, type);
}

String supportCaseOperationalMetaText(
  AppLocalizations l10n, {
  required String caseId,
  required OrderSupportCaseType type,
  required OrderSupportCaseStatus status,
  required OrderSupportSettlementStatus settlementStatus,
  required String? backendText,
  required String sourceField,
}) {
  final isArabic = l10n.localeName.toLowerCase().startsWith('ar');

  if (type == OrderSupportCaseType.returnRequest) {
    switch (settlementStatus) {
      case OrderSupportSettlementStatus.couponRedeemed:
        return isArabic
            ? 'أُغلقت بعد استخدام الكوبون'
            : 'Closed after coupon redemption';
      case OrderSupportSettlementStatus.couponIssued:
        return isArabic
            ? 'تم إصدار كوبون تعويضي للعميل'
            : 'A compensation coupon was issued to the customer';
      case OrderSupportSettlementStatus.cashRefunded:
        return isArabic
            ? 'تم استرداد مبلغ العميل'
            : 'The customer refund was completed';
      default:
        if (status == OrderSupportCaseStatus.approved) {
          return isArabic
              ? 'تمت الموافقة على الطلب وبانتظار اكتمال التسوية'
              : 'The request was approved and is awaiting settlement completion';
        }
    }
  }

  return supportCaseSanitizeVisibleText(
    l10n,
    backendText,
    caseId: caseId,
    fieldName: sourceField,
  );
}

bool supportCaseShouldShowWaitingBadge({
  required OrderSupportCaseStatus status,
  required String? waitingOnRole,
}) {
  final normalizedRole = waitingOnRole?.trim() ?? '';
  if (normalizedRole.isEmpty) return false;

  return status != OrderSupportCaseStatus.resolved &&
      status != OrderSupportCaseStatus.rejected;
}

String supportCaseWaitingOnLabel(
  AppLocalizations l10n,
  String? waitingOnRole,
) {
  final isArabic = l10n.localeName.toLowerCase().startsWith('ar');
  final normalizedRole = waitingOnRole?.trim().toLowerCase() ?? '';

  switch (normalizedRole) {
    case 'customer':
      return isArabic ? 'بانتظار العميل' : 'Waiting on customer';
    case 'support':
      return isArabic ? 'بانتظار الدعم' : 'Waiting on support';
    case 'vendor':
      return isArabic ? 'بانتظار البائع' : 'Waiting on vendor';
    default:
      final role = supportCaseHumanize(waitingOnRole ?? '');
      if (role == '-') return isArabic ? 'بانتظار رد' : 'Waiting on reply';
      return isArabic ? 'بانتظار $role' : 'Waiting on $role';
  }
}

String supportCaseActivityTitle(
  AppLocalizations l10n, {
  required String title,
  required String action,
}) {
  final normalizedTitle = title.trim();
  if (normalizedTitle.isNotEmpty) return normalizedTitle;

  if (action.trim().toLowerCase() == 'submitted') {
    return l10n.my_orders_support_case_created;
  }

  return supportCaseHumanize(action);
}

String supportCaseActorLabel(
  AppLocalizations l10n, {
  required bool byCustomer,
}) {
  return byCustomer
      ? l10n.my_orders_support_case_actor_you
      : l10n.my_orders_support_case_actor_support;
}

String supportCaseSanitizeVisibleText(
  AppLocalizations l10n,
  String? text, {
  required String caseId,
  required String fieldName,
}) {
  final normalized = text?.trim() ?? '';
  if (normalized.isEmpty) return '';

  final isArabic = l10n.localeName.toLowerCase().startsWith('ar');
  if (isArabic || !_containsArabicScript(normalized)) {
    return normalized;
  }

  debugPrint(
    'Vendor dispute English payload regression: caseId=$caseId, field=$fieldName, value=$normalized',
  );
  return '';
}

bool _containsArabicScript(String value) {
  return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]').hasMatch(value);
}

String formatSupportCaseDate(DateTime? dateTime, String locale) {
  if (dateTime == null) return '-';
  return DateFormat.yMMMd(locale).add_jm().format(dateTime.toLocal());
}

String supportCaseHumanize(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) return '-';

  return normalized
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map(
        (word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');
}
