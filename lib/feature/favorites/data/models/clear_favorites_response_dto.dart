class ClearFavoritesResponseDto {
  const ClearFavoritesResponseDto({required this.message});

  final String message;

  factory ClearFavoritesResponseDto.fromJson(Map<String, dynamic> json) {
    return ClearFavoritesResponseDto(
      message: json['message'] as String? ?? '',
    );
  }
}
