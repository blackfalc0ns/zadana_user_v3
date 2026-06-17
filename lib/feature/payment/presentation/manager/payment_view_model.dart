import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/services/checkout_flow_service.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_request_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/apply_checkout_promo_code_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/get_checkout_summary_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/place_order_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/remove_checkout_promo_code_usecase.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_event.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_address_selector_bottom_sheet.dart';

@injectable
class PaymentViewModel extends Cubit<PaymentState> {
  PaymentViewModel(
    this._getCheckoutSummaryUseCase,
    this._applyCheckoutPromoCodeUseCase,
    this._removeCheckoutPromoCodeUseCase,
    this._placeOrderUseCase,
    this._getCustomerAddressesUseCase,
  ) : super(const PaymentState());

  final GetCheckoutSummaryUseCase _getCheckoutSummaryUseCase;
  final ApplyCheckoutPromoCodeUseCase _applyCheckoutPromoCodeUseCase;
  final RemoveCheckoutPromoCodeUseCase _removeCheckoutPromoCodeUseCase;
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;

  void initialize({String? vendorId}) {
    if (state.vendorId == vendorId) return;
    emit(state.copyWith(vendorId: vendorId));
  }

  void doIntent(PaymentEvent event) {
    switch (event) {
      case PaymentLoadEvent():
      case PaymentRetryEvent():
        _loadCheckoutData();
      case PaymentSelectAddressEvent():
        _refreshSummary(addressId: event.addressId);
      case PaymentSelectDeliverySlotEvent():
        _refreshSummary(
          addressId: state.selectedAddressId,
          deliverySlotId: event.deliverySlotId,
        );
      case PaymentSelectPaymentMethodEvent():
        _selectPaymentMethod(event.paymentMethodCode);
      case PaymentApplyPromoEvent():
        _applyPromoCode(event.code);
      case PaymentRemovePromoEvent():
        _removePromoCode();
      case PaymentPlaceOrderEvent():
        _placeOrder();
      case PaymentRequestAddressSelectionEvent():
        emit(state.copyWith(uiEffect: const OpenAddressSelectorEffect()));
      case PaymentHandleAddressSelectionResultEvent():
        _handleAddressSelectionResult(event.result);
      case PaymentHandleAddAddressCompletedEvent():
        _loadCheckoutData();
      case PaymentClearFeedbackEvent():
        emit(
          state.copyWith(clearActionFailure: true, clearFeedbackMessage: true),
        );
      case PaymentClearPlacedOrderEvent():
        emit(state.copyWith(clearPlacedOrder: true));
      case PaymentClearUiEffectEvent():
        emit(state.copyWith(clearUiEffect: true));
    }
  }

