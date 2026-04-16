import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/pagination/cubit/home_paginated_products_cubit.dart';
import 'package:zadana_user_v3/core/pagination/models/paginated_section_page_data.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_special_offers_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_special_offers_usecase.dart';

@injectable
class SpecialOffersProductsCubit extends HomePaginatedProductsCubit {
  SpecialOffersProductsCubit(
    this._getHomeSpecialOffersUseCase,
    @factoryParam String title,
  ) : super(initialTitle: title);

  final GetHomeSpecialOffersUseCase _getHomeSpecialOffersUseCase;

  @override
  Future<ApiResult<PaginatedSectionPageData<ProductModel>>> fetchSection(
    int take,
  ) async {
    final result = await _getHomeSpecialOffersUseCase(take: take);
    switch (result) {
      case ApiSuccessResult<HomeSpecialOffersEntity>():
        return ApiSuccessResult(
          data: PaginatedSectionPageData<ProductModel>(
            title: result.data.title,
            totalCount: result.data.itemsCount,
            items: result.data.items,
          ),
        );
      case ApiErrorResult<HomeSpecialOffersEntity>():
        return ApiErrorResult(failure: result.failure);
    }
  }
}
