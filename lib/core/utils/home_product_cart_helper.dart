import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/cart_count_sync_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/cart/data/services/guest_cart_sync_service.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/add_cart_item_usecase.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_details_entity.dart';
import 'package:zadana_user_v3/feature/product_details/domain/usecase/product_details_usecase.dart';

class HomeProductCartHelper {
  const HomeProductCartHelper._();

  static Future<void> addProductToCart(
    BuildContext context,
    ProductModel product,
  ) async {
    final l10n = context.localization;
    final productDetailsUseCase = getIt<ProductDetailsUseCase>();
    final addCartItemUseCase = getIt<AddCartItemUseCase>();
    final guestCartSyncService = getIt<GuestCartSyncService>();

    final detailsResult = await productDetailsUseCase.getProductDetails(
      product.id,
    );

    if (!context.mounted) return;

    switch (detailsResult) {
      case ApiSuccessResult<ProductDetailsEntity>():
        final productId = detailsResult.data.masterProductId;
        if (productId.isEmpty) {
          CustomSnackbar.showError(
            context: context,
            message: 'Product id is unavailable for this item.',
          );
          return;
        }

        final request = AddCartItemRequestEntity(
          productId: productId,
          quantity: 1,
        );
        final addResult = await addCartItemUseCase.call(request);

        if (!context.mounted) return;

        switch (addResult) {
          case ApiSuccessResult():
            await guestCartSyncService.cacheGuestCartItem(request);
            CartCountSyncService().incrementBy(request.quantity);
            if (!context.mounted) return;
            CustomSnackbar.showSuccess(
              context: context,
              message: addResult.data.message.isNotEmpty
                  ? addResult.data.message
                  : l10n.product_added_to_cart(1, product.name),
            );
          case ApiErrorResult():
            CustomSnackbar.showError(
              context: context,
              message: addResult.failure.errorMessage,
            );
        }
      case ApiErrorResult<ProductDetailsEntity>():
        CustomSnackbar.showError(
          context: context,
          message: detailsResult.failure.errorMessage,
        );
    }
  }
}
