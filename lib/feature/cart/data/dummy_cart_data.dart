import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

// ══════════════════════════════════════════════
// DUMMY CART DATA
// ══════════════════════════════════════════════

final List<CartItemModel> dummyCartItems = [
  CartItemModel(
    id: '1',
    name: 'تفاح أحمر',
    imageUrl: '🍎',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 26),
      VendorPrice(id: 'v2', name: 'سبينس', price: 24),
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 28),
      VendorPrice(id: 'v4', name: 'بشاير', price: 23),
      VendorPrice(id: 'v5', name: 'أونستوب', price: 25),
      VendorPrice(id: 'v6', name: 'فاتورة', price: 22),
      VendorPrice(id: 'v7', name: 'جملة', price: 20),
    ],
  ),
  CartItemModel(
    id: '2',
    name: 'جمبري',
    imageUrl: '🦐',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 40),
      VendorPrice(id: 'v2', name: 'سبينس', price: 38),
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 42),
      VendorPrice(id: 'v4', name: 'بشاير', price: 37),
      VendorPrice(id: 'v5', name: 'أونستوب', price: 39),
      VendorPrice(id: 'v6', name: 'فاتورة', price: 36),
      VendorPrice(id: 'v7', name: 'جملة', price: 35),
    ],
  ),
  CartItemModel(
    id: '3',
    name: 'بروكلي',
    imageUrl: '🥦',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 26),
      VendorPrice(id: 'v2', name: 'سبينس', price: 24),
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 27),
      VendorPrice(id: 'v4', name: 'بشاير', price: 23),
      VendorPrice(id: 'v5', name: 'أونستوب', price: 25),
      VendorPrice(id: 'v6', name: 'فاتورة', price: 22),
      VendorPrice(id: 'v7', name: 'جملة', price: 21),
    ],
  ),
  CartItemModel(
    id: '4',
    name: 'رمان',
    imageUrl: '🍷',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 24),
      VendorPrice(id: 'v2', name: 'سبينس', price: 22),
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 25),
      VendorPrice(id: 'v4', name: 'بشاير', price: 21),
      VendorPrice(id: 'v5', name: 'أونستوب', price: 23),
      VendorPrice(id: 'v6', name: 'فاتورة', price: 20),
      VendorPrice(id: 'v7', name: 'جملة', price: 19),
    ],
  ),
  CartItemModel(
    id: '5',
    name: 'بصل أحمر',
    imageUrl: '🧅',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 8),
      VendorPrice(id: 'v2', name: 'سبينس', price: 7),
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 9),
      VendorPrice(id: 'v4', name: 'بشاير', price: 6),
      VendorPrice(id: 'v5', name: 'أونستوب', price: 8),
      VendorPrice(id: 'v6', name: 'فاتورة', price: 7),
      VendorPrice(id: 'v7', name: 'جملة', price: 5),
    ],
  ),
];
