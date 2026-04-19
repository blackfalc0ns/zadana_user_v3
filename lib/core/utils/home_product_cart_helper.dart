import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class HomeProductCartHelper {
  const HomeProductCartHelper._();

  static Future<void> addProductToCart(
    BuildContext context,
    ProductModel product,
  ) async {
    final l10n = context.localization;
    final result = await context.read<AppSectionGlobalCubit>().addProductToCart(
      product,
    );

    if (!context.mounted) return;

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
