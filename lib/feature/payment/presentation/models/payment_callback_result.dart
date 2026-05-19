/// Result map returned from a payment screen (Moyasar native form or legacy).
///
/// Common keys: `source`, `status`, `paymentId`, `orderId`, `message`.
typedef PaymentCallbackResult = Map<String, String?>;
