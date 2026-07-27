import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_support_case_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/order_support_case_page.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/confirm_moyasar_payment_usecase.dart';
import 'package:zadana_user_v3/feature/payment/presentation/models/payment_callback_result.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/moyasar_payment_screen.dart';
import 'package:zadana_user_v3/feature/payment/presentation/services/moyasar_apple_pay_service.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/moyasar_payment_confirmer.dart';

class OrderDetailsPageFlow {
  const OrderDetailsPageFlow();

  static const String _paymentStatusSuccess = 'success';
  static const String _paymentStatusFailed = 'failed';
  static const String _paymentStatusPending = 'pending';

  Future<void> retryPayment(BuildContext context, String targetOrderId) async {
    final l10n = AppLocalizations.of(context)!;
    final payment = await context.read<OrderDetailsViewModel>().retryPayment(
      targetOrderId,
    );
    if (!context.mounted || payment == null) {
      return;
    }

    // Handle bank transfer retry — navigate to pending screen.
    if (payment.isBankTransfer) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.bankTransferPending,
        arguments: {
          'orderId': targetOrderId,
          'bankTransferConfig': payment.bankTransferConfig,
          'providerReference': payment.providerReference,
        },
      );
      return;
    }

    if (!payment.isMoyasarForm || payment.providerConfig == null) {
      CustomSnackbar.showError(
        context: context,
        message: l10n.error_other_desc,
      );
      return;
    }

    final providerConfig = payment.providerConfig!;
    final PaymentCallbackResult? sdkResult;
    if (MoyasarApplePayService.isApplePayConfig(providerConfig)) {
      try {
        sdkResult = await const MoyasarApplePayService().startPayment(
          config: providerConfig,
          orderId: targetOrderId,
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
            config: providerConfig,
            orderId: targetOrderId,
          ),
        ),
      );
    }

    if (!context.mounted) return;
    if (sdkResult == null) return;

    // The payment form has just closed, but the backend still needs to
    // confirm the transaction. Keep the order-details page covered so it
    // never flashes briefly before the result screen appears.
    _showConfirmingOverlay(context);

    // Confirm with backend before deciding navigation.
    final confirmer = MoyasarPaymentConfirmer(
      getIt<ConfirmMoyasarPaymentUseCase>(),
    );
    final PaymentCallbackResult? paymentResult;
    try {
      paymentResult = await confirmer.confirmAndResolve(sdkResult);
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    if (!context.mounted) return;
    await _handlePaymentCallbackResult(
      context: context,
      result: paymentResult,
      fallbackErrorMessage: l10n.error_other_desc,
      pendingMessage: l10n.order_pending,
      fallbackOrderId: targetOrderId,
    );
  }

  void _showConfirmingOverlay(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (_) =>
          const PopScope(canPop: false, child: CustomProgressIndicator()),
    );
  }

  void openTracking(BuildContext context, String targetOrderId) {
    Navigator.pushNamed(
      context,
      AppRoutes.trackOrder,
      arguments: targetOrderId,
    );
  }

  Future<void> openSupportCases(
    BuildContext context,
    String targetOrderId, {
    String? caseId,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => OrderSupportCaseViewModel(
            getIt<MyOrdersRepository>(),
            getIt<NotificationsSignalRService>(),
          )..initialize(targetOrderId, initialCaseId: caseId),
          child: OrderSupportCasePage(
            orderId: targetOrderId,
            initialCaseId: caseId,
          ),
        ),
      ),
    );

    if (context.mounted) {
      await context.read<OrderDetailsViewModel>().load(targetOrderId);
    }
  }

  Future<void> _handlePaymentCallbackResult({
    required BuildContext context,
    required PaymentCallbackResult? result,
    required String fallbackErrorMessage,
    required String pendingMessage,
    required String fallbackOrderId,
  }) async {
    if (result == null) {
      return;
    }

    final paymentStatus = _resolvePaymentCallbackStatus(result);
    final paymentMessage = result['message'];
    final orderId = result['orderId'] ?? fallbackOrderId;

    if (paymentStatus == _paymentStatusFailed) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.paymentFailed,
        (route) => route.isFirst,
        arguments: {
          'orderId': orderId,
          'message': paymentMessage ?? fallbackErrorMessage,
        },
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

    if (paymentStatus == _paymentStatusSuccess && orderId.isNotEmpty) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.paymentSuccess,
        (route) => route.isFirst,
        arguments: orderId,
      );
      return;
    }

    CustomSnackbar.showError(
      context: context,
      message: paymentMessage ?? fallbackErrorMessage,
    );
  }

  String? _resolvePaymentCallbackStatus(PaymentCallbackResult result) {
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
}
