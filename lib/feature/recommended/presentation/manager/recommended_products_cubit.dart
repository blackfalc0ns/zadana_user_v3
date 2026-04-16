import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/pagination/cubit/home_paginated_products_cubit.dart';
import 'package:zadana_user_v3/core/pagination/models/paginated_section_page_data.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_recommended_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_recommended_usecase.dart';

@injectable
class RecommendedProductsCubit extends HomePaginatedProductsCubit {
  RecommendedProductsCubit(
    this._getHomeRecommendedUseCase,
    @factoryParam String title,
  ) : super(initialTitle: title);

  final GetHomeRecommendedUseCase _getHomeRecommendedUseCase;

  @override
  Future<ApiResult<PaginatedSectionPageData<ProductModel>>> fetchSection(
    int take,
  ) async {
    final result = await _getHomeRecommendedUseCase(take: take);
    switch (result) {
      case ApiSuccessResult<HomeRecommendedEntity>():
        return ApiSuccessResult(
          data: PaginatedSectionPageData<ProductModel>(
            title: result.data.title,
            totalCount: result.data.itemsCount,
            items: result.data.items,
          ),
        );
      case ApiErrorResult<HomeRecommendedEntity>():
        return ApiErrorResult(failure: result.failure);
    }
  }
}
