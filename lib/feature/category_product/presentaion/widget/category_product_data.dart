import 'category_product_model.dart';

class CategoryProductData {

  // ── Sub-categories ────────────────────────────────────────────
  static const Map<String, List<SubCategoryModel>> subCategories = {
    'hc1': [
      SubCategoryModel(id: 'all', name: 'الكل'),
      SubCategoryModel(id: 'onion', name: 'بصل'),
      SubCategoryModel(id: 'potato', name: 'بطاطس'),
      SubCategoryModel(id: 'tomato', name: 'طماطم'),
      SubCategoryModel(id: 'carrot', name: 'جزر'),
      SubCategoryModel(id: 'pepper', name: 'فلفل'),
    ],

    'hc2': [
      SubCategoryModel(id: 'all', name: 'الكل'),
      SubCategoryModel(id: 'butter', name: 'زبدة'),
      SubCategoryModel(id: 'laban', name: 'لبن'),
      SubCategoryModel(id: 'yogurt', name: 'زبادي'),
      SubCategoryModel(id: 'cheese', name: 'جبن'),
    ],

    'hc3': [
      SubCategoryModel(id: 'all', name: 'الكل'),
      SubCategoryModel(id: 'bread', name: 'خبز'),
      SubCategoryModel(id: 'cake', name: 'كيك'),
      SubCategoryModel(id: 'cookie', name: 'بسكويت'),
    ],

    'hc4': [
      SubCategoryModel(id: 'all', name: 'الكل'),
      SubCategoryModel(id: 'beef', name: 'لحم بقري'),
      SubCategoryModel(id: 'chicken', name: 'دجاج'),
      SubCategoryModel(id: 'fish', name: 'سمك'),
    ],

    'hc5': [
      SubCategoryModel(id: 'all', name: 'الكل'),
      SubCategoryModel(id: 'juice', name: 'عصائر'),
      SubCategoryModel(id: 'water', name: 'مياه'),
      SubCategoryModel(id: 'soda', name: 'مشروبات غازية'),
    ],

    'hc6': [
      SubCategoryModel(id: 'all', name: 'الكل'),
      SubCategoryModel(id: 'clean', name: 'منظفات'),
      SubCategoryModel(id: 'kitchen', name: 'مطبخ'),
    ],

    'hc7': [
      SubCategoryModel(id: 'all', name: 'الكل'),
      SubCategoryModel(id: 'hair', name: 'شعر'),
      SubCategoryModel(id: 'skin', name: 'بشرة'),
      SubCategoryModel(id: 'dental', name: 'أسنان'),
    ],

    'hc8': [
      SubCategoryModel(id: 'all', name: 'الكل'),
      SubCategoryModel(id: 'chips', name: 'شيبس'),
      SubCategoryModel(id: 'nuts', name: 'مكسرات'),
      SubCategoryModel(id: 'candy', name: 'حلوى'),
    ],
  };


