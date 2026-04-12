import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/sections/home_product_section_content.dart';

class DynamicHomePreviewSection extends StatelessWidget {
  const DynamicHomePreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = _fakeDynamicSections
        .where((section) => section.isActive)
        .toList(growable: false);

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          _DynamicSectionBlock(section: sections[i]),
          if (i != sections.length - 1) const SizedBox(height: Spacing.xl),
        ],
      ],
    );
  }
}

class _DynamicSectionBlock extends StatelessWidget {
  const _DynamicSectionBlock({required this.section});

  final _FakeDynamicSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: section.title, actionLabel: 'عرض المزيد'),
        const SizedBox(height: Spacing.md),
        HomeProductSectionContent(
          items: section.items,
          theme: section.theme,
          heroSource: 'dynamic-${section.key}',
        ),
      ],
    );
  }
}

class _FakeDynamicSection {
  const _FakeDynamicSection({
    required this.key,
    required this.title,
    required this.theme,
    required this.isActive,
    required this.items,
  });

  final String key;
  final String title;
  final String theme;
  final bool isActive;
  final List<ProductModel> items;
}

final List<_FakeDynamicSection> _fakeDynamicSections = [
  const _FakeDynamicSection(
    key: 'dynamic-showcase',
    title: 'أقوى العروض',
    theme: '3',
    isActive: true,
    items: [
      ProductModel(
        id: 'dyn-1',
        name: 'توليفة صباحية فاخرة',
        store: 'محمصة زادنا',
        price: 290,
        oldPrice: 340,
        imageUrl: '',
        emoji: '☕',
        rating: 4.8,
        reviewCount: 31,
        isFavorite: true,
        isDiscounted: true,
      ),
      ProductModel(
        id: 'dyn-2',
        name: 'قهوة مانجا باردة',
        store: 'ركن الصيف',
        price: 190,
        oldPrice: 220,
        imageUrl: '',
        emoji: '🥭',
        rating: 4.6,
        reviewCount: 18,
        isDiscounted: true,
      ),
      ProductModel(
        id: 'dyn-3',
        name: 'باقة الموكا اليومية',
        store: 'زادنا كافيه',
        price: 244,
        oldPrice: 280,
        imageUrl: '',
        emoji: '🍫',
        rating: 4.7,
        reviewCount: 22,
        isFavorite: true,
        isDiscounted: true,
      ),
      ProductModel(
        id: 'dyn-4',
        name: 'تحميصة المساء',
        store: 'محمصة البيت',
        price: 260,
        oldPrice: 300,
        imageUrl: '',
        emoji: '🌙',
        rating: 4.5,
        reviewCount: 12,
        isDiscounted: true,
      ),
      ProductModel(
        id: 'dyn-12',
        name: 'خلطة بن مخصوصة',
        store: 'روائح زادنا',
        price: 210,
        oldPrice: 250,
        imageUrl: '',
        emoji: '🫘',
        rating: 4.6,
        reviewCount: 16,
        isFavorite: true,
        isDiscounted: true,
      ),
      ProductModel(
        id: 'dyn-13',
        name: 'قهوة هيل ناعمة',
        store: 'بن الدار',
        price: 175,
        oldPrice: 205,
        imageUrl: '',
        emoji: '🌿',
        rating: 4.4,
        reviewCount: 10,
        isDiscounted: true,
      ),
    ],
  ),
  const _FakeDynamicSection(
    key: 'dynamic-compact',
    title: 'مختارة ليك',
    theme: '2',
    isActive: true,
    items: [
      ProductModel(
        id: 'dyn-5',
        name: 'حبوب كولومبية',
        store: 'روست هاوس',
        price: 125,
        oldPrice: 150,
        imageUrl: '',
        emoji: '🫘',
        rating: 4.9,
        reviewCount: 40,
        isDiscounted: true,
      ),
      ProductModel(
        id: 'dyn-6',
        name: 'خلطة إسبريسو',
        store: 'قهوة العرب',
        price: 99,
        oldPrice: 120,
        imageUrl: '',
        emoji: '☕',
        rating: 4.4,
        reviewCount: 14,
        isFavorite: true,
        isDiscounted: true,
      ),
      ProductModel(
        id: 'dyn-7',
        name: 'قهوة تركي مضبوط',
        store: 'بن الشرق',
        price: 85,
        imageUrl: '',
        emoji: '🫘',
        rating: 4.3,
        reviewCount: 9,
        isDiscounted: false,
      ),
    ],
  ),
  const _FakeDynamicSection(
    key: 'dynamic-classic',
    title: 'تجميعة اليوم',
    theme: '1',
    isActive: true,
    items: [
      ProductModel(
        id: 'dyn-8',
        name: 'براونيز كافيه',
        store: 'سويت هب',
        price: 45,
        oldPrice: 59,
        imageUrl: '',
        emoji: '🍪',
        rating: 4.2,
        reviewCount: 11,
        isDiscounted: true,
      ),
      ProductModel(
        id: 'dyn-9',
        name: 'قهوة فرنسية',
        store: 'كافيه روز',
        price: 110,
        oldPrice: 135,
        imageUrl: '',
        emoji: '🥐',
        rating: 4.7,
        reviewCount: 28,
        isFavorite: true,
        isDiscounted: true,
      ),
      ProductModel(
        id: 'dyn-10',
        name: 'كوب هدية',
        store: 'أكسسوارات القهوة',
        price: 70,
        imageUrl: '',
        emoji: '🧋',
        rating: 4.1,
        reviewCount: 6,
        isDiscounted: false,
      ),
      ProductModel(
        id: 'dyn-11',
        name: 'حبوب إثيوبية',
        store: 'روست برو',
        price: 160,
        oldPrice: 190,
        imageUrl: '',
        emoji: '🌿',
        rating: 4.8,
        reviewCount: 21,
        isFavorite: true,
        isDiscounted: true,
      ),
    ],
  ),
];
