import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/product_display_size_extension.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/utils/bloc_provider_utils.dart';
import 'package:zadana_user_v3/core/utils/home_product_cart_helper.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_state.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_variant_option_entity.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_cubit.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_event.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_state.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_details_loading_view.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/reusable_product_details_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
    this.activeProductId,
    this.heroTag,
  });

  final ProductModel product;
  final String? activeProductId;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductDetailsCubit>()
        ..doIntent(
          InitializeProductDetailsEvent(
            productId: product.id,
            activeProductId: activeProductId,
          ),
        ),
      child: _ProductDetailsView(product: product, heroTag: heroTag),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  const _ProductDetailsView({required this.product, this.heroTag});

  final ProductModel product;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final globalCubit = maybeReadBloc<AppSectionGlobalCubit>(context);

    return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
      listenWhen: (previous, current) =>
          previous.addToCartSuccessMessage != current.addToCartSuccessMessage ||
          previous.addToCartFailure != current.addToCartFailure,
      listener: (context, state) {
        if (state.addToCartSuccessMessage != null) {
          CustomSnackbar.showSuccess(
            context: context,
            message: state.addToCartSuccessMessage!,
          );
          context.read<ProductDetailsCubit>().doIntent(
            const ClearProductDetailsFeedbackEvent(),
          );
        } else if (state.addToCartFailure != null) {
          CustomSnackbar.showError(
            context: context,
            message: state.addToCartFailure!.errorMessage,
          );
          context.read<ProductDetailsCubit>().doIntent(
            const ClearProductDetailsFeedbackEvent(),
          );
        }
      },
      builder: (context, state) {
        final color = Theme.of(context).colorScheme;
        final cubit = context.read<ProductDetailsCubit>();
        final productDetails = state.productDetails;
        final title = productDetails?.name ?? product.name;
        final imageUrl = state.effectiveImageUrl.isNotEmpty
            ? state.effectiveImageUrl
            : (productDetails?.imageUrl ?? product.imageUrl);
        final productId = productDetails?.id ?? product.id;

        if (state.isInitialLoading) {
          return const Scaffold(
          
            body: SafeArea(child: ProductDetailsLoadingView()),
          );
        }

        if (productDetails != null) {
          Widget buildScreen(int cartCount) {
            return ReusableProductDetailsScreen(
              productId: productId,
              productName: title,
              unit: state.effectiveUnit ?? productDetails.unit,
              displaySize: _resolveDisplaySize(context, product, state.resolvedVariantOptions),
              emoji: product.emoji ?? '',
              imageUrl: imageUrl,
              quantity: state.quantity,
              onIncrease: () =>
                  cubit.doIntent(const IncreaseProductQuantityEvent()),
              onDecrease: () =>
                  cubit.doIntent(const DecreaseProductQuantityEvent()),
              descriptionTitle: l10n.product_description,
              description: productDetails.description,
              basePrice: state.effectivePrice,
              oldPrice: state.effectiveOldPrice,
              currency: l10n.currency,
              variantOptions: state.resolvedVariantOptions,
              vendorPrices: state.effectiveVendorPrices,
              similarProducts: productDetails.similarProducts,
              onVariantSelected: (variant) {
                cubit.doIntent(SelectVariantEvent(variant.id));
              },
              onSimilarProductTap: (similarProduct) async {
                cubit.doIntent(SetActiveProductDetailsEvent(similarProduct.id));
                await WidgetsBinding.instance.endOfFrame;
                if (!context.mounted) return;

                ProductNavigationHelper.navigateToProductDetails(
                  context,
                  similarProduct,
                  activeProductId: similarProduct.id,
                  heroTag: productHeroTag(
                    similarProduct.id,
                    source: 'similar-products',
                  ),
                );
              },
              onSimilarProductAddToCart: (similarProduct) async {
                await HomeProductCartHelper.addProductToCart(
                  context,
                  similarProduct,
                );
              },
              onAddToCart: () => cubit.doIntent(const AddProductToCartEvent()),
              onGoToCart: () => _goToCartTab(context),
              activeProductId: state.activeProductId,
              heroTag: heroTag,
              backgroundColor: color.surface,
              appBarBackgroundColor: color.surface,
              appBarTitleColor: color.onSurface,
              appBarLeading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: color.onSurface,
                ),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 20,
              ),
              appBarSystemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: color.brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
                statusBarBrightness: color.brightness == Brightness.dark
                    ? Brightness.dark
                    : Brightness.light,
              ),
              cartCount: cartCount,
              isAddingToCart: state.isAddingToCart,
              isAvailableForPurchase: state.isAvailableForPurchase,
              unavailableMessage: state.isAvailableForPurchase
                  ? null
                  : state.unavailableMessage,
            );
          }

          if (globalCubit != null) {
            return BlocBuilder<AppSectionGlobalCubit, AppSectionGlobalState>(
              bloc: globalCubit,
              builder: (context, globalState) =>
                  buildScreen(math.max(globalState.cartCount, state.cartCount)),
            );
          }

          return buildScreen(state.cartCount);
        }

        if (state.loadFailure != null) {
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: title,
              backgroundColor: color.surface,
              titleColor: color.onSurface,
              showShadow: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: color.onSurface,
                ),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 20,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: ApiErrorWidget(
                exception: state.loadFailure!.exception,
                onRetry: () => cubit.doIntent(const LoadProductDetailsEvent()),
                onGoBack: () => Navigator.of(context).maybePop(),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _goToCartTab(BuildContext context) {
    final navigator = Navigator.of(context);
    final shellState = mainShellKey.currentState;

    if (shellState == null) {
      navigator.pushNamedAndRemoveUntil(
        AppRoutes.mainShell,
        (route) => false,
        arguments: 2,
      );
      return;
    }

    navigator.popUntil(
      (route) => route.settings.name == AppRoutes.mainShell || route.isFirst,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainShellKey.currentState?.jumpToTab(2);
    });
  }
}

String? _resolveDisplaySize(
  BuildContext context,
  ProductModel product,
  List<ProductVariantOptionEntity> variantOptions,
) {
  final isArabic =
      Localizations.localeOf(context).languageCode.startsWith('ar');

  // Prefer the current variant's display size
  final currentVariant = variantOptions.where((v) => v.isCurrent).firstOrNull;
  if (currentVariant != null) {
    final variantSize =
        isArabic ? currentVariant.displaySizeAr : currentVariant.displaySizeEn;
    if (variantSize.isNotEmpty) return variantSize;
  }

  return isArabic
      ? product.resolvedDisplaySizeAr
      : product.resolvedDisplaySizeEn;
}
