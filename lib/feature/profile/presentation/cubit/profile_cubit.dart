import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/feature/profile/presentation/cubit/profile_nav_event.dart';
import 'package:zadana_user_v3/feature/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final StreamController<ProfileNavEvent> _navigationController = 
      StreamController<ProfileNavEvent>.broadcast();

  Stream<ProfileNavEvent> get navigationStream => 
      _navigationController.stream;

  ProfileCubit() : super(
    const ProfileState(
      fullName: 'John Doe',
      email: 'john.doe@example.com',
      avatarUrl: null,
      phone: '+1 234 567 8900',
      dateOfBirth: '1990-01-15',
      gender: 'Male',
      addresses: [
        AddressModel(
          id: '1',
          title: 'Home',
          fullAddress: '123 Main Street, Downtown, New York',
          isDefault: true,
        ),
        AddressModel(
          id: '2',
          title: 'Work',
          fullAddress: '456 Business Ave, Midtown, New York',
          isDefault: false,
        ),
      ],
      isDarkMode: false,
      notificationsEnabled: true,
      currentLanguage: 'en',
    ),
  );

  void editAvatar() {
    // TODO: Implement avatar editing logic
    // For now, just simulate loading
    emit(state.copyWith(isLoading: true));
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(
        isLoading: false,
        avatarUrl: 'https://example.com/new-avatar.jpg',
      ));
    });
  }

  void updatePersonalInfo() {
    _navigationController.add(NavigateToEditInfo());
  }

  void addAddress() {
    _navigationController.add(NavigateToAddAddress());
  }

  void editAddress(AddressModel address) {
    _navigationController.add(NavigateToEditAddress(address));
  }

  void deleteAddress(AddressModel address) {
    final updatedAddresses = state.addresses
        .where((addr) => addr.id != address.id)
        .toList();
    
    emit(state.copyWith(addresses: updatedAddresses));
  }

  void toggleDarkMode(bool value) {
    emit(state.copyWith(isDarkMode: value));
    // TODO: Persist theme preference
  }

  void toggleNotifications(bool value) {
    emit(state.copyWith(notificationsEnabled: value));
    // TODO: Update notification settings
  }

  void changeLanguage(String language) {
    emit(state.copyWith(currentLanguage: language));
    // TODO: Persist language preference and update app locale
  }

  void changePassword() {
    _navigationController.add(NavigateToChangePassword());
  }

  void helpSupport() {
    _navigationController.add(NavigateToHelpSupport());
  }

  void aboutApp() {
    _navigationController.add(NavigateToAboutApp());
  }

  void termsConditions() {
    _navigationController.add(NavigateToTerms());
  }

  void privacyPolicy() {
    _navigationController.add(NavigateToPrivacyPolicy());
  }

  void faq() {
    _navigationController.add(NavigateToFaq());
  }

  void logout() {
    emit(state.copyWith(isLoading: true));
    
    // Simulate logout process
    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(isLoading: false));
      _navigationController.add(LoggedOut());
    });
  }

  @override
  Future<void> close() {
    _navigationController.close();
    return super.close();
  }
}