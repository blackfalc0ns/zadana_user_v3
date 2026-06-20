import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';

class CartVendorsEntity {
  const CartVendorsEntity({
    required this.vendors,
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  final List<CartVendorEntity> vendors;
  final int total;
  final int limit;
  final int offset;
  final bool hasMore;
}
