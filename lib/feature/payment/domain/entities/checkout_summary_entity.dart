import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_delivery_check_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/estimated_delivery_window_entity.dart';

class CheckoutSummaryEntity {
  const CheckoutSummaryEntity({
    required this.cart,
    required this.availableAddresses,
    required this.deliverySlots,
    required this.paymentMethods,
    required this.summary,
    required this.shippingBreakdown,
    this.fulfillmentType = 'delivery',
    this.selectedAddress,
    this.pickupBranch,
    this.promoCode,
    this.deliveryQuote,
    this.pricingMode,
    this.deliveryCheck,
    this.estimatedDeliveryWindow,
  });

  final CheckoutCartEntity cart;
  final List<CheckoutAddressEntity> availableAddresses;
  final String fulfillmentType;
  final CheckoutAddressEntity? selectedAddress;
  final CheckoutBranchEntity? pickupBranch;
  final List<CheckoutDeliverySlotEntity> deliverySlots;
  final List<CheckoutPaymentMethodEntity> paymentMethods;
  final CheckoutPromoCodeEntity? promoCode;
  final CheckoutDeliveryQuoteEntity? deliveryQuote;
  final List<CheckoutShippingLineEntity> shippingBreakdown;
  final String? pricingMode;
  final CheckoutTotalsEntity summary;
  final CheckoutDeliveryCheckEntity? deliveryCheck;
  final EstimatedDeliveryWindowEntity? estimatedDeliveryWindow;

  /// Whether delivery is valid based on the backend delivery check.
  /// Returns true if no delivery check is present (backwards compatibility).
  bool get isDeliveryValid =>
      deliveryCheck == null || deliveryCheck!.canProceedToCheckout;

  bool get isPickup => fulfillmentType.trim().toLowerCase() == 'pickup';

  CheckoutSummaryEntity copyWith({
    CheckoutCartEntity? cart,
    List<CheckoutAddressEntity>? availableAddresses,
    String? fulfillmentType,
    CheckoutAddressEntity? selectedAddress,
    bool clearSelectedAddress = false,
    CheckoutBranchEntity? pickupBranch,
    bool clearPickupBranch = false,
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
    CheckoutDeliveryCheckEntity? deliveryCheck,
    bool clearDeliveryCheck = false,
    EstimatedDeliveryWindowEntity? estimatedDeliveryWindow,
    bool clearEstimatedDeliveryWindow = false,
  }) {
    return CheckoutSummaryEntity(
      cart: cart ?? this.cart,
      availableAddresses: availableAddresses ?? this.availableAddresses,
      fulfillmentType: fulfillmentType ?? this.fulfillmentType,
      selectedAddress: clearSelectedAddress
          ? null
          : selectedAddress ?? this.selectedAddress,
      pickupBranch: clearPickupBranch ? null : pickupBranch ?? this.pickupBranch,
      deliverySlots: deliverySlots ?? this.deliverySlots,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      promoCode: clearPromoCode ? null : promoCode ?? this.promoCode,
      deliveryQuote: clearDeliveryQuote
          ? null
          : deliveryQuote ?? this.deliveryQuote,
      shippingBreakdown: shippingBreakdown ?? this.shippingBreakdown,
      pricingMode: clearPricingMode ? null : pricingMode ?? this.pricingMode,
      summary: summary ?? this.summary,
      deliveryCheck: clearDeliveryCheck
          ? null
          : deliveryCheck ?? this.deliveryCheck,
      estimatedDeliveryWindow: clearEstimatedDeliveryWindow
          ? null
          : estimatedDeliveryWindow ?? this.estimatedDeliveryWindow,
    );
  }
}

class CheckoutCartEntity {
  const CheckoutCartEntity({
    required this.itemsCount,
    required this.totalQuantity,
    required this.items,
    this.hasUnavailableItems = false,
    this.unavailableItemsCount = 0,
    this.requiresUnavailableItemsConfirmation = false,
    this.unavailableItems = const [],
  });

  final int itemsCount;
  final int totalQuantity;
  final List<CheckoutCartItemEntity> items;
  final bool hasUnavailableItems;
  final int unavailableItemsCount;
  final bool requiresUnavailableItemsConfirmation;
  final List<CheckoutUnavailableCartItemEntity> unavailableItems;
}

class CheckoutUnavailableCartItemEntity {
  const CheckoutUnavailableCartItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.availabilityStatus,
  });

  final String id;
  final String productId;
  final String name;
  final int quantity;
  final String availabilityStatus;
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
    this.variantDisplaySize,
    this.packageTypeName,
    this.measurementValue,
    this.measurementUnitName,
    this.variantImageUrl,
    this.variantImages = const [],
  });

  final String id;
  final String productId;
  final String name;
  final String? imageUrl;
  final String? unit;
  final int quantity;
  final double price;
  final double totalPrice;
  final String? variantDisplaySize;
  final String? packageTypeName;
  final String? measurementValue;
  final String? measurementUnitName;
  final String? variantImageUrl;
  final List<String> variantImages;

  /// Returns the best available image URL for this item.
  /// Priority: variantImageUrl → first of variantImages → imageUrl
  String? get displayImageUrl =>
      variantImageUrl ??
      (variantImages.isNotEmpty ? variantImages.first : null) ??
      imageUrl;
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

class CheckoutBranchEntity {
  const CheckoutBranchEntity({
    required this.id,
    required this.name,
    this.addressLine,
    this.city,
    this.address,
    this.hoursToday,
  });

  final String id;
  final String name;
  final String? addressLine;
  final String? city;
  final String? address;
  final String? hoursToday;

  String get displayAddress {
    if (address != null && address!.trim().isNotEmpty) {
      return address!.trim();
    }

    final parts = <String>[
      if (addressLine != null && addressLine!.trim().isNotEmpty)
        addressLine!.trim(),
      if (city != null && city!.trim().isNotEmpty) city!.trim(),
    ];
    return parts.join(', ');
  }
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
