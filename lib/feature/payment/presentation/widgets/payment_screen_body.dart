import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/sections/checkout_content_section.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_bottom_action.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/payment_loading_view.dart';

class PaymentScreenBody extends StatelessWidget {
  const PaymentScreenBody({
    super.key,
    required this.state,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onRetry,
    required this.onChangeAddress,
    required this.onChangePickupBranch,
    required this.onFulfillmentTypeChanged,
    required this.onDeliverySlotChanged,
    required this.onPaymentMethodChanged,
    required this.onApplyPromoCode,
    required this.onRemovePromoCode,
    required this.onPlaceOrder,
  });

  final PaymentState state;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final VoidCallback onRetry;
  final VoidCallback onChangeAddress;
  final VoidCallback onChangePickupBranch;
  final ValueChanged<String> onFulfillmentTypeChanged;
  final ValueChanged<String> onDeliverySlotChanged;
  final ValueChanged<String> onPaymentMethodChanged;
  final ValueChanged<String> onApplyPromoCode;
  final VoidCallback onRemovePromoCode;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final checkoutSummary = state.checkoutSummary;

    if (state.isLoadingSummary && checkoutSummary == null) {
      return const PaymentLoadingView();
    }

    if (state.summaryFailure != null && checkoutSummary == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ApiErrorWidget(
            exception: state.summaryFailure!.exception,
            onRetry: onRetry,
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
    final shouldShowPickupHint =
        state.isPickup &&
        !state.canPlaceOrder &&
        (state.vendorBranchId ?? checkoutSummary.pickupBranch?.id) == null;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: CheckoutContentSection(
                    checkoutSummary: checkoutSummary,
                    checkoutConfig: state.checkoutConfig,
                    selectedFulfillmentType: state.fulfillmentType,
                    addresses: state.availableAddresses,
                    selectedPaymentMethodCode: state.selectedPaymentMethodCode,
                    isLoadingAddresses: state.isLoadingAddresses,
                    addressesFailure: state.addressesFailure,
                    isRefreshingSummary: state.isRefreshingSummary,
                    isChangingFulfillmentType: state.isChangingFulfillmentType,
                    isPromoLoading:
                        state.isApplyingPromo || state.isRemovingPromo,
                    onChangeAddress: onChangeAddress,
                    onChangePickupBranch: onChangePickupBranch,
                    onFulfillmentTypeChanged: onFulfillmentTypeChanged,
                    onDeliverySlotChanged: onDeliverySlotChanged,
                    onPaymentMethodChanged: onPaymentMethodChanged,
                    onApplyPromoCode: onApplyPromoCode,
                    onRemovePromoCode: onRemovePromoCode,
                  ),
                ),
              ),
            ),
            if (shouldShowPickupHint)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.md,
                  horizontal: Spacing.md,
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    resolvePickupSelectionHint(context),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            PaymentBottomAction(
              buttonText: state.isPlacingOrder
                  ? l10n.processing
                  : '${l10n.checkout} - ${checkoutSummary.summary.total.toStringAsFixed(2)} $currency',
              onPressed: state.canPlaceOrder ? onPlaceOrder : null,
            ),
          ],
        ),
        if (state.isPlacingOrder)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.18),
              child: const CustomProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
