import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/section_listing_shared/presentation/manager/paginated_section_state.dart';
import 'package:zadana_user_v3/feature/section_listing_shared/presentation/widgets/paginated_products_grid_page.dart';
import 'package:zadana_user_v3/feature/special_offers/presentation/manager/special_offers_products_cubit.dart';

class SpecialOffersProductsPage extends StatelessWidget {
  const SpecialOffersProductsPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<SpecialOffersProductsCubit>(param1: title)..loadInitial(),
      child:
          BlocBuilder<
            SpecialOffersProductsCubit,
            PaginatedSectionState<ProductModel>
          >(
            builder: (context, state) {
              final cubit = context.read<SpecialOffersProductsCubit>();
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
