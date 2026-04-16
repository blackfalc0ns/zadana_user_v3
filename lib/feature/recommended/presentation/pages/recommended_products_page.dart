import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/pagination/models/paginated_section_state.dart';
import 'package:zadana_user_v3/core/pagination/widgets/paginated_products_grid_page.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/recommended/presentation/manager/recommended_products_cubit.dart';

class RecommendedProductsPage extends StatelessWidget {
  const RecommendedProductsPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<RecommendedProductsCubit>(param1: title)..loadInitial(),
      child:
          BlocBuilder<
            RecommendedProductsCubit,
            PaginatedSectionState<ProductModel>
          >(
            builder: (context, state) {
              final cubit = context.read<RecommendedProductsCubit>();
              return PaginatedProductsGridPage(
                title: title,
                state: state,
                onRefresh: cubit.refresh,
                onRetry: cubit.loadInitial,
                onLoadMore: cubit.loadMore,
              );
            },
          ),
    );
  }
}
