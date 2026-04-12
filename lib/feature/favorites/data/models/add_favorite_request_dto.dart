class AddFavoriteRequestDto {
  const AddFavoriteRequestDto({required this.productId});

  final String productId;

  Map<String, dynamic> toJson() => {'productId': productId};
}
