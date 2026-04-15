import 'package:json_annotation/json_annotation.dart';

part 'vendor_price_response_dto.g.dart';

@JsonSerializable()
class VendorPriceResponseDto {
  factory VendorPriceResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VendorPriceResponseDtoFromJson(json);
  const VendorPriceResponseDto({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.isDiscounted,
  });

  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final bool isDiscounted;

  Map<String, dynamic> toJson() => _$VendorPriceResponseDtoToJson(this);
}
