import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/brand/domain/entities/brand_model.dart';
import 'package:zadana_user_v3/feature/brand/presentation/pages/brand_page.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/brand_card.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';

// Mock brands data - Replace with actual API call
final List<Map<String, dynamic>> brandsData = [
  {
    'id': 'juhayna',
    'name': 'جهينة',
    'emoji': '🥛',
    'logo':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Juhayna_Food_Industries_logo.svg/1200px-Juhayna_Food_Industries_logo.svg.png',
    'coverImage':
        'https://images.unsplash.com/photo-1563636619-e9143da7973b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    'productCount': 45,
    'description': 'منتجات الألبان والعصائر الطبيعية',
  },
  {
    'id': 'almarai',
    'name': 'المراعي',
    'emoji': '🧈',
    'logo': 'https://example.com/almarai.png',
    'productCount': 67,
  },
  {
    'id': 'beyti',
    'name': 'بيتي',
    'emoji': '🥩',
    'logo': 'https://example.com/beyti.png',
    'productCount': 32,
  },
  {
    'id': 'puck',
    'name': 'بوك',
    'emoji': '🧀',
    'logo': 'https://example.com/puck.png',
    'productCount': 28,
  },
  {
    'id': 'domty',
    'name': 'دمياط',
    'emoji': '🧀',
    'logo': 'https://example.com/domty.png',
    'productCount': 41,
  },
  {
    'id': 'lactel',
    'name': 'لاكتيل',
    'emoji': '🥛',
    'logo': 'https://example.com/lactel.png',
    'productCount': 35,
  },
  {
    'id': 'president',
    'name': 'بريزيدان',
    'emoji': '🧈',
    'logo': 'https://example.com/president.png',
    'productCount': 29,
  },
  {
    'id': 'kiri',
    'name': 'كيري',
    'emoji': '🧀',
    'logo': 'https://example.com/kiri.png',
    'productCount': 18,
  },
  {
    'id': 'nada',
    'name': 'ندى',
    'emoji': '🥛',
    'logo': 'https://example.com/nada.png',
    'productCount': 52,
  },
  {
    'id': 'sadia',
    'name': 'ساديا',
    'emoji': '🍗',
    'logo': 'https://example.com/sadia.png',
    'productCount': 38,
  },
  {
    'id': 'americana',
    'name': 'أمريكانا',
    'emoji': '🍔',
    'logo': 'https://example.com/americana.png',
    'productCount': 44,
  },
  {
    'id': 'chipsy',
    'name': 'شيبسي',
    'emoji': '🥔',
    'logo': 'https://example.com/chipsy.png',
    'productCount': 25,
  },
  {
    'id': 'indomie',
    'name': 'إندومي',
    'emoji': '🍜',
    'logo': 'https://example.com/indomie.png',
    'productCount': 15,
  },
  {
    'id': 'barilla',
    'name': 'باريلا',
    'emoji': '🍝',
    'logo': 'https://example.com/barilla.png',
    'productCount': 22,
  },
  {
    'id': 'nestle',
    'name': 'نستله',
    'emoji': '🍫',
    'logo': 'https://example.com/nestle.png',
    'productCount': 78,
  },
];

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  void _navigateToBrandPage(
    BuildContext context,
    Map<String, dynamic> brandData,
  ) {
    final brand = BrandModel(
      id: brandData['id'],
      name: brandData['name'],
      logo: brandData['logo'],
      emoji: brandData['emoji'],
      productCount: brandData['productCount'],
      coverImage: brandData['coverImage'],
      description: brandData['description'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BrandPage(brand: brand)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      decoration: const BoxDecoration(color: AppColors.primary),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // Header
          SectionHeader(
            actionColor: Colors.white,
            title: 'تصفح حسب العلامة التجارية',
            actionLabel: 'عرض الكل',
            isActionBold: true,
            titleColor: AppColors.white,
            horizontalPadding: 16,
            onActionTap: () {
              // TODO: Navigate to all brands page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('عرض جميع العلامات التجارية')),
              );
            },
          ),

          const SizedBox(height: Spacing.md),

          // Scrollable Grid of brands
          SizedBox(
            height: 180,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Spacing.sm,
                mainAxisSpacing: Spacing.sm,
                childAspectRatio: 0.9,
              ),
              itemCount: brandsData.length,
              itemBuilder: (context, index) {
                final brand = brandsData[index];
                return BrandCard(
                  name: brand['name']!,
                  emoji: brand['emoji']!,
                  onTap: () => _navigateToBrandPage(context, brand),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
