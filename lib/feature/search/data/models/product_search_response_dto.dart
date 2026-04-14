import 'package:zadana_user_v3/feature/search/data/models/product_search_item_dto.dart';

class ProductSearchResponseDto {
  const ProductSearchResponseDto({
    this.query,
    this.total,
    this.page,
    this.perPage,
    this.items,
  });

  factory ProductSearchResponseDto.fromJson(Map<String, dynamic> json) {
    return ProductSearchResponseDto(
      query: json['query'] as String?,
      total: json['total'] as int?,
      page: json['page'] as int?,
      perPage: json['per_page'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (item) =>
                ProductSearchItemDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final String? query;
  final int? total;
  final int? page;
  final int? perPage;
  final List<ProductSearchItemDto>? items;
}
