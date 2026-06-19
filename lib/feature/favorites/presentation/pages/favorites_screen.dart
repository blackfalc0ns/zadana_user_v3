import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/utils/bloc_provider_utils.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/favorites/domain/usecase/clear_favorites_usecase.dart';
import 'package:zadana_user_v3/feature/favorites/domain/usecase/get_favorites_usecase.dart';
import 'package:zadana_user_v3/feature/favorites/domain/usecase/remove_favorite_usecase.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/manager/favorites_state.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/manager/favorites_view_model.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/clear_all_dialog.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_app_bar.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_empty_state.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_grid.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final existingViewModel = maybeReadBloc<FavoritesViewModel>(context);
    if (existingViewModel != null) {
      return BlocProvider.value(
        value: existingViewModel,
        child: const _FavoritesScreenView(),
      );
    }

    final getIt = GetIt.instance;
    return BlocProvider(
      create: (_) => FavoritesViewModel(
        getIt<GetFavoritesUseCase>(),
        getIt<RemoveFavoriteUseCase>(),
        getIt<ClearFavoritesUseCase>(),
      )..loadFavorites(),
      child: const _FavoritesScreenView(),
    );
  }
}

class _FavoritesScreenView extends StatelessWidget {
  const _FavoritesScreenView();

  Future<void> _toggleFavorite(
    BuildContext context,
    FavoritesViewModel viewModel,
    ProductModel product,
  ) async {
    viewModel.removeFavorite(product.id);
  }

  Future<void> _addToCart(BuildContext context, ProductModel product) {
    return HomeProductCartHelper.addProductToCart(context, product);
  }

  void _showClearDialog(BuildContext context, FavoritesViewModel viewModel) {
    showClearAllDialog(
      context: context,
      onConfirm: () => viewModel.clearAllFavorites(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FavoritesViewModel>();

    return BlocListener<FavoritesViewModel, FavoritesState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          CustomSnackbar.showError(
            context: context,
            message: state.errorMessage!,
          );
          context.read<FavoritesViewModel>().clearError();
        }
        if (state.successMessage != null) {
          CustomSnackbar.showSuccess(
            context: context,
            message: state.successMessage!,
          );
          context.read<FavoritesViewModel>().clearSuccess();
        }
      },
      child: BlocBuilder<FavoritesViewModel, FavoritesState>(
        builder: (context, state) {
          final color = context.colorScheme;
          final isEmpty = state.items.isEmpty;
          final hasBlockingError = state.failure != null && isEmpty;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: color.surface,
              appBar: FavoritesAppBar(
                itemCount: state.itemsCount,
                onClearAll: isEmpty
                    ? null
                    : () => _showClearDialog(context, viewModel),
              ),
              body: state.isLoading
                  ? const FavoritesLoadingSkeleton()
                  : hasBlockingError
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ApiErrorWidget(
                            exception: state.failure!.exception,
                            onRetry: () {
                            context.read<FavoritesViewModel>().clearFailure();
                            context.read<FavoritesViewModel>().loadFavorites();
                          },
                        ),
                      ),
                    )
                  : isEmpty
                  ? FavoritesEmptyState(
                      onStartShopping: () =>
                          mainShellKey.currentState?.jumpToTab(0),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        bottom: 90,
                        left: 12,
                        right: 12,
                      ),
                      child: FavoritesGrid(
                        products: state.items,
                        isLoadingMore: state.isLoadingMore,
                        hasMore: state.hasMore,
                        onAddToCart: (product) => _addToCart(context, product),
                        onToggleFavorite: (product) =>
                            _toggleFavorite(context, viewModel, product),
                        onLoadMore: () => viewModel.loadMore(),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
