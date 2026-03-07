import 'category_product_model.dart';

class CategoryProductData {
  // ── Sub-categories ────────────────────────────────────────────
  static const Map<String, List<SubCategoryModel>> subCategories = {
    'hc1': [
      SubCategoryModel(id: 'all',    name: 'الكل'),
      SubCategoryModel(id: 'onion',  name: 'بصل'),
      SubCategoryModel(id: 'potato', name: 'بطاطس'),
      SubCategoryModel(id: 'tomato', name: 'طماطم'),
      SubCategoryModel(id: 'carrot', name: 'جزر'),
      SubCategoryModel(id: 'pepper', name: 'فلفل'),
    ],
    'hc2': [
      SubCategoryModel(id: 'all',    name: 'الكل'),
      SubCategoryModel(id: 'butter', name: 'زبدة'),
      SubCategoryModel(id: 'laban',  name: 'لبن'),
      SubCategoryModel(id: 'yogurt', name: 'زبادي'),
      SubCategoryModel(id: 'cheese', name: 'جبن'),
    ],
    'hc3': [
      SubCategoryModel(id: 'all',    name: 'الكل'),
      SubCategoryModel(id: 'bread',  name: 'خبز'),
      SubCategoryModel(id: 'cake',   name: 'كيك'),
      SubCategoryModel(id: 'cookie', name: 'بسكويت'),
    ],
    'hc4': [
      SubCategoryModel(id: 'all',     name: 'الكل'),
      SubCategoryModel(id: 'beef',    name: 'لحم بقري'),
      SubCategoryModel(id: 'chicken', name: 'دجاج'),
      SubCategoryModel(id: 'fish',    name: 'سمك'),
    ],
    'hc5': [
      SubCategoryModel(id: 'all',   name: 'الكل'),
      SubCategoryModel(id: 'juice', name: 'عصائر'),
      SubCategoryModel(id: 'water', name: 'مياه'),
      SubCategoryModel(id: 'soda',  name: 'مشروبات غازية'),
    ],
    'hc6': [
      SubCategoryModel(id: 'all',     name: 'الكل'),
      SubCategoryModel(id: 'clean',   name: 'منظفات'),
      SubCategoryModel(id: 'kitchen', name: 'مطبخ'),
    ],
    'hc7': [
      SubCategoryModel(id: 'all',    name: 'الكل'),
      SubCategoryModel(id: 'hair',   name: 'شعر'),
      SubCategoryModel(id: 'skin',   name: 'بشرة'),
      SubCategoryModel(id: 'dental', name: 'أسنان'),
    ],
    'hc8': [
      SubCategoryModel(id: 'all',   name: 'الكل'),
      SubCategoryModel(id: 'chips', name: 'شيبس'),
      SubCategoryModel(id: 'nuts',  name: 'مكسرات'),
      SubCategoryModel(id: 'candy', name: 'حلوى'),
    ],
  };

