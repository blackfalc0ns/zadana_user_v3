import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
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
      case PaymentHandleWebViewResultEvent():
        _handleWebViewResult(
          result: event.result,
          fallbackErrorMessage: event.fallbackErrorMessage,
          pendingMessage: event.pendingMessage,
        );
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

    developer.log('Loading checkout summary', name: 'PaymentViewModel');

    final checkoutFuture = _getCheckoutSummaryUseCase();
    final addressesFuture = _getCustomerAddressesUseCase();

    final checkoutResult = await checkoutFuture;
    final addressesResult = await addressesFuture;

    var nextState = state.copyWith(
      isLoadingSummary: false,
      isLoadingAddresses: false,
    );

    switch (checkoutResult) {
      case ApiSuccessResult<CheckoutSummaryEntity>():
        nextState = nextState.copyWith(
          checkoutSummary: checkoutResult.data,
          selectedPaymentMethodCode: _resolvePaymentMethodCode(
            checkoutResult.data,
            preferredCode: state.selectedPaymentMethodCode,
          ),
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
  }

  Future<void> _refreshSummary({
    String? addressId,
    String? deliverySlotId,
  }) async {
    emit(
      state.copyWith(
        isRefreshingSummary: true,
        clearActionFailure: true,
        clearFeedbackMessage: true,
      ),
    );

    final result = await _getCheckoutSummaryUseCase(
      addressId: addressId,
      deliverySlotId: deliverySlotId,
    );

    switch (result) {
      case ApiSuccessResult<CheckoutSummaryEntity>():
        emit(
          state.copyWith(
            isRefreshingSummary: false,
            checkoutSummary: result.data,
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

    final result = await _applyCheckoutPromoCodeUseCase(trimmedCode);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isApplyingPromo: false,
            checkoutSummary: state.checkoutSummary!.copyWith(
              promoCode: result.data.promoCode,
              clearPromoCode: result.data.promoCode == null,
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

    final result = await _removeCheckoutPromoCodeUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isRemovingPromo: false,
            checkoutSummary: state.checkoutSummary!.copyWith(
              clearPromoCode: true,
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
          actionFailure: const Failure(
            errorMessage: 'Please complete the checkout details first.',
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
        addressId: selectedAddressId,
        deliverySlotId: selectedDeliverySlotId,
        paymentMethod: selectedPaymentMethodCode,
        promoCode: checkoutSummary.promoCode?.code ?? '',
      ),
    );

    switch (result) {
      case ApiSuccessResult():
        final iframeUrl = result.data.payment?.iframeUrl ?? '';
        emit(
          state.copyWith(
            isPlacingOrder: false,
            placedOrder: result.data,
            uiEffect: iframeUrl.isNotEmpty
                ? OpenPaymentWebViewEffect(iframeUrl)
                : NavigateToPaymentSuccessEffect(result.data.order.id),
            clearActionFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isPlacingOrder: false, actionFailure: result.failure),
        );
    }
  }

  void _handleAddressSelectionResult(String? result) {
    if (result == null) {
      emit(state.copyWith(clearUiEffect: true));
      return;
    }

    if (result == 'add_new_address') {
      emit(state.copyWith(uiEffect: const OpenAddAddressEffect()));
      return;
    }

    emit(state.copyWith(clearUiEffect: true));
    _refreshSummary(addressId: result);
  }

  void _handleWebViewResult({
    required Map<String, String?>? result,
    required String fallbackErrorMessage,
    required String pendingMessage,
  }) {
    emit(state.copyWith(clearUiEffect: true));
    if (result == null) {
      return;
    }

    final paymentStatus = _resolveWebViewPaymentStatus(result);
    final paymentMessage = result['message'];
    final callbackOrderId = result['orderId'];
    final orderId = callbackOrderId ?? state.placedOrder?.order.id;

    if (paymentStatus == 'failed') {
      emit(
        state.copyWith(
          uiEffect: ShowPaymentErrorEffect(
            paymentMessage ?? fallbackErrorMessage,
          ),
        ),
      );
      return;
    }

    if (paymentStatus == 'pending') {
      emit(
        state.copyWith(
          uiEffect: ShowPaymentInfoEffect(paymentMessage ?? pendingMessage),
        ),
      );
      return;
    }

    if (paymentStatus == 'success' && orderId != null && orderId.isNotEmpty) {
      emit(state.copyWith(uiEffect: NavigateToPaymentSuccessEffect(orderId)));
      return;
    }

    emit(
      state.copyWith(
        uiEffect: ShowPaymentErrorEffect(
          paymentMessage ?? fallbackErrorMessage,
        ),
      ),
    );
  }

  String? _resolveWebViewPaymentStatus(Map<String, String?> result) {
    final directStatus = result['status']?.trim().toLowerCase();
    if (directStatus == 'success' ||
        directStatus == 'failed' ||
        directStatus == 'pending') {
      return directStatus;
    }

    final rawPaymentStatus = result['paymentStatus']?.trim().toLowerCase();
    if (rawPaymentStatus == 'paid' ||
        rawPaymentStatus == 'success' ||
        rawPaymentStatus == 'succeeded') {
      return 'success';
    }

    if (rawPaymentStatus == 'failed' ||
        rawPaymentStatus == 'unpaid' ||
        rawPaymentStatus == 'canceled' ||
        rawPaymentStatus == 'cancelled') {
      return 'failed';
    }

    if (rawPaymentStatus == 'pending' || rawPaymentStatus == 'processing') {
      return 'pending';
    }

    final orderStatus = result['orderStatus']?.trim().toLowerCase();
    if (orderStatus?.contains('pending') ?? false) {
      return 'pending';
    }

    return null;
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
}
