import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/utils/bloc_provider_utils.dart';
import 'package:zadana_user_v3/feature/app_section/manager/app_section_global_cubit.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/pages/product_details_screen.dart';

class ProductNavigationHelper {
  static Future<void> navigateToProductDetails(
    BuildContext context,
    ProductModel product, {
    String? activeProductId,
    String? heroTag,
  }) {
    final globalCubit = maybeReadBloc<AppSectionGlobalCubit>(context);

    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final screen = ProductDetailsScreen(
            product: product,
            activeProductId: activeProductId,
            heroTag: heroTag,
          );

          if (globalCubit == null) {
            return screen;
          }

          return BlocProvider.value(value: globalCubit, child: screen);
        },
      ),
    );
  }
}
