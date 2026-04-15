import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';
import 'package:zadana_user_v3/core/services/favorites_navigation_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/clear_all_dialog.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_app_bar.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_empty_state.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_grid.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/favorites/data/data_source/favorites_remote_data_source_impl.dart';
import 'package:zadana_user_v3/feature/favorites/data/repo/favorites_repository.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/manager/favorites_state.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/manager/favorites_view_model.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final getIt = GetIt.instance;
    _viewModel = FavoritesViewModel(
      FavoritesRepository(
        FavoritesRemoteDataSourceImpl(
          getIt<ApiServices>(),
          getIt<Dio>(),
          getIt<TokenService>(),
          getIt<DeviceIdService>(),
        ),
      ),
    )..loadFavorites();
    FavoritesNavigationService().addListener(_reloadFavorites);
  }

  @override
  void dispose() {
    FavoritesNavigationService().removeListener(_reloadFavorites);
    _viewModel.close();
    super.dispose();
  }

  void _reloadFavorites() {
    _viewModel.loadFavorites();
  }

  Future<void> _toggleFavorite(ProductModel product) async {
    _viewModel.removeFavorite(product.id);
  }

  Future<void> _addToCart(ProductModel product) {
    return HomeProductCartHelper.addProductToCart(context, product);
  }

  void _showClearDialog() {
    showClearAllDialog(
      context: context,
      onConfirm: () => _viewModel.clearAllFavorites(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: BlocListener<FavoritesViewModel, FavoritesState>(
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
                  onClearAll: isEmpty ? null : _showClearDialog,
                ),
                body: state.isLoading
                    ? const FavoritesLoadingSkeleton()
                    : hasBlockingError
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ApiErrorWidget.fromFailure(
                            state.failure!,
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
                          onAddToCart: _addToCart,
                          onToggleFavorite: _toggleFavorite,
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