  // ── Products ──────────────────────────────────────────────────
  static const Map<String, List<CategoryProductModel>> products = {

    // خضار
    'hc1': [

      CategoryProductModel(id: 'p1', name: 'بصل بلدي 1 كجم', subCategoryId: 'onion', price: 8.5, emoji: '🧅'),
      CategoryProductModel(id: 'p2', name: 'بصل أحمر 500 جم', subCategoryId: 'onion', price: 5, emoji: '🧅'),
      CategoryProductModel(id: 'p3', name: 'بصل أبيض 1 كجم', subCategoryId: 'onion', price: 9, emoji: '🧅'),

      CategoryProductModel(id: 'p4', name: 'بطاطس بيضاء 1 كجم', subCategoryId: 'potato', price: 12, emoji: '🥔'),
      CategoryProductModel(id: 'p5', name: 'بطاطس تحمير', subCategoryId: 'potato', price: 13, emoji: '🥔'),
      CategoryProductModel(id: 'p6', name: 'بطاطس حلوة', subCategoryId: 'potato', price: 9.5, emoji: '🍠'),

      CategoryProductModel(id: 'p7', name: 'طماطم طازجة', subCategoryId: 'tomato', price: 7, emoji: '🍅'),
      CategoryProductModel(id: 'p8', name: 'طماطم بلدي', subCategoryId: 'tomato', price: 6.5, emoji: '🍅'),

      CategoryProductModel(id: 'p9', name: 'جزر طازج', subCategoryId: 'carrot', price: 6.5, emoji: '🥕'),
      CategoryProductModel(id: 'p10', name: 'جزر مصري', subCategoryId: 'carrot', price: 11, emoji: '🥕'),

      CategoryProductModel(id: 'p11', name: 'فلفل أخضر', subCategoryId: 'pepper', price: 4.5, emoji: '🫑'),
      CategoryProductModel(id: 'p12', name: 'فلفل أحمر', subCategoryId: 'pepper', price: 5, emoji: '🌶️'),
    ],

    // ألبان
    'hc2': [

      CategoryProductModel(id: 'p20', name: 'كريستال زبدة 1 كجم', subCategoryId: 'butter', price: 112, oldPrice: 119.95, emoji: '🧈'),
      CategoryProductModel(id: 'p21', name: 'زبدة طبيعي', subCategoryId: 'butter', price: 68, emoji: '🧈'),

      CategoryProductModel(id: 'p22', name: 'حليب كامل الدسم 1 لتر', subCategoryId: 'laban', price: 18.5, emoji: '🥛'),
      CategoryProductModel(id: 'p23', name: 'حليب قليل الدسم', subCategoryId: 'laban', price: 17, emoji: '🥛'),

      CategoryProductModel(id: 'p24', name: 'زبادي يوناني', subCategoryId: 'yogurt', price: 12, emoji: '🫙'),
      CategoryProductModel(id: 'p25', name: 'زبادي فواكه', subCategoryId: 'yogurt', price: 6.5, emoji: '🫙'),

      CategoryProductModel(id: 'p26', name: 'جبنة بيضاء', subCategoryId: 'cheese', price: 35, emoji: '🧀'),
      CategoryProductModel(id: 'p27', name: 'جبنة رومي', subCategoryId: 'cheese', price: 42, emoji: '🧀'),
    ],

    // مخبوزات
    'hc3': [
      CategoryProductModel(id: 'p40', name: 'خبز بلدي', subCategoryId: 'bread', price: 2, emoji: '🍞'),
      CategoryProductModel(id: 'p41', name: 'خبز توست', subCategoryId: 'bread', price: 18, emoji: '🍞'),

      CategoryProductModel(id: 'p42', name: 'كيك شوكولاتة', subCategoryId: 'cake', price: 25, emoji: '🎂'),
      CategoryProductModel(id: 'p43', name: 'كيك فانيليا', subCategoryId: 'cake', price: 23, emoji: '🎂'),

      CategoryProductModel(id: 'p44', name: 'بسكويت شاي', subCategoryId: 'cookie', price: 8, emoji: '🍪'),
      CategoryProductModel(id: 'p45', name: 'بسكويت زبدة', subCategoryId: 'cookie', price: 10, emoji: '🍪'),
    ],

    // لحوم
    'hc4': [
      CategoryProductModel(id: 'p60', name: 'لحم بقري مفروم', subCategoryId: 'beef', price: 85, emoji: '🥩'),
      CategoryProductModel(id: 'p61', name: 'ستيك بقري', subCategoryId: 'beef', price: 120, emoji: '🥩'),

      CategoryProductModel(id: 'p62', name: 'فيليه دجاج', subCategoryId: 'chicken', price: 65, emoji: '🍗'),
      CategoryProductModel(id: 'p63', name: 'أوراك دجاج', subCategoryId: 'chicken', price: 58, emoji: '🍗'),

      CategoryProductModel(id: 'p64', name: 'سمك تونة', subCategoryId: 'fish', price: 45, emoji: '🐟'),
      CategoryProductModel(id: 'p65', name: 'سمك سالمون', subCategoryId: 'fish', price: 120, emoji: '🐟'),
    ],

    // مشروبات
    'hc5': [
      CategoryProductModel(id: 'p80', name: 'عصير برتقال', subCategoryId: 'juice', price: 22, emoji: '🍊'),
      CategoryProductModel(id: 'p81', name: 'عصير تفاح', subCategoryId: 'juice', price: 21, emoji: '🍎'),

      CategoryProductModel(id: 'p82', name: 'مياه معدنية', subCategoryId: 'water', price: 5.5, emoji: '💧'),
      CategoryProductModel(id: 'p83', name: 'مياه غازية', subCategoryId: 'water', price: 6, emoji: '💧'),

      CategoryProductModel(id: 'p84', name: 'كولا 2 لتر', subCategoryId: 'soda', price: 18, emoji: '🥤'),
      CategoryProductModel(id: 'p85', name: 'سفن اب', subCategoryId: 'soda', price: 17.5, emoji: '🥤'),
    ],

    // منظفات
    'hc6': [
      CategoryProductModel(id: 'p100', name: 'منظف أرضيات', subCategoryId: 'clean', price: 28, emoji: '🧹'),
      CategoryProductModel(id: 'p101', name: 'كلور', subCategoryId: 'clean', price: 18, emoji: '🧴'),

      CategoryProductModel(id: 'p102', name: 'سائل غسيل أطباق', subCategoryId: 'kitchen', price: 14, emoji: '🧼'),
      CategoryProductModel(id: 'p103', name: 'اسفنجة تنظيف', subCategoryId: 'kitchen', price: 6, emoji: '🧽'),
    ],

    // عناية شخصية
    'hc7': [
      CategoryProductModel(id: 'p120', name: 'شامبو للشعر', subCategoryId: 'hair', price: 38, emoji: '🧴'),
      CategoryProductModel(id: 'p121', name: 'بلسم شعر', subCategoryId: 'hair', price: 34, emoji: '🧴'),

      CategoryProductModel(id: 'p122', name: 'كريم ترطيب', subCategoryId: 'skin', price: 45, emoji: '🧴'),
      CategoryProductModel(id: 'p123', name: 'غسول وجه', subCategoryId: 'skin', price: 39, emoji: '🧴'),

      CategoryProductModel(id: 'p124', name: 'معجون أسنان', subCategoryId: 'dental', price: 15, emoji: '🪥'),
      CategoryProductModel(id: 'p125', name: 'فرشاة أسنان', subCategoryId: 'dental', price: 10, emoji: '🪥'),
    ],

    // سناكس
    'hc8': [
      CategoryProductModel(id: 'p140', name: 'شيبس بالملح', subCategoryId: 'chips', price: 9, emoji: '🍿'),
      CategoryProductModel(id: 'p141', name: 'شيبس جبنة', subCategoryId: 'chips', price: 10, emoji: '🍿'),

      CategoryProductModel(id: 'p142', name: 'مكسرات مشكلة', subCategoryId: 'nuts', price: 35, emoji: '🥜'),
      CategoryProductModel(id: 'p143', name: 'فستق', subCategoryId: 'nuts', price: 55, emoji: '🥜'),

      CategoryProductModel(id: 'p144', name: 'حلوى فواكه', subCategoryId: 'candy', price: 12, emoji: '🍬'),
      CategoryProductModel(id: 'p145', name: 'شوكولاتة', subCategoryId: 'candy', price: 15, emoji: '🍫'),
    ],
  };
}

