import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/utils/product_hero_tag.dart';
import 'package:zadana_user_v3/core/utils/product_navigation_helper.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/cart/data/services/guest_cart_sync_service.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/add_cart_item_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/usecase/product_details_usecase.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_bottom_actions.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_details_content.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/product_main_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  final String? activeProductId;
  final String? heroTag;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    this.activeProductId,
    this.heroTag,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductDetailsUseCase _productDetailsUseCase;
  late final AddCartItemUseCase _addCartItemUseCase;
  late final GuestCartSyncService _guestCartSyncService;
  late Future<ApiResult<ProductDetailsEntity>> _productDetailsFuture;
  int _quantity = 1;
  String? _activeProductId;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _productDetailsUseCase = getIt<ProductDetailsUseCase>();
    _addCartItemUseCase = getIt<AddCartItemUseCase>();
    _guestCartSyncService = getIt<GuestCartSyncService>();
    _activeProductId = widget.activeProductId;
    _productDetailsFuture = _loadProductDetails();
  }

  Future<ApiResult<ProductDetailsEntity>> _loadProductDetails() {
    return _productDetailsUseCase.getProductDetails(widget.product.id);
  }

  Future<void> _addToCart(ProductDetailsEntity productDetails) async {
    if (_isAddingToCart) return;

    final l10n = AppLocalizations.of(context)!;
    if (productDetails.masterProductId.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: 'Product id is unavailable for this item.',
      );
      return;
    }

    setState(() => _isAddingToCart = true);

    final request = AddCartItemRequestEntity(
      productId: productDetails.masterProductId,
      quantity: _quantity,
    );

    final result = await _addCartItemUseCase.call(request);

    if (!mounted) return;

    switch (result) {
      case ApiSuccessResult():
        await _guestCartSyncService.cacheGuestCartItem(request);
        if (!mounted) return;
        CustomSnackbar.showSuccess(
          context: context,
          message: result.data.message.isNotEmpty
              ? result.data.message
              : l10n.product_added_to_cart(_quantity, productDetails.name),
        );
      case ApiErrorResult():
        CustomSnackbar.showError(
          context: context,
          message: result.failure.errorMessage,
        );
    }

    if (mounted) {
      setState(() => _isAddingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<ApiResult<ProductDetailsEntity>>(
      future: _productDetailsFuture,
      builder: (context, snapshot) {
        final result = snapshot.data;
        final productDetails = result is ApiSuccessResult<ProductDetailsEntity>
            ? result.data
            : null;

        final title = productDetails?.name ?? widget.product.name;
        final imageUrl = productDetails?.imageUrl ?? (widget.product.imageUrl);
        final productId = productDetails?.id ?? widget.product.id;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Text(title),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductMainImage(
                  emoji: widget.product.emoji ?? '',
                  imageUrl: imageUrl,
                  productId: productId,
                  heroTag: widget.heroTag,
                  height: 250,
                ),
                if (snapshot.connectionState != ConnectionState.done)
                  const _ProductDetailsLoadingContent()
                else if (productDetails != null)
                  ProductDetailsContent(
                    productName: productDetails.name,
                    unit: productDetails.unit,
                    quantity: _quantity,
                    onIncrease: () => setState(() => _quantity++),
                    onDecrease: () => setState(() {
                      if (_quantity > 1) {
                        _quantity--;
                      }
                    }),
                    descriptionTitle: l10n.product_description,
                    description: productDetails.description,
                    basePrice: productDetails.price,
                    oldPrice: productDetails.oldPrice,
                    currency: l10n.egp,
                    vendorPrices: productDetails.vendorPrices,
                    similarProducts: productDetails.similarProducts,
                    onSimilarProductTap: (product) async {
                      setState(() => _activeProductId = product.id);
                      await WidgetsBinding.instance.endOfFrame;

                      if (!mounted) return;

                      ProductNavigationHelper.navigateToProductDetails(
                        context,
                        product,
                        activeProductId: product.id,
                        heroTag: productHeroTag(
                          product.id,
                          source: 'similar-products',
                        ),
                      );
                    },
                    onSimilarProductAddToCart: (product) {
                      CustomSnackbar.showSuccess(
                        context: context,
                        message: 'تم إضافة ${product.name} إلى السلة',
                      );
                    },
                    activeProductId: _activeProductId,
                  )
                else
                  _ProductDetailsErrorContent(
                    message: result is ApiErrorResult<ProductDetailsEntity>
                        ? result.failure.errorMessage
                        : 'Unexpected error occurred.',
                    onRetry: () {
                      setState(() {
                        _productDetailsFuture = _loadProductDetails();
                      });
                    },
                  ),
              ],
            ),
          ),
          bottomSheet: productDetails == null
              ? null
              : ProductBottomActions(
                  onAddToCart: _isAddingToCart
                      ? null
                      : () => _addToCart(productDetails),
                  onGoToCart: () => CustomSnackbar.showInfo(
                    context: context,
                    message: 'الانتقال للسلة',
                  ),
                ),
        );
      },
    );
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
            Row(
              children: const [
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
            Row(
              children: const [
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
                separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
                itemBuilder: (_, __) => Container(
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
                separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
                itemBuilder: (_, __) => Container(
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

class _ProductDetailsErrorContent extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProductDetailsErrorContent({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsShimmer extends StatefulWidget {
  final Widget child;

  const _DetailsShimmer({required this.child});

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
                AppColors.shimmerBase,
                AppColors.shimmerHighlight.withValues(alpha: 0.55),
                AppColors.shimmerBase,
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
  final double? width;
  final double height;
  final double radius;

  const _DetailsBone({this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
