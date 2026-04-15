import 'package:json_annotation/json_annotation.dart';

part 'home_response_model_dto.g.dart';

@JsonSerializable()
class HomeAppBarModelDto {
  const HomeAppBarModelDto({
    this.deliverToLabel,
    this.location,
    this.addressLine,
    this.notificationsCount,
  });

  factory HomeAppBarModelDto.fromJson(Map<String, dynamic> json) =>
      _$HomeAppBarModelDtoFromJson(json);
  @JsonKey(name: 'deliver_to_label')
  final String? deliverToLabel;
  final String? location;

  @JsonKey(name: 'address_line')
  final String? addressLine;

  @JsonKey(name: 'notifications_count')
  final int? notificationsCount;

  Map<String, dynamic> toJson() => _$HomeAppBarModelDtoToJson(this);
}
