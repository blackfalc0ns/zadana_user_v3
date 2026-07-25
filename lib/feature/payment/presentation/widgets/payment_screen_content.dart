import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_scaffold.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_event.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_view_model.dart';
import 'package:zadana_user_v3/feature/payment/presentation/mixins/payment_animations_mixin.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_screen_effect_handler.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_screen_body.dart';

class PaymentScreenContent extends StatefulWidget {
  const PaymentScreenContent({super.key});

  @override
  State<PaymentScreenContent> createState() => _PaymentScreenContentState();
}

class _PaymentScreenContentState extends State<PaymentScreenContent>
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
      appBar: CustomAppBar(title: l10n.checkout),
      body: BlocConsumer<PaymentViewModel, PaymentState>(
        listenWhen: _shouldHandleEffect,
        listener: _handleEffect,
        builder: (context, state) => PaymentScreenBody(
          state: state,
          fadeAnimation: fadeAnimation,
          slideAnimation: slideAnimation,
          onRetry: _onRetry,
          onChangeAddress: _onChangeAddress,
          onChangePickupBranch: _onChangePickupBranch,
          onFulfillmentTypeChanged: _onFulfillmentTypeChanged,
          onDeliverySlotChanged: _onDeliverySlotChanged,
          onPaymentMethodChanged: _onPaymentMethodChanged,
          onApplyPromoCode: _onApplyPromoCode,
          onRemovePromoCode: _onRemovePromoCode,
          onPlaceOrder: _onPlaceOrder,
        ),
      ),
    );
  }

  bool _shouldHandleEffect(PaymentState previous, PaymentState current) {
    return previous.feedbackMessage != current.feedbackMessage ||
        previous.actionFailure != current.actionFailure ||
        previous.uiEffect != current.uiEffect;
  }

  Future<void> _handleEffect(BuildContext context, PaymentState state) {
    return PaymentScreenEffectHandler.handle(
      context: context,
      state: state,
      viewModel: _viewModel,
    );
  }

  void _onRetry() {
    _viewModel.doIntent(const PaymentRetryEvent());
  }

  void _onChangeAddress() {
    _viewModel.doIntent(const PaymentRequestAddressSelectionEvent());
  }

  void _onChangePickupBranch() {
    _viewModel.doIntent(const PaymentRequestPickupBranchSelectionEvent());
  }

  void _onFulfillmentTypeChanged(String fulfillmentType) {
    _viewModel.doIntent(PaymentSelectFulfillmentTypeEvent(fulfillmentType));
  }

  void _onDeliverySlotChanged(String slotId) {
    _viewModel.doIntent(PaymentSelectDeliverySlotEvent(slotId));
  }

  void _onPaymentMethodChanged(String method) {
    _viewModel.doIntent(PaymentSelectPaymentMethodEvent(method));
  }

  void _onApplyPromoCode(String code) {
    _viewModel.doIntent(PaymentApplyPromoEvent(code));
  }

  void _onRemovePromoCode() {
    _viewModel.doIntent(const PaymentRemovePromoEvent());
  }

  void _onPlaceOrder() {
    _viewModel.doIntent(const PaymentPlaceOrderEvent());
  }
}
