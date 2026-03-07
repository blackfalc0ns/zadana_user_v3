import 'package:zadana_user_v3/feature/profile/presentation/cubit/profile_state.dart';

sealed class ProfileNavEvent {}

class NavigateToEditInfo extends ProfileNavEvent {}

class NavigateToAddAddress extends ProfileNavEvent {}

class NavigateToEditAddress extends ProfileNavEvent {
  final AddressModel address;
  
  NavigateToEditAddress(this.address);
}

class NavigateToChangePassword extends ProfileNavEvent {}

class NavigateToHelpSupport extends ProfileNavEvent {}

class NavigateToAboutApp extends ProfileNavEvent {}

class NavigateToTerms extends ProfileNavEvent {}

class NavigateToPrivacyPolicy extends ProfileNavEvent {}

class NavigateToFaq extends ProfileNavEvent {}

class LoggedOut extends ProfileNavEvent {}