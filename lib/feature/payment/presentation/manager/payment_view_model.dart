import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/core/services/checkout_flow_service.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/place_order_request_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/pickup_branch_option_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/apply_checkout_promo_code_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/get_checkout_config_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/get_pickup_branches_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/get_checkout_summary_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/place_order_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/remove_checkout_promo_code_usecase.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_event.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_state.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/checkout_address_selector_bottom_sheet.dart';

@injectable
class PaymentViewModel extends Cubit<PaymentState> {
  PaymentViewModel(
    this._getCheckoutConfigUseCase,
    this._getCheckoutSummaryUseCase,
    this._getPickupBranchesUseCase,
    this._applyCheckoutPromoCodeUseCase,
    this._removeCheckoutPromoCodeUseCase,
    this._placeOrderUseCase,
    this._getCustomerAddressesUseCase,
  ) : super(const PaymentState());

  final GetCheckoutConfigUseCase _getCheckoutConfigUseCase;
  final GetCheckoutSummaryUseCase _getCheckoutSummaryUseCase;
  final GetPickupBranchesUseCase _getPickupBranchesUseCase;
  final ApplyCheckoutPromoCodeUseCase _applyCheckoutPromoCodeUseCase;
  final RemoveCheckoutPromoCodeUseCase _removeCheckoutPromoCodeUseCase;
  final PlaceOrderUseCase _placeOrderUseCase;
  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;

  void initialize({String? vendorId, bool removeUnavailableItems = false}) {
    if (state.vendorId == vendorId &&
        state.removeUnavailableItems == removeUnavailableItems) {
      return;
    }
    emit(
      state.copyWith(
        vendorId: vendorId,
        removeUnavailableItems: removeUnavailableItems,
      ),
    );
  }

  void initializeCheckout({
    String? vendorId,
    String fulfillmentType = 'delivery',
    String? vendorBranchId,
    bool removeUnavailableItems = false,
  }) {
    if (state.vendorId == vendorId &&
        state.fulfillmentType == fulfillmentType &&
        state.vendorBranchId == vendorBranchId &&
        state.removeUnavailableItems == removeUnavailableItems) {
      return;
    }

    emit(
      state.copyWith(
        vendorId: vendorId,
        fulfillmentType: fulfillmentType,
        vendorBranchId: vendorBranchId,
        removeUnavailableItems: removeUnavailableItems,
      ),
    );
  }

  void doIntent(PaymentEvent event) {
    switch (event) {
      case PaymentLoadEvent():
      case PaymentRetryEvent():
        _loadCheckoutData();
      case PaymentSelectAddressEvent():
        _refreshSummary(addressId: event.addressId);
      case PaymentSelectFulfillmentTypeEvent():
        _changeFulfillmentType(event.fulfillmentType);
      case PaymentRequestPickupBranchSelectionEvent():
        _openPickupBranchSelector();
      case PaymentSelectPickupBranchEvent():
        _selectPickupBranch(event.branchId);
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
        _placeOrder(removeUnavailableItems: event.removeUnavailableItems);
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
        isLoadingConfig: true,
        isLoadingAddresses: true,
        isLoadingPickupBranches: state.isPickup,
        clearSummaryFailure: true,
        clearAddressesFailure: true,
        clearPickupBranchesFailure: true,
        clearActionFailure: true,
        clearFeedbackMessage: true,
      ),
    );

    // Wait for any pending cart sync (e.g. guest cart → authenticated cart)
    // to complete before fetching the checkout summary.
    await CheckoutFlowService().awaitCartSyncIfPending();

    developer.log('Loading checkout summary', name: 'PaymentViewModel');

    final configFuture = _getCheckoutConfigUseCase();
    final checkoutFuture = _getCheckoutSummaryUseCase(
      vendorId: state.vendorId,
      fulfillmentType: state.fulfillmentType,
      vendorBranchId: state.vendorBranchId,
      paymentMethod: state.selectedPaymentMethodCode,
      promoCode: requestedPromoCode,
    );
    final addressesFuture = _getCustomerAddressesUseCase();

    final configResult = await configFuture;
    final checkoutResult = await checkoutFuture;
    final addressesResult = await addressesFuture;

    var nextState = state.copyWith(
      isLoadingSummary: false,
      isLoadingConfig: false,
      isLoadingAddresses: false,
    );

    switch (configResult) {
      case ApiSuccessResult():
        nextState = nextState.copyWith(checkoutConfig: configResult.data);
      case ApiErrorResult():
        // Keep defaults if config fails.
        break;
    }

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
          vendorBranchId:
              state.vendorBranchId ?? checkoutResult.data.pickupBranch?.id,
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

