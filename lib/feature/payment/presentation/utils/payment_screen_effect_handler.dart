import 'dart:developer' as developer;

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/cart_count_sync_service.dart';
import 'package:zadana_user_v3/core/services/cart_refresh_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/cart/data/services/cart_cache_invalidator.dart';
import 'package:zadana_user_v3/feature/cart/data/services/guest_cart_sync_service.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_usecase.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_event.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_view_model.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_webview_screen.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_address_selector_bottom_sheet.dart';

class PaymentScreenEffectHandler {
  const PaymentScreenEffectHandler._();

  static Future<void> _clearCartRelatedCache() async {
    final cacheInvalidator = CartCacheInvalidator(getIt<CacheStore>());
    await cacheInvalidator.clearCartCache();
    await cacheInvalidator.clearCheckoutSummaryCache();
  }

  static Future<bool> _isBackendCartEmpty() async {
    final result = await getIt<GetCartUseCase>().call();

    switch (result) {
      case ApiSuccessResult():
        return result.data.summary.totalQuantity == 0;
      case ApiErrorResult():
        developer.log(
          'Could not verify backend cart state: ${result.failure.errorMessage}',
          name: 'PaymentScreenEffectHandler',
        );
        return false;
    }
  }

  static void _requestCartRefresh() {
    CartCountSyncService().requestRefresh();
    CartRefreshService().notifyCartChanged();
  }

  static Future<void> _waitForBackendCartRefresh() async {
    const verificationDelays = <Duration>[
      Duration.zero,
      Duration(milliseconds: 400),
      Duration(milliseconds: 900),
      Duration(milliseconds: 1400),
    ];

    for (final delay in verificationDelays) {
      if (delay > Duration.zero) {
        await Future<void>.delayed(delay);
      }

      _requestCartRefresh();

      if (await _isBackendCartEmpty()) {
        developer.log(
          'Backend cart is empty after successful payment refresh.',
          name: 'PaymentScreenEffectHandler',
        );
        return;
      }
    }

    developer.log(
      'Backend cart still has items after payment retries. '
      'No local clear will be forced.',
      name: 'PaymentScreenEffectHandler',
    );
  }

  static Future<void> _syncCartAfterSuccessfulPayment() async {
    await _clearCartRelatedCache();
    await getIt<GuestCartSyncService>().clearPendingItems();
    await _waitForBackendCartRefresh();
    developer.log(
      'Cart cache invalidated after successful payment and refresh requested.',
      name: 'PaymentScreenEffectHandler',
    );
  }

  static Future<void> handle({
    required BuildContext context,
    required PaymentState state,
    required PaymentViewModel viewModel,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    if (state.feedbackMessage != null) {
      CustomSnackbar.showSuccess(
        context: context,
        message: state.feedbackMessage!,
      );
      viewModel.doIntent(const PaymentClearFeedbackEvent());
      return;
    }

    if (state.actionFailure != null) {
      CustomSnackbar.showError(
        context: context,
        message: state.actionFailure!.errorMessage,
      );
      viewModel.doIntent(const PaymentClearFeedbackEvent());
      return;
    }

    final effect = state.uiEffect;
    if (effect == null) return;

    if (effect is OpenAddressSelectorEffect) {
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      final result = await CheckoutAddressSelectorBottomSheet.show(
        context,
        addresses: state.addresses,
        selectedAddressId: state.selectedAddressId,
        isLoading: state.isLoadingAddresses,
        failure: state.addressesFailure,
      );
      if (!context.mounted) return;
      viewModel.doIntent(PaymentHandleAddressSelectionResultEvent(result));
      return;
    }

    if (effect is OpenAddAddressEffect) {
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      await Navigator.pushNamed(
        context,
        AppRoutes.startSelectLocationPage,
        arguments: true,
      );
      if (!context.mounted) return;
      viewModel.doIntent(const PaymentHandleAddAddressCompletedEvent());
      return;
    }

    if (effect is OpenPaymentWebViewEffect) {
      viewModel.doIntent(const PaymentClearPlacedOrderEvent());
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      final paymentResult = await Navigator.push<PaymentCallbackResult>(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebViewScreen(paymentUrl: effect.paymentUrl),
        ),
      );

      if (!context.mounted) return;
      viewModel.doIntent(
        PaymentHandleWebViewResultEvent(
          result: paymentResult,
          fallbackErrorMessage: l10n.error_other_desc,
          pendingMessage: l10n.order_pending,
        ),
      );
      return;
    }

    if (effect is NavigateToPaymentSuccessEffect) {
      viewModel.doIntent(const PaymentClearPlacedOrderEvent());
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      await _syncCartAfterSuccessfulPayment();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.paymentSuccess,
        arguments: effect.orderId,
      );
      return;
    }

    if (effect is ShowPaymentErrorEffect) {
      CustomSnackbar.showError(context: context, message: effect.message);
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      return;
    }

    if (effect is ShowPaymentInfoEffect) {
      CustomSnackbar.showInfo(context: context, message: effect.message);
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      return;
    }

    if (effect is ShowPaymentSuccessEffect) {
      CustomSnackbar.showSuccess(context: context, message: effect.message);
      viewModel.doIntent(const PaymentClearUiEffectEvent());
    }
  }
}
