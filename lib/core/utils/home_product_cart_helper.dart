import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/core/widgets/variant_selection_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class HomeProductCartHelper {
  const HomeProductCartHelper._();

  static Future<void> addProductToCart(
    BuildContext context,
    ProductModel product,
  ) async {
    final l10n = context.localization;
    final globalCubit = context.read<AppSectionGlobalCubit>();

    final result = await globalCubit.addProductToCart(product);

    if (!context.mounted) return;

    // If the product has multiple variants, show the selection bottom sheet.
    if (result.requiresVariantSelection && result.productDetails != null) {
      final details = result.productDetails!;
      final selectedVariant = await VariantSelectionBottomSheet.show(
        context,
        productName: details.name,
        productImageUrl: details.imageUrl,
        variants: details.variantOptions,
        currency: l10n.currency,
      );

      if (selectedVariant == null || !context.mounted) return;

      final addResult = await globalCubit.addVariantToCart(
        details.masterProductId,
      );

      if (!context.mounted) return;

      if (addResult.isSuccess) {
        CustomSnackbar.showSuccess(
          context: context,
          message: addResult.message.isNotEmpty
              ? addResult.message
              : l10n.product_added_to_cart(1, product.name),
        );
      } else {
        CustomSnackbar.showError(context: context, message: addResult.message);
      }
      return;
    }

    if (result.isSuccess) {
      CustomSnackbar.showSuccess(
        context: context,
        message: result.message.isNotEmpty
            ? result.message
            : l10n.product_added_to_cart(1, product.name),
      );
      return;
    }

    CustomSnackbar.showError(context: context, message: result.message);
  }
}
