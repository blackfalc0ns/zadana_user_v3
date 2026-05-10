import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_support_case_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/order_support_case_page.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_webview_screen.dart';

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

    final paymentUrl = payment.iframeUrl.trim();
    if (paymentUrl.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: l10n.error_other_desc,
      );
      return;
    }

    final paymentResult = await Navigator.push<PaymentCallbackResult>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebViewScreen(paymentUrl: paymentUrl),
      ),
    );

    if (!context.mounted) return;
    await _handlePaymentCallbackResult(
      context: context,
      result: paymentResult,
      fallbackErrorMessage: l10n.error_other_desc,
      pendingMessage: l10n.order_pending,
      fallbackOrderId: targetOrderId,
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.paymentFailed,
          arguments: {
            'orderId': orderId,
            'message': paymentMessage ?? fallbackErrorMessage,
          },
        );
      });
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.paymentSuccess, arguments: orderId);
      });
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
