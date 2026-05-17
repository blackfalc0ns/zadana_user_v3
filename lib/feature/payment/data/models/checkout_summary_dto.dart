import 'package:zadana_user_v3/feature/payment/data/models/checkout_delivery_check_dto.dart';
import 'package:zadana_user_v3/feature/payment/data/models/estimated_delivery_window_dto.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';

class CheckoutSummaryDto {
  const CheckoutSummaryDto({
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
    this.deliveryCheck,
    this.estimatedDeliveryWindow,
  });

  factory CheckoutSummaryDto.fromJson(Map<String, dynamic> json) {
    return CheckoutSummaryDto(
      cart: CheckoutCartDto.fromJson(_asMap(json['cart'])),
      selectedAddress: _nullableMap(json['selected_address']) == null
          ? null
          : CheckoutAddressDto.fromJson(_asMap(json['selected_address'])),
      availableAddresses: _asList(json['available_addresses'])
          .map((item) => CheckoutAddressDto.fromJson(_asMap(item)))
          .toList(),
      deliverySlots: _asList(json['delivery_slots'])
          .map((item) => CheckoutDeliverySlotDto.fromJson(_asMap(item)))
          .toList(),
      paymentMethods: _asList(json['payment_methods'])
          .map((item) => CheckoutPaymentMethodDto.fromJson(_asMap(item)))
          .toList(),
      promoCode: _nullableMap(json['promo_code']) == null
          ? null
          : CheckoutPromoCodeDto.fromJson(_asMap(json['promo_code'])),
      deliveryQuote: _nullableMap(json['delivery_quote']) == null
          ? null
          : CheckoutDeliveryQuoteDto.fromJson(_asMap(json['delivery_quote'])),
      shippingBreakdown: _asList(json['shipping_breakdown'])
          .map((item) => CheckoutShippingLineDto.fromJson(_asMap(item)))
          .toList(),
      pricingMode: json['pricing_mode']?.toString(),
      summary: CheckoutTotalsDto.fromJson(_asMap(json['summary'])),
      deliveryCheck: _nullableMap(json['delivery_check']) == null
          ? null
          : CheckoutDeliveryCheckDto.fromJson(_asMap(json['delivery_check'])),
      estimatedDeliveryWindow:
          _nullableMap(json['estimated_delivery_window']) == null
              ? null
              : EstimatedDeliveryWindowDto.fromJson(
                  _asMap(json['estimated_delivery_window']),
                ),
    );
  }

  final CheckoutCartDto cart;
  final List<CheckoutAddressDto> availableAddresses;
  final CheckoutAddressDto? selectedAddress;
  final List<CheckoutDeliverySlotDto> deliverySlots;
  final List<CheckoutPaymentMethodDto> paymentMethods;
  final CheckoutPromoCodeDto? promoCode;
  final CheckoutDeliveryQuoteDto? deliveryQuote;
  final List<CheckoutShippingLineDto> shippingBreakdown;
  final String? pricingMode;
  final CheckoutTotalsDto summary;
  final CheckoutDeliveryCheckDto? deliveryCheck;
  final EstimatedDeliveryWindowDto? estimatedDeliveryWindow;

  CheckoutSummaryEntity toEntity() {
    return CheckoutSummaryEntity(
      cart: cart.toEntity(),
      availableAddresses: availableAddresses
          .map((item) => item.toEntity())
          .toList(),
      selectedAddress: selectedAddress?.toEntity(),
      deliverySlots: deliverySlots.map((item) => item.toEntity()).toList(),
      paymentMethods: paymentMethods.map((item) => item.toEntity()).toList(),
      promoCode: promoCode?.toEntity(),
      deliveryQuote: deliveryQuote?.toEntity(),
      shippingBreakdown: shippingBreakdown.map((item) => item.toEntity()).toList(),
      pricingMode: pricingMode,
      summary: summary.toEntity(),
      deliveryCheck: deliveryCheck?.toEntity(),
      estimatedDeliveryWindow: estimatedDeliveryWindow?.toEntity(),
    );
  }
}

class CheckoutCartDto {
  const CheckoutCartDto({
    required this.itemsCount,
    required this.totalQuantity,
    required this.items,
  });

  factory CheckoutCartDto.fromJson(Map<String, dynamic> json) {
    return CheckoutCartDto(
      itemsCount: _asInt(json['items_count']),
      totalQuantity: _asInt(json['total_quantity']),
      items: _asList(json['items'])
          .map((item) => CheckoutCartItemDto.fromJson(_asMap(item)))
          .toList(),
    );
  }

  final int itemsCount;
  final int totalQuantity;
  final List<CheckoutCartItemDto> items;

