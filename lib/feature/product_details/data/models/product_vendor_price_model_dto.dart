class ProductVendorPriceModelDto {
  final String? id;
  final String? name;
  final String? logoUrl;
  final double? price;
  final double? oldPrice;
  final bool? isDiscounted;

  const ProductVendorPriceModelDto({
    this.id,
    this.name,
    this.logoUrl,
    this.price,
    this.oldPrice,
    this.isDiscounted,
  });

  factory ProductVendorPriceModelDto.fromJson(Map<String, dynamic> json) {
    return ProductVendorPriceModelDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      logoUrl: json['logo_url'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      oldPrice: (json['old_price'] as num?)?.toDouble(),
      isDiscounted: json['is_discounted'] as bool?,
    );
  }
}
