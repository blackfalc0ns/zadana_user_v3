import 'package:zadana_user_v3/feature/cart/domain/entities/cart_summary_entity.dart';

class RemoveCartItemResponseEntity {
  const RemoveCartItemResponseEntity({
    required this.message,
    required this.summary,
  });

  final String message;
  final CartSummaryEntity summary;
}
