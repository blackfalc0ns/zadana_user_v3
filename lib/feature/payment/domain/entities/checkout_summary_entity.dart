class CheckoutSummaryEntity {
  const CheckoutSummaryEntity({
    required this.cart,
    required this.availableAddresses,
    required this.deliverySlots,
    required this.paymentMethods,
    required this.summary,
    required this.shippingBreakdown,
    this.selectedAddress,
    this.promoCode,
    this.deliveryQuote,
    this.pricingMode,
  });

  final CheckoutCartEntity cart;
  final List<CheckoutAddressEntity> availableAddresses;
  final CheckoutAddressEntity? selectedAddress;
  final List<CheckoutDeliverySlotEntity> deliverySlots;
  final List<CheckoutPaymentMethodEntity> paymentMethods;
  final CheckoutPromoCodeEntity? promoCode;
  final CheckoutDeliveryQuoteEntity? deliveryQuote;
  final List<CheckoutShippingLineEntity> shippingBreakdown;
  final String? pricingMode;
  final CheckoutTotalsEntity summary;

  CheckoutSummaryEntity copyWith({
    CheckoutCartEntity? cart,
    List<CheckoutAddressEntity>? availableAddresses,
    CheckoutAddressEntity? selectedAddress,
    bool clearSelectedAddress = false,
    List<CheckoutDeliverySlotEntity>? deliverySlots,
    List<CheckoutPaymentMethodEntity>? paymentMethods,
    CheckoutPromoCodeEntity? promoCode,
    bool clearPromoCode = false,
    CheckoutDeliveryQuoteEntity? deliveryQuote,
    bool clearDeliveryQuote = false,
    List<CheckoutShippingLineEntity>? shippingBreakdown,
    String? pricingMode,
    bool clearPricingMode = false,
    CheckoutTotalsEntity? summary,
  }) {
    return CheckoutSummaryEntity(
      cart: cart ?? this.cart,
      availableAddresses: availableAddresses ?? this.availableAddresses,
      selectedAddress: clearSelectedAddress
          ? null
          : selectedAddress ?? this.selectedAddress,
      deliverySlots: deliverySlots ?? this.deliverySlots,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      promoCode: clearPromoCode ? null : promoCode ?? this.promoCode,
      deliveryQuote: clearDeliveryQuote
          ? null
          : deliveryQuote ?? this.deliveryQuote,
      shippingBreakdown: shippingBreakdown ?? this.shippingBreakdown,
      pricingMode: clearPricingMode ? null : pricingMode ?? this.pricingMode,
      summary: summary ?? this.summary,
    );
  }
}

class CheckoutCartEntity {
  const CheckoutCartEntity({
    required this.itemsCount,
    required this.totalQuantity,
    required this.items,
  });

  final int itemsCount;
  final int totalQuantity;
  final List<CheckoutCartItemEntity> items;
}

class CheckoutCartItemEntity {
  const CheckoutCartItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    this.imageUrl,
    this.unit,
  });

  final String id;
  final String productId;
  final String name;
  final String? imageUrl;
  final String? unit;
  final int quantity;
  final double price;
  final double totalPrice;
}

class CheckoutAddressEntity {
  const CheckoutAddressEntity({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.isDefault,
  });

  final String id;
  final String label;
  final String addressLine;
  final bool isDefault;
}

class CheckoutDeliverySlotEntity {
  const CheckoutDeliverySlotEntity({
    required this.id,
    required this.labelAr,
    required this.labelEn,
    required this.startAt,
    required this.endAt,
    required this.isAvailable,
    required this.isSelected,
  });

  final String id;
  final String labelAr;
  final String labelEn;
  final DateTime startAt;
  final DateTime endAt;
  final bool isAvailable;
  final bool isSelected;
}

class CheckoutPaymentMethodEntity {
  const CheckoutPaymentMethodEntity({
    required this.code,
    required this.labelAr,
    required this.labelEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.isAvailable,
    required this.isDefault,
  });

  final String code;
  final String labelAr;
  final String labelEn;
  final String descriptionAr;
  final String descriptionEn;
  final bool isAvailable;
  final bool isDefault;
}

class CheckoutPromoCodeEntity {
  const CheckoutPromoCodeEntity({
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.discountAmount,
  });

  final String code;
  final String discountType;
  final double discountValue;
  final double discountAmount;
}

class CheckoutDeliveryQuoteEntity {
  const CheckoutDeliveryQuoteEntity({
    required this.distanceKm,
    required this.baseFee,
    required this.distanceFee,
    required this.surgeFee,
    required this.totalFee,
    this.pricingMode,
    this.ruleLabel,
  });

  final double distanceKm;
  final double baseFee;
  final double distanceFee;
  final double surgeFee;
  final double totalFee;
  final String? pricingMode;
  final String? ruleLabel;
}

class CheckoutShippingLineEntity {
  const CheckoutShippingLineEntity({
    required this.code,
    required this.labelAr,
    required this.labelEn,
    required this.amount,
  });

  final String code;
  final String labelAr;
  final String labelEn;
  final double amount;
}

class CheckoutTotalsEntity {
  const CheckoutTotalsEntity({
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.total,
    required this.currency,
    this.vatAmount,
    this.codFee,
  });

  final double subtotal;
  final double shippingCost;
  final double discount;
  final double total;
  final String currency;
  final double? vatAmount;
  final double? codFee;
}
