import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class HomeData {
  // ── Special Offers ────────────────────────────────────────────
  static const List<ProductModel> specialOffers = [
    ProductModel(
      id: 'so1', name: 'فراولة عضوية', store: 'مزرعة فريش',
      price: 4.50, oldPrice: 6.00, imageUrl: '',
      discount: '25',
       emoji: '🍓',
       isDiscounted: true,
    ),
    ProductModel(
      id: 'so2', name: 'حليب كامل الدسم 1 لتر', store: 'عالم الألبان',
      price: 2.10, oldPrice: 2.40, imageUrl: '',
      discount: '10', emoji: '🥛',
      isDiscounted: false
    ),
    ProductModel(
      id: 'so3', 
      name: 'عسل طبيعي',
       store: 'مزرعة مباشر',
      price: 3.20, 
      oldPrice: 4.00, 
      imageUrl: '',
      discount: '20',
       emoji: '🍯',
      isDiscounted: true

       
    ),
  ];

  // ── Best Selling ──────────────────────────────────────────────
  static const List<ProductModel> bestSelling = [
    ProductModel(
      id: 'bs1', name: 'عصير برتقال طازج', store: 'سوق الخضرة',
      price: 3.99, imageUrl: '',
      rating: 4.9, reviewCount: 120, unit: 'لتر', emoji: '🍊',
      isDiscounted: false
    ),
    ProductModel(
      id: 'bs2', name: 'بسكويت شوكولاتة', store: 'مخبز البيت',
      price: 5.50, imageUrl: '',
      rating: 4.8, reviewCount: 85, emoji: '🍪',
      isDiscounted: true
    ),
    ProductModel(
      id: 'bs3', name: 'زيت زيتون بكر', store: 'طبيعة أفضل',
      price: 7.80, imageUrl: '',
      rating: 4.7, reviewCount: 64, emoji: '🫒',
      isDiscounted: false
    ),
  ];

  // ── Featured Products ─────────────────────────────────────────
  static const List<ProductModel> featured = [
    ProductModel(
      id: 'fp1', name: 'شوفان كامل', store: 'فريش فارم',
      price: 1.99, imageUrl: '',
      isFavorite: true, unit: 'كجم', emoji: '🌾',
      isDiscounted: false
    ),
    ProductModel(
      id: 'fp2', name: 'زبدة فول سوداني', store: 'ركن الفاكهة',
      price: 3.25, imageUrl: '',
      isFavorite: true, unit: 'جم', emoji: '🥜', isDiscounted: false
    ),
    ProductModel(
      id: 'fp3', name: 'أرز بسمتي', store: 'حبوب الشرق', isDiscounted: false ,
      price: 2.75, imageUrl: '',
      isFavorite: true, unit: 'كجم', emoji: '🍚',
    ),
    ProductModel(
      id: 'fp4', name: 'زيت عباد الشمس', store: 'طبيعة نقية', isDiscounted: false,
      price: 4.50, imageUrl: '',
      isFavorite: true, unit: 'لتر', emoji: '🌻',
    ),
    ProductModel(
      id: 'fp5', name: 'سكر أبيض', store: 'حلاوة البيت', isDiscounted: false,
      price: 1.80, imageUrl: '',
      isFavorite: true, unit: 'كجم', emoji: '🍯',
    ),
    ProductModel(
      id: 'fp6', name: 'ملح البحر', store: 'كنوز البحر', isDiscounted: false,
      price: 0.99, imageUrl: '',
      isFavorite: true, unit: 'كجم', emoji: '🧂',
    ),
    ProductModel(
      id: 'fp7', name: 'معكرونة إيطالية', store: 'المطبخ الإيطالي', isDiscounted: false,
      price: 5.50, imageUrl: '',
      isFavorite: true, unit: 'كجم', emoji: '🍝',
    ),
    ProductModel(
      id: 'fp8', name: 'صلصة طماطم', store: 'مزرعة فريش', isDiscounted: false,
      price: 2.99, imageUrl: '',
      isFavorite: true, unit: 'علبة', emoji: '🍅',
    ),
    ProductModel(
      id: 'fp9', name: 'جبنة موزاريلا', store: 'عالم الألبان', isDiscounted: false,
      price: 8.50, imageUrl: '',
      isFavorite: true, unit: 'كجم', emoji: '🧀',
    ),
    ProductModel(
      id: 'fp10', name: 'خبز توست', store: 'مخبز البيت', isDiscounted: false,
      price: 3.75, imageUrl: '',
      isFavorite: true, unit: 'كيس', emoji: '🍞',
    ),
    ProductModel(
      id: 'fp11', name: 'بيض طازج', store: 'مزرعة مباشر', isDiscounted: false,
      price: 4.20, imageUrl: '',
      isFavorite: true, unit: 'كرتونة', emoji: '🥚',
    ),
    ProductModel(
      id: 'fp12', name: 'حليب طازج', store: 'عالم الألبان', isDiscounted: false,
      price: 2.50, imageUrl: '',
      isFavorite: true, unit: 'لتر', emoji: '🥛',
    ),
    ProductModel(
      id: 'fp13', name: 'زبدة طبيعية', store: 'طبيعة نقية', isDiscounted: false,
      price: 6.99, imageUrl: '',
      isFavorite: true, unit: 'علبة', emoji: '🧈',
    ),
    ProductModel(
      id: 'fp14', name: 'مربى فراولة', store: 'حلاوة البيت', isDiscounted: false,
      price: 4.50, imageUrl: '',
      isFavorite: true, unit: 'برطمان', emoji: '🍓',
    ),
    ProductModel(
      id: 'fp15', name: 'شاي أخضر', store: 'ركن المشروبات', isDiscounted: false,
      price: 7.25, imageUrl: '',
      isFavorite: true, unit: 'علبة', emoji: '🍵',
    ),
  ];

  // ── Recommended ───────────────────────────────────────────────
  static const List<ProductModel> recommended = [
    ProductModel(
      id: 'rc1', name: 'نوتيلا 400 جم', store: 'ملك الحلويات', isDiscounted: false,
      price: 4.00, imageUrl: '', emoji: '🍫',
    ),
    ProductModel(
      id: 'rc2', name: 'كورن فليكس', store: 'الأكل الصحي', isDiscounted: false,
      price: 12.00, imageUrl: '', emoji: '🥣',
    ),
    ProductModel(
      id: 'rc3', name: 'زبادي يوناني', store: 'عالم الألبان', isDiscounted: false,
      price: 3.50, imageUrl: '', emoji: '🫙',
    ),
  ];

  // ── Explore More ──────────────────────────────────────────────
  static const List<ProductModel> exploreMore = [
    ProductModel(
      id: 'em1', name: 'شعرية باستا بارييلا', store: 'المطبخ الإيطالي', isDiscounted: false,
      price: 6.99, imageUrl: '', emoji: '🍝',
    ),
    ProductModel(
      id: 'em2', name: 'تونة معلبة في الزيت', store: 'صيد المحيط', isDiscounted: false,
      price: 18.50, imageUrl: '', unit: 'علبة', emoji: '🐟',
    ),
    ProductModel(
      id: 'em3', name: 'رقائق بطاطس ليز', store: 'ركن الوجبات', isDiscounted: false,
      price: 9.00, imageUrl: '', emoji: '🍿',
    ),
  ];
}