class ClearFavoritesResponseDto {
  factory ClearFavoritesResponseDto.fromJson(Map<String, dynamic> json) {
    return ClearFavoritesResponseDto(message: json['message'] as String? ?? '');
  }
  const ClearFavoritesResponseDto({required this.message});

  final String message;
}
