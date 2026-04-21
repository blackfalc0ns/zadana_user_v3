import 'package:json_annotation/json_annotation.dart';

part 'favorites_summary_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FavoritesSummaryDto {
  const FavoritesSummaryDto({required this.itemsCount});

  factory FavoritesSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$FavoritesSummaryDtoFromJson(json);

  @JsonKey(defaultValue: 0)
  final int itemsCount;

  Map<String, dynamic> toJson() => _$FavoritesSummaryDtoToJson(this);
}