  Future<void> _loadCheckoutData() async {
    final requestedPaymentMethod = state.selectedPaymentMethodCode;
    final requestedPromoCode = state.appliedPromoCode;
    emit(
      state.copyWith(
        isLoadingSummary: true,
        isLoadingAddresses: true,
        clearSummaryFailure: true,
        clearAddressesFailure: true,
        clearActionFailure: true,
        clearFeedbackMessage: true,
      ),
    );

    // Wait for any pending cart sync (e.g. guest cart → authenticated cart)
    // to complete before fetching the checkout summary.
    await CheckoutFlowService().awaitCartSyncIfPending();

    developer.log('Loading checkout summary', name: 'PaymentViewModel');

    final checkoutFuture = _getCheckoutSummaryUseCase(
      vendorId: state.vendorId,
      paymentMethod: state.selectedPaymentMethodCode,
      promoCode: requestedPromoCode,
    );
    final addressesFuture = _getCustomerAddressesUseCase();

    final checkoutResult = await checkoutFuture;
    final addressesResult = await addressesFuture;

    var nextState = state.copyWith(
      isLoadingSummary: false,
      isLoadingAddresses: false,
    );

    switch (checkoutResult) {
      case ApiSuccessResult<CheckoutSummaryEntity>():
        final resolvedPaymentMethod = _resolvePaymentMethodCode(
          checkoutResult.data,
          preferredCode: state.selectedPaymentMethodCode,
        );
        nextState = nextState.copyWith(
          checkoutSummary: checkoutResult.data,
          appliedPromoCode:
              checkoutResult.data.promoCode?.code ?? requestedPromoCode,
          selectedPaymentMethodCode: resolvedPaymentMethod,
          clearSummaryFailure: true,
        );
      case ApiErrorResult<CheckoutSummaryEntity>():
        nextState = nextState.copyWith(summaryFailure: checkoutResult.failure);
    }

    switch (addressesResult) {
      case ApiSuccessResult<List<CustomerAddressEntity>>():
        nextState = nextState.copyWith(
          addresses: addressesResult.data,
          clearAddressesFailure: true,
        );
      case ApiErrorResult<List<CustomerAddressEntity>>():
        nextState = nextState.copyWith(
          addressesFailure: addressesResult.failure,
        );
    }

    emit(nextState);

    if (checkoutResult case ApiSuccessResult<CheckoutSummaryEntity>()) {
      final resolvedPaymentMethod = nextState.selectedPaymentMethodCode;
      if ((requestedPaymentMethod == null || requestedPaymentMethod.isEmpty) &&
          resolvedPaymentMethod != null &&
          resolvedPaymentMethod.isNotEmpty) {
        await _refreshSummary(
          addressId: checkoutResult.data.selectedAddress?.id,
          deliverySlotId: _selectedDeliverySlotIdFromSummary(
            checkoutResult.data,
          ),
          paymentMethod: resolvedPaymentMethod,
          promoCode: nextState.appliedPromoCode,
        );
      }
    }
  }

  Future<void> _refreshSummary({
    String? addressId,
    String? deliverySlotId,
    String? paymentMethod,
    String? promoCode,
  }) async {
    emit(
      state.copyWith(
        isRefreshingSummary: true,
        clearActionFailure: true,
        clearFeedbackMessage: true,
      ),
    );

    final result = await _getCheckoutSummaryUseCase(
      vendorId: state.vendorId,
      addressId: addressId,
      deliverySlotId: deliverySlotId,
      paymentMethod: paymentMethod ?? state.selectedPaymentMethodCode,
      promoCode: promoCode ?? state.appliedPromoCode,
    );

    switch (result) {
      case ApiSuccessResult<CheckoutSummaryEntity>():
        final retainedPromoCode =
            result.data.promoCode?.code ?? promoCode ?? state.appliedPromoCode;

        // Check if delivery is unavailable after address change
        final deliveryCheck = result.data.deliveryCheck;
        final isDeliveryUnavailable =
            deliveryCheck != null && !deliveryCheck.isDeliverable;

        emit(
          state.copyWith(
            isRefreshingSummary: false,
            checkoutSummary: result.data,
            appliedPromoCode: retainedPromoCode,
            selectedPaymentMethodCode: _resolvePaymentMethodCode(
              result.data,
              preferredCode: state.selectedPaymentMethodCode,
            ),
            clearSummaryFailure: true,
            clearActionFailure: true,
            uiEffect: isDeliveryUnavailable
                ? ShowDeliveryUnavailableDialogEffect(
                    deliveryCheck.messageAr.isNotEmpty
                        ? deliveryCheck.messageAr
                        : deliveryCheck.messageEn,
                  )
                : null,
          ),
        );
      case ApiErrorResult<CheckoutSummaryEntity>():
        emit(
          state.copyWith(
            isRefreshingSummary: false,
            actionFailure: result.failure,
          ),
        );
    }
  }

  void _selectPaymentMethod(String paymentMethodCode) {
    if (state.selectedPaymentMethodCode == paymentMethodCode) return;

    final isAvailable = state.checkoutSummary?.paymentMethods.any(
      (method) => method.code == paymentMethodCode && method.isAvailable,
    );

    if (isAvailable != true) return;

    emit(
      state.copyWith(
        selectedPaymentMethodCode: paymentMethodCode,
        clearActionFailure: true,
      ),
    );

    _refreshSummary(
      addressId: state.selectedAddressId,
      deliverySlotId: state.selectedDeliverySlotId,
      paymentMethod: paymentMethodCode,
      promoCode: state.appliedPromoCode,
    );
  }

