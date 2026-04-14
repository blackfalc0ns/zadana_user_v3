import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class ProductSearchState {
  const ProductSearchState({
    this.query = '',
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.totalCount = 0,
    this.failure,
  });

  final String query;
  final List<ProductModel> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int totalCount;
  final Failure? failure;

  bool get hasQuery => query.trim().isNotEmpty;

  ProductSearchState copyWith({
    String? query,
    List<ProductModel>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? totalCount,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProductSearchState(
      query: query ?? this.query,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
