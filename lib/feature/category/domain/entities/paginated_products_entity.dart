import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class PaginatedProductsEntity {
  const PaginatedProductsEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
    this.breadcrumbCategoryId,
    this.breadcrumbCategoryName,
    this.breadcrumbSubCategoryId,
    this.breadcrumbSubCategoryName,
  });

  final List<ProductModel> items;
  final int total;
  final int page;
  final int perPage;
  final String? breadcrumbCategoryId;
  final String? breadcrumbCategoryName;
  final String? breadcrumbSubCategoryId;
  final String? breadcrumbSubCategoryName;

  bool get hasMore => items.length >= perPage && (page * perPage) < total;

  bool get hasBreadcrumb =>
      breadcrumbCategoryId != null && breadcrumbCategoryId!.isNotEmpty;
}
