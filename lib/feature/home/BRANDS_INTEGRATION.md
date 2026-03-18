# تكامل العلامات التجارية في الصفحة الرئيسية

## التعديلات المنفذة

### 1. إنشاء Brand Card Widget
**الملف**: `lib/feature/home/presentation/widget/brand_card.dart`

- كارد بسيط لعرض العلامة التجارية
- يحتوي على emoji/logo والاسم
- تصميم مشابه لـ StoreCard الموجود

### 2. إنشاء Brands Section
**الملف**: `lib/feature/home/presentation/widget/sections/brands_section.dart`

**المميزات**:
- عرض العلامات التجارية في grid أفقي قابل للتمرير
- 15 علامة تجارية مصرية ومشهورة (جهينة، المراعي، بيتي، إلخ)
- عند الضغط على أي علامة تجارية، يتم الانتقال لصفحة البراند
- زر "عرض الكل" للانتقال لصفحة جميع العلامات التجارية

**العلامات التجارية المضافة**:
1. جهينة 🥛 (45 منتج)
2. المراعي 🧈 (67 منتج)
3. بيتي 🥩 (32 منتج)
4. بوك 🧀 (28 منتج)
5. دمياط 🧀 (41 منتج)
6. لاكتيل 🥛 (35 منتج)
7. بريزيدان 🧈 (29 منتج)
8. كيري 🧀 (18 منتج)
9. ندى 🥛 (52 منتج)
10. ساديا 🍗 (38 منتج)
11. أمريكانا 🍔 (44 منتج)
12. شيبسي 🥔 (25 منتج)
13. إندومي 🍜 (15 منتج)
14. باريلا 🍝 (22 منتج)
15. نستله 🍫 (78 منتج)

### 3. تحديث Home Screen
**الملف**: `lib/feature/home/presentation/pages/home_screen.dart`

**التغييرات**:
- استبدال `StoresSection` بـ `BrandsSection`
- تحديث الـ import
- الاحتفاظ بنفس الموقع في الصفحة (بعد Best Selling Section)

## كيفية الاستخدام

### الانتقال لصفحة البراند
عند الضغط على أي علامة تجارية، يتم:
1. إنشاء `BrandModel` من البيانات
2. الانتقال لـ `BrandPage` مع تمرير البيانات
3. عرض منتجات العلامة التجارية

```dart
void _navigateToBrandPage(BuildContext context, Map<String, dynamic> brandData) {
  final brand = BrandModel(
    id: brandData['id'],
    name: brandData['name'],
    logo: brandData['logo'],
    emoji: brandData['emoji'],
    productCount: brandData['productCount'],
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BrandPage(brand: brand),
    ),
  );
}
```

## التخصيص

### إضافة علامات تجارية جديدة
عدل الـ `brandsData` في `brands_section.dart`:

```dart
final List<Map<String, dynamic>> brandsData = [
  {
    'id': 'brand_id',
    'name': 'اسم العلامة',
    'emoji': '🏷️',
    'logo': 'https://example.com/logo.png',
    'productCount': 50,
  },
  // ... المزيد
];
```

### استبدال البيانات الوهمية بـ API
استبدل `brandsData` بـ API call:

```dart
class BrandsSection extends StatefulWidget {
  const BrandsSection({super.key});

  @override
  State<BrandsSection> createState() => _BrandsSectionState();
}

class _BrandsSectionState extends State<BrandsSection> {
  List<Map<String, dynamic>> brands = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      // استدعاء الـ API
      final response = await brandsRepository.getAllBrands();
      setState(() {
        brands = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    
    // ... باقي الكود
  }
}
```

### تغيير عدد الصفوف في الـ Grid
عدل `crossAxisCount` في `GridView.builder`:

```dart
gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3, // غير من 2 لـ 3 صفوف
  crossAxisSpacing: Spacing.sm,
  mainAxisSpacing: Spacing.sm,
  childAspectRatio: 0.9,
),
```

## الخطوات التالية

### مطلوب للإنتاج
- [ ] استبدال البيانات الوهمية بـ API حقيقي
- [ ] إضافة loading state
- [ ] إضافة error handling
- [ ] إنشاء صفحة "عرض الكل" للعلامات التجارية

### تحسينات اختيارية
- [ ] إضافة صور حقيقية للعلامات التجارية بدل الـ emoji
- [ ] إضافة badge لعدد المنتجات على الكارد
- [ ] إضافة animation عند الضغط
- [ ] إضافة favorite للعلامات التجارية
- [ ] إضافة search للعلامات التجارية

## الملفات المتأثرة

```
lib/feature/home/
├── presentation/
│   ├── pages/
│   │   └── home_screen.dart                    ✅ تم التعديل
│   └── widget/
│       ├── brand_card.dart                     ✅ جديد
│       └── sections/
│           ├── brands_section.dart             ✅ جديد
│           └── stores_section.dart             ⚠️ لم يعد مستخدم
└── BRANDS_INTEGRATION.md                       ✅ هذا الملف
```

## الاختبار

### سيناريوهات الاختبار
1. ✅ عرض العلامات التجارية في الصفحة الرئيسية
2. ✅ التمرير الأفقي للعلامات التجارية
3. ✅ الضغط على علامة تجارية والانتقال لصفحتها
4. ✅ عرض اسم العلامة التجارية بشكل صحيح
5. ✅ عرض الـ emoji بشكل صحيح
6. ⏳ زر "عرض الكل" (يحتاج صفحة جديدة)

### اختبار على أجهزة مختلفة
- [ ] شاشة صغيرة (<360dp)
- [ ] شاشة متوسطة (360-600dp)
- [ ] شاشة كبيرة (>600dp)
- [ ] تابلت
- [ ] اتجاه أفقي

## ملاحظات

- تم الاحتفاظ بنفس تصميم الـ StoresSection
- الألوان والـ spacing متناسقة مع باقي التطبيق
- الكود جاهز للتكامل مع API
- يمكن إعادة استخدام StoresSection لاحقاً إذا لزم الأمر

---

**تم التنفيذ بنجاح!** 🎉

العلامات التجارية الآن تظهر في الصفحة الرئيسية بدلاً من المتاجر، وعند الضغط عليها يتم الانتقال لصفحة البراند.
