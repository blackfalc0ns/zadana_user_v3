import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

/// Extension to provide display size text with fallback logic.
///
/// If [displaySizeAr]/[displaySizeEn] is available from the API, use it directly.
/// Otherwise, build the text locally from:
///   packageTypeName + measurementValue + measurementUnitName
extension ProductDisplaySizeExtension on ProductModel {
  /// Returns the Arabic display size string, or builds it from components.
  String? get resolvedDisplaySizeAr {
    if (displaySizeAr != null && displaySizeAr!.isNotEmpty) {
      return displaySizeAr;
    }
    return _buildDisplaySize(
      packageTypeName: packageTypeNameAr,
      value: measurementValue,
      unitName: measurementUnitNameAr,
    );
  }

  /// Returns the English display size string, or builds it from components.
  String? get resolvedDisplaySizeEn {
    if (displaySizeEn != null && displaySizeEn!.isNotEmpty) {
      return displaySizeEn;
    }
    return _buildDisplaySize(
      packageTypeName: packageTypeNameEn,
      value: measurementValue,
      unitName: measurementUnitNameEn,
    );
  }

  static String? _buildDisplaySize({
    String? packageTypeName,
    double? value,
    String? unitName,
  }) {
    final parts = <String>[];
    if (packageTypeName != null && packageTypeName.isNotEmpty) {
      parts.add(packageTypeName);
    }
    if (value != null) {
      // Format as integer if whole number, otherwise keep decimal
      final formatted = value == value.roundToDouble()
          ? value.toInt().toString()
          : value.toString();
      parts.add(formatted);
    }
    if (unitName != null && unitName.isNotEmpty) {
      parts.add(unitName);
    }
    return parts.isEmpty ? null : parts.join(' ');
  }
}
