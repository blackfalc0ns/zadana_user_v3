import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/delete_order_response_entity.dart';

part 'delete_order_response_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DeleteOrderResponseDto {
  const DeleteOrderResponseDto({
    required this.message,
    required this.orderId,
    required this.deleted,
  });

  factory DeleteOrderResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteOrderResponseDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String message;
  @JsonKey(defaultValue: '')
  final String orderId;
  @JsonKey(defaultValue: false)
  final bool deleted;

  Map<String, dynamic> toJson() => _$DeleteOrderResponseDtoToJson(this);

  DeleteOrderResponseEntity toEntity() {
    return DeleteOrderResponseEntity(
      message: message,
      orderId: orderId,
      deleted: deleted,
    );
  }
}
