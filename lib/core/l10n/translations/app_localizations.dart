import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translations/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @name_is_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required!'**
  String get name_is_required;

  /// No description provided for @name_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This name is not valid'**
  String get name_is_not_valid;

  /// No description provided for @email_is_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required!'**
  String get email_is_required;

  /// No description provided for @email_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This email is not valid'**
  String get email_is_not_valid;

  /// No description provided for @password_is_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required!'**
  String get password_is_required;

  /// No description provided for @password_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This password is not valid'**
  String get password_is_not_valid;

  /// No description provided for @password_must_be_at_least_6_characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_must_be_at_least_6_characters;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @confirm_password_is_required.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required!'**
  String get confirm_password_is_required;

  /// No description provided for @confirm_password_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This confirm password is not valid'**
  String get confirm_password_is_not_valid;

  /// No description provided for @password_and_confirm_password_must_be_same.
  ///
  /// In en, this message translates to:
  /// **'Password and confirm password must be same!'**
  String get password_and_confirm_password_must_be_same;

  /// No description provided for @phone_number_is_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required!'**
  String get phone_number_is_required;

  /// No description provided for @phone_number_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This phone number is not valid'**
  String get phone_number_is_not_valid;

  /// No description provided for @this_field_is_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get this_field_is_required;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @start_button.
  ///
  /// In en, this message translates to:
  /// **'start now'**
  String get start_button;

  /// No description provided for @location_service_disabled.
  ///
  /// In en, this message translates to:
  /// **'Location service is disabled'**
  String get location_service_disabled;

  /// No description provided for @location_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get location_permission_denied;

  /// No description provided for @location_permission_denied_forever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get location_permission_denied_forever;

  /// No description provided for @auth_title.
  ///
  /// In en, this message translates to:
  /// **'Get Started Now'**
  String get auth_title;

  /// No description provided for @auth_subtitle_login.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Log in to your account'**
  String get auth_subtitle_login;

  /// No description provided for @auth_subtitle_signup.
  ///
  /// In en, this message translates to:
  /// **'Create an account to explore our app'**
  String get auth_subtitle_signup;

  /// No description provided for @toggle_login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get toggle_login;

  /// No description provided for @toggle_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get toggle_signup;

  /// No description provided for @label_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get label_full_name;

  /// No description provided for @label_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get label_email;

  /// No description provided for @label_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get label_phone;

  /// No description provided for @label_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get label_password;

  /// No description provided for @hint_full_name.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get hint_full_name;

  /// No description provided for @hint_email.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get hint_email;

  /// No description provided for @hint_phone.
  ///
  /// In en, this message translates to:
  /// **'(454) 726-0592'**
  String get hint_phone;

  /// No description provided for @hint_password.
  ///
  /// In en, this message translates to:
  /// **'P@ssw0rd123'**
  String get hint_password;

  /// No description provided for @btn_login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get btn_login;

  /// No description provided for @btn_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get btn_signup;

  /// No description provided for @btn_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get btn_forgot_password;

  /// No description provided for @social_divider.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get social_divider;

  /// No description provided for @btn_login_google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get btn_login_google;

  /// No description provided for @btn_login_apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get btn_login_apple;

  /// No description provided for @footer_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get footer_have_account;

  /// No description provided for @footer_no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get footer_no_account;

  /// No description provided for @footer_action_login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get footer_action_login;

  /// No description provided for @footer_action_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get footer_action_signup;

  /// No description provided for @deliver_to.
  ///
  /// In en, this message translates to:
  /// **'DELIVER TO'**
  String get deliver_to;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Downtown, New York'**
  String get location;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for products, stores...'**
  String get search_hint;

  /// No description provided for @banner_tag.
  ///
  /// In en, this message translates to:
  /// **'LIMITED OFFER'**
  String get banner_tag;

  /// No description provided for @banner_title.
  ///
  /// In en, this message translates to:
  /// **'Fresh Organic\nVegetables Up to 40% Off'**
  String get banner_title;

  /// No description provided for @banner_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Shop fresh, eat healthy every day'**
  String get banner_subtitle;

  /// No description provided for @banner_action.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get banner_action;

  /// No description provided for @section_special_offers.
  ///
  /// In en, this message translates to:
  /// **'Special Offers'**
  String get section_special_offers;

  /// No description provided for @section_best_selling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get section_best_selling;

  /// No description provided for @section_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get section_featured;

  /// No description provided for @section_recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended For You'**
  String get section_recommended;

  /// No description provided for @section_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get section_explore;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get see_all;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get add_to_cart;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get nav_categories;

  /// No description provided for @nav_cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get nav_cart;

  /// No description provided for @nav_orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get nav_orders;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @start_page_title.
  ///
  /// In en, this message translates to:
  /// **'Fresh Products Excellent Quality'**
  String get start_page_title;

  /// No description provided for @start_page_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoy Shopping'**
  String get start_page_subtitle;

  /// No description provided for @start_page_button.
  ///
  /// In en, this message translates to:
  /// **'Get Started Now'**
  String get start_page_button;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @edit_avatar.
  ///
  /// In en, this message translates to:
  /// **'Edit Avatar'**
  String get edit_avatar;

  /// No description provided for @personal_info.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_info;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get date_of_birth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @add_address.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get add_address;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @help_support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help_support;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_app;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_conditions;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirm;

  /// No description provided for @cart_title.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get cart_title;

  /// No description provided for @cart_items_count.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String cart_items_count(Object count);

  /// No description provided for @current_vendor.
  ///
  /// In en, this message translates to:
  /// **'Current Vendor'**
  String get current_vendor;

  /// No description provided for @change_vendor.
  ///
  /// In en, this message translates to:
  /// **'Change Vendor'**
  String get change_vendor;

  /// No description provided for @vendor_change_warning.
  ///
  /// In en, this message translates to:
  /// **'Changing the vendor will affect all products in your cart. Do you want to continue?'**
  String get vendor_change_warning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @promo_code.
  ///
  /// In en, this message translates to:
  /// **'Promo Code'**
  String get promo_code;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @cart_empty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cart_empty;

  /// No description provided for @cart_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Start shopping and add products to your cart'**
  String get cart_empty_message;

  /// No description provided for @shop_now.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shop_now;

  /// No description provided for @delete_item.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get delete_item;

  /// No description provided for @delete_item_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this item from your cart?'**
  String get delete_item_confirm;

  /// No description provided for @available_vendors.
  ///
  /// In en, this message translates to:
  /// **'Available Vendors'**
  String get available_vendors;

  /// No description provided for @sar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get sar;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
