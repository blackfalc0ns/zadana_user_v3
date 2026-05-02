import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';

String supportCaseStatusLabel(
  AppLocalizations l10n,
  OrderSupportCaseStatus status,
) {
  switch (status) {
    case OrderSupportCaseStatus.submitted:
      return l10n.my_orders_support_case_status_submitted;
    case OrderSupportCaseStatus.inReview:
      return l10n.my_orders_support_case_status_in_review;
    case OrderSupportCaseStatus.awaitingCustomerEvidence:
      return l10n.my_orders_support_case_status_awaiting_customer_evidence;
    case OrderSupportCaseStatus.approved:
      return l10n.my_orders_support_case_status_approved;
    case OrderSupportCaseStatus.rejected:
      return l10n.my_orders_support_case_status_rejected;
    case OrderSupportCaseStatus.resolved:
      return l10n.my_orders_support_case_status_resolved;
    case OrderSupportCaseStatus.unknown:
      return l10n.my_orders_support_case_status_unknown;
  }
}

String supportCaseTypeLabel(
  AppLocalizations l10n,
  OrderSupportCaseType type,
) {
  switch (type) {
    case OrderSupportCaseType.complaint:
      return l10n.my_orders_support_case_type_complaint;
    case OrderSupportCaseType.returnRequest:
      return l10n.my_orders_support_case_type_return_request;
    case OrderSupportCaseType.unknown:
      return l10n.my_orders_support_case_type_generic;
  }
}

(Color, Color) supportCaseStatusColors(
  ColorScheme scheme,
  OrderSupportCaseStatus status,
) {
  switch (status) {
    case OrderSupportCaseStatus.approved:
    case OrderSupportCaseStatus.resolved:
      return (const Color(0xFFE7F8EE), const Color(0xFF157347));
    case OrderSupportCaseStatus.rejected:
      return (const Color(0xFFFDECEC), const Color(0xFFC62828));
    case OrderSupportCaseStatus.awaitingCustomerEvidence:
      return (const Color(0xFFFFF6E0), const Color(0xFFB26A00));
    case OrderSupportCaseStatus.submitted:
    case OrderSupportCaseStatus.inReview:
    case OrderSupportCaseStatus.unknown:
      return (
        scheme.secondaryContainer.withValues(alpha: .45),
        scheme.onSecondaryContainer,
      );
  }
}
