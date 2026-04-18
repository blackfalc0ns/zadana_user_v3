import 'package:zadana_user_v3/feature/category/domain/entities/category_entity.dart';
import 'package:zadana_user_v3/feature/home/data/models/categories/home_categories_response_model_dto.dart';

extension CategoryHomeCategoriesResponseModelDtoMapper
    on HomeCategoriesResponseModelDto {
  List<CategoryEntity> toCategoryEntities() {
    return (items ?? const [])
        .where(
          (item) => (item.id ?? '').isNotEmpty && (item.name ?? '').isNotEmpty,
        )
        .map(
          (item) => CategoryEntity(
            id: item.id ?? '',
            name: item.name ?? '',
            imageAsset: item.imageUrl ?? '',
            emoji: (item.name ?? '').substring(0, 1),
          ),
        )
        .toList(growable: false);
  }
}
