import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/pagination/models/paginated_section_state.dart';
import 'package:zadana_user_v3/core/pagination/widgets/paginated_products_grid_page.dart';
import 'package:zadana_user_v3/core/utils/bloc_provider_utils.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/best_selling/presentation/manager/best_selling_products_cubit.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class BestSellingProductsPage extends StatelessWidget {
  const BestSellingProductsPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final globalCubit = maybeReadBloc<AppSectionGlobalCubit>(context);
    final page = BlocProvider(
      create: (_) =>
          getIt<BestSellingProductsCubit>(param1: title)..loadInitial(),
      child:
          BlocBuilder<
            BestSellingProductsCubit,
            PaginatedSectionState<ProductModel>
          >(
            builder: (context, state) {
              final cubit = context.read<BestSellingProductsCubit>();
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

    if (globalCubit == null) {
      return page;
    }

    return BlocProvider.value(value: globalCubit, child: page);
  }
}
