sealed class PaymentEvent {
  const PaymentEvent();
}

class PaymentLoadEvent extends PaymentEvent {
  const PaymentLoadEvent();
}

class PaymentRetryEvent extends PaymentEvent {
  const PaymentRetryEvent();
}

class PaymentSelectAddressEvent extends PaymentEvent {
  const PaymentSelectAddressEvent(this.addressId);

  final String addressId;
}

class PaymentSelectDeliverySlotEvent extends PaymentEvent {
  const PaymentSelectDeliverySlotEvent(this.deliverySlotId);

  final String deliverySlotId;
}

class PaymentSelectPaymentMethodEvent extends PaymentEvent {
  const PaymentSelectPaymentMethodEvent(this.paymentMethodCode);

  final String paymentMethodCode;
}

class PaymentApplyPromoEvent extends PaymentEvent {
  const PaymentApplyPromoEvent(this.code);

  final String code;
}

class PaymentRemovePromoEvent extends PaymentEvent {
  const PaymentRemovePromoEvent();
}

class PaymentPlaceOrderEvent extends PaymentEvent {
  const PaymentPlaceOrderEvent();
}

class PaymentRequestAddressSelectionEvent extends PaymentEvent {
  const PaymentRequestAddressSelectionEvent();
}

class PaymentHandleAddressSelectionResultEvent extends PaymentEvent {
  const PaymentHandleAddressSelectionResultEvent(this.result);

  final String? result;
}

class PaymentHandleAddAddressCompletedEvent extends PaymentEvent {
  const PaymentHandleAddAddressCompletedEvent();
}

class PaymentClearFeedbackEvent extends PaymentEvent {
  const PaymentClearFeedbackEvent();
}

class PaymentClearPlacedOrderEvent extends PaymentEvent {
  const PaymentClearPlacedOrderEvent();
}

class PaymentClearUiEffectEvent extends PaymentEvent {
  const PaymentClearUiEffectEvent();
}