    final config = nextState.checkoutConfig;
    if (config != null) {
      final currentType = nextState.fulfillmentType.trim().toLowerCase();
      if (currentType == 'pickup' &&
          !config.pickupEnabled &&
          config.deliveryEnabled) {
        nextState = nextState.copyWith(fulfillmentType: 'delivery');
      } else if (currentType == 'delivery' &&
          !config.deliveryEnabled &&
          config.pickupEnabled) {
        nextState = nextState.copyWith(fulfillmentType: 'pickup');
      }
    }

    emit(nextState);

    if (nextState.isPickup) {
      await _loadPickupBranches();
    }

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
          vendorBranchId:
              state.vendorBranchId ?? checkoutResult.data.pickupBranch?.id,
          paymentMethod: resolvedPaymentMethod,
          promoCode: nextState.appliedPromoCode,
        );
      }
    }
  }

  Future<void> _refreshSummary({
    String? addressId,
    String? deliverySlotId,
    String? vendorBranchId,
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
      fulfillmentType: state.fulfillmentType,
      addressId: addressId,
      deliverySlotId: deliverySlotId,
      vendorBranchId: vendorBranchId ?? state.vendorBranchId,
      paymentMethod: paymentMethod ?? state.selectedPaymentMethodCode,
      promoCode: promoCode ?? state.appliedPromoCode,
    );

    switch (result) {
      case ApiSuccessResult<CheckoutSummaryEntity>():
        final retainedPromoCode =
            result.data.promoCode?.code ?? promoCode ?? state.appliedPromoCode;

        // A pickup summary without a selected branch reports
        // `pickup_branch_required` with a non-deliverable check. That is an
        // expected selection state, not a delivery failure dialog.
        final deliveryCheck = result.data.deliveryCheck;
        final isDeliveryUnavailable =
            !state.isPickup &&
            deliveryCheck != null &&
            !deliveryCheck.isDeliverable;

        emit(
          state.copyWith(
            isRefreshingSummary: false,
            isChangingFulfillmentType: false,
            vendorBranchId: vendorBranchId ?? result.data.pickupBranch?.id,
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
            isChangingFulfillmentType: false,
            actionFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _changeFulfillmentType(String fulfillmentType) async {
    final normalized = fulfillmentType.trim().toLowerCase();
    if (normalized.isEmpty || normalized == state.fulfillmentType) return;

    final previousFulfillmentType = state.fulfillmentType;

    emit(
      state.copyWith(
        fulfillmentType: normalized,
        isRefreshingSummary: true,
        isChangingFulfillmentType: true,
        isLoadingPickupBranches: normalized == 'pickup',
        clearActionFailure: true,
        clearFeedbackMessage: true,
      ),
    );

    if (normalized == 'pickup') {
      // Request a pickup summary even before a branch is chosen. This clears
      // delivery-only pricing and methods while the branch selector is shown.
      await _refreshSummary(vendorBranchId: state.vendorBranchId);
      await _loadPickupBranches(openSelectorIfNeeded: true);
      return;
    }

    final result = await _getCheckoutSummaryUseCase(
      vendorId: state.vendorId,
      fulfillmentType: normalized,
      addressId: normalized == 'pickup' ? null : state.selectedAddressId,
      deliverySlotId: normalized == 'pickup'
          ? null
          : state.selectedDeliverySlotId,
      vendorBranchId: normalized == 'pickup' ? state.vendorBranchId : null,
      paymentMethod: state.selectedPaymentMethodCode,
      promoCode: state.appliedPromoCode,
    );

    switch (result) {
      case ApiSuccessResult<CheckoutSummaryEntity>():
        emit(
          state.copyWith(
            isRefreshingSummary: false,
            isChangingFulfillmentType: false,
            isLoadingPickupBranches: false,
            fulfillmentType: result.data.fulfillmentType,
            clearVendorBranchId: true,
            checkoutSummary: result.data,
            appliedPromoCode:
                result.data.promoCode?.code ?? state.appliedPromoCode,
            selectedPaymentMethodCode: _resolvePaymentMethodCode(
              result.data,
              preferredCode: state.selectedPaymentMethodCode,
            ),
            clearSummaryFailure: true,
            clearActionFailure: true,
          ),
        );
      case ApiErrorResult<CheckoutSummaryEntity>():
        emit(
          state.copyWith(
            isRefreshingSummary: false,
            isChangingFulfillmentType: false,
            isLoadingPickupBranches: false,
            fulfillmentType: previousFulfillmentType,
            actionFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadPickupBranches({bool openSelectorIfNeeded = false}) async {
    final targetAddress = _resolvePickupAddress();
    final city = targetAddress?.city.trim();
    final hasAddressId = targetAddress?.id.trim().isNotEmpty == true;
    final hasCity = city != null && city.isNotEmpty;

    if (!hasAddressId && !hasCity) {
      emit(
        state.copyWith(
          isLoadingPickupBranches: false,
          isChangingFulfillmentType: false,
          pickupBranches: const [],
          clearVendorBranchId: true,
          actionFailure: Failure(
            errorMessage:
                'Please select or add an address first so we can find pickup branches in your city.',
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoadingPickupBranches: true,
        clearPickupBranchesFailure: true,
        clearActionFailure: true,
      ),
    );

    final result = await _getPickupBranchesUseCase(
      vendorId: state.vendorId,
      addressId: hasAddressId ? targetAddress!.id : null,
      city: hasAddressId ? null : city,
    );

    switch (result) {
      case ApiSuccessResult<List<PickupBranchOptionEntity>>():
        final allBranches = result.data;
        final eligibleBranches = allBranches
            .where((branch) => branch.canFulfillCart)
            .toList();
        final selectedBranchId = state.vendorBranchId;
        final selectedStillValid =
            selectedBranchId != null &&
            eligibleBranches.any((branch) => branch.id == selectedBranchId);

        if (eligibleBranches.length == 1) {
          final autoSelectedBranch = eligibleBranches.first;
          emit(
            state.copyWith(
              pickupBranches: allBranches,
              vendorBranchId: autoSelectedBranch.id,
              isLoadingPickupBranches: false,
              isChangingFulfillmentType: false,
              clearPickupBranchesFailure: true,
            ),
          );
          await _refreshSummary(vendorBranchId: autoSelectedBranch.id);
          return;
        }

        emit(
          state.copyWith(
            pickupBranches: allBranches,
            vendorBranchId: selectedStillValid ? selectedBranchId : null,
            isLoadingPickupBranches: false,
            isChangingFulfillmentType: false,
            clearPickupBranchesFailure: true,
            uiEffect:
                openSelectorIfNeeded &&
                    eligibleBranches.isNotEmpty &&
                    !selectedStillValid
                ? const OpenPickupBranchSelectorEffect()
                : null,
          ),
        );
      case ApiErrorResult<List<PickupBranchOptionEntity>>():
        emit(
          state.copyWith(
            isLoadingPickupBranches: false,
            isChangingFulfillmentType: false,
            pickupBranches: const [],
            clearVendorBranchId: true,
            pickupBranchesFailure: result.failure,
          ),
        );
    }
  }

  CustomerAddressEntity? _resolvePickupAddress() {
    final selectedAddressId = state.selectedAddressId;

    if (selectedAddressId != null) {
      for (final address in state.addresses) {
        if (address.id == selectedAddressId) {
          return address;
        }
      }
    }

    for (final address in state.addresses) {
      if (address.isDefault) {
        return address;
      }
    }

    return state.addresses.isNotEmpty ? state.addresses.first : null;
  }

  void _openPickupBranchSelector() {
    if (state.pickupBranches.isEmpty) {
      _loadPickupBranches(openSelectorIfNeeded: true);
      return;
    }

    emit(state.copyWith(uiEffect: const OpenPickupBranchSelectorEffect()));
  }

  Future<void> _selectPickupBranch(String branchId) async {
    if (branchId.trim().isEmpty || branchId == state.vendorBranchId) return;

    emit(state.copyWith(vendorBranchId: branchId, clearActionFailure: true));
    await _refreshSummary(vendorBranchId: branchId);
  }

  void _selectPaymentMethod(String paymentMethodCode) {
    if (state.selectedPaymentMethodCode == paymentMethodCode) return;

    if (!_isPaymentMethodSupportedOnCurrentPlatform(paymentMethodCode)) {
      return;
    }

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
      addressId: state.isPickup ? null : state.selectedAddressId,
      deliverySlotId: state.isPickup ? null : state.selectedDeliverySlotId,
      vendorBranchId: state.vendorBranchId,
      paymentMethod: paymentMethodCode,
      promoCode: state.appliedPromoCode,
    );
  }

  bool _isPaymentMethodSupportedOnCurrentPlatform(String paymentMethodCode) {
    if (isBankTransferPaymentMethod(paymentMethodCode)) return false;

    return paymentMethodCode.trim().toLowerCase() != 'apple_pay' ||
        defaultTargetPlatform == TargetPlatform.iOS;
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
      fulfillmentType: state.fulfillmentType,
      vendorBranchId: state.isPickup
          ? (state.vendorBranchId ?? state.checkoutSummary?.pickupBranch?.id)
          : null,
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
      fulfillmentType: state.fulfillmentType,
      vendorBranchId: state.isPickup
          ? (state.vendorBranchId ?? state.checkoutSummary?.pickupBranch?.id)
          : null,
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

  Future<void> _placeOrder({bool removeUnavailableItems = false}) async {
    final checkoutSummary = state.checkoutSummary;
    final selectedPaymentMethodCode = state.selectedPaymentMethodCode;
    final selectedAddressId = state.selectedAddressId;
    final selectedDeliverySlotId = state.selectedDeliverySlotId;
    final selectedVendorBranchId =
        state.vendorBranchId ?? checkoutSummary?.pickupBranch?.id;

    if (checkoutSummary == null ||
        selectedPaymentMethodCode == null ||
        (!state.isPickup &&
            (selectedAddressId == null || selectedDeliverySlotId == null)) ||
        (state.isPickup && selectedVendorBranchId == null)) {
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
    if (!state.isPickup && !checkoutSummary.isDeliveryValid) {
      final message =
          checkoutSummary.deliveryCheck?.messageAr.isNotEmpty == true
          ? checkoutSummary.deliveryCheck!.messageAr
          : 'Delivery is not available for the selected address.';
      emit(state.copyWith(actionFailure: Failure(errorMessage: message)));
      return;
    }

    final shouldRemoveUnavailableItems =
        removeUnavailableItems || state.removeUnavailableItems;
    if (checkoutSummary.cart.requiresUnavailableItemsConfirmation &&
        !shouldRemoveUnavailableItems) {
      emit(
        state.copyWith(
          uiEffect: ConfirmUnavailableItemsEffect(
            unavailableItemsCount: checkoutSummary.cart.unavailableItemsCount,
          ),
        ),
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
        fulfillmentType: state.fulfillmentType,
        addressId: state.isPickup ? null : selectedAddressId,
        deliverySlotId: state.isPickup ? null : selectedDeliverySlotId,
        vendorBranchId: state.isPickup ? selectedVendorBranchId : null,
        paymentMethod: selectedPaymentMethodCode,
        promoCode:
            state.appliedPromoCode ?? checkoutSummary.promoCode?.code ?? '',
        removeUnavailableItems: shouldRemoveUnavailableItems,
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
        final requiresUnavailableItemsConfirmation =
            result.failure.code ==
                'CART_UNAVAILABLE_ITEMS_CONFIRMATION_REQUIRED' ||
            result.failure.code ==
                'cart_unavailable_items_confirmation_required';
        final insufficientStock =
            result.failure.code == 'INSUFFICIENT_STOCK' ||
            result.failure.code == 'insufficient_stock';

        emit(
          state.copyWith(
            isPlacingOrder: false,
            actionFailure:
                requiresUnavailableItemsConfirmation || isCartItemsUnavailable
                ? null
                : result.failure,
            clearActionFailure:
                requiresUnavailableItemsConfirmation || isCartItemsUnavailable,
            uiEffect: requiresUnavailableItemsConfirmation
                ? ConfirmUnavailableItemsEffect(
                    unavailableItemsCount:
                        checkoutSummary.cart.unavailableItemsCount,
                  )
                : isCartItemsUnavailable
                ? ShowCartItemsUnavailableAtBranchEffect(
                    result.failure.errorMessage,
                  )
                : null,
          ),
        );

        if (isPaymentMethodNotSupported ||
            insufficientStock ||
            isCartItemsUnavailable) {
          // Reload checkout summary to get updated payment methods.
          _refreshSummary(
            addressId: state.isPickup ? null : state.selectedAddressId,
            deliverySlotId: state.isPickup
                ? null
                : state.selectedDeliverySlotId,
            vendorBranchId: state.vendorBranchId,
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
    if (state.isPickup) {
      emit(
        state.copyWith(
          clearVendorBranchId: true,
          pickupBranches: const [],
          clearPickupBranchesFailure: true,
        ),
      );
      _loadPickupBranches(openSelectorIfNeeded: true);
      return;
    }

    _refreshSummary(addressId: result);
  }

  String? _resolvePaymentMethodCode(
    CheckoutSummaryEntity summary, {
    String? preferredCode,
  }) {
    final availableMethods = summary.paymentMethods
        .where(
          (method) =>
              method.isAvailable &&
              _isPaymentMethodSupportedOnCurrentPlatform(method.code),
        )
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
