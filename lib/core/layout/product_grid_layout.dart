import 'package:zadana_user_v3/config/theme/spacing.dart';

class ProductGridLayout {
  const ProductGridLayout({
    required this.crossAxisCount,
    required this.childAspectRatio,
  });

  final int crossAxisCount;
  final double childAspectRatio;

  static ProductGridLayout resolve(
    double width, {
    double horizontalPadding = Spacing.md * 2,
    double crossAxisSpacing = Spacing.xss,
  }) {
    final availableWidth = (width - horizontalPadding).clamp(0.0, width);

    final crossAxisCount = switch (availableWidth) {
      < 300 => 2,
      < 760 => 3,
      < 1080 => 4,
      _ => 5,
    };

    final totalSpacing = crossAxisSpacing * (crossAxisCount - 1);
    final itemWidth = (availableWidth - totalSpacing) / crossAxisCount;
    final itemHeight = itemWidth < 96
        ? itemWidth * 1.22
        : itemWidth < 120
        ? itemWidth * 1.14
        : itemWidth * 1.08;

    return ProductGridLayout(
      crossAxisCount: crossAxisCount,
      childAspectRatio: itemWidth / itemHeight,
    );
  }
}
