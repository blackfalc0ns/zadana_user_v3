import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class HomeData {
  // ── Special Offers ────────────────────────────────────────────
  static const List<ProductModel> specialOffers = [
    ProductModel(
      id: 'so1', name: 'فراولة عضوية', store: 'مزرعة فريش',
      price: 4.50, oldPrice: 6.00, imageUrl: '',
      discount: '25% خصم', emoji: '🍓',
    ),
    ProductModel(
      id: 'so2', name: 'حليب كامل الدسم 1 لتر', store: 'عالم الألبان',
      price: 2.10, oldPrice: 2.40, imageUrl: '',
      discount: '10% خصم', emoji: '🥛',
    ),
    ProductModel(
      id: 'so3', name: 'عسل طبيعي', store: 'مزرعة مباشر',
      price: 3.20, oldPrice: 4.00, imageUrl: '',
      discount: '20% خصم', emoji: '🍯',
    ),
  ];

  // ── Best Selling ──────────────────────────────────────────────
  static const List<ProductModel> bestSelling = [
    ProductModel(
      id: 'bs1', name: 'عصير برتقال طازج', store: 'سوق الخضرة',
      price: 3.99, imageUrl: '',
      rating: 4.9, reviewCount: 120, unit: 'لتر', emoji: '🍊',
    ),
    ProductModel(
      id: 'bs2', name: 'بسكويت شوكولاتة', store: 'مخبز البيت',
      price: 5.50, imageUrl: '',
      rating: 4.8, reviewCount: 85, emoji: '🍪',
    ),
    ProductModel(
      id: 'bs3', name: 'زيت زيتون بكر', store: 'طبيعة أفضل',
      price: 7.80, imageUrl: '',
      rating: 4.7, reviewCount: 64, emoji: '🫒',
    ),
  ];

  // ── Featured Products ─────────────────────────────────────────
  static const List<ProductModel> featured = [
    ProductModel(
      id: 'fp1', name: 'شوفان كامل', store: 'فريش فارم',
      price: 1.99, imageUrl: '',
      isFavorite: false, unit: 'كجم', emoji: '🌾',
    ),
    ProductModel(
      id: 'fp2', name: 'زبدة فول سوداني', store: 'ركن الفاكهة',
      price: 3.25, imageUrl: '',
      isFavorite: true, unit: 'جم', emoji: '🥜',
    ),
  ];

  // ── Recommended ───────────────────────────────────────────────
  static const List<ProductModel> recommended = [
    ProductModel(
      id: 'rc1', name: 'نوتيلا 400 جم', store: 'ملك الحلويات',
      price: 4.00, imageUrl: '', emoji: '🍫',
    ),
    ProductModel(
      id: 'rc2', name: 'كورن فليكس', store: 'الأكل الصحي',
      price: 12.00, imageUrl: '', emoji: '🥣',
    ),
    ProductModel(
      id: 'rc3', name: 'زبادي يوناني', store: 'عالم الألبان',
      price: 3.50, imageUrl: '', emoji: '🫙',
    ),
  ];

  // ── Explore More ──────────────────────────────────────────────
  static const List<ProductModel> exploreMore = [
    ProductModel(
      id: 'em1', name: 'شعرية باستا بارييلا', store: 'المطبخ الإيطالي',
      price: 6.99, imageUrl: '', emoji: '🍝',
    ),
    ProductModel(
      id: 'em2', name: 'تونة معلبة في الزيت', store: 'صيد المحيط',
      price: 18.50, imageUrl: '', unit: 'علبة', emoji: '🐟',
    ),
    ProductModel(
      id: 'em3', name: 'رقائق بطاطس ليز', store: 'ركن الوجبات',
      price: 9.00, imageUrl: '', emoji: '🍿',
    ),
  ];
}