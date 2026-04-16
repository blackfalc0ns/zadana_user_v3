import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/services/cart_count_sync_service.dart';
import 'package:zadana_user_v3/core/widgets/app_scaffold.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_event.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_view_model.dart';
import 'package:zadana_user_v3/feature/payment/presentation/mixins/payment_animations_mixin.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_webview_screen.dart';
import 'package:zadana_user_v3/feature/payment/presentation/sections/checkout_content_section.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_address_selector_bottom_sheet.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_app_bar.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_bottom_action.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PaymentViewModel>()..doIntent(const PaymentLoadEvent()),
      child: const _PaymentScreenView(),
    );
  }
}

class _PaymentScreenView extends StatefulWidget {
  const _PaymentScreenView();

  @override
  State<_PaymentScreenView> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<_PaymentScreenView>
    with TickerProviderStateMixin, PaymentAnimationsMixin {
  PaymentViewModel get _viewModel => context.read<PaymentViewModel>();

  @override
  void initState() {
    super.initState();
    initializePaymentAnimations();
  }

  @override
  void dispose() {
    disposePaymentAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return AppScaffold(
      backgroundColor: colors.surface,
      appBar: PaymentAppBar(title: l10n.checkout),
      body: BlocConsumer<PaymentViewModel, PaymentState>(
        listenWhen: (previous, current) =>
            previous.feedbackMessage != current.feedbackMessage ||
            previous.actionFailure != current.actionFailure ||
            previous.placedOrder != current.placedOrder,
        listener: _handleStateChanges,
        builder: (context, state) {
          final checkoutSummary = state.checkoutSummary;

          if (state.isLoadingSummary && checkoutSummary == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.summaryFailure != null && checkoutSummary == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ApiErrorWidget.fromFailure(
                  state.summaryFailure!,
                  onRetry: () => _viewModel.doIntent(const PaymentRetryEvent()),
                ),
              ),
            );
          }

          if (checkoutSummary == null) {
            return EmptyStateWidget(
              title: l10n.cart_empty_description,
              description: l10n.cart_empty_message,
              icon: Icons.shopping_cart_outlined,
            );
          }

          final currency = localizePaymentCurrency(
            l10n,
            checkoutSummary.summary.currency,
          );

          return Column(
            children: [
              Expanded(
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: CheckoutContentSection(
                      checkoutSummary: checkoutSummary,
                      addresses: state.addresses,
                      selectedPaymentMethodCode:
                          state.selectedPaymentMethodCode,
                      isLoadingAddresses: state.isLoadingAddresses,
                      addressesFailure: state.addressesFailure,
                      isRefreshingSummary: state.isRefreshingSummary,
                      isPromoLoading:
                          state.isApplyingPromo || state.isRemovingPromo,
                      onChangeAddress: () => _onChangeAddress(state),
                      onDeliverySlotChanged: (slotId) {
                        _viewModel.doIntent(
                          PaymentSelectDeliverySlotEvent(slotId),
                        );
                      },
                      onPaymentMethodChanged: (method) {
                        _viewModel.doIntent(
                          PaymentSelectPaymentMethodEvent(method),
                        );
                      },
                      onApplyPromoCode: (code) {
                        _viewModel.doIntent(PaymentApplyPromoEvent(code));
                      },
                      onRemovePromoCode: () {
                        _viewModel.doIntent(const PaymentRemovePromoEvent());
                      },
                    ),
                  ),
                ),
              ),
              PaymentBottomAction(
                buttonText: state.isPlacingOrder
                    ? l10n.processing
                    : '${l10n.checkout} - ${checkoutSummary.summary.total.toStringAsFixed(2)} $currency',
                isLoading: state.isPlacingOrder,
                onPressed: state.canPlaceOrder
                    ? () => _viewModel.doIntent(const PaymentPlaceOrderEvent())
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onChangeAddress(PaymentState state) async {
    final result = await CheckoutAddressSelectorBottomSheet.show(
      context,
      addresses: state.addresses,
      selectedAddressId: state.selectedAddressId,
      isLoading: state.isLoadingAddresses,
      failure: state.addressesFailure,
    );

    if (!mounted || result == null) return;

    if (result == CheckoutAddressSelectorBottomSheet.addNewAddressResult) {
      await Navigator.pushNamed(
        context,
        AppRoutes.startSelectLocationPage,
        arguments: true,
      );
      if (!mounted) return;
      _viewModel.doIntent(const PaymentRetryEvent());
      return;
    }

    _viewModel.doIntent(PaymentSelectAddressEvent(result));
  }

  Future<void> _handleStateChanges(
    BuildContext context,
    PaymentState state,
  ) async {
    if (state.feedbackMessage != null) {
      CustomSnackbar.showSuccess(
        context: context,
        message: state.feedbackMessage!,
      );
      _viewModel.doIntent(const PaymentClearFeedbackEvent());
      return;
    }

    if (state.actionFailure != null) {
      CustomSnackbar.showError(
        context: context,
        message: state.actionFailure!.errorMessage,
      );
      _viewModel.doIntent(const PaymentClearFeedbackEvent());
      return;
    }

    if (state.placedOrder != null) {
      final order = state.placedOrder!;
      final l10n = AppLocalizations.of(context)!;
      _viewModel.doIntent(const PaymentClearPlacedOrderEvent());
      CartCountSyncService().setCount(0);

      final iframeUrl = order.payment?.iframeUrl ?? '';
      if (iframeUrl.isNotEmpty) {
        final paymentResult = await Navigator.push<PaymentCallbackResult>(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentWebViewScreen(paymentUrl: iframeUrl),
          ),
        );

        if (!context.mounted || paymentResult == null) return;

        final paymentStatus = paymentResult['status'];
        final paymentMessage = paymentResult['message'];
        final callbackOrderId = paymentResult['orderId'];

        if (paymentStatus == 'failed') {
          CustomSnackbar.showError(
            context: context,
            message: paymentMessage ?? l10n.error_other_desc,
          );
          return;
        }

        if (paymentStatus == 'pending') {
          CustomSnackbar.showInfo(
            context: context,
            message: paymentMessage ?? l10n.order_pending,
          );
          return;
        }

        if (paymentStatus == 'success') {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.paymentSuccess,
            arguments: callbackOrderId ?? order.order.id,
          );
        }

        return;
      }

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.paymentSuccess,
        arguments: order.order.id,
      );
    }
  }
}