  Future<void> _applyPromoCode(String code) async {
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty || state.checkoutSummary == null) return;

    emit(
      state.copyWith(
        isApplyingPromo: true,
        clearActionFailure: true,
        clearFeedbackMessage: true,
      ),
    );

    final result = await _applyCheckoutPromoCodeUseCase(
      trimmedCode,
      vendorId: state.vendorId,
      paymentMethod: state.selectedPaymentMethodCode,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isApplyingPromo: false,
            appliedPromoCode: result.data.promoCode?.code ?? trimmedCode,
            checkoutSummary: state.checkoutSummary!.copyWith(
              promoCode: result.data.promoCode,
              clearPromoCode: result.data.promoCode == null,
              deliveryQuote: result.data.deliveryQuote,
              clearDeliveryQuote: result.data.deliveryQuote == null,
              shippingBreakdown: result.data.shippingBreakdown,
              pricingMode: result.data.pricingMode,
              clearPricingMode: result.data.pricingMode == null,
              summary: result.data.summary,
            ),
            feedbackMessage: result.data.message,
            clearActionFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isApplyingPromo: false, actionFailure: result.failure),
        );
    }
  }

  Future<void> _removePromoCode() async {
    if (state.checkoutSummary?.promoCode == null) return;

    emit(
      state.copyWith(
        isRemovingPromo: true,
        clearActionFailure: true,
        clearFeedbackMessage: true,
      ),
    );

    final result = await _removeCheckoutPromoCodeUseCase(
      vendorId: state.vendorId,
      paymentMethod: state.selectedPaymentMethodCode,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isRemovingPromo: false,
            clearAppliedPromoCode: true,
            checkoutSummary: state.checkoutSummary!.copyWith(
              clearPromoCode: true,
              deliveryQuote: result.data.deliveryQuote,
              clearDeliveryQuote: result.data.deliveryQuote == null,
              shippingBreakdown: result.data.shippingBreakdown,
              pricingMode: result.data.pricingMode,
              clearPricingMode: result.data.pricingMode == null,
              summary: result.data.summary,
            ),
            feedbackMessage: result.data.message,
            clearActionFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isRemovingPromo: false, actionFailure: result.failure),
        );
    }
  }

  Future<void> _placeOrder() async {
    final checkoutSummary = state.checkoutSummary;
    final selectedPaymentMethodCode = state.selectedPaymentMethodCode;
    final selectedAddressId = state.selectedAddressId;
    final selectedDeliverySlotId = state.selectedDeliverySlotId;

    if (checkoutSummary == null ||
        selectedPaymentMethodCode == null ||
        selectedAddressId == null ||
        selectedDeliverySlotId == null) {
      emit(
        state.copyWith(
          actionFailure: Failure(
            errorMessage: 'Please complete the checkout details first.',
          ),
        ),
      );
      return;
    }

    // Block order placement if delivery check indicates invalid delivery.
    if (!checkoutSummary.isDeliveryValid) {
      final message =
          checkoutSummary.deliveryCheck?.messageAr.isNotEmpty == true
              ? checkoutSummary.deliveryCheck!.messageAr
              : 'Delivery is not available for the selected address.';
      emit(
        state.copyWith(actionFailure: Failure(errorMessage: message)),
      );
      return;
    }

    emit(
      state.copyWith(
        isPlacingOrder: true,
        clearActionFailure: true,
        clearFeedbackMessage: true,
      ),
    );

    final result = await _placeOrderUseCase(
      PlaceOrderRequestEntity(
        vendorId: state.vendorId,
        addressId: selectedAddressId,
        deliverySlotId: selectedDeliverySlotId,
        paymentMethod: selectedPaymentMethodCode,
        promoCode:
            state.appliedPromoCode ?? checkoutSummary.promoCode?.code ?? '',
      ),
    );

    switch (result) {
      case ApiSuccessResult():
        final payment = result.data.payment;
        final isCashOnDelivery = _isCashOnDeliveryMethod(
          result.data.order.paymentMethod,
        );

        PaymentUiEffect? uiEffect;
        if (payment != null) {
          if (payment.isBankTransfer) {
            // Bank transfer: order created but NOT paid. Show pending screen.
            uiEffect = NavigateToBankTransferPendingEffect(
              orderId: result.data.order.id,
              bankTransferConfig: payment.bankTransferConfig,
              providerReference: payment.providerReference,
            );
          } else if (payment.isMoyasarForm && payment.providerConfig != null) {
            uiEffect = OpenMoyasarPaymentEffect(
              payment.providerConfig!,
              orderId: result.data.order.id,
            );
          } else {
            uiEffect = ShowPaymentErrorEffect(
              result.data.message.isNotEmpty
                  ? result.data.message
                  : 'Unable to start the payment session.',
            );
          }
        } else {
          uiEffect = NavigateToPaymentSuccessEffect(
            result.data.order.id,
            isCashOnDelivery: isCashOnDelivery,
          );
        }

        emit(
          state.copyWith(
            isPlacingOrder: false,
            placedOrder: result.data,
            uiEffect: uiEffect,
            clearActionFailure: true,
          ),
        );
      case ApiErrorResult():
        final isPaymentMethodNotSupported =
            result.failure.code == 'PAYMENT_METHOD_NOT_SUPPORTED' ||
            result.failure.code == 'payment_method_not_supported';

        final isCartItemsUnavailable =
            result.failure.code == 'CART_ITEMS_UNAVAILABLE_AT_ADDRESS_BRANCH' ||
            result.failure.code == 'cart_items_unavailable_at_address_branch';

        emit(
          state.copyWith(
            isPlacingOrder: false,
            actionFailure: result.failure,
            uiEffect: isCartItemsUnavailable
                ? ShowCartItemsUnavailableAtBranchEffect(
                    result.failure.errorMessage,
                  )
                : null,
          ),
        );

        if (isPaymentMethodNotSupported) {
          // Reload checkout summary to get updated payment methods.
          _refreshSummary(
            addressId: state.selectedAddressId,
            deliverySlotId: state.selectedDeliverySlotId,
            paymentMethod: null,
            promoCode: state.appliedPromoCode,
          );
        }
    }
  }

  void _handleAddressSelectionResult(String? result) {
    if (result == null) {
      emit(state.copyWith(clearUiEffect: true));
      return;
    }

    if (result == CheckoutAddressSelectorBottomSheet.addNewAddressResult) {
      emit(state.copyWith(uiEffect: const OpenAddAddressEffect()));
      return;
    }

    emit(state.copyWith(clearUiEffect: true));
    _refreshSummary(addressId: result);
  }

  String? _resolvePaymentMethodCode(
    CheckoutSummaryEntity summary, {
    String? preferredCode,
  }) {
    final availableMethods = summary.paymentMethods
        .where((method) => method.isAvailable)
        .toList();

    if (availableMethods.isEmpty) return null;

    if (preferredCode != null &&
        availableMethods.any((method) => method.code == preferredCode)) {
      return preferredCode;
    }

    final defaultMethod = availableMethods.where((method) => method.isDefault);
    if (defaultMethod.isNotEmpty) {
      return defaultMethod.first.code;
    }

    return availableMethods.first.code;
  }

  bool _isCashOnDeliveryMethod(String paymentMethod) {
    final normalized = paymentMethod.trim().toLowerCase();
    return normalized == 'cash' ||
        normalized == 'cash_on_delivery' ||
        normalized == 'cod';
  }

  String? _selectedDeliverySlotIdFromSummary(CheckoutSummaryEntity summary) {
    for (final slot in summary.deliverySlots) {
      if (slot.isSelected) {
        return slot.id;
      }
    }
    return null;
  }
}
