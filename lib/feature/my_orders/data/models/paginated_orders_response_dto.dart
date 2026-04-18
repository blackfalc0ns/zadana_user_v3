import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_list_item_dto.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/paginated_orders_entity.dart';

part 'paginated_orders_response_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PaginatedOrdersResponseDto {
  const PaginatedOrdersResponseDto({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
  });

  factory PaginatedOrdersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PaginatedOrdersResponseDtoFromJson(json);

  final List<OrderListItemDto> items;
  final int page;
  final int perPage;
  final int total;

  Map<String, dynamic> toJson() => _$PaginatedOrdersResponseDtoToJson(this);

  PaginatedOrdersEntity toEntity() {
    return PaginatedOrdersEntity(
      items: items.map((item) => item.toEntity()).toList(),
      page: page,
      perPage: perPage,
      total: total,
    );
  }
}