  // ── Products ──────────────────────────────────────────────────
  static const Map<String, List<CategoryProductModel>> products = {

    'hc1': [
      CategoryProductModel(id: 'p1', name: 'بصل بلدي 1 كجم',    subCategoryId: 'onion',  price: 8.50,  emoji: '🧅'),
      CategoryProductModel(id: 'p2', name: 'بصل أحمر 500 جم',   subCategoryId: 'onion',  price: 5.00,  emoji: '🧅'),
      CategoryProductModel(id: 'p3', name: 'بطاطس بيضاء 1 كجم', subCategoryId: 'potato', price: 12.00, emoji: '🥔'),
      CategoryProductModel(id: 'p4', name: 'بطاطس حلوة 500 جم', subCategoryId: 'potato', price: 9.50,  emoji: '🍠'),
      CategoryProductModel(id: 'p5', name: 'طماطم طازجة 1 كجم', subCategoryId: 'tomato', price: 7.00,  emoji: '🍅'),
      CategoryProductModel(id: 'p6', name: 'جزر طازج 500 جم',   subCategoryId: 'carrot', price: 6.50,  emoji: '🥕'),
      CategoryProductModel(id: 'p7', name: 'فلفل أخضر 250 جم',  subCategoryId: 'pepper', price: 4.50,  emoji: '🫑'),
      CategoryProductModel(id: 'p8', name: 'فلفل أحمر 250 جم',  subCategoryId: 'pepper', price: 5.00,  emoji: '🌶️'),
    ],

    'hc2': [
      CategoryProductModel(id: 'p9',  name: 'كريستال زبدة 1 كجم',  subCategoryId: 'butter', price: 112.0,  oldPrice: 119.95, emoji: '🧈'),
      CategoryProductModel(id: 'p10', name: 'زبدة خليط 1 كجم',     subCategoryId: 'butter', price: 138.95,               emoji: '🧈'),
      CategoryProductModel(id: 'p11', name: 'زبدة مخفوقة 1 كجم',   subCategoryId: 'butter', price: 99.95,  oldPrice: 114.95, emoji: '🧈'),
      CategoryProductModel(id: 'p12', name: 'حليب كامل الدسم 1 لتر',subCategoryId: 'laban',  price: 18.50,               emoji: '🥛'),
      CategoryProductModel(id: 'p13', name: 'زبادي يوناني 170 جم',  subCategoryId: 'yogurt', price: 12.00,               emoji: '🫙'),
      CategoryProductModel(id: 'p14', name: 'جبنة بيضاء 500 جم',   subCategoryId: 'cheese', price: 35.00,               emoji: '🧀'),
    ],

    'hc3': [
      CategoryProductModel(id: 'p15', name: 'خبز العجين المخمر', subCategoryId: 'bread',  price: 3.50,  emoji: '🍞'),
      CategoryProductModel(id: 'p16', name: 'كيك شوكولاتة',      subCategoryId: 'cake',   price: 25.00, emoji: '🎂'),
      CategoryProductModel(id: 'p17', name: 'بسكويت شاي',        subCategoryId: 'cookie', price: 8.00,  emoji: '🍪'),
    ],

    'hc4': [
      CategoryProductModel(id: 'p18', name: 'لحم بقري مفروم 500 جم', subCategoryId: 'beef',    price: 85.00, emoji: '🥩'),
      CategoryProductModel(id: 'p19', name: 'فيليه دجاج 1 كجم',      subCategoryId: 'chicken', price: 65.00, emoji: '🍗'),
      CategoryProductModel(id: 'p20', name: 'سمك تونة معلب',          subCategoryId: 'fish',    price: 45.00, emoji: '🐟'),
    ],

    'hc5': [
      CategoryProductModel(id: 'p21', name: 'عصير برتقال 1 لتر',   subCategoryId: 'juice', price: 22.00, emoji: '🍊'),
      CategoryProductModel(id: 'p22', name: 'مياه معدنية 1.5 لتر', subCategoryId: 'water', price: 5.50,  emoji: '💧'),
      CategoryProductModel(id: 'p23', name: 'كولا 2 لتر',          subCategoryId: 'soda',  price: 18.00, emoji: '🥤'),
    ],

    'hc6': [
      CategoryProductModel(id: 'p24', name: 'منظف أرضيات 2 لتر', subCategoryId: 'clean',   price: 28.00, emoji: '🧹'),
      CategoryProductModel(id: 'p25', name: 'صابون غسيل',         subCategoryId: 'kitchen', price: 12.00, emoji: '🧼'),
    ],

    'hc7': [
      CategoryProductModel(id: 'p26', name: 'شامبو للشعر الجاف 400 مل', subCategoryId: 'hair',   price: 38.00, emoji: '🧴'),
      CategoryProductModel(id: 'p27', name: 'كريم ترطيب 200 مل',        subCategoryId: 'skin',   price: 45.00, emoji: '🧴'),
      CategoryProductModel(id: 'p28', name: 'معجون أسنان 100 مل',       subCategoryId: 'dental', price: 15.00, emoji: '🪥'),
    ],

    'hc8': [
      CategoryProductModel(id: 'p29', name: 'شيبس بالملح 75 جم',   subCategoryId: 'chips', price: 9.00,  emoji: '🍿'),
      CategoryProductModel(id: 'p30', name: 'مكسرات مشكلة 200 جم', subCategoryId: 'nuts',  price: 35.00, emoji: '🥜'),
      CategoryProductModel(id: 'p31', name: 'حلوى فواكه 100 جم',   subCategoryId: 'candy', price: 12.00, emoji: '🍬'),
    ],
  };
}