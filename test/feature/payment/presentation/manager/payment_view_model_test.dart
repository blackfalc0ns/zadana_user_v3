import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/domain/repo/customer_addresses_repository.dart';
import 'package:zadana_user_v3/feature/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_config_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/domain/repo/payment_repository.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/apply_checkout_promo_code_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/get_checkout_config_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/get_checkout_summary_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/get_pickup_branches_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/place_order_usecase.dart';
import 'package:zadana_user_v3/feature/payment/domain/usecase/remove_checkout_promo_code_usecase.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_event.dart';
import 'package:zadana_user_v3/feature/payment/presentation/manager/payment_view_model.dart';

void main() {
  test(
    'does not emit when checkout data completes after the cubit is closed',
    () async {
      final paymentRepository = _CheckoutPaymentRepository();
      final addressesRepository = _DelayedAddressesRepository();
      final viewModel = PaymentViewModel(
        GetCheckoutConfigUseCase(paymentRepository),
        GetCheckoutSummaryUseCase(paymentRepository),
        GetPickupBranchesUseCase(paymentRepository),
        ApplyCheckoutPromoCodeUseCase(paymentRepository),
        RemoveCheckoutPromoCodeUseCase(paymentRepository),
        PlaceOrderUseCase(paymentRepository),
        GetCustomerAddressesUseCase(addressesRepository),
      );

      viewModel.doIntent(const PaymentLoadEvent());
      await paymentRepository.summaryRequested.future;
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.isLoadingAddresses, isTrue);

      await viewModel.close();
      addressesRepository.resultCompleter.complete(
        ApiSuccessResult<List<CustomerAddressEntity>>(data: const []),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.isClosed, isTrue);
      expect(
        () => viewModel.doIntent(const PaymentLoadEvent()),
        returnsNormally,
      );
    },
  );
}

class _CheckoutPaymentRepository implements PaymentRepository {
  final Completer<void> summaryRequested = Completer<void>();

  @override
  Future<ApiResult<CheckoutConfigEntity>> getCheckoutConfig() async {
    return ApiSuccessResult(
      data: const CheckoutConfigEntity(
        deliveryEnabled: true,
        pickupEnabled: true,
        pickupCashOnPickupEnabled: true,
        allowedPaymentsForPickup: [],
      ),
    );
  }

  @override
  Future<ApiResult<CheckoutSummaryEntity>> getCheckoutSummary({
    String? vendorId,
    String? fulfillmentType,
    String? addressId,
    String? deliverySlotId,
    String? vendorBranchId,
    String? paymentMethod,
    String? promoCode,
  }) async {
    if (!summaryRequested.isCompleted) summaryRequested.complete();
    return ApiErrorResult(
      failure: Failure(errorMessage: 'Test checkout failure'),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DelayedAddressesRepository implements CustomerAddressesRepository {
  final Completer<ApiResult<List<CustomerAddressEntity>>> resultCompleter =
      Completer<ApiResult<List<CustomerAddressEntity>>>();

  @override
  Future<ApiResult<List<CustomerAddressEntity>>> getCustomerAddresses() {
    return resultCompleter.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
