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

  /// No description provided for @error_no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get error_no_internet_connection;

  /// No description provided for @error_no_internet_connection_desc.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get error_no_internet_connection_desc;

  /// No description provided for @error_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout with server'**
  String get error_connection_timeout;

  /// No description provided for @error_connection_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The connection took too long to establish. Please try again'**
  String get error_connection_timeout_desc;

  /// No description provided for @error_receive_timeout.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout with server'**
  String get error_receive_timeout;

  /// No description provided for @error_receive_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Please try again'**
  String get error_receive_timeout_desc;

  /// No description provided for @error_send_timeout.
  ///
  /// In en, this message translates to:
  /// **'Send timeout with server'**
  String get error_send_timeout;

  /// No description provided for @error_send_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'Failed to send data to the server. Please try again'**
  String get error_send_timeout_desc;

  /// No description provided for @error_server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get error_server_error;

  /// No description provided for @error_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on the server. Please try again later'**
  String get error_server_error_desc;

  /// No description provided for @error_internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get error_internal_server_error;

  /// No description provided for @error_internal_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'The server encountered an internal error. Please try again later'**
  String get error_internal_server_error_desc;

  /// No description provided for @error_bad_gateway.
  ///
  /// In en, this message translates to:
  /// **'Bad gateway'**
  String get error_bad_gateway;

  /// No description provided for @error_bad_gateway_desc.
  ///
  /// In en, this message translates to:
  /// **'The server received an invalid response. Please try again later'**
  String get error_bad_gateway_desc;

  /// No description provided for @error_service_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get error_service_unavailable;

  /// No description provided for @error_service_unavailable_desc.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again later'**
  String get error_service_unavailable_desc;

  /// No description provided for @error_gateway_timeout.
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout'**
  String get error_gateway_timeout;

  /// No description provided for @error_gateway_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The gateway timed out. Please try again later'**
  String get error_gateway_timeout_desc;

  /// No description provided for @error_bad_request.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get error_bad_request;

  /// No description provided for @properties_empty_message_favourite.
  ///
  /// In en, this message translates to:
  /// **'You have not added any properties to your favorites.'**
  String get properties_empty_message_favourite;

  /// No description provided for @error_bad_request_desc.
  ///
  /// In en, this message translates to:
  /// **'The request contains invalid data. Please check your input'**
  String get error_bad_request_desc;

  /// No description provided for @error_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized, please sign in again'**
  String get error_unauthorized;

  /// No description provided for @error_unauthorized_desc.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to access this resource. Please login again'**
  String get error_unauthorized_desc;

  /// No description provided for @error_forbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission'**
  String get error_forbidden;

  /// No description provided for @error_forbidden_desc.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to access this resource'**
  String get error_forbidden_desc;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get error_not_found;

  /// No description provided for @error_not_found_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found'**
  String get error_not_found_desc;

  /// No description provided for @error_method_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Method not allowed'**
  String get error_method_not_allowed;

  /// No description provided for @error_method_not_allowed_desc.
  ///
  /// In en, this message translates to:
  /// **'This method is not allowed for this resource'**
  String get error_method_not_allowed_desc;

  /// No description provided for @error_not_acceptable.
  ///
  /// In en, this message translates to:
  /// **'Not acceptable'**
  String get error_not_acceptable;

  /// No description provided for @error_not_acceptable_desc.
  ///
  /// In en, this message translates to:
  /// **'The request is not acceptable'**
  String get error_not_acceptable_desc;

  /// No description provided for @error_request_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get error_request_timeout;

  /// No description provided for @error_request_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please try again'**
  String get error_request_timeout_desc;

  /// No description provided for @error_conflict.
  ///
  /// In en, this message translates to:
  /// **'Data conflict occurred'**
  String get error_conflict;

  /// No description provided for @error_conflict_desc.
  ///
  /// In en, this message translates to:
  /// **'There is a conflict with the current state of the resource'**
  String get error_conflict_desc;

  /// No description provided for @error_gone.
  ///
  /// In en, this message translates to:
  /// **'Resource gone'**
  String get error_gone;

  /// No description provided for @error_gone_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource is no longer available'**
  String get error_gone_desc;

  /// No description provided for @error_length_required.
  ///
  /// In en, this message translates to:
  /// **'Length required'**
  String get error_length_required;

  /// No description provided for @error_length_required_desc.
  ///
  /// In en, this message translates to:
  /// **'The request must specify the content length'**
  String get error_length_required_desc;

  /// No description provided for @error_precondition_failed.
  ///
  /// In en, this message translates to:
  /// **'Precondition failed'**
  String get error_precondition_failed;

  /// No description provided for @error_precondition_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'One or more preconditions failed'**
  String get error_precondition_failed_desc;

  /// No description provided for @error_payload_too_large.
  ///
  /// In en, this message translates to:
  /// **'Payload too large'**
  String get error_payload_too_large;

  /// No description provided for @error_payload_too_large_desc.
  ///
  /// In en, this message translates to:
  /// **'The request payload is too large'**
  String get error_payload_too_large_desc;

  /// No description provided for @error_uri_too_long.
  ///
  /// In en, this message translates to:
  /// **'URI too long'**
  String get error_uri_too_long;

  /// No description provided for @error_uri_too_long_desc.
  ///
  /// In en, this message translates to:
  /// **'The request URI is too long'**
  String get error_uri_too_long_desc;

  /// No description provided for @lead_send_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sending the contact request'**
  String get lead_send_error;

  /// No description provided for @lead_info_collected.
  ///
  /// In en, this message translates to:
  /// **'Lead information collected successfully'**
  String get lead_info_collected;

  /// No description provided for @lead_offline_mode.
  ///
  /// In en, this message translates to:
  /// **'Contact information saved offline'**
  String get lead_offline_mode;

  /// No description provided for @error_unsupported_media_type.
  ///
  /// In en, this message translates to:
  /// **'Unsupported media type'**
  String get error_unsupported_media_type;

  /// No description provided for @error_unsupported_media_type_desc.
  ///
  /// In en, this message translates to:
  /// **'The media type is not supported'**
  String get error_unsupported_media_type_desc;

  /// No description provided for @error_range_not_satisfiable.
  ///
  /// In en, this message translates to:
  /// **'Range not satisfiable'**
  String get error_range_not_satisfiable;

  /// No description provided for @error_range_not_satisfiable_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested range cannot be satisfied'**
  String get error_range_not_satisfiable_desc;

  /// No description provided for @error_expectation_failed.
  ///
  /// In en, this message translates to:
  /// **'Expectation failed'**
  String get error_expectation_failed;

  /// No description provided for @error_expectation_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'The expectation given in the request header field could not be met'**
  String get error_expectation_failed_desc;

  /// No description provided for @error_too_many_requests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests'**
  String get error_too_many_requests;

  /// No description provided for @error_too_many_requests_desc.
  ///
  /// In en, this message translates to:
  /// **'You have sent too many requests. Please try again later'**
  String get error_too_many_requests_desc;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get error_unknown;

  /// No description provided for @error_unknown_desc.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again'**
  String get error_unknown_desc;

  /// No description provided for @error_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get error_cancelled;

  /// No description provided for @error_cancelled_desc.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled'**
  String get error_cancelled_desc;

  /// No description provided for @error_other.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get error_other;

  /// No description provided for @error_other_desc.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get error_other_desc;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get go_back;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @check_connection.
  ///
  /// In en, this message translates to:
  /// **'Check Connection'**
  String get check_connection;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continue_as_guest;

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

  /// No description provided for @location_service_disabled_message.
  ///
  /// In en, this message translates to:
  /// **'Location service is disabled. Please enable location services from settings and try again.'**
  String get location_service_disabled_message;

  /// No description provided for @location_permission_denied_message.
  ///
  /// In en, this message translates to:
  /// **'The app needs location permission to determine your current location. Please allow location access.'**
  String get location_permission_denied_message;

  /// No description provided for @location_permission_denied_forever_message.
  ///
  /// In en, this message translates to:
  /// **'Location permission has been permanently denied. Please go to the app settings and enable location permission.'**
  String get location_permission_denied_forever_message;

  /// No description provided for @location_search_temporarily_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Search is temporarily unavailable. Please try again later.'**
  String get location_search_temporarily_unavailable;

  /// No description provided for @location_rate_limit_retry.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment before trying again.'**
  String get location_rate_limit_retry;

  /// No description provided for @location_start_title.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location_start_title;

  /// No description provided for @location_start_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your location so we can deliver your orders quickly and accurately.'**
  String get location_start_subtitle;

  /// No description provided for @location_start_selected_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Selected location: {address}'**
  String location_start_selected_subtitle(String address);

  /// No description provided for @location_select_on_map.
  ///
  /// In en, this message translates to:
  /// **'Choose location from map'**
  String get location_select_on_map;

  /// No description provided for @location_use_current_location.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get location_use_current_location;

  /// No description provided for @location_enter_address_manually.
  ///
  /// In en, this message translates to:
  /// **'Enter address manually'**
  String get location_enter_address_manually;

  /// No description provided for @location_map_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for a place...'**
  String get location_map_search_hint;

  /// No description provided for @location_map_drag_hint.
  ///
  /// In en, this message translates to:
  /// **'Move the map to choose a location'**
  String get location_map_drag_hint;

  /// No description provided for @location_map_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm location'**
  String get location_map_confirm;

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

  /// No description provided for @login_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get login_hero_badge;

  /// No description provided for @login_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login_hero_title;

  /// No description provided for @login_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue and browse products'**
  String get login_hero_subtitle;

  /// No description provided for @login_section_badge.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get login_section_badge;

  /// No description provided for @login_section_title.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login_section_title;

  /// No description provided for @login_section_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or mobile number and password to access your account.'**
  String get login_section_description;

  /// No description provided for @register_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get register_hero_badge;

  /// No description provided for @register_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get register_screen_title;

  /// No description provided for @register_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account in a few steps and start shopping with ease.'**
  String get register_hero_subtitle;

  /// No description provided for @register_section_badge.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get register_section_badge;

  /// No description provided for @register_form_title.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get register_form_title;

  /// No description provided for @register_form_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your basic details to get started.'**
  String get register_form_description;

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
  /// **'example@gmail.com '**
  String get hint_email;

  /// No description provided for @hint_email_or_phone.
  ///
  /// In en, this message translates to:
  /// **'example@email.com or 5xxxxxxxx'**
  String get hint_email_or_phone;

  /// No description provided for @label_email_or_phone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get label_email_or_phone;

  /// No description provided for @hint_phone.
  ///
  /// In en, this message translates to:
  /// **'(+966) 726-0592'**
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

  /// No description provided for @forget_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forget_password_title;

  /// No description provided for @forget_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number or email to receive a verification code'**
  String get forget_password_description;

  /// No description provided for @forget_password_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Recover access'**
  String get forget_password_hero_badge;

  /// No description provided for @forget_password_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We will help you recover access quickly so you can get back to your account without friction.'**
  String get forget_password_hero_subtitle;

  /// No description provided for @forget_password_section_badge.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get forget_password_section_badge;

  /// No description provided for @btn_send_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get btn_send_verification_code;

  /// No description provided for @msg_verification_code_sent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get msg_verification_code_sent;

  /// No description provided for @reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password_title;

  /// No description provided for @reset_password_description_prefix.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to'**
  String get reset_password_description_prefix;

  /// No description provided for @reset_password_otp_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Confirm code'**
  String get reset_password_otp_hero_badge;

  /// No description provided for @reset_password_otp_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent so you can safely continue to set your new password.'**
  String get reset_password_otp_hero_subtitle;

  /// No description provided for @reset_password_otp_section_badge.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get reset_password_otp_section_badge;

  /// No description provided for @reset_password_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Secure account'**
  String get reset_password_hero_badge;

  /// No description provided for @reset_password_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a stronger password and keep your account protected across every session.'**
  String get reset_password_hero_subtitle;

  /// No description provided for @reset_password_section_badge.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get reset_password_section_badge;

  /// No description provided for @label_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get label_verification_code;

  /// No description provided for @hint_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get hint_verification_code;

  /// No description provided for @label_new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get label_new_password;

  /// No description provided for @hint_new_password.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get hint_new_password;

  /// No description provided for @btn_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get btn_confirm;

  /// No description provided for @msg_password_reset_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get msg_password_reset_success;

  /// No description provided for @verification_code_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get verification_code_required;

  /// No description provided for @verification_code_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get verification_code_invalid;

  /// No description provided for @otp_description.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to you'**
  String get otp_description;

  /// No description provided for @otp_code_sent_to.
  ///
  /// In en, this message translates to:
  /// **'Code sent to'**
  String get otp_code_sent_to;

  /// No description provided for @otp_verify_button.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otp_verify_button;

  /// No description provided for @otp_complete_code_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete verification code'**
  String get otp_complete_code_required;

  /// No description provided for @otp_success_message.
  ///
  /// In en, this message translates to:
  /// **'Account verified successfully'**
  String get otp_success_message;

  /// No description provided for @otp_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Account verification'**
  String get otp_hero_badge;

  /// No description provided for @otp_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to you to complete account verification.'**
  String get otp_hero_subtitle;

  /// No description provided for @otp_section_badge.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otp_section_badge;

  /// No description provided for @otp_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get otp_screen_title;

  /// No description provided for @otp_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to you to confirm your account'**
  String get otp_screen_subtitle;

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

  /// No description provided for @search_marketplace_title.
  ///
  /// In en, this message translates to:
  /// **'Search in shopping'**
  String get search_marketplace_title;

  /// No description provided for @search_start_title.
  ///
  /// In en, this message translates to:
  /// **'Start searching'**
  String get search_start_title;

  /// No description provided for @search_start_description.
  ///
  /// In en, this message translates to:
  /// **'Type a product name and results will load progressively as you browse.'**
  String get search_start_description;

  /// No description provided for @search_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get search_empty_title;

  /// No description provided for @search_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Try a different keyword or broaden your search.'**
  String get search_empty_description;

  /// No description provided for @search_in_brand_products.
  ///
  /// In en, this message translates to:
  /// **'Search in {brandName} products'**
  String search_in_brand_products(String brandName);

  /// No description provided for @home_search_hint_dairy.
  ///
  /// In en, this message translates to:
  /// **'🧀 Search for dairy products...'**
  String get home_search_hint_dairy;

  /// No description provided for @home_search_hint_vegetables.
  ///
  /// In en, this message translates to:
  /// **'🥬 Search for fresh vegetables...'**
  String get home_search_hint_vegetables;

  /// No description provided for @home_search_hint_fruits.
  ///
  /// In en, this message translates to:
  /// **'🍎 Search for seasonal fruits...'**
  String get home_search_hint_fruits;

  /// No description provided for @home_search_hint_meat.
  ///
  /// In en, this message translates to:
  /// **'🍗 Search for meat and poultry...'**
  String get home_search_hint_meat;

  /// No description provided for @home_search_hint_drinks.
  ///
  /// In en, this message translates to:
  /// **'☕ Search for drinks and coffee...'**
  String get home_search_hint_drinks;

  /// No description provided for @home_search_hint_bakery.
  ///
  /// In en, this message translates to:
  /// **'🥐 Search for bakery and desserts...'**
  String get home_search_hint_bakery;

  /// No description provided for @home_search_hint_spices.
  ///
  /// In en, this message translates to:
  /// **'🌶️ Search for spices and legumes...'**
  String get home_search_hint_spices;

  /// No description provided for @home_search_hint_cleaning.
  ///
  /// In en, this message translates to:
  /// **'🧴 Search for home cleaning products...'**
  String get home_search_hint_cleaning;

  /// No description provided for @home_search_hint_oils.
  ///
  /// In en, this message translates to:
  /// **'🫒 Search for oils and ghee...'**
  String get home_search_hint_oils;

  /// No description provided for @home_search_hint_nuts.
  ///
  /// In en, this message translates to:
  /// **'🥜 Search for nuts and dried fruits...'**
  String get home_search_hint_nuts;

  /// No description provided for @home_search_hint_canned.
  ///
  /// In en, this message translates to:
  /// **'🥫 Search for canned food and fast meals...'**
  String get home_search_hint_canned;

  /// No description provided for @home_search_hint_baby.
  ///
  /// In en, this message translates to:
  /// **'🍼 Search for baby food...'**
  String get home_search_hint_baby;

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

  /// No description provided for @special_offers_unavailable.
  ///
  /// In en, this message translates to:
  /// **'No special offers available'**
  String get special_offers_unavailable;

  /// No description provided for @section_best_selling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get section_best_selling;

  /// No description provided for @best_selling_unavailable.
  ///
  /// In en, this message translates to:
  /// **'No best-selling products available'**
  String get best_selling_unavailable;

  /// No description provided for @section_brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get section_brands;

  /// No description provided for @brands_unavailable.
  ///
  /// In en, this message translates to:
  /// **'No brands available'**
  String get brands_unavailable;

  /// No description provided for @brands_empty_description.
  ///
  /// In en, this message translates to:
  /// **'No brands are available right now. Pull to refresh or try again shortly.'**
  String get brands_empty_description;

  /// No description provided for @brands_listing_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse the available brands and jump into the one you want faster.'**
  String get brands_listing_subtitle;

  /// No description provided for @brands_count_badge.
  ///
  /// In en, this message translates to:
  /// **'{count} brands'**
  String brands_count_badge(int count);

  /// No description provided for @section_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get section_featured;

  /// No description provided for @featured_unavailable.
  ///
  /// In en, this message translates to:
  /// **'No featured products available'**
  String get featured_unavailable;

  /// No description provided for @section_recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended For You'**
  String get section_recommended;

  /// No description provided for @recommended_unavailable.
  ///
  /// In en, this message translates to:
  /// **'No recommended products available'**
  String get recommended_unavailable;

  /// No description provided for @section_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get section_explore;

  /// No description provided for @explore_more_unavailable.
  ///
  /// In en, this message translates to:
  /// **'No explore more products available'**
  String get explore_more_unavailable;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get see_all;

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

  /// No description provided for @categ.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categ;

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
  /// **'Order Everything You Need Easily'**
  String get start_page_title;

  /// No description provided for @start_page_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast delivery for all your daily needs'**
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

  /// No description provided for @change_address.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change_address;

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

  /// No description provided for @notifications_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notifications_empty_title;

  /// No description provided for @notifications_empty_description.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up for now. New order and account updates will appear here.'**
  String get notifications_empty_description;

  /// No description provided for @notifications_mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notifications_mark_all_read;

  /// No description provided for @notifications_mark_all_read_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read?'**
  String get notifications_mark_all_read_confirm_title;

  /// No description provided for @notifications_mark_all_read_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Do you want to mark all current notifications as read?'**
  String get notifications_mark_all_read_confirm_message;

  /// No description provided for @notifications_preferences_saved.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences saved'**
  String get notifications_preferences_saved;

  /// No description provided for @notifications_unread_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No unread notifications} =1{1 unread notification} other{{count} unread notifications}}'**
  String notifications_unread_count(int count);

  /// No description provided for @brand_product_count.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String brand_product_count(int count);

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

  /// No description provided for @help_support_header_title.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get help_support_header_title;

  /// No description provided for @help_support_header_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us and we will get back to you soon.'**
  String get help_support_header_subtitle;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_app;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @contact_whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get contact_whatsapp;

  /// No description provided for @contact_whatsapp_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with us on WhatsApp'**
  String get contact_whatsapp_subtitle;

  /// No description provided for @contact_phone_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Call us directly'**
  String get contact_phone_subtitle;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @about_app_title.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_app_title;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Zadana Smart Shopping App'**
  String get app_name;

  /// No description provided for @version_label.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version_label;

  /// No description provided for @release_date.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get release_date;

  /// No description provided for @app_description.
  ///
  /// In en, this message translates to:
  /// **'Zadana is a multi-vendor shopping platform that redefines your shopping experience. Thousands of vendors, hundreds of thousands of products, and endless categories... all you need is just one click.\n\nWith our vast network of vendors, from local businesses to global brands, we offer our users the widest range of products, providing a seamless shopping experience through secure payment infrastructure and fast shipping options.\n\nAt Zadana, you don\'t just buy products; you discover, compare, find the best prices, and win with exclusive offers. Whether you\'re interested in fashion, electronics, home & living, Zadana is always with you.\n\nYour new shopping destination: Zadana'**
  String get app_description;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @login_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get login_success;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully, please verify your email'**
  String get register_success;

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

  /// No description provided for @faq_track_order_question.
  ///
  /// In en, this message translates to:
  /// **'How can I track my order?'**
  String get faq_track_order_question;

  /// No description provided for @faq_track_order_answer.
  ///
  /// In en, this message translates to:
  /// **'You can track your order from the My Orders page, then open the order you want to follow.'**
  String get faq_track_order_answer;

  /// No description provided for @faq_payment_methods_question.
  ///
  /// In en, this message translates to:
  /// **'What payment methods are available?'**
  String get faq_payment_methods_question;

  /// No description provided for @faq_payment_methods_answer.
  ///
  /// In en, this message translates to:
  /// **'We support common payment cards, e-wallets, and cash on delivery when available.'**
  String get faq_payment_methods_answer;

  /// No description provided for @faq_return_product_question.
  ///
  /// In en, this message translates to:
  /// **'How can I return a product?'**
  String get faq_return_product_question;

  /// No description provided for @faq_return_product_answer.
  ///
  /// In en, this message translates to:
  /// **'You can request a return from the order details page within the allowed return period.'**
  String get faq_return_product_answer;

  /// No description provided for @faq_contact_support_question.
  ///
  /// In en, this message translates to:
  /// **'How do I contact support?'**
  String get faq_contact_support_question;

  /// No description provided for @faq_contact_support_answer.
  ///
  /// In en, this message translates to:
  /// **'You can contact us through the Help & Support page or the communication methods available in the app.'**
  String get faq_contact_support_answer;

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
  /// **'Cart is Empty!'**
  String get cart_empty;

  /// No description provided for @cart_empty_description.
  ///
  /// In en, this message translates to:
  /// **'There are no products in your shopping cart'**
  String get cart_empty_description;

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

  /// No description provided for @delete_category_title.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get delete_category_title;

  /// No description provided for @delete_category_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the selected category?'**
  String get delete_category_confirm;

  /// No description provided for @delete_category_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get delete_category_tooltip;

  /// No description provided for @clear_filters_title.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clear_filters_title;

  /// No description provided for @clear_filters_confirm.
  ///
  /// In en, this message translates to:
  /// **'Your selected price, brand, and other active filters will be removed. Do you want to continue?'**
  String get clear_filters_confirm;

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

  /// No description provided for @error_bad_certificate.
  ///
  /// In en, this message translates to:
  /// **'Invalid security certificate'**
  String get error_bad_certificate;

  /// No description provided for @error_request_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled'**
  String get error_request_cancelled;

  /// No description provided for @error_no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get error_no_internet;

  /// No description provided for @offline_connection_issue_title.
  ///
  /// In en, this message translates to:
  /// **'Connection problem'**
  String get offline_connection_issue_title;

  /// No description provided for @offline_connection_issue_message.
  ///
  /// In en, this message translates to:
  /// **'Check your internet and try again'**
  String get offline_connection_issue_message;

  /// No description provided for @error_no_response.
  ///
  /// In en, this message translates to:
  /// **'No response received from server'**
  String get error_no_response;

  /// No description provided for @error_validation.
  ///
  /// In en, this message translates to:
  /// **'Invalid input data'**
  String get error_validation;

  /// No description provided for @error_server.
  ///
  /// In en, this message translates to:
  /// **'Server error, please try again later'**
  String get error_server;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get locationPermissionDeniedForever;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get unknownError;

  /// No description provided for @product_details.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details;

  /// No description provided for @product_description.
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get product_description;

  /// No description provided for @product_description_text.
  ///
  /// In en, this message translates to:
  /// **'This is a high-quality product with excellent features suitable for all uses.'**
  String get product_description_text;

  /// No description provided for @quantity_label.
  ///
  /// In en, this message translates to:
  /// **'Quantity:'**
  String get quantity_label;

  /// No description provided for @add_to_cart_button.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get add_to_cart_button;

  /// No description provided for @added_to_favorites.
  ///
  /// In en, this message translates to:
  /// **'Product added to favorites'**
  String get added_to_favorites;

  /// No description provided for @removed_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Product removed from favorites'**
  String get removed_from_favorites;

  /// No description provided for @product_added_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Added {quantity} of {name} to cart'**
  String product_added_to_cart(Object quantity, Object name);

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @buy_now.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buy_now;

  /// No description provided for @store_price_comparison.
  ///
  /// In en, this message translates to:
  /// **'Store Price Comparison'**
  String get store_price_comparison;

  /// No description provided for @fresh_products.
  ///
  /// In en, this message translates to:
  /// **'Fresh Products'**
  String get fresh_products;

  /// No description provided for @nutrition_info.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Info'**
  String get nutrition_info;

  /// No description provided for @high_fiber.
  ///
  /// In en, this message translates to:
  /// **'High Fiber'**
  String get high_fiber;

  /// No description provided for @high_protein.
  ///
  /// In en, this message translates to:
  /// **'High Protein'**
  String get high_protein;

  /// No description provided for @natural_100.
  ///
  /// In en, this message translates to:
  /// **'100% Natural'**
  String get natural_100;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get not_available;

  /// No description provided for @redirecting_to_checkout.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to checkout...'**
  String get redirecting_to_checkout;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get cart;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get product;

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clear_all;

  /// No description provided for @delete_item_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_item_confirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @clear_cart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clear_cart;

  /// No description provided for @clear_cart_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all items from cart?'**
  String get clear_cart_confirmation;

  /// No description provided for @start_shopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get start_shopping;

  /// No description provided for @start_shopping_message.
  ///
  /// In en, this message translates to:
  /// **'Start shopping and add products to cart'**
  String get start_shopping_message;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// No description provided for @complete_from.
  ///
  /// In en, this message translates to:
  /// **'Complete from'**
  String get complete_from;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// No description provided for @select_vendor_to_show_price.
  ///
  /// In en, this message translates to:
  /// **'Select vendor to show price'**
  String get select_vendor_to_show_price;

  /// No description provided for @comparison_results.
  ///
  /// In en, this message translates to:
  /// **'Comparison Results'**
  String get comparison_results;

  /// No description provided for @save_amount.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_amount;

  /// No description provided for @if_buy_from.
  ///
  /// In en, this message translates to:
  /// **'if you buy from'**
  String get if_buy_from;

  /// No description provided for @cheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get cheapest;

  /// No description provided for @more_expensive_by.
  ///
  /// In en, this message translates to:
  /// **'More expensive by'**
  String get more_expensive_by;

  /// No description provided for @currently_selected.
  ///
  /// In en, this message translates to:
  /// **'Currently Selected'**
  String get currently_selected;

  /// No description provided for @select_one_more_vendor.
  ///
  /// In en, this message translates to:
  /// **'Select at least one more vendor'**
  String get select_one_more_vendor;

  /// No description provided for @compare_prices.
  ///
  /// In en, this message translates to:
  /// **'Compare Prices'**
  String get compare_prices;

  /// No description provided for @select_cheapest.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select_cheapest;

  /// No description provided for @select_vendors_to_compare.
  ///
  /// In en, this message translates to:
  /// **'Select Vendors to Compare'**
  String get select_vendors_to_compare;

  /// No description provided for @select_2_to_3_vendors.
  ///
  /// In en, this message translates to:
  /// **'Select 2 to 3 vendors to compare prices'**
  String get select_2_to_3_vendors;

  /// No description provided for @category_vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get category_vegetables;

  /// No description provided for @category_fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get category_fruits;

  /// No description provided for @category_meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get category_meat;

  /// No description provided for @category_poultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get category_poultry;

  /// No description provided for @category_dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get category_dairy;

  /// No description provided for @category_bakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get category_bakery;

  /// No description provided for @category_beverages.
  ///
  /// In en, this message translates to:
  /// **'Beverages'**
  String get category_beverages;

  /// No description provided for @category_household.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get category_household;

  /// No description provided for @category_personal_care.
  ///
  /// In en, this message translates to:
  /// **'Personal Care'**
  String get category_personal_care;

  /// No description provided for @category_snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get category_snacks;

  /// No description provided for @sort_newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sort_newest;

  /// No description provided for @sort_newest_desc.
  ///
  /// In en, this message translates to:
  /// **'Recently added products'**
  String get sort_newest_desc;

  /// No description provided for @sort_price_low.
  ///
  /// In en, this message translates to:
  /// **'Price Low to High'**
  String get sort_price_low;

  /// No description provided for @sort_price_low_desc.
  ///
  /// In en, this message translates to:
  /// **'From cheapest to most expensive'**
  String get sort_price_low_desc;

  /// No description provided for @sort_price_high.
  ///
  /// In en, this message translates to:
  /// **'Price High to Low'**
  String get sort_price_high;

  /// No description provided for @sort_price_high_desc.
  ///
  /// In en, this message translates to:
  /// **'From most expensive to cheapest'**
  String get sort_price_high_desc;

  /// No description provided for @sort_best_selling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get sort_best_selling;

  /// No description provided for @sort_best_selling_desc.
  ///
  /// In en, this message translates to:
  /// **'Most purchased products'**
  String get sort_best_selling_desc;

  /// No description provided for @sort_highest_rated.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get sort_highest_rated;

  /// No description provided for @sort_highest_rated_desc.
  ///
  /// In en, this message translates to:
  /// **'Based on customer ratings'**
  String get sort_highest_rated_desc;

  /// No description provided for @sort_alphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get sort_alphabetical;

  /// No description provided for @sort_alphabetical_desc.
  ///
  /// In en, this message translates to:
  /// **'From A to Z'**
  String get sort_alphabetical_desc;

  /// No description provided for @filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filter Products'**
  String get filter_title;

  /// No description provided for @sort_title.
  ///
  /// In en, this message translates to:
  /// **'Sort Products'**
  String get sort_title;

  /// No description provided for @search_hint_category.
  ///
  /// In en, this message translates to:
  /// **'Search for vegetables, fruits, meat...'**
  String get search_hint_category;

  /// No description provided for @filter_button.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter_button;

  /// No description provided for @sort_button.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort_button;

  /// No description provided for @all_categories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all_categories;

  /// No description provided for @select_product_type.
  ///
  /// In en, this message translates to:
  /// **'Select Product Type'**
  String get select_product_type;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @price_range.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get price_range;

  /// No description provided for @brand_filter_category_title.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get brand_filter_category_title;

  /// No description provided for @brand_filter_type_title.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get brand_filter_type_title;

  /// No description provided for @brand_filter_unit_title.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get brand_filter_unit_title;

  /// No description provided for @brand_filter_accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get brand_filter_accessories;

  /// No description provided for @brand_filter_chargers.
  ///
  /// In en, this message translates to:
  /// **'Chargers'**
  String get brand_filter_chargers;

  /// No description provided for @brand_filter_phone_cases.
  ///
  /// In en, this message translates to:
  /// **'Phone Cases'**
  String get brand_filter_phone_cases;

  /// No description provided for @brand_filter_cables.
  ///
  /// In en, this message translates to:
  /// **'Cables'**
  String get brand_filter_cables;

  /// No description provided for @brand_filter_adapters.
  ///
  /// In en, this message translates to:
  /// **'Adapters'**
  String get brand_filter_adapters;

  /// No description provided for @brand_filter_headphones.
  ///
  /// In en, this message translates to:
  /// **'Headphones'**
  String get brand_filter_headphones;

  /// No description provided for @brand_filter_speakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get brand_filter_speakers;

  /// No description provided for @brand_filter_power_banks.
  ///
  /// In en, this message translates to:
  /// **'Power Banks'**
  String get brand_filter_power_banks;

  /// No description provided for @brand_filter_screen_protectors.
  ///
  /// In en, this message translates to:
  /// **'Screen Protectors'**
  String get brand_filter_screen_protectors;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currency;

  /// No description provided for @filter_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get filter_type;

  /// No description provided for @filter_part.
  ///
  /// In en, this message translates to:
  /// **'Part'**
  String get filter_part;

  /// No description provided for @filter_brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get filter_brand;

  /// No description provided for @filter_category_title.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filter_category_title;

  /// No description provided for @filter_subcategory_title.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get filter_subcategory_title;

  /// No description provided for @filter_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get filter_apply;

  /// No description provided for @show_more.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get show_more;

  /// No description provided for @show_less.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get show_less;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @favorites_empty.
  ///
  /// In en, this message translates to:
  /// **'No favorite products'**
  String get favorites_empty;

  /// No description provided for @favorites_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Start adding your favorite products for easy access'**
  String get favorites_empty_message;

  /// No description provided for @clear_favorites.
  ///
  /// In en, this message translates to:
  /// **'Clear All Favorites'**
  String get clear_favorites;

  /// No description provided for @clear_favorites_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all products from favorites?'**
  String get clear_favorites_confirmation;

  /// No description provided for @invoice_details.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoice_details;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @order_success.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully! '**
  String get order_success;

  /// No description provided for @order_number.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get order_number;

  /// No description provided for @payment_successful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful! '**
  String get payment_successful;

  /// No description provided for @payment_success_message.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your order has been received and will be delivered soon'**
  String get payment_success_message;

  /// No description provided for @estimated_delivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery Time'**
  String get estimated_delivery;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @track_order.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get track_order;

  /// No description provided for @back_to_home.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get back_to_home;

  /// No description provided for @track_order_order_placed.
  ///
  /// In en, this message translates to:
  /// **'Order placed'**
  String get track_order_order_placed;

  /// No description provided for @track_order_vendor_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Vendor confirmed'**
  String get track_order_vendor_confirmed;

  /// No description provided for @track_order_preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing order'**
  String get track_order_preparing;

  /// No description provided for @track_order_out_for_delivery.
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get track_order_out_for_delivery;

  /// No description provided for @my_orders_title.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get my_orders_title;

  /// No description provided for @my_orders_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your current and previous orders easily'**
  String get my_orders_subtitle;

  /// No description provided for @active_orders_tab.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active_orders_tab;

  /// No description provided for @completed_orders_tab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed_orders_tab;

  /// No description provided for @returned_orders_tab.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get returned_orders_tab;

  /// No description provided for @order_returning.
  ///
  /// In en, this message translates to:
  /// **'In Return'**
  String get order_returning;

  /// No description provided for @no_active_orders.
  ///
  /// In en, this message translates to:
  /// **'No active orders'**
  String get no_active_orders;

  /// No description provided for @no_previous_orders.
  ///
  /// In en, this message translates to:
  /// **'No previous orders'**
  String get no_previous_orders;

  /// No description provided for @no_returning_orders.
  ///
  /// In en, this message translates to:
  /// **'No orders in return process'**
  String get no_returning_orders;

  /// No description provided for @my_orders_order_date.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get my_orders_order_date;

  /// No description provided for @my_orders_created_at.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get my_orders_created_at;

  /// No description provided for @my_orders_items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get my_orders_items;

  /// No description provided for @my_orders_items_count.
  ///
  /// In en, this message translates to:
  /// **'Items Count'**
  String get my_orders_items_count;

  /// No description provided for @my_orders_piece_count.
  ///
  /// In en, this message translates to:
  /// **'Pieces'**
  String get my_orders_piece_count;

  /// No description provided for @my_orders_unit_price.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get my_orders_unit_price;

  /// No description provided for @my_orders_quantity_badge.
  ///
  /// In en, this message translates to:
  /// **'{quantity} x'**
  String my_orders_quantity_badge(int quantity);

  /// No description provided for @my_orders_view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get my_orders_view_details;

  /// No description provided for @my_orders_cancel_order.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get my_orders_cancel_order;

  /// No description provided for @my_orders_reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get my_orders_reorder;

  /// No description provided for @my_orders_rate_order.
  ///
  /// In en, this message translates to:
  /// **'Rate Order'**
  String get my_orders_rate_order;

  /// No description provided for @my_orders_reorder_button.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get my_orders_reorder_button;

  /// No description provided for @my_orders_return_request.
  ///
  /// In en, this message translates to:
  /// **'Return Request'**
  String get my_orders_return_request;

  /// No description provided for @my_orders_retry_payment.
  ///
  /// In en, this message translates to:
  /// **'Retry Payment'**
  String get my_orders_retry_payment;

  /// No description provided for @my_orders_follow_up.
  ///
  /// In en, this message translates to:
  /// **'Follow Up'**
  String get my_orders_follow_up;

  /// No description provided for @my_orders_submit_complaint.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get my_orders_submit_complaint;

  /// No description provided for @my_orders_details_title.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get my_orders_details_title;

  /// No description provided for @my_orders_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete this order?'**
  String get my_orders_delete_title;

  /// No description provided for @my_orders_delete_message.
  ///
  /// In en, this message translates to:
  /// **'This action permanently removes the order from your list if deletion is available for it.'**
  String get my_orders_delete_message;

  /// No description provided for @my_orders_order_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get my_orders_order_summary_title;

  /// No description provided for @my_orders_delivery_otp_title.
  ///
  /// In en, this message translates to:
  /// **'Delivery OTP'**
  String get my_orders_delivery_otp_title;

  /// No description provided for @my_orders_view_otp.
  ///
  /// In en, this message translates to:
  /// **'View OTP'**
  String get my_orders_view_otp;

  /// No description provided for @my_orders_complaint_status_title.
  ///
  /// In en, this message translates to:
  /// **'Complaint Status'**
  String get my_orders_complaint_status_title;

  /// No description provided for @my_orders_cancel_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get my_orders_cancel_sheet_title;

  /// No description provided for @my_orders_cancel_sheet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please choose a cancellation reason before confirming the request'**
  String get my_orders_cancel_sheet_subtitle;

  /// No description provided for @my_orders_cancel_sheet_reason_label.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get my_orders_cancel_sheet_reason_label;

  /// No description provided for @my_orders_cancel_sheet_note_hint.
  ///
  /// In en, this message translates to:
  /// **'Write an additional note (optional)...'**
  String get my_orders_cancel_sheet_note_hint;

  /// No description provided for @my_orders_cancel_sheet_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get my_orders_cancel_sheet_back;

  /// No description provided for @my_orders_cancel_sheet_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get my_orders_cancel_sheet_confirm;

  /// No description provided for @my_orders_cancel_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm order cancellation?'**
  String get my_orders_cancel_confirm_title;

  /// No description provided for @my_orders_cancel_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Please make sure you want to cancel this order before continuing.'**
  String get my_orders_cancel_confirm_message;

  /// No description provided for @my_orders_cancel_reason_delay.
  ///
  /// In en, this message translates to:
  /// **'Delay in preparing the order'**
  String get my_orders_cancel_reason_delay;

  /// No description provided for @my_orders_cancel_reason_changed_mind.
  ///
  /// In en, this message translates to:
  /// **'I changed my mind'**
  String get my_orders_cancel_reason_changed_mind;

  /// No description provided for @my_orders_cancel_reason_modify_order.
  ///
  /// In en, this message translates to:
  /// **'I want to modify the order'**
  String get my_orders_cancel_reason_modify_order;

  /// No description provided for @my_orders_cancel_reason_ordered_by_mistake.
  ///
  /// In en, this message translates to:
  /// **'I ordered by mistake'**
  String get my_orders_cancel_reason_ordered_by_mistake;

  /// No description provided for @my_orders_cancel_reason_price_not_suitable.
  ///
  /// In en, this message translates to:
  /// **'The price is not suitable'**
  String get my_orders_cancel_reason_price_not_suitable;

  /// No description provided for @my_orders_cancel_reason_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get my_orders_cancel_reason_other;

  /// No description provided for @my_orders_complaint_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get my_orders_complaint_sheet_title;

  /// No description provided for @my_orders_complaint_sheet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Write the issue details and attach images if needed'**
  String get my_orders_complaint_sheet_subtitle;

  /// No description provided for @my_orders_complaint_sheet_hint.
  ///
  /// In en, this message translates to:
  /// **'Write complaint details'**
  String get my_orders_complaint_sheet_hint;

  /// No description provided for @my_orders_complaint_sheet_attach_images.
  ///
  /// In en, this message translates to:
  /// **'Attach Images'**
  String get my_orders_complaint_sheet_attach_images;

  /// No description provided for @my_orders_complaint_sheet_attached_images.
  ///
  /// In en, this message translates to:
  /// **'{count} image(s) attached'**
  String my_orders_complaint_sheet_attached_images(int count);

  /// No description provided for @my_orders_complaint_sheet_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get my_orders_complaint_sheet_send;

  /// No description provided for @my_orders_cancelled_feedback.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled: {reason}'**
  String my_orders_cancelled_feedback(String reason);

  /// No description provided for @my_orders_complaint_submitted_feedback.
  ///
  /// In en, this message translates to:
  /// **'Complaint submitted'**
  String get my_orders_complaint_submitted_feedback;

  /// No description provided for @my_orders_complaint_received.
  ///
  /// In en, this message translates to:
  /// **'Complaint Received'**
  String get my_orders_complaint_received;

  /// No description provided for @my_orders_complaint_under_review.
  ///
  /// In en, this message translates to:
  /// **'Complaint Under Review'**
  String get my_orders_complaint_under_review;

  /// No description provided for @my_orders_complaint_resolved.
  ///
  /// In en, this message translates to:
  /// **'Complaint Resolved'**
  String get my_orders_complaint_resolved;

  /// No description provided for @my_orders_support_case_title.
  ///
  /// In en, this message translates to:
  /// **'Support Case'**
  String get my_orders_support_case_title;

  /// No description provided for @my_orders_support_case_history_title.
  ///
  /// In en, this message translates to:
  /// **'Case History'**
  String get my_orders_support_case_history_title;

  /// No description provided for @my_orders_support_case_details_title.
  ///
  /// In en, this message translates to:
  /// **'Case Details'**
  String get my_orders_support_case_details_title;

  /// No description provided for @my_orders_support_case_timeline_title.
  ///
  /// In en, this message translates to:
  /// **'Customer Timeline'**
  String get my_orders_support_case_timeline_title;

  /// No description provided for @my_orders_support_case_empty_details.
  ///
  /// In en, this message translates to:
  /// **'Choose a case to view its details.'**
  String get my_orders_support_case_empty_details;

  /// No description provided for @my_orders_support_case_action.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get my_orders_support_case_action;

  /// No description provided for @my_orders_support_case_view.
  ///
  /// In en, this message translates to:
  /// **'View Case'**
  String get my_orders_support_case_view;

  /// No description provided for @my_orders_support_case_created.
  ///
  /// In en, this message translates to:
  /// **'Support case submitted'**
  String get my_orders_support_case_created;

  /// No description provided for @my_orders_support_case_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Create Support Case'**
  String get my_orders_support_case_sheet_title;

  /// No description provided for @my_orders_support_case_sheet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue and attach files before sending the case.'**
  String get my_orders_support_case_sheet_subtitle;

  /// No description provided for @my_orders_support_case_sheet_hint.
  ///
  /// In en, this message translates to:
  /// **'Write what happened'**
  String get my_orders_support_case_sheet_hint;

  /// No description provided for @my_orders_support_case_sheet_attach_files.
  ///
  /// In en, this message translates to:
  /// **'Attach Files'**
  String get my_orders_support_case_sheet_attach_files;

  /// No description provided for @my_orders_support_case_sheet_attached_files.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s) attached'**
  String my_orders_support_case_sheet_attached_files(int count);

  /// No description provided for @my_orders_support_case_sheet_send.
  ///
  /// In en, this message translates to:
  /// **'Send Case'**
  String get my_orders_support_case_sheet_send;

  /// No description provided for @my_orders_support_case_type_complaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get my_orders_support_case_type_complaint;

  /// No description provided for @my_orders_support_case_type_return_request.
  ///
  /// In en, this message translates to:
  /// **'Return Request'**
  String get my_orders_support_case_type_return_request;

  /// No description provided for @my_orders_support_case_type_generic.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get my_orders_support_case_type_generic;

  /// No description provided for @my_orders_support_case_reason_label.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get my_orders_support_case_reason_label;

  /// No description provided for @my_orders_support_case_queue_label.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get my_orders_support_case_queue_label;

  /// No description provided for @my_orders_support_case_priority_label.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get my_orders_support_case_priority_label;

  /// No description provided for @my_orders_support_case_evidence_guidance.
  ///
  /// In en, this message translates to:
  /// **'If more evidence is requested, please review the latest note and contact support or wait for the next update.'**
  String get my_orders_support_case_evidence_guidance;

  /// No description provided for @my_orders_support_case_status_submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get my_orders_support_case_status_submitted;

  /// No description provided for @my_orders_support_case_status_in_review.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get my_orders_support_case_status_in_review;

  /// No description provided for @my_orders_support_case_status_awaiting_customer_evidence.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Evidence'**
  String get my_orders_support_case_status_awaiting_customer_evidence;

  /// No description provided for @my_orders_support_case_status_approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get my_orders_support_case_status_approved;

  /// No description provided for @my_orders_support_case_status_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get my_orders_support_case_status_rejected;

  /// No description provided for @my_orders_support_case_status_resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get my_orders_support_case_status_resolved;

  /// No description provided for @my_orders_support_case_status_unknown.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get my_orders_support_case_status_unknown;

  /// No description provided for @my_orders_support_case_reason_payment_issue.
  ///
  /// In en, this message translates to:
  /// **'Payment issue'**
  String get my_orders_support_case_reason_payment_issue;

  /// No description provided for @my_orders_support_case_reason_delivery_delay.
  ///
  /// In en, this message translates to:
  /// **'Delivery delay'**
  String get my_orders_support_case_reason_delivery_delay;

  /// No description provided for @my_orders_support_case_reason_prep_delay.
  ///
  /// In en, this message translates to:
  /// **'Preparation delay'**
  String get my_orders_support_case_reason_prep_delay;

  /// No description provided for @my_orders_support_case_reason_fraud.
  ///
  /// In en, this message translates to:
  /// **'Fraud'**
  String get my_orders_support_case_reason_fraud;

  /// No description provided for @my_orders_support_case_reason_fraud_suspicion.
  ///
  /// In en, this message translates to:
  /// **'Fraud suspicion'**
  String get my_orders_support_case_reason_fraud_suspicion;

  /// No description provided for @order_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get order_pending;

  /// No description provided for @order_shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get order_shipped;

  /// No description provided for @order_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get order_delivered;

  /// No description provided for @order_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get order_cancelled;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @credit_debit_card.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit Card'**
  String get credit_debit_card;

  /// No description provided for @credit_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard, Mada'**
  String get credit_card_subtitle;

  /// No description provided for @apple_pay.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get apple_pay;

  /// No description provided for @apple_pay_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast and secure payment'**
  String get apple_pay_subtitle;

  /// No description provided for @cash_on_delivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cash_on_delivery;

  /// No description provided for @cash_on_delivery_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay cash when order arrives'**
  String get cash_on_delivery_subtitle;

  /// No description provided for @bank_transfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bank_transfer;

  /// No description provided for @bank_transfer_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Direct transfer from bank'**
  String get bank_transfer_subtitle;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'shopping'**
  String get shopping;

  /// No description provided for @delivery_otp_title.
  ///
  /// In en, this message translates to:
  /// **'Delivery Verification'**
  String get delivery_otp_title;

  /// No description provided for @delivery_otp_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to you for delivery confirmation'**
  String get delivery_otp_subtitle;

  /// No description provided for @delivery_otp_sent_to.
  ///
  /// In en, this message translates to:
  /// **'Code sent to'**
  String get delivery_otp_sent_to;

  /// No description provided for @delivery_otp_verify_button.
  ///
  /// In en, this message translates to:
  /// **'Verify Delivery'**
  String get delivery_otp_verify_button;

  /// No description provided for @delivery_otp_resend.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get delivery_otp_resend;

  /// No description provided for @delivery_otp_resend_success.
  ///
  /// In en, this message translates to:
  /// **'Verification code resent successfully'**
  String get delivery_otp_resend_success;

  /// No description provided for @delivery_otp_verified.
  ///
  /// In en, this message translates to:
  /// **'Delivery verified successfully'**
  String get delivery_otp_verified;

  /// No description provided for @delivery_otp_invalid_code.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get delivery_otp_invalid_code;

  /// No description provided for @delivery_otp_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get delivery_otp_required;

  /// No description provided for @delivery_otp_expired.
  ///
  /// In en, this message translates to:
  /// **'Verification code has expired'**
  String get delivery_otp_expired;

  /// No description provided for @delivery_otp_attempts_exceeded.
  ///
  /// In en, this message translates to:
  /// **'Maximum verification attempts exceeded'**
  String get delivery_otp_attempts_exceeded;

  /// No description provided for @delivery_otp_remaining_attempts.
  ///
  /// In en, this message translates to:
  /// **'Remaining attempts'**
  String get delivery_otp_remaining_attempts;

  /// No description provided for @delivery_otp_timer_prefix.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get delivery_otp_timer_prefix;

  /// No description provided for @delivery_otp_seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get delivery_otp_seconds;

  /// No description provided for @delivery_rating_delivered_to.
  ///
  /// In en, this message translates to:
  /// **'Delivered to'**
  String get delivery_rating_delivered_to;

  /// No description provided for @delivery_rating_your_feeling.
  ///
  /// In en, this message translates to:
  /// **'How do you feel about the courier?'**
  String get delivery_rating_your_feeling;

  /// No description provided for @delivery_rating_your_rating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get delivery_rating_your_rating;

  /// No description provided for @delivery_rating_write_comment.
  ///
  /// In en, this message translates to:
  /// **'Write about the courier (optional)'**
  String get delivery_rating_write_comment;

  /// No description provided for @delivery_rating_comment_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: Very fast and friendly, thank you...'**
  String get delivery_rating_comment_hint;

  /// No description provided for @delivery_rating_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get delivery_rating_cancel;

  /// No description provided for @delivery_rating_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get delivery_rating_submit;

  /// No description provided for @delivery_code_title.
  ///
  /// In en, this message translates to:
  /// **'Your Delivery Verification Code'**
  String get delivery_code_title;

  /// No description provided for @delivery_code_share_instruction.
  ///
  /// In en, this message translates to:
  /// **'Please share this code with your delivery courier'**
  String get delivery_code_share_instruction;

  /// No description provided for @delivery_code_share_label.
  ///
  /// In en, this message translates to:
  /// **'Share This Code'**
  String get delivery_code_share_label;

  /// No description provided for @delivery_code_shared_button.
  ///
  /// In en, this message translates to:
  /// **'Code Shared'**
  String get delivery_code_shared_button;

  /// No description provided for @delivery_code_generate_new.
  ///
  /// In en, this message translates to:
  /// **'Generate New Code'**
  String get delivery_code_generate_new;

  /// No description provided for @order_success_title.
  ///
  /// In en, this message translates to:
  /// **'Order Successful'**
  String get order_success_title;

  /// No description provided for @order_success_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your order! Your order will be delivered soon'**
  String get order_success_subtitle;

  /// No description provided for @courier_name.
  ///
  /// In en, this message translates to:
  /// **'Courier Name'**
  String get courier_name;

  /// No description provided for @delegate_values.
  ///
  /// In en, this message translates to:
  /// **'Delegate Values'**
  String get delegate_values;

  /// No description provided for @continue_shopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continue_shopping;

  /// No description provided for @view_order_details.
  ///
  /// In en, this message translates to:
  /// **'View Order Details'**
  String get view_order_details;

  /// No description provided for @delivery_get_otp.
  ///
  /// In en, this message translates to:
  /// **'verification code'**
  String get delivery_get_otp;

  /// No description provided for @delivery_datetime_title.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date & Time'**
  String get delivery_datetime_title;

  /// No description provided for @select_date_time.
  ///
  /// In en, this message translates to:
  /// **'Select date and time'**
  String get select_date_time;

  /// No description provided for @select_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Select delivery time'**
  String get select_delivery_time;

  /// No description provided for @delivery_time_selected.
  ///
  /// In en, this message translates to:
  /// **'Selected delivery time'**
  String get delivery_time_selected;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @delivery_time_note.
  ///
  /// In en, this message translates to:
  /// **'Delivery time may vary based on availability'**
  String get delivery_time_note;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @delivery_code_section_title.
  ///
  /// In en, this message translates to:
  /// **'Delivery Code'**
  String get delivery_code_section_title;

  /// No description provided for @otp_verification_code.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification Code'**
  String get otp_verification_code;

  /// No description provided for @otp_show_instruction.
  ///
  /// In en, this message translates to:
  /// **'Press to view verification code upon order receipt'**
  String get otp_show_instruction;

  /// No description provided for @view_otp_code.
  ///
  /// In en, this message translates to:
  /// **'View OTP Code'**
  String get view_otp_code;

  /// No description provided for @location_accuracy_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Enable location accuracy'**
  String get location_accuracy_dialog_title;

  /// No description provided for @location_accuracy_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'To detect your current location more precisely and speed up delivery, we will ask your device to enable the recommended location settings.'**
  String get location_accuracy_dialog_message;

  /// No description provided for @location_accuracy_dialog_hint.
  ///
  /// In en, this message translates to:
  /// **'A system prompt may appear next to confirm location access or improve accuracy. You can continue now or try again later.'**
  String get location_accuracy_dialog_hint;

  /// No description provided for @location_accuracy_dialog_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get location_accuracy_dialog_continue;

  /// No description provided for @location_accuracy_dialog_not_now.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get location_accuracy_dialog_not_now;

  /// No description provided for @home_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No products or categories are available right now'**
  String get home_empty_title;

  /// No description provided for @home_empty_description.
  ///
  /// In en, this message translates to:
  /// **'We could not load any content for the home page at the moment. Pull to refresh or try again in a little while.'**
  String get home_empty_description;

  /// No description provided for @profile_guest_title.
  ///
  /// In en, this message translates to:
  /// **'You are browsing as a guest'**
  String get profile_guest_title;

  /// No description provided for @profile_guest_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in or create an account to access your orders, favorites, and personal details.'**
  String get profile_guest_subtitle;

  /// No description provided for @profile_guest_explore_title.
  ///
  /// In en, this message translates to:
  /// **'Available for now'**
  String get profile_guest_explore_title;

  /// No description provided for @profile_guest_addresses_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You can add an address, but syncing your data requires signing in'**
  String get profile_guest_addresses_subtitle;

  /// No description provided for @location_building_details_page_title.
  ///
  /// In en, this message translates to:
  /// **'Building details'**
  String get location_building_details_page_title;

  /// No description provided for @location_save_address.
  ///
  /// In en, this message translates to:
  /// **'Save address'**
  String get location_save_address;

  /// No description provided for @location_building_details_heading.
  ///
  /// In en, this message translates to:
  /// **'Enter building details'**
  String get location_building_details_heading;

  /// No description provided for @location_building_details_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add the building and apartment details to complete your address'**
  String get location_building_details_subtitle;

  /// No description provided for @location_address_label_title.
  ///
  /// In en, this message translates to:
  /// **'Address label *'**
  String get location_address_label_title;

  /// No description provided for @location_address_label_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose an address label'**
  String get location_address_label_hint;

  /// No description provided for @location_address_label_required.
  ///
  /// In en, this message translates to:
  /// **'Please choose an address label'**
  String get location_address_label_required;

  /// No description provided for @location_address_label_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get location_address_label_home;

  /// No description provided for @location_address_label_work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get location_address_label_work;

  /// No description provided for @location_address_label_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get location_address_label_other;

  /// No description provided for @location_building_number_label.
  ///
  /// In en, this message translates to:
  /// **'Building number *'**
  String get location_building_number_label;

  /// No description provided for @location_building_number_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: 15'**
  String get location_building_number_hint;

  /// No description provided for @location_building_number_required.
  ///
  /// In en, this message translates to:
  /// **'Building number is required'**
  String get location_building_number_required;

  /// No description provided for @location_floor_number_label.
  ///
  /// In en, this message translates to:
  /// **'Floor number'**
  String get location_floor_number_label;

  /// No description provided for @location_floor_number_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: 3'**
  String get location_floor_number_hint;

  /// No description provided for @location_apartment_number_label.
  ///
  /// In en, this message translates to:
  /// **'Apartment number'**
  String get location_apartment_number_label;

  /// No description provided for @location_apartment_number_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: 5'**
  String get location_apartment_number_hint;

  /// No description provided for @location_manual_address_page_title.
  ///
  /// In en, this message translates to:
  /// **'Enter address manually'**
  String get location_manual_address_page_title;

  /// No description provided for @location_confirm_address.
  ///
  /// In en, this message translates to:
  /// **'Confirm address'**
  String get location_confirm_address;

  /// No description provided for @location_manual_address_heading.
  ///
  /// In en, this message translates to:
  /// **'Enter your address details'**
  String get location_manual_address_heading;

  /// No description provided for @location_manual_address_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the following details to add your new address'**
  String get location_manual_address_subtitle;

  /// No description provided for @location_edit_address_page_title.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get location_edit_address_page_title;

  /// No description provided for @location_update_address.
  ///
  /// In en, this message translates to:
  /// **'Update address'**
  String get location_update_address;

  /// No description provided for @location_edit_address_heading.
  ///
  /// In en, this message translates to:
  /// **'Edit your address details'**
  String get location_edit_address_heading;

  /// No description provided for @location_edit_address_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Update the following details and save your changes'**
  String get location_edit_address_subtitle;

  /// No description provided for @location_address_details_label.
  ///
  /// In en, this message translates to:
  /// **'Detailed address *'**
  String get location_address_details_label;

  /// No description provided for @location_address_details_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: Al Gomhoria Street, next to Al Noor Mosque'**
  String get location_address_details_hint;

  /// No description provided for @location_address_details_required.
  ///
  /// In en, this message translates to:
  /// **'Detailed address is required'**
  String get location_address_details_required;

  /// No description provided for @location_city_label.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get location_city_label;

  /// No description provided for @location_city_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: Cairo'**
  String get location_city_hint;

  /// No description provided for @location_city_required.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get location_city_required;

  /// No description provided for @location_area_label.
  ///
  /// In en, this message translates to:
  /// **'Area *'**
  String get location_area_label;

  /// No description provided for @location_area_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: Maadi'**
  String get location_area_hint;

  /// No description provided for @location_area_required.
  ///
  /// In en, this message translates to:
  /// **'Area is required'**
  String get location_area_required;

  /// No description provided for @addresses_summary_count.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String addresses_summary_count(Object count);

  /// No description provided for @addresses_summary_count_badge.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String addresses_summary_count_badge(Object count);

  /// No description provided for @addresses_summary_default.
  ///
  /// In en, this message translates to:
  /// **'Current default: {label}'**
  String addresses_summary_default(String label);

  /// No description provided for @addresses_primary_label.
  ///
  /// In en, this message translates to:
  /// **'Primary address'**
  String get addresses_primary_label;

  /// No description provided for @addresses_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get addresses_default;

  /// No description provided for @addresses_current.
  ///
  /// In en, this message translates to:
  /// **'Current address'**
  String get addresses_current;

  /// No description provided for @addresses_set_default.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get addresses_set_default;

  /// No description provided for @addresses_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get addresses_edit;

  /// No description provided for @addresses_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get addresses_delete;

  /// No description provided for @addresses_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete address'**
  String get addresses_delete_title;

  /// No description provided for @addresses_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete \"{label}\"?'**
  String addresses_delete_confirm(String label);

  /// No description provided for @addresses_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Address deleted successfully'**
  String get addresses_delete_success;

  /// No description provided for @addresses_set_default_success.
  ///
  /// In en, this message translates to:
  /// **'\"{label}\" was set as the default address'**
  String addresses_set_default_success(String label);

  /// No description provided for @addresses_edit_success.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get addresses_edit_success;

  /// No description provided for @addresses_meta_building.
  ///
  /// In en, this message translates to:
  /// **'Building {value}'**
  String addresses_meta_building(String value);

  /// No description provided for @addresses_meta_floor.
  ///
  /// In en, this message translates to:
  /// **'Floor {value}'**
  String addresses_meta_floor(String value);

  /// No description provided for @addresses_meta_apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment {value}'**
  String addresses_meta_apartment(String value);

  /// No description provided for @profile_role_label.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get profile_role_label;

  /// No description provided for @profile_status_label.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get profile_status_label;

  /// No description provided for @profile_status_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get profile_status_active;

  /// No description provided for @profile_edit_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your name, phone number, and email'**
  String get profile_edit_subtitle;

  /// No description provided for @profile_addresses_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage delivery addresses and saved locations'**
  String get profile_addresses_subtitle;

  /// No description provided for @profile_orders_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Review your current and previous orders easily'**
  String get profile_orders_subtitle;

  /// No description provided for @profile_language_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage the app language'**
  String get profile_language_subtitle;

  /// No description provided for @profile_notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Control alerts and notifications'**
  String get profile_notifications_subtitle;

  /// No description provided for @profile_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password to keep your account safe'**
  String get profile_password_subtitle;

  /// No description provided for @profile_help_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us or browse the help center'**
  String get profile_help_subtitle;

  /// No description provided for @profile_faq_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick questions and answers to help you'**
  String get profile_faq_subtitle;

  /// No description provided for @profile_about_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn more about the app and current version'**
  String get profile_about_subtitle;

  /// No description provided for @profile_privacy_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy, terms, and legal information'**
  String get profile_privacy_subtitle;

  /// No description provided for @profile_logout_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out from this device'**
  String get profile_logout_subtitle;
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
