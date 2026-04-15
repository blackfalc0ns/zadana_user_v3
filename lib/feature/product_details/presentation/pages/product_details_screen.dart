import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/core/widgets/skeleton_colors.dart';
import 'package:zadana_user_v3/feature/app_section/page/main_shell.dart';
import 'package:zadana_user_v3/feature/cart/data/services/guest_cart_sync_service.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/add_cart_item_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/usecase/product_details_usecase.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_cubit.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_event.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/manager/product_details_state.dart';
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
      create: (_) => ProductDetailsCubit(
        productDetailsUseCase: getIt<ProductDetailsUseCase>(),
        addCartItemUseCase: getIt<AddCartItemUseCase>(),
        getCartUseCase: getIt<GetCartUseCase>(),
        guestCartSyncService: getIt<GuestCartSyncService>(),
        languageService: getIt<LanguageService>(),
      )..doIntent(
        InitializeProductDetailsEvent(
        productId: product.id,
        activeProductId: activeProductId,
      )),
      child: _ProductDetailsView(
        product: product,
        heroTag: heroTag,
      ),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  const _ProductDetailsView({
    required this.product,
    this.heroTag,
  });

  final ProductModel product;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        final imageUrl = productDetails?.imageUrl ?? product.imageUrl;
        final productId = productDetails?.id ?? product.id;

        if (state.isInitialLoading) {
          return Scaffold(
            backgroundColor: color.surface,
            body: const SafeArea(child: _ProductDetailsLoadingContent()),
          );
        }

        if (productDetails != null) {
          return ReusableProductDetailsScreen(
            productId: productId,
            productName: title,
            unit: productDetails.unit,
            emoji: product.emoji ?? '',
            imageUrl: imageUrl,
            quantity: state.quantity,
            onIncrease: () => cubit.doIntent(
              const IncreaseProductQuantityEvent(),
            ),
            onDecrease: () => cubit.doIntent(
              const DecreaseProductQuantityEvent(),
            ),
            descriptionTitle: l10n.product_description,
            description: productDetails.description,
            basePrice: productDetails.price,
            oldPrice: productDetails.oldPrice,
            currency: l10n.egp,
            vendorPrices: productDetails.vendorPrices,
            similarProducts: productDetails.similarProducts,
            onSimilarProductTap: (similarProduct) async {
              cubit.doIntent(
                SetActiveProductDetailsEvent(similarProduct.id),
              );
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
            onSimilarProductAddToCart: (_) async {},
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
            cartCount: state.cartCount,
            isAddingToCart: state.isAddingToCart,
          );
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
              child: ApiErrorWidget.fromFailure(
                state.loadFailure!,
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

class _ProductDetailsLoadingContent extends StatelessWidget {
  const _ProductDetailsLoadingContent();

  @override
  Widget build(BuildContext context) {
    return _DetailsShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _DetailsBone(height: 28, radius: 12),
            const SizedBox(height: Spacing.sm),
            const Row(
              children: [
                Expanded(child: _DetailsBone(height: 18, radius: 10)),
                SizedBox(width: Spacing.sm),
                _DetailsBone(width: 88, height: 18, radius: 10),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            const _DetailsBone(width: 140, height: 20, radius: 10),
            const SizedBox(height: Spacing.sm),
            const _DetailsBone(height: 14, radius: 8),
            const SizedBox(height: Spacing.xs),
            const _DetailsBone(height: 14, radius: 8),
            const SizedBox(height: Spacing.xs),
            const _DetailsBone(width: 220, height: 14, radius: 8),
            const SizedBox(height: Spacing.lg),
            const Row(
              children: [
                _DetailsBone(width: 110, height: 20, radius: 10),
                Spacer(),
                _DetailsBone(width: 90, height: 20, radius: 10),
              ],
            ),
            const SizedBox(height: Spacing.base),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                itemBuilder: (_, _) => Container(
                  width: 145,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Column(
                    children: [
                      _DetailsBone(width: 40, height: 40, radius: 10),
                      SizedBox(height: 10),
                      _DetailsBone(height: 12, radius: 8),
                      SizedBox(height: 8),
                      _DetailsBone(width: 70, height: 16, radius: 8),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            const _DetailsBone(width: 120, height: 20, radius: 10),
            const SizedBox(height: Spacing.base),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                itemBuilder: (_, _) => Container(
                  width: 130,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(Spacing.cardRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailsBone(height: 55, radius: 12),
                      SizedBox(height: 10),
                      _DetailsBone(height: 12, radius: 8),
                      Spacer(),
                      _DetailsBone(width: 70, height: 14, radius: 8),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}

class _DetailsShimmer extends StatefulWidget {
  const _DetailsShimmer({required this.child});

  final Widget child;

  @override
  State<_DetailsShimmer> createState() => _DetailsShimmerState();
}

class _DetailsShimmerState extends State<_DetailsShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = SkeletonColors.base(context);
    final highlightColor = SkeletonColors.highlight(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-2.0 + (_controller.value * 4), -0.4),
              end: Alignment(0.0 + (_controller.value * 4), 0.4),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _DetailsBone extends StatelessWidget {
  const _DetailsBone({this.width, required this.height, required this.radius});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final baseColor = SkeletonColors.base(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
