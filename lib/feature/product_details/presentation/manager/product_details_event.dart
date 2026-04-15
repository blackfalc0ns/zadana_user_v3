abstract class ProductDetailsEvent {
  const ProductDetailsEvent();
}

class InitializeProductDetailsEvent extends ProductDetailsEvent {
  const InitializeProductDetailsEvent({
    required this.productId,
    this.activeProductId,
  });

  final String productId;
  final String? activeProductId;
}

class LoadProductDetailsEvent extends ProductDetailsEvent {
  const LoadProductDetailsEvent();
}

class IncreaseProductQuantityEvent extends ProductDetailsEvent {
  const IncreaseProductQuantityEvent();
}

class DecreaseProductQuantityEvent extends ProductDetailsEvent {
  const DecreaseProductQuantityEvent();
}

class SetActiveProductDetailsEvent extends ProductDetailsEvent {
  const SetActiveProductDetailsEvent(this.productId);

  final String? productId;
}

class AddProductToCartEvent extends ProductDetailsEvent {
  const AddProductToCartEvent();
}

class ClearProductDetailsFeedbackEvent extends ProductDetailsEvent {
  const ClearProductDetailsFeedbackEvent();
}
