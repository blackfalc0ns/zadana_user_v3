import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_dialogs.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/confirm_moyasar_payment_usecase.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_event.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_view_model.dart';
import 'package:zadana_user_v3/feature/payment/presentation/models/payment_callback_result.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/moyasar_payment_screen.dart';
import 'package:zadana_user_v3/feature/payment/presentation/services/moyasar_apple_pay_service.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/moyasar_payment_confirmer.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_address_selector_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_phone_required_dialog.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/pickup_branch_selector_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/domain/usecase/profile_usecase.dart';

class PaymentScreenEffectHandler {
  const PaymentScreenEffectHandler._();

  static const String _paymentStatusSuccess = 'success';
  static const String _paymentStatusFailed = 'failed';
  static const String _paymentStatusPending = 'pending';

  static void _showConfirmingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }

  static Future<void> _navigateToPaymentSuccess(
    BuildContext context,
    String orderId, {
    bool isCashOnDelivery = false,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.paymentSuccess,
        (route) => route.isFirst,
        arguments: {'orderId': orderId, 'isCashOnDelivery': isCashOnDelivery},
      );
    });
  }

  static Future<void> _navigateToPaymentFailed(
    BuildContext context, {
    String? orderId,
    String? message,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.paymentFailed,
        (route) => route.isFirst,
        arguments: {'orderId': orderId, 'message': message},
      );
    });
  }

  static Future<bool> _confirmUnavailableItems(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.checkout_unavailable_items_confirm_title),
            content: Text(l10n.checkout_unavailable_items_confirm_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l10n.checkout_unavailable_items_confirm_continue),
              ),
            ],
          ),
        ) ??
        false;
  }

  static Future<void> _handlePaymentCallbackResult({
    required BuildContext context,
    required PaymentCallbackResult? result,
    required String fallbackErrorMessage,
    required String pendingMessage,
    required String? fallbackOrderId,
  }) async {
    if (result == null) {
      return;
    }

    final paymentStatus = _resolvePaymentCallbackStatus(result);
    final paymentMessage = result['message'];
    final callbackOrderId = result['orderId'];
    final orderId = callbackOrderId ?? fallbackOrderId;

    if (paymentStatus == _paymentStatusFailed) {
      await _navigateToPaymentFailed(
        context,
        orderId: orderId,
        message: paymentMessage ?? fallbackErrorMessage,
      );
      return;
    }

    if (paymentStatus == _paymentStatusPending) {
      CustomSnackbar.showInfo(
        context: context,
        message: paymentMessage ?? pendingMessage,
      );
      return;
    }

    if (paymentStatus == _paymentStatusSuccess &&
        orderId != null &&
        orderId.isNotEmpty) {
      await _navigateToPaymentSuccess(context, orderId);
      return;
    }

    CustomSnackbar.showError(
      context: context,
      message: paymentMessage ?? fallbackErrorMessage,
    );
  }

  static String? _resolvePaymentCallbackStatus(PaymentCallbackResult result) {
    final directStatus = result['status']?.trim().toLowerCase();
    if (directStatus == _paymentStatusSuccess ||
        directStatus == _paymentStatusFailed ||
        directStatus == _paymentStatusPending) {
      return directStatus;
    }

    final rawPaymentStatus = result['paymentStatus']?.trim().toLowerCase();
    if (rawPaymentStatus == 'paid' ||
        rawPaymentStatus == 'success' ||
        rawPaymentStatus == 'succeeded') {
      return _paymentStatusSuccess;
    }

    if (rawPaymentStatus == 'failed' ||
        rawPaymentStatus == 'unpaid' ||
        rawPaymentStatus == 'canceled' ||
        rawPaymentStatus == 'cancelled') {
      return _paymentStatusFailed;
    }

    if (rawPaymentStatus == 'pending' || rawPaymentStatus == 'processing') {
      return _paymentStatusPending;
    }

    final orderStatus = result['orderStatus']?.trim().toLowerCase();
    if (orderStatus?.contains('pending') ?? false) {
      return _paymentStatusPending;
    }

    return null;
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

    if (effect is ConfirmUnavailableItemsEffect) {
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      final confirmed = await _confirmUnavailableItems(context);
      if (!context.mounted || !confirmed) return;
      viewModel.doIntent(
        const PaymentPlaceOrderEvent(removeUnavailableItems: true),
      );
      return;
    }

    if (effect is OpenAddressSelectorEffect) {
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      final result = await CheckoutAddressSelectorBottomSheet.show(
        context,
        addresses: state.availableAddresses,
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

    if (effect is OpenPickupBranchSelectorEffect) {
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      final result = await PickupBranchSelectorBottomSheet.show(
        context,
        branches: state.pickupBranches,
        selectedBranchId:
            state.vendorBranchId ?? state.checkoutSummary?.pickupBranch?.id,
        isLoading: state.isLoadingPickupBranches,
        failure: state.pickupBranchesFailure,
      );
      if (!context.mounted || result == null) return;
      viewModel.doIntent(PaymentSelectPickupBranchEvent(result));
      return;
    }

    if (effect is OpenProfileDetailsForPhoneEffect) {
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      final shouldOpenProfile = await showCheckoutPhoneRequiredDialog(
        context: context,
        message: effect.message,
      );
      if (!context.mounted || !shouldOpenProfile) return;

      final profileResult = await getIt<ProfileUseCase>().call();
      if (!context.mounted) return;

      switch (profileResult) {
        case ApiSuccessResult<ProfileResponseEntity>():
          final updatedProfile = await Navigator.of(
            context,
          ).pushNamed(AppRoutes.profileDetails, arguments: profileResult.data);
          if (!context.mounted) return;
          if (updatedProfile is ProfileResponseEntity &&
              updatedProfile.phone.trim().isNotEmpty) {
            viewModel.doIntent(const PaymentRetryEvent());
          }
        case ApiErrorResult<ProfileResponseEntity>():
          CustomSnackbar.showError(
            context: context,
            message: profileResult.failure.errorMessage,
          );
      }
      return;
    }

    if (effect is OpenMoyasarPaymentEffect) {
      final placedOrderId = state.placedOrder?.order.id;
      final orderId = effect.orderId ?? placedOrderId;
      viewModel.doIntent(const PaymentClearPlacedOrderEvent());
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      final PaymentCallbackResult? sdkResult;

      if (MoyasarApplePayService.isApplePayConfig(effect.providerConfig)) {
        try {
          sdkResult = await const MoyasarApplePayService().startPayment(
            config: effect.providerConfig,
            orderId: orderId,
          );
        } on ApplePayUnavailableException {
          if (!context.mounted) return;
          CustomSnackbar.showInfo(
            context: context,
            message: l10n.apple_pay_unavailable,
          );
          return;
        } catch (_) {
          if (!context.mounted) return;
          CustomSnackbar.showError(
            context: context,
            message: l10n.error_other_desc,
          );
          return;
        }
      } else {
        sdkResult = await Navigator.push<PaymentCallbackResult>(
          context,
          MaterialPageRoute(
            builder: (_) => MoyasarPaymentScreen(
              config: effect.providerConfig,
              orderId: orderId,
            ),
          ),
        );
      }

      if (!context.mounted) return;
      if (sdkResult == null) return;

      // Show loading overlay while confirming payment with backend.
      _showConfirmingOverlay(context);

      // Confirm with backend before deciding navigation.
      final confirmer = MoyasarPaymentConfirmer(
        getIt<ConfirmMoyasarPaymentUseCase>(),
      );
      final paymentResult = await confirmer.confirmAndResolve(sdkResult);

      if (!context.mounted) return;

      // Dismiss loading overlay.
      Navigator.of(context, rootNavigator: true).pop();

      if (!context.mounted) return;
      await _handlePaymentCallbackResult(
        context: context,
        result: paymentResult,
        fallbackErrorMessage: l10n.error_other_desc,
        pendingMessage: l10n.order_pending,
        fallbackOrderId: orderId,
      );
      return;
    }

    if (effect is NavigateToPaymentSuccessEffect) {
      viewModel.doIntent(const PaymentClearPlacedOrderEvent());
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      if (!context.mounted) return;
      await _navigateToPaymentSuccess(
        context,
        effect.orderId,
        isCashOnDelivery: effect.isCashOnDelivery,
      );
      return;
    }

    if (effect is NavigateToBankTransferPendingEffect) {
      viewModel.doIntent(const PaymentClearPlacedOrderEvent());
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.bankTransferPending,
        (route) => route.isFirst,
        arguments: {
          'orderId': effect.orderId,
          'bankTransferConfig': effect.bankTransferConfig,
          'providerReference': effect.providerReference,
        },
      );
      return;
    }

    if (effect is ShowDeliveryUnavailableDialogEffect) {
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      showDeliveryUnavailableDialog(context: context, message: effect.message);
      return;
    }

    if (effect is ShowCartItemsUnavailableAtBranchEffect) {
      viewModel.doIntent(const PaymentClearUiEffectEvent());
      showDeliveryUnavailableDialog(
        context: context,
        message: effect.message.isNotEmpty
            ? effect.message
            : l10n.cart_items_unavailable_at_address_branch,
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
