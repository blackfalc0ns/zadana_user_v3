import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String? phone;
  final String? dateOfBirth;
  final String? gender;
  final List<AddressModel> addresses;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String currentLanguage;
  final bool isLoading;
  final String? error;

  const ProfileState({
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.phone,
    this.dateOfBirth,
    this.gender,
    required this.addresses,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.currentLanguage,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? avatarUrl,
    String? phone,
    String? dateOfBirth,
    String? gender,
    List<AddressModel>? addresses,
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? currentLanguage,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      addresses: addresses ?? this.addresses,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: 
          notificationsEnabled ?? this.notificationsEnabled,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        avatarUrl,
        phone,
        dateOfBirth,
        gender,
        addresses,
        isDarkMode,
        notificationsEnabled,
        currentLanguage,
        isLoading,
        error,
      ];
}

class AddressModel extends Equatable {
  final String id;
  final String title;
  final String fullAddress;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.title,
    required this.fullAddress,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? id,
    String? title,
    String? fullAddress,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      fullAddress: fullAddress ?? this.fullAddress,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, title, fullAddress, isDefault];
}