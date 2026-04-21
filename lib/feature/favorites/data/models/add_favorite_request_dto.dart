import 'package:json_annotation/json_annotation.dart';

part 'add_favorite_request_dto.g.dart';

@JsonSerializable()
class AddFavoriteRequestDto {
  const AddFavoriteRequestDto({required this.productId});

  factory AddFavoriteRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AddFavoriteRequestDtoFromJson(json);

  @JsonKey(name: 'productId')
  final String productId;

  Map<String, dynamic> toJson() => _$AddFavoriteRequestDtoToJson(this);
}
