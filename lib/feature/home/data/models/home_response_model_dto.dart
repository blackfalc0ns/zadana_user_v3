import 'package:json_annotation/json_annotation.dart';

part 'home_response_model_dto.g.dart';

@JsonSerializable()
class HomeAppBarModelDto {
  @JsonKey(name: 'deliver_to_label')
  final String? deliverToLabel;
  final String? location;

  @JsonKey(name: 'address_line')
  final String? addressLine;

  @JsonKey(name: 'notifications_count')
  final int? notificationsCount;

  const HomeAppBarModelDto({
    this.deliverToLabel,
    this.location,
    this.addressLine,
    this.notificationsCount,
  });

  factory HomeAppBarModelDto.fromJson(Map<String, dynamic> json) =>
      _$HomeAppBarModelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeAppBarModelDtoToJson(this);
}
