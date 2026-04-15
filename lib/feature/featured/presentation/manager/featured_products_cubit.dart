import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_featured_entity.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_featured_products_usecase.dart';
import 'package:zadana_user_v3/feature/section_listing_shared/presentation/manager/home_paginated_products_cubit.dart';
import 'package:zadana_user_v3/feature/section_listing_shared/presentation/manager/paginated_section_page_data.dart';

class FeaturedProductsCubit extends HomePaginatedProductsCubit {
  FeaturedProductsCubit(
    this._getHomeFeaturedProductsUseCase, {
    required String title,
  }) : super(initialTitle: title);

  final GetHomeFeaturedProductsUseCase _getHomeFeaturedProductsUseCase;

  @override
  Future<ApiResult<PaginatedSectionPageData<ProductModel>>> fetchSection(
    int take,
  ) async {
    final result = await _getHomeFeaturedProductsUseCase();
    switch (result) {
      case ApiSuccessResult<HomeFeaturedEntity>():
        return ApiSuccessResult(
          data: PaginatedSectionPageData<ProductModel>(
            title: result.data.title,
            totalCount: result.data.itemsCount,
            items: result.data.items,
          ),
        );
      case ApiErrorResult<HomeFeaturedEntity>():
        return ApiErrorResult(failure: result.failure);
    }
  }
}
