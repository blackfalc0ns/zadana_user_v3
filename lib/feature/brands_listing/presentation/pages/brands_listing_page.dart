import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brands_listing/presentation/manager/brands_listing_cubit.dart';
import 'package:zadana_user_v3/feature/section_listing_shared/presentation/manager/paginated_section_state.dart';
import 'package:zadana_user_v3/feature/section_listing_shared/presentation/widgets/paginated_brands_grid_page.dart';

class BrandsListingPage extends StatelessWidget {
  const BrandsListingPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BrandsListingCubit>(param1: title)..loadInitial(),
      child: BlocBuilder<BrandsListingCubit, PaginatedSectionState<BrandModel>>(
        builder: (context, state) {
          final cubit = context.read<BrandsListingCubit>();
          return PaginatedBrandsGridPage(
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
