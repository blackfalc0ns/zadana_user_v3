import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/section_header.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/store_card.dart';

// Extended store data
final List<Map<String, String>> storesData = [
  {'id': 'v1', 'name': 'كارفور', 'emoji': '🛒'},
  {'id': 'v2', 'name': 'سبينس', 'emoji': '🏪'},
  {'id': 'v3', 'name': 'هايبر وان', 'emoji': '🏬'},
  {'id': 'v4', 'name': 'بشاير', 'emoji': '🛍️'},
  {'id': 'v5', 'name': 'أونستوب', 'emoji': '🏪'},
  {'id': 'v6', 'name': 'فاتورة', 'emoji': '📦'},
  {'id': 'v7', 'name': 'جملة', 'emoji': '🏭'},
  {'id': 'v8', 'name': 'مترو', 'emoji': '🏢'},
  {'id': 'v9', 'name': 'خير زمان', 'emoji': '🌾'},
  {'id': 'v10', 'name': 'العثيم', 'emoji': '🏪'},
  {'id': 'v11', 'name': 'بنده', 'emoji': '🛒'},
  {'id': 'v12', 'name': 'لولو', 'emoji': '🏬'},
  {'id': 'v13', 'name': 'الدانوب', 'emoji': '🏪'},
  {'id': 'v14', 'name': 'التميمي', 'emoji': '🛍️'},
  {'id': 'v15', 'name': 'المزرعة', 'emoji': '🌿'},
];

class StoresSection extends StatelessWidget {
  const StoresSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      decoration: const BoxDecoration(color: AppColors.primary),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // Header using SectionHeader
          SectionHeader(
            title: 'تصفح حسب المتاجر',
            actionLabel: 'عرض الكل',
            titleColor: AppColors.white,
            horizontalPadding: 16,
          ),

          const SizedBox(height: Spacing.md),

          // Scrollable Grid of stores
          SizedBox(
            height: 180, // Fixed height for scrolling
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Spacing.sm,
                mainAxisSpacing: Spacing.sm,
                childAspectRatio: 0.9,
              ),
              itemCount: storesData.length,
              itemBuilder: (_, index) {
                final store = storesData[index];
                return StoreCard(
                  name: store['name']!,
                  emoji: store['emoji']!,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم اختيار ${store['name']}')),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
