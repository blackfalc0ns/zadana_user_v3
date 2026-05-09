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

  factory PaginatedOrdersResponseDto.fromJson(Map<String, dynamic> json) {
    return PaginatedOrdersResponseDto(
      items: _list(
        json['items'],
      ).map((item) => OrderListItemDto.fromJson(_map(item))).toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

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

  static Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }

    return const <String, dynamic>{};
  }

  static List<dynamic> _list(dynamic value) {
    if (value is List) return value;
    return const <dynamic>[];
  }
}
