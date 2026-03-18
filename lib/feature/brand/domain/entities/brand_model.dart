class BrandModel {
  final String id;
  final String name;
  final String logo;
  final String? coverImage;
  final String? emoji;
  final int productCount;
  final String? description;

  const BrandModel({
    required this.id,
    required this.name,
    required this.logo,
    this.coverImage,
    this.emoji,
    required this.productCount,
    this.description,
  });

  BrandModel copyWith({
    String? id,
    String? name,
    String? logo,
    String? coverImage,
    String? emoji,
    int? productCount,
    String? description,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      coverImage: coverImage ?? this.coverImage,
      emoji: emoji ?? this.emoji,
      productCount: productCount ?? this.productCount,
      description: description ?? this.description,
    );
  }
}
