import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

enum OrderComplaintState { none, submitted, inReview, resolved }

String complaintStatusLabel(AppLocalizations l10n, OrderComplaintState state) {
  switch (state) {
    case OrderComplaintState.none:
      return '';
    case OrderComplaintState.submitted:
      return l10n.my_orders_complaint_received;
    case OrderComplaintState.inReview:
      return l10n.my_orders_complaint_under_review;
    case OrderComplaintState.resolved:
      return l10n.my_orders_complaint_resolved;
  }
}