  CheckoutCartEntity toEntity() {
    return CheckoutCartEntity(
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }
}

class CheckoutCartItemDto {
  const CheckoutCartItemDto({
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

  factory CheckoutCartItemDto.fromJson(Map<String, dynamic> json) {
    return CheckoutCartItemDto(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      unit: json['unit']?.toString(),
      quantity: _asInt(json['quantity']),
      price: _asDouble(json['price']),
      totalPrice: _asDouble(json['total_price']),
      variantDisplaySize: json['variant_display_size']?.toString(),
      packageTypeName: json['package_type_name']?.toString(),
      measurementValue: json['measurement_value']?.toString(),
      measurementUnitName: json['measurement_unit_name']?.toString(),
      variantImageUrl: json['variant_image_url']?.toString(),
      variantImages: _asList(json['variant_images'])
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList(),
    );
  }

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

  CheckoutCartItemEntity toEntity() {
    return CheckoutCartItemEntity(
      id: id,
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      unit: unit,
      quantity: quantity,
      price: price,
      totalPrice: totalPrice,
      variantDisplaySize: variantDisplaySize,
      packageTypeName: packageTypeName,
      measurementValue: measurementValue,
      measurementUnitName: measurementUnitName,
      variantImageUrl: variantImageUrl,
      variantImages: variantImages,
    );
  }
}

class CheckoutAddressDto {
  const CheckoutAddressDto({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.isDefault,
  });

  factory CheckoutAddressDto.fromJson(Map<String, dynamic> json) {
    return CheckoutAddressDto(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      addressLine: json['address_line']?.toString() ?? '',
      isDefault: json['is_default'] == true,
    );
  }

  final String id;
  final String label;
  final String addressLine;
  final bool isDefault;

  CheckoutAddressEntity toEntity() {
    return CheckoutAddressEntity(
      id: id,
      label: label,
      addressLine: addressLine,
      isDefault: isDefault,
    );
  }
}

class CheckoutDeliverySlotDto {
  const CheckoutDeliverySlotDto({
    required this.id,
    required this.labelAr,
    required this.labelEn,
    required this.startAt,
    required this.endAt,
    required this.isAvailable,
    required this.isSelected,
  });

  factory CheckoutDeliverySlotDto.fromJson(Map<String, dynamic> json) {
    return CheckoutDeliverySlotDto(
      id: json['id']?.toString() ?? '',
      labelAr: _readLocalizedValue(
        json,
        arabicKey: 'label_ar',
        englishKey: 'label_en',
        fallbackKey: 'label',
        preferArabic: true,
      ),
      labelEn: _readLocalizedValue(
        json,
        arabicKey: 'label_ar',
        englishKey: 'label_en',
        fallbackKey: 'label',
        preferArabic: false,
      ),
      startAt: _asDateTime(json['start_at']),
      endAt: _asDateTime(json['end_at']),
      isAvailable: json['is_available'] == true,
      isSelected: json['is_selected'] == true,
    );
  }

  final String id;
  final String labelAr;
  final String labelEn;
  final DateTime startAt;
  final DateTime endAt;
  final bool isAvailable;
  final bool isSelected;

  CheckoutDeliverySlotEntity toEntity() {
    return CheckoutDeliverySlotEntity(
      id: id,
      labelAr: labelAr,
      labelEn: labelEn,
      startAt: startAt,
      endAt: endAt,
      isAvailable: isAvailable,
      isSelected: isSelected,
    );
  }
}

class CheckoutPaymentMethodDto {
  const CheckoutPaymentMethodDto({
    required this.code,
    required this.labelAr,
    required this.labelEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.isAvailable,
    required this.isDefault,
  });

  factory CheckoutPaymentMethodDto.fromJson(Map<String, dynamic> json) {
    return CheckoutPaymentMethodDto(
      code: json['code']?.toString() ?? '',
      labelAr: _readLocalizedValue(
        json,
        arabicKey: 'label_ar',
        englishKey: 'label_en',
        fallbackKey: 'label',
        preferArabic: true,
      ),
      labelEn: _readLocalizedValue(
        json,
        arabicKey: 'label_ar',
        englishKey: 'label_en',
        fallbackKey: 'label',
        preferArabic: false,
      ),
      descriptionAr: _readLocalizedValue(
        json,
        arabicKey: 'description_ar',
        englishKey: 'description_en',
        fallbackKey: 'description',
        preferArabic: true,
      ),
      descriptionEn: _readLocalizedValue(
        json,
        arabicKey: 'description_ar',
        englishKey: 'description_en',
        fallbackKey: 'description',
        preferArabic: false,
      ),
      isAvailable: json['is_available'] == true,
      isDefault: json['is_default'] == true,
    );
  }

  final String code;
  final String labelAr;
  final String labelEn;
  final String descriptionAr;
  final String descriptionEn;
  final bool isAvailable;
  final bool isDefault;

  CheckoutPaymentMethodEntity toEntity() {
    return CheckoutPaymentMethodEntity(
      code: code,
      labelAr: labelAr,
      labelEn: labelEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      isAvailable: isAvailable,
      isDefault: isDefault,
    );
  }
}

class CheckoutPromoCodeDto {
  const CheckoutPromoCodeDto({
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.discountAmount,
  });

  factory CheckoutPromoCodeDto.fromJson(Map<String, dynamic> json) {
    return CheckoutPromoCodeDto(
      code: json['code']?.toString() ?? '',
      discountType: json['discount_type']?.toString() ?? '',
      discountValue: _asDouble(json['discount_value']),
      discountAmount: _asDouble(json['discount_amount']),
    );
  }

  final String code;
  final String discountType;
  final double discountValue;
  final double discountAmount;

  CheckoutPromoCodeEntity toEntity() {
    return CheckoutPromoCodeEntity(
      code: code,
      discountType: discountType,
      discountValue: discountValue,
      discountAmount: discountAmount,
    );
  }
}

class CheckoutDeliveryQuoteDto {
  const CheckoutDeliveryQuoteDto({
    required this.distanceKm,
    required this.baseFee,
    required this.distanceFee,
    required this.surgeFee,
    required this.totalFee,
    this.pricingMode,
    this.ruleLabel,
  });

  factory CheckoutDeliveryQuoteDto.fromJson(Map<String, dynamic> json) {
    return CheckoutDeliveryQuoteDto(
      distanceKm: _asDouble(json['distance_km']),
      baseFee: _asDouble(json['base_fee']),
      distanceFee: _asDouble(json['distance_fee']),
      surgeFee: _asDouble(json['surge_fee']),
      totalFee: _asDouble(json['total_fee']),
      pricingMode: json['pricing_mode']?.toString(),
      ruleLabel: json['rule_label']?.toString(),
    );
  }

  final double distanceKm;
  final double baseFee;
  final double distanceFee;
  final double surgeFee;
  final double totalFee;
  final String? pricingMode;
  final String? ruleLabel;

  CheckoutDeliveryQuoteEntity toEntity() {
    return CheckoutDeliveryQuoteEntity(
      distanceKm: distanceKm,
      baseFee: baseFee,
      distanceFee: distanceFee,
      surgeFee: surgeFee,
      totalFee: totalFee,
      pricingMode: pricingMode,
      ruleLabel: ruleLabel,
    );
  }
}

class CheckoutShippingLineDto {
  const CheckoutShippingLineDto({
    required this.code,
    required this.labelAr,
    required this.labelEn,
    required this.amount,
  });

  factory CheckoutShippingLineDto.fromJson(Map<String, dynamic> json) {
    return CheckoutShippingLineDto(
      code: json['code']?.toString() ?? '',
      labelAr: _readLocalizedValue(
        json,
        arabicKey: 'label_ar',
        englishKey: 'label_en',
        fallbackKey: 'label',
        preferArabic: true,
      ),
      labelEn: _readLocalizedValue(
        json,
        arabicKey: 'label_ar',
        englishKey: 'label_en',
        fallbackKey: 'label',
        preferArabic: false,
      ),
      amount: _asDouble(json['amount']),
    );
  }

  final String code;
  final String labelAr;
  final String labelEn;
  final double amount;

  CheckoutShippingLineEntity toEntity() {
    return CheckoutShippingLineEntity(
      code: code,
      labelAr: labelAr,
      labelEn: labelEn,
      amount: amount,
    );
  }
}

class CheckoutTotalsDto {
  const CheckoutTotalsDto({
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.total,
    required this.currency,
    this.vatAmount,
    this.codFee,
  });

  factory CheckoutTotalsDto.fromJson(Map<String, dynamic> json) {
    return CheckoutTotalsDto(
      subtotal: _asDouble(json['subtotal']),
      shippingCost: _asDouble(json['shipping_cost']),
      discount: _asDouble(json['discount']),
      total: _asDouble(json['total']),
      currency: json['currency']?.toString() ?? '',
      vatAmount: _asNullableDouble(json['vat_amount']),
      codFee: _asNullableDouble(json['cod_fee']),
    );
  }

  final double subtotal;
  final double shippingCost;
  final double discount;
  final double total;
  final String currency;
  final double? vatAmount;
  final double? codFee;

  CheckoutTotalsEntity toEntity() {
    return CheckoutTotalsEntity(
      subtotal: subtotal,
      shippingCost: shippingCost,
      discount: discount,
      total: total,
      currency: currency,
      vatAmount: vatAmount,
      codFee: codFee,
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

Map<String, dynamic>? _nullableMap(dynamic value) {
  return value is Map<String, dynamic> ? value : null;
}

List<dynamic> _asList(dynamic value) {
  return value is List ? value : const [];
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is String && value.trim().isEmpty) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

DateTime _asDateTime(dynamic value) {
  return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
}

String _readLocalizedValue(
  Map<String, dynamic> json, {
  required String arabicKey,
  required String englishKey,
  required String fallbackKey,
  required bool preferArabic,
}) {
  final primary = preferArabic ? arabicKey : englishKey;
  final secondary = preferArabic ? englishKey : arabicKey;

  return _readString(json[primary]) ??
      _readString(json[secondary]) ??
      _readString(json[fallbackKey]) ??
      '';
}

String? _readString(dynamic value) {
  final normalized = value?.toString().trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }

  return normalized;
}
