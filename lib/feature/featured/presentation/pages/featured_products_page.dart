import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/pagination/models/paginated_section_state.dart';
import 'package:zadana_user_v3/core/pagination/widgets/paginated_products_grid_page.dart';
import 'package:zadana_user_v3/feature/featured/presentation/manager/featured_products_cubit.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/domain/usecase/get_home_featured_products_usecase.dart';

class FeaturedProductsPage extends StatelessWidget {
  const FeaturedProductsPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeaturedProductsCubit(
        getIt<GetHomeFeaturedProductsUseCase>(),
        title: title,
      )..loadInitial(),
      child:
          BlocBuilder<
            FeaturedProductsCubit,
            PaginatedSectionState<ProductModel>
          >(
            builder: (context, state) {
              final cubit = context.read<FeaturedProductsCubit>();
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
