import 'package:zadana_user_v3/feature/cart/domain/entities/cart_item_entity.dart';

// ══════════════════════════════════════════════
// DUMMY CART DATA
// ══════════════════════════════════════════════
// ملاحظات هامة:
// - السعر 0 يعني أن المنتج غير متوفر في هذا المتجر
// - بعض المنتجات متوفرة في جميع المتاجر
// - بعض المنتجات غير متوفرة في متاجر معينة
// ══════════════════════════════════════════════

final List<CartItemModel> dummyCartItems = [
  // ══════════════════════════════════════════════
  // منتج 1: تفاح أحمر - متوفر في جميع المتاجر
  // ══════════════════════════════════════════════
  CartItemModel(
    id: '1',
    name: 'تفاح أحمر',
    imageUrl: '🍎',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 26, oldPrice: 30, isDiscounted: true),
      VendorPrice(id: 'v2', name: 'سبينس', price: 24, oldPrice: 28, isDiscounted: true),
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 28),
      VendorPrice(id: 'v4', name: 'بشاير', price: 23, oldPrice: 27, isDiscounted: true),
      VendorPrice(id: 'v5', name: 'أونستوب', price: 25),
      VendorPrice(id: 'v6', name: 'فاتورة', price: 22, oldPrice: 25, isDiscounted: true),
      VendorPrice(id: 'v7', name: 'جملة', price: 20, oldPrice: 24, isDiscounted: true),
    ],
  ),

  // ══════════════════════════════════════════════
  // منتج 2: جمبري - غير متوفر في سبينس وأونستوب
  // ══════════════════════════════════════════════
  CartItemModel(
    id: '2',
    name: 'جمبري',
    imageUrl: '🦐',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 40, oldPrice: 50, isDiscounted: true),
      VendorPrice(id: 'v2', name: 'سبينس', price: 0), // غير متوفر
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 42),
      VendorPrice(id: 'v4', name: 'بشاير', price: 37, oldPrice: 45, isDiscounted: true),
      VendorPrice(id: 'v5', name: 'أونستوب', price: 0), // غير متوفر
      VendorPrice(id: 'v6', name: 'فاتورة', price: 36),
      VendorPrice(id: 'v7', name: 'جملة', price: 35, oldPrice: 42, isDiscounted: true),
    ],
  ),

  // ══════════════════════════════════════════════
  // منتج 3: بروكلي - متوفر في جميع المتاجر
  // ══════════════════════════════════════════════
  CartItemModel(
    id: '3',
    name: 'بروكلي',
    imageUrl: '🥦',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 26),
      VendorPrice(id: 'v2', name: 'سبينس', price: 24, oldPrice: 28, isDiscounted: true),
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 27),
      VendorPrice(id: 'v4', name: 'بشاير', price: 23),
      VendorPrice(id: 'v5', name: 'أونستوب', price: 25),
      VendorPrice(id: 'v6', name: 'فاتورة', price: 22, oldPrice: 26, isDiscounted: true),
      VendorPrice(id: 'v7', name: 'جملة', price: 21),
    ],
  ),

  // ══════════════════════════════════════════════
  // منتج 4: رمان - غير متوفر في هايبر وان وبشاير
  // ══════════════════════════════════════════════
  CartItemModel(
    id: '4',
    name: 'رمان',
    imageUrl: '🍷',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 24, oldPrice: 29, isDiscounted: true),
      VendorPrice(id: 'v2', name: 'سبينس', price: 22),
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 0), // غير متوفر
      VendorPrice(id: 'v4', name: 'بشاير', price: 0), // غير متوفر
      VendorPrice(id: 'v5', name: 'أونستوب', price: 23),
      VendorPrice(id: 'v6', name: 'فاتورة', price: 20),
      VendorPrice(id: 'v7', name: 'جملة', price: 19, oldPrice: 23, isDiscounted: true),
    ],
  ),

  // ══════════════════════════════════════════════
  // منتج 5: بصل أحمر - متوفر في جميع المتاجر
  // ══════════════════════════════════════════════
  CartItemModel(
    id: '5',
    name: 'بصل أحمر',
    imageUrl: '🧅',
    unit: 'كيلو',
    quantity: 1,
    vendorPrices: const [
      VendorPrice(id: 'v1', name: 'كارفور', price: 8),
      VendorPrice(id: 'v2', name: 'سبينس', price: 7, oldPrice: 9, isDiscounted: true),
      VendorPrice(id: 'v3', name: 'هايبر وان', price: 9),
      VendorPrice(id: 'v4', name: 'بشاير', price: 6),
      VendorPrice(id: 'v5', name: 'أونستوب', price: 8),
      VendorPrice(id: 'v6', name: 'فاتورة', price: 7),
      VendorPrice(id: 'v7', name: 'جملة', price: 5, oldPrice: 7, isDiscounted: true),
    ],
  ),
];
