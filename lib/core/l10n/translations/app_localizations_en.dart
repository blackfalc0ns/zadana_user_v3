// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get error_no_internet_connection => 'No internet connection';

  @override
  String get error_no_internet_connection_desc =>
      'Please check your internet connection and try again';

  @override
  String get error_connection_timeout => 'Connection timeout with server';

  @override
  String get error_connection_timeout_desc =>
      'The connection took too long to establish. Please try again';

  @override
  String get error_receive_timeout => 'Receive timeout with server';

  @override
  String get error_receive_timeout_desc =>
      'The server took too long to respond. Please try again';

  @override
  String get error_send_timeout => 'Send timeout with server';

  @override
  String get error_send_timeout_desc =>
      'Failed to send data to the server. Please try again';

  @override
  String get error_server_error => 'Server error';

  @override
  String get error_server_error_desc =>
      'Something went wrong on the server. Please try again later';

  @override
  String get error_internal_server_error => 'Internal server error';

  @override
  String get error_internal_server_error_desc =>
      'The server encountered an internal error. Please try again later';

  @override
  String get error_bad_gateway => 'Temporary error';

  @override
  String get error_bad_gateway_desc =>
      'Something went wrong while connecting to the server. Please try again';

  @override
  String get error_service_unavailable => 'Service unavailable';

  @override
  String get error_service_unavailable_desc =>
      'The service is temporarily unavailable. Please try again later';

  @override
  String get error_gateway_timeout => 'Gateway timeout';

  @override
  String get error_gateway_timeout_desc =>
      'The gateway timed out. Please try again later';

  @override
  String get reviewsFor => 'Reviews for';

  @override
  String get error_bad_request => 'Bad request';

  @override
  String get properties_empty_message_favourite =>
      'You have not added any properties to your favorites.';

  @override
  String get error_bad_request_desc =>
      'The request contains invalid data. Please check your input';

  @override
  String get error_unauthorized => 'Unauthorized, please sign in again';

  @override
  String get error_unauthorized_desc =>
      'You are not authorized to access this resource. Please login again';

  @override
  String get error_forbidden => 'You do not have permission';

  @override
  String get error_forbidden_desc =>
      'You don\'t have permission to access this resource';

  @override
  String get error_not_found => 'Resource not found';

  @override
  String get error_not_found_desc => 'The requested resource was not found';

  @override
  String get error_method_not_allowed => 'Method not allowed';

  @override
  String get error_method_not_allowed_desc =>
      'This method is not allowed for this resource';

  @override
  String get error_not_acceptable => 'Not acceptable';

  @override
  String get error_not_acceptable_desc => 'The request is not acceptable';

  @override
  String get error_request_timeout => 'Request timeout';

  @override
  String get error_request_timeout_desc =>
      'The request timed out. Please try again';

  @override
  String get error_conflict => 'Data conflict occurred';

  @override
  String get error_conflict_desc =>
      'There is a conflict with the current state of the resource';

  @override
  String get error_gone => 'Resource gone';

  @override
  String get error_gone_desc => 'The requested resource is no longer available';

  @override
  String get error_length_required => 'Length required';

  @override
  String get error_length_required_desc =>
      'The request must specify the content length';

  @override
  String get error_precondition_failed => 'Precondition failed';

  @override
  String get error_precondition_failed_desc =>
      'One or more preconditions failed';

  @override
  String get error_payload_too_large => 'Payload too large';

  @override
  String get error_payload_too_large_desc => 'The request payload is too large';

  @override
  String get error_uri_too_long => 'URI too long';

  @override
  String get error_uri_too_long_desc => 'The request URI is too long';

  @override
  String get lead_send_error =>
      'An error occurred while sending the contact request';

  @override
  String get lead_info_collected => 'Lead information collected successfully';

  @override
  String get lead_offline_mode => 'Contact information saved offline';

  @override
  String get error_unsupported_media_type => 'Unsupported media type';

  @override
  String get error_unsupported_media_type_desc =>
      'The media type is not supported';

  @override
  String get error_range_not_satisfiable => 'Range not satisfiable';

  @override
  String get error_range_not_satisfiable_desc =>
      'The requested range cannot be satisfied';

  @override
  String get error_expectation_failed => 'Expectation failed';

  @override
  String get error_expectation_failed_desc =>
      'The expectation given in the request header field could not be met';

  @override
  String get error_too_many_requests => 'Too many requests';

  @override
  String get error_too_many_requests_desc =>
      'You have sent too many requests. Please try again later';

  @override
  String get error_unknown => 'Unexpected error occurred';

  @override
  String get error_unknown_desc =>
      'An unknown error occurred. Please try again';

  @override
  String get error_cancelled => 'Request cancelled';

  @override
  String get error_cancelled_desc => 'The request was cancelled';

  @override
  String get error_other => 'Error occurred';

  @override
  String get error_other_desc => 'An error occurred. Please try again';

  @override
  String get retry => 'Retry';

  @override
  String get contact_support => 'Contact Support';

  @override
  String get go_back => 'Go Back';

  @override
  String get refresh => 'Refresh';

  @override
  String get check_connection => 'Check Connection';

  @override
  String get login => 'Login';

  @override
  String get continue_as_guest => 'Continue as guest';

  @override
  String get name_is_required => 'Name is required!';

  @override
  String get name_is_not_valid => 'This name is not valid';

  @override
  String get email_is_required => 'Email is required!';

  @override
  String get email_is_not_valid => 'This email is not valid';

  @override
  String get password_is_required => 'Password is required!';

  @override
  String get password_is_not_valid => 'This password is not valid';

  @override
  String get password_must_be_at_least_6_characters =>
      'Password must be at least 6 characters';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get confirm_password_is_required => 'Confirm password is required!';

  @override
  String get confirm_password_is_not_valid =>
      'This confirm password is not valid';

  @override
  String get password_and_confirm_password_must_be_same =>
      'Password and confirm password must be same!';

  @override
  String get phone_number_is_required => 'Phone number is required!';

  @override
  String get phone_number_is_not_valid => 'This phone number is not valid';

  @override
  String get this_field_is_required => 'This field is required';

  @override
  String get error => 'Error';

  @override
  String get start_button => 'start now';

  @override
  String get location_service_disabled => 'Location service is disabled';

  @override
  String get location_permission_denied => 'Location permission denied';

  @override
  String get location_permission_denied_forever =>
      'Location permission permanently denied';

  @override
  String get location_service_disabled_message =>
      'Location service is disabled. Please enable location services from settings and try again.';

  @override
  String get location_permission_denied_message =>
      'The app needs location permission to determine your current location. Please allow location access.';

  @override
  String get location_permission_denied_forever_message =>
      'Location permission has been permanently denied. Please go to the app settings and enable location permission.';

  @override
  String get location_search_temporarily_unavailable =>
      'Search is temporarily unavailable. Please try again later.';

  @override
  String get location_rate_limit_retry =>
      'Please wait a moment before trying again.';

  @override
  String get location_start_title => 'Location';

  @override
  String get location_start_subtitle =>
      'Set your location so we can deliver your orders quickly and accurately.';

  @override
  String location_start_selected_subtitle(String address) {
    return 'Selected location: $address';
  }

  @override
  String get location_select_on_map => 'Choose location from map';

  @override
  String get location_use_current_location => 'Use my current location';

  @override
  String get location_enter_address_manually => 'Enter address manually';

  @override
  String get location_map_search_hint => 'Search for a place...';

  @override
  String get location_map_drag_hint => 'Move the map to choose a location';

  @override
  String get location_map_confirm => 'Confirm location';

  @override
  String get auth_title => 'Get Started Now';

  @override
  String get auth_subtitle_login => 'Welcome back! Log in to your account';

  @override
  String get auth_subtitle_signup => 'Create an account to explore our app';

  @override
  String get login_hero_badge => 'Welcome Back';

  @override
  String get login_hero_title => 'Sign In';

  @override
  String get login_hero_subtitle => 'Log in to continue and browse products';

  @override
  String get login_section_badge => 'Member';

  @override
  String get login_section_title => 'Log In';

  @override
  String get login_section_description =>
      'Enter your email or mobile number and password to access your account.';

  @override
  String get register_hero_badge => 'Start shopping';

  @override
  String get register_screen_title => 'Create account';

  @override
  String get register_hero_subtitle =>
      'Create your account in a few steps and start shopping with ease.';

  @override
  String get register_section_badge => 'New account';

  @override
  String get register_form_title => 'Create a new account';

  @override
  String get register_form_description =>
      'Enter your basic details to get started.';

  @override
  String get toggle_login => 'Log In';

  @override
  String get toggle_signup => 'Sign Up';

  @override
  String get label_full_name => 'Full Name';

  @override
  String get label_email => 'Email';

  @override
  String get label_phone => 'Phone';

  @override
  String get label_password => 'Password';

  @override
  String get hint_full_name => 'John Doe';

  @override
  String get hint_email => 'example@gmail.com ';

  @override
  String get hint_email_or_phone => 'example@email.com';

  @override
  String get label_email_or_phone => 'Email';

  @override
  String get hint_phone => '(+966) 726-0592';

  @override
  String get hint_password => 'P@ssw0rd123';

  @override
  String get btn_login => 'Log In';

  @override
  String get btn_signup => 'Sign Up';

  @override
  String get btn_forgot_password => 'Forgot Password?';

  @override
  String get forget_password_title => 'Forgot Password';

  @override
  String get forget_password_description =>
      'Enter your phone number or email to receive a verification code';

  @override
  String get forget_password_hero_badge => 'Recover access';

  @override
  String get forget_password_hero_subtitle =>
      'We will help you recover access quickly so you can get back to your account without friction.';

  @override
  String get forget_password_section_badge => 'Recovery';

  @override
  String get btn_send_verification_code => 'Send Verification Code';

  @override
  String get msg_verification_code_sent =>
      'Verification code sent successfully';

  @override
  String get reset_password_title => 'Reset Password';

  @override
  String get reset_password_description_prefix =>
      'Enter the verification code sent to';

  @override
  String get reset_password_otp_hero_badge => 'Confirm code';

  @override
  String get reset_password_otp_hero_subtitle =>
      'Enter the code we sent so you can safely continue to set your new password.';

  @override
  String get reset_password_otp_section_badge => 'OTP';

  @override
  String get reset_password_hero_badge => 'Secure account';

  @override
  String get reset_password_hero_subtitle =>
      'Choose a stronger password and keep your account protected across every session.';

  @override
  String get reset_password_section_badge => 'Secure';

  @override
  String get label_verification_code => 'Verification Code';

  @override
  String get hint_verification_code => 'Enter verification code';

  @override
  String get label_new_password => 'New Password';

  @override
  String get hint_new_password => 'Enter new password';

  @override
  String get btn_confirm => 'Confirm';

  @override
  String get msg_password_reset_success => 'Password changed successfully';

  @override
  String get verification_code_required => 'Please enter verification code';

  @override
  String get verification_code_invalid => 'Invalid verification code';

  @override
  String get otp_description => 'Enter the verification code sent to you';

  @override
  String get otp_code_sent_to => 'Code sent to';

  @override
  String get otp_verify_button => 'Verify';

  @override
  String get otp_complete_code_required =>
      'Please enter the complete verification code';

  @override
  String get otp_success_message => 'Account verified successfully';

  @override
  String get otp_resend_code => 'Resend Code';

  @override
  String get otp_resend_success => 'Verification code resent successfully';

  @override
  String otp_resend_cooldown(Object seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get otp_hero_badge => 'Account verification';

  @override
  String get otp_hero_subtitle =>
      'Enter the code sent to you to complete account verification.';

  @override
  String get otp_section_badge => 'Verify';

  @override
  String get otp_screen_title => 'Verification Code';

  @override
  String get otp_screen_subtitle =>
      'Enter the verification code sent to you to confirm your account';

  @override
  String get social_divider => 'Or continue with';

  @override
  String get btn_login_google => 'Google';

  @override
  String get btn_login_apple => 'Apple';

  @override
  String get footer_have_account => 'Already have an account? ';

  @override
  String get footer_no_account => 'Don\'t have an account? ';

  @override
  String get footer_action_login => 'Log In';

  @override
  String get footer_action_signup => 'Sign Up';

  @override
  String get deliver_to => 'DELIVER TO';

  @override
  String get location => 'Downtown, New York';

  @override
  String get search_hint => 'Search for products, stores...';

  @override
  String get search_marketplace_title => 'Search in shopping';

  @override
  String get search_start_title => 'Start searching';

  @override
  String get search_start_description =>
      'Type a product name and results will load progressively as you browse.';

  @override
  String get search_empty_title => 'No results found';

  @override
  String get search_empty_description =>
      'Try a different keyword or broaden your search.';

  @override
  String search_in_brand_products(String brandName) {
    return 'Search in $brandName products';
  }

  @override
  String get home_search_hint_dairy => '🧀 Search for dairy products...';

  @override
  String get home_search_hint_vegetables => '🥬 Search for fresh vegetables...';

  @override
  String get home_search_hint_fruits => '🍎 Search for seasonal fruits...';

  @override
  String get home_search_hint_meat => '🍗 Search for meat and poultry...';

  @override
  String get home_search_hint_drinks => '☕ Search for drinks and coffee...';

  @override
  String get home_search_hint_bakery => '🥐 Search for bakery and desserts...';

  @override
  String get home_search_hint_spices => '🌶️ Search for spices and legumes...';

  @override
  String get home_search_hint_cleaning =>
      '🧴 Search for home cleaning products...';

  @override
  String get home_search_hint_oils => '🫒 Search for oils and ghee...';

  @override
  String get home_search_hint_nuts => '🥜 Search for nuts and dried fruits...';

  @override
  String get home_search_hint_canned =>
      '🥫 Search for canned food and fast meals...';

  @override
  String get home_search_hint_baby => '🍼 Search for baby food...';

  @override
  String get banner_tag => 'LIMITED OFFER';

  @override
  String get banner_title => 'Fresh Organic\nVegetables Up to 40% Off';

  @override
  String get banner_subtitle => 'Shop fresh, eat healthy every day';

  @override
  String get banner_action => 'Shop Now';

  @override
  String get section_special_offers => 'Special Offers';

  @override
  String get special_offers_unavailable => 'No special offers available';

  @override
  String get section_best_selling => 'Best Selling';

  @override
  String get best_selling_unavailable => 'No best-selling products available';

  @override
  String get section_brands => 'Brands';

  @override
  String get brands_unavailable => 'No brands available';

  @override
  String get brands_empty_description =>
      'No brands are available right now. Pull to refresh or try again shortly.';

  @override
  String get brands_listing_subtitle =>
      'Browse the available brands and jump into the one you want faster.';

  @override
  String brands_count_badge(int count) {
    return '$count brands';
  }

  @override
  String get section_featured => 'Featured Products';

  @override
  String get featured_unavailable => 'No featured products available';

  @override
  String get section_recommended => 'Recommended For You';

  @override
  String get recommended_unavailable => 'No recommended products available';

  @override
  String get section_explore => 'Explore More';

  @override
  String get explore_more_unavailable => 'No explore more products available';

  @override
  String get similar_products => 'Similar Products';

  @override
  String get see_all => 'See All';

  @override
  String get add_to_cart => 'Add to Cart';

  @override
  String get add_button => 'Add';

  @override
  String get select_size => 'Select size:';

  @override
  String variant_sizes_count(Object count) {
    return '$count sizes';
  }

  @override
  String get nav_home => 'Home';

  @override
  String get nav_categories => 'Categories';

  @override
  String get categ => 'Categories';

  @override
  String get nav_cart => 'Cart';

  @override
  String get nav_orders => 'Orders';

  @override
  String get nav_profile => 'Profile';

  @override
  String get start_page_title => 'Order Everything You Need Easily';

  @override
  String get start_page_subtitle => 'Fast delivery for all your daily needs';

  @override
  String get start_page_button => 'Get Started Now';

  @override
  String get profile_title => 'Profile';

  @override
  String get edit_avatar => 'Edit Avatar';

  @override
  String get personal_info => 'Personal Information';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get date_of_birth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get addresses => 'Addresses';

  @override
  String get add_address => 'Add New Address';

  @override
  String get change_address => 'Change';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get notifications_empty_title => 'No notifications';

  @override
  String get notifications_empty_description =>
      'You are all caught up for now. New order and account updates will appear here.';

  @override
  String get notifications_mark_all_read => 'Mark all read';

  @override
  String get notifications_mark_all_read_confirm_title => 'Mark all as read?';

  @override
  String get notifications_mark_all_read_confirm_message =>
      'Do you want to mark all current notifications as read?';

  @override
  String get notifications_preferences_saved => 'Preferences saved';

  @override
  String notifications_unread_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread notifications',
      one: '1 unread notification',
      zero: 'No unread notifications',
    );
    return '$_temp0';
  }

  @override
  String brand_product_count(int count) {
    return '$count products';
  }

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get account => 'Account';

  @override
  String get change_password => 'Change Password';

  @override
  String get help_support => 'Help & Support';

  @override
  String get help_support_header_title => 'How can we help you?';

  @override
  String get help_support_header_subtitle =>
      'Contact us and we will get back to you soon.';

  @override
  String get about_app => 'About App';

  @override
  String get developer => 'Developer';

  @override
  String get version => 'Version';

  @override
  String get contact_us => 'Contact Us';

  @override
  String get contact_whatsapp => 'WhatsApp';

  @override
  String get contact_whatsapp_subtitle => 'Chat with us on WhatsApp';

  @override
  String get contact_phone_subtitle => 'Call us directly';

  @override
  String get select_language => 'Select Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get about_app_title => 'About App';

  @override
  String get app_name => 'Zadana Smart Shopping App';

  @override
  String get version_label => 'Version';

  @override
  String get release_date => 'Release Date';

  @override
  String get app_description =>
      'Zadana is a multi-vendor shopping platform that redefines your shopping experience. Thousands of vendors, hundreds of thousands of products, and endless categories... all you need is just one click.\n\nWith our vast network of vendors, from local businesses to global brands, we offer our users the widest range of products, providing a seamless shopping experience through secure payment infrastructure and fast shipping options.\n\nAt Zadana, you don\'t just buy products; you discover, compare, find the best prices, and win with exclusive offers. Whether you\'re interested in fashion, electronics, home & living, Zadana is always with you.\n\nYour new shopping destination: Zadana';

  @override
  String get ok => 'OK';

  @override
  String get login_success => 'Login successful';

  @override
  String get register_success =>
      'Account created successfully, please verify your email';

  @override
  String get legal => 'Legal';

  @override
  String get terms_conditions => 'Terms & Conditions';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get faq => 'FAQ';

  @override
  String get faq_track_order_question => 'How can I track my order?';

  @override
  String get faq_track_order_answer =>
      'You can track your order from the My Orders page, then open the order you want to follow.';

  @override
  String get faq_payment_methods_question =>
      'What payment methods are available?';

  @override
  String get faq_payment_methods_answer =>
      'We support common payment cards, e-wallets, and cash on delivery when available.';

  @override
  String get faq_return_product_question => 'How can I return a product?';

  @override
  String get faq_return_product_answer =>
      'You can request a return from the order details page within the allowed return period.';

  @override
  String get faq_contact_support_question => 'How do I contact support?';

  @override
  String get faq_contact_support_answer =>
      'You can contact us through the Help & Support page or the communication methods available in the app.';

  @override
  String get logout => 'Logout';

  @override
  String get logout_confirm => 'Are you sure you want to logout?';

  @override
  String get cart_title => 'My Cart';

  @override
  String cart_items_count(Object count) {
    return '$count items';
  }

  @override
  String get current_vendor => 'Current Vendor';

  @override
  String get change_vendor => 'Change Vendor';

  @override
  String get vendor_change_warning =>
      'Changing the vendor will affect all products in your cart. Do you want to continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get promo_code => 'Promo Code';

  @override
  String get apply => 'Apply';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shipping => 'Shipping';

  @override
  String get discount => 'Discount';

  @override
  String get vat => 'VAT';

  @override
  String get cod_fee => 'COD Fee';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Checkout';

  @override
  String get cart_empty => 'Cart is Empty!';

  @override
  String get cart_empty_description =>
      'There are no products in your shopping cart';

  @override
  String get cart_empty_message =>
      'Start shopping and add products to your cart';

  @override
  String get cart_unavailable_products_title => 'Unavailable products';

  @override
  String cart_unavailable_products_message(int count) {
    return '$count products are unavailable in this store';
  }

  @override
  String get cart_checkout_blocked_unavailable_products =>
      'Checkout is unavailable because some products are not available';

  @override
  String get cart_checkout_unavailable_hint =>
      'Review unavailable products before checkout';

  @override
  String cart_unavailable_checkout_dialog_message(int count) {
    return '$count products in your cart are currently unavailable at this store. Remove them or choose another store, then try again.';
  }

  @override
  String get cart_unavailable_checkout_dialog_action => 'Review cart';

  @override
  String get shop_now => 'Shop Now';

  @override
  String get delete_item => 'Delete Item';

  @override
  String get delete_item_confirm =>
      'Do you want to remove this item from your cart?';

  @override
  String get delete_category_title => 'Delete category';

  @override
  String get delete_category_confirm =>
      'Do you want to delete the selected category?';

  @override
  String get delete_category_tooltip => 'Delete selected';

  @override
  String get clear_filters_title => 'Clear filters';

  @override
  String get clear_filters_confirm =>
      'Your selected price, brand, and other active filters will be removed. Do you want to continue?';

  @override
  String get available_vendors => 'Available Vendors';

  @override
  String get sar => 'SAR';

  @override
  String get free => 'Free';

  @override
  String get quantity => 'Quantity';

  @override
  String get error_bad_certificate => 'Invalid security certificate';

  @override
  String get error_request_cancelled => 'Request was cancelled';

  @override
  String get error_no_internet => 'No internet connection';

  @override
  String get offline_connection_issue_title => 'Connection problem';

  @override
  String get offline_connection_issue_message =>
      'Check your internet and try again';

  @override
  String get error_no_response => 'No response received from server';

  @override
  String get error_validation => 'Invalid input data';

  @override
  String get error_server => 'Server error, please try again later';

  @override
  String get locationServicesDisabled => 'Location services are disabled';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission permanently denied';

  @override
  String get unknownError => 'Something went wrong';

  @override
  String get product_details => 'Product Details';

  @override
  String get product_description => 'Product Description';

  @override
  String get product_description_text =>
      'This is a high-quality product with excellent features suitable for all uses.';

  @override
  String get quantity_label => 'Quantity:';

  @override
  String get add_to_cart_button => 'Add to Cart';

  @override
  String get added_to_favorites => 'Product added to favorites';

  @override
  String get removed_from_favorites => 'Product removed from favorites';

  @override
  String product_added_to_cart(Object quantity, Object name) {
    return 'Added $quantity of $name to cart';
  }

  @override
  String get egp => 'EGP';

  @override
  String get buy_now => 'Buy Now';

  @override
  String get store_price_comparison => 'Store Price Comparison';

  @override
  String get fresh_products => 'Fresh Products';

  @override
  String get nutrition_info => 'Nutrition Info';

  @override
  String get high_fiber => 'High Fiber';

  @override
  String get high_protein => 'High Protein';

  @override
  String get natural_100 => '100% Natural';

  @override
  String get available => 'Available';

  @override
  String get not_available => 'Not Available';

  @override
  String get yes => 'Yes';

  @override
  String get redirecting_to_checkout => 'Redirecting to checkout...';

  @override
  String get cart => 'Shopping Cart';

  @override
  String get product => 'product';

  @override
  String get clear_all => 'Clear All';

  @override
  String get delete_item_confirmation => 'Delete';

  @override
  String get delete => 'Delete';

  @override
  String get no => 'No';

  @override
  String get clear_cart => 'Clear Cart';

  @override
  String get clear_cart_confirmation =>
      'Are you sure you want to clear all items from cart?';

  @override
  String get start_shopping => 'Start Shopping';

  @override
  String get start_shopping_message =>
      'Start shopping and add products to cart';

  @override
  String get item => 'item';

  @override
  String get complete_from => 'Complete from';

  @override
  String get compare => 'Compare';

  @override
  String get select_vendor_to_show_price => 'Select vendor to show price';

  @override
  String get comparison_results => 'Comparison Results';

  @override
  String get save_amount => 'Save';

  @override
  String get if_buy_from => 'if you buy from';

  @override
  String get cheapest => 'Cheapest';

  @override
  String get more_expensive_by => 'More expensive by';

  @override
  String get currently_selected => 'Currently Selected';

  @override
  String get select_one_more_vendor => 'Select at least one more vendor';

  @override
  String get compare_prices => 'Compare Prices';

  @override
  String get select_cheapest => 'Select';

  @override
  String get select_vendors_to_compare => 'Select Vendors to Compare';

  @override
  String get select_2_to_3_vendors => 'Select 2 to 3 vendors to compare prices';

  @override
  String get category_vegetables => 'Vegetables';

  @override
  String get category_fruits => 'Fruits';

  @override
  String get category_meat => 'Meat';

  @override
  String get category_poultry => 'Poultry';

  @override
  String get category_dairy => 'Dairy';

  @override
  String get category_bakery => 'Bakery';

  @override
  String get category_beverages => 'Beverages';

  @override
  String get category_household => 'Household';

  @override
  String get category_personal_care => 'Personal Care';

  @override
  String get category_snacks => 'Snacks';

  @override
  String get sort_newest => 'Newest';

  @override
  String get sort_newest_desc => 'Recently added products';

  @override
  String get sort_price_low => 'Price Low to High';

  @override
  String get sort_price_low_desc => 'From cheapest to most expensive';

  @override
  String get sort_price_high => 'Price High to Low';

  @override
  String get sort_price_high_desc => 'From most expensive to cheapest';

  @override
  String get sort_best_selling => 'Best Selling';

  @override
  String get sort_best_selling_desc => 'Most purchased products';

  @override
  String get sort_highest_rated => 'Highest Rated';

  @override
  String get sort_highest_rated_desc => 'Based on customer ratings';

  @override
  String get sort_alphabetical => 'Alphabetical';

  @override
  String get sort_alphabetical_desc => 'From A to Z';

  @override
  String get filter_title => 'Filter Products';

  @override
  String get sort_title => 'Sort Products';

  @override
  String get search_hint_category => 'Search for vegetables, fruits, meat...';

  @override
  String get filter_button => 'Filter';

  @override
  String get sort_button => 'Sort';

  @override
  String get all_categories => 'All';

  @override
  String get select_product_type => 'Select Product Type';

  @override
  String get category => 'Category';

  @override
  String get price_range => 'Price Range';

  @override
  String get brand_filter_category_title => 'Category';

  @override
  String get brand_filter_type_title => 'Type';

  @override
  String get brand_filter_unit_title => 'Quantity';

  @override
  String get brand_filter_accessories => 'Accessories';

  @override
  String get brand_filter_chargers => 'Chargers';

  @override
  String get brand_filter_phone_cases => 'Phone Cases';

  @override
  String get brand_filter_cables => 'Cables';

  @override
  String get brand_filter_adapters => 'Adapters';

  @override
  String get brand_filter_headphones => 'Headphones';

  @override
  String get brand_filter_speakers => 'Speakers';

  @override
  String get brand_filter_power_banks => 'Power Banks';

  @override
  String get brand_filter_screen_protectors => 'Screen Protectors';

  @override
  String get brand_filter_package_type_title => 'Package Type';

  @override
  String get brand_filter_measurement_unit_title => 'Measurement Unit';

  @override
  String get brand_filter_measurement_value_title => 'Size';

  @override
  String get currency => 'SAR';

  @override
  String get filter_type => 'Type';

  @override
  String get filter_part => 'Part';

  @override
  String get filter_brand => 'Brand';

  @override
  String get filter_category_title => 'Category';

  @override
  String get filter_subcategory_title => 'Subcategory';

  @override
  String get filter_apply => 'Apply Filter';

  @override
  String get show_more => 'Show More';

  @override
  String get show_less => 'Show Less';

  @override
  String get favorites => 'Favorites';

  @override
  String get favorites_empty => 'No favorite products';

  @override
  String get favorites_empty_message =>
      'Start adding your favorite products for easy access';

  @override
  String get clear_favorites => 'Clear All Favorites';

  @override
  String get clear_favorites_confirmation =>
      'Are you sure you want to remove all products from favorites?';

  @override
  String get invoice_details => 'Invoice Details';

  @override
  String get processing => 'Processing...';

  @override
  String get order_success => 'Order Placed Successfully! ';

  @override
  String get order_number => 'Order Number';

  @override
  String get payment_successful => 'Payment Successful! ';

  @override
  String get payment_success_message =>
      'Thank you! Your order has been received and will be delivered soon';

  @override
  String get payment_confirmation_failed => 'Payment Confirmation Failed';

  @override
  String get payment_confirmation_failed_message =>
      'We could not confirm the payment, and the order is still waiting for payment. You can track the order or try again later.';

  @override
  String get estimated_delivery => 'Estimated Delivery Time';

  @override
  String get minutes => 'minutes';

  @override
  String get track_order => 'Track Order';

  @override
  String get back_to_home => 'Back to Home';

  @override
  String get track_order_order_placed => 'Order placed';

  @override
  String get track_order_vendor_confirmed => 'Vendor confirmed';

  @override
  String get track_order_preparing => 'Preparing order';

  @override
  String get track_order_out_for_delivery => 'Out for delivery';

  @override
  String get my_orders_title => 'My Orders';

  @override
  String get my_orders_subtitle =>
      'Track your current and previous orders easily';

  @override
  String get active_orders_tab => 'Active';

  @override
  String get completed_orders_tab => 'Completed';

  @override
  String get returned_orders_tab => 'Returns';

  @override
  String get order_returning => 'In Return';

  @override
  String get no_active_orders => 'No active orders';

  @override
  String get no_previous_orders => 'No previous orders';

  @override
  String get no_returning_orders => 'No orders in return process';

  @override
  String get my_orders_order_date => 'Order Date';

  @override
  String get my_orders_created_at => 'Created At';

  @override
  String get my_orders_items => 'Items';

  @override
  String get my_orders_items_count => 'Items Count';

  @override
  String get my_orders_piece_count => 'Pieces';

  @override
  String get my_orders_unit_price => 'Unit Price';

  @override
  String my_orders_quantity_badge(int quantity) {
    return '$quantity x';
  }

  @override
  String get my_orders_view_details => 'View Details';

  @override
  String get my_orders_cancel_order => 'Cancel Order';

  @override
  String get my_orders_reorder => 'Reorder';

  @override
  String get my_orders_rate_order => 'Rate Order';

  @override
  String get my_orders_reorder_button => 'Reorder';

  @override
  String get my_orders_return_request => 'Return Request';

  @override
  String get my_orders_retry_payment => 'Retry Payment';

  @override
  String get my_orders_follow_up => 'Follow Up';

  @override
  String get my_orders_submit_complaint => 'Submit Complaint';

  @override
  String get my_orders_details_title => 'Order Details';

  @override
  String get my_orders_delete_title => 'Delete this order?';

  @override
  String get my_orders_delete_message =>
      'This action permanently removes the order from your list if deletion is available for it.';

  @override
  String get my_orders_order_summary_title => 'Order Summary';

  @override
  String get my_orders_delivery_otp_title => 'Delivery OTP';

  @override
  String get my_orders_view_otp => 'View OTP';

  @override
  String get my_orders_complaint_status_title => 'Complaint Status';

  @override
  String get my_orders_cancel_sheet_title => 'Cancel Order';

  @override
  String get my_orders_cancel_sheet_subtitle =>
      'Please choose a cancellation reason before confirming the request';

  @override
  String get my_orders_cancel_sheet_reason_label => 'Cancellation Reason';

  @override
  String get my_orders_cancel_sheet_note_hint =>
      'Write an additional note (optional)...';

  @override
  String get my_orders_cancel_sheet_back => 'Back';

  @override
  String get my_orders_cancel_sheet_confirm => 'Confirm Cancellation';

  @override
  String get my_orders_cancel_confirm_title => 'Confirm order cancellation?';

  @override
  String get my_orders_cancel_confirm_message =>
      'Please make sure you want to cancel this order before continuing.';

  @override
  String get my_orders_cancel_reason_delay => 'Delay in preparing the order';

  @override
  String get my_orders_cancel_reason_changed_mind => 'I changed my mind';

  @override
  String get my_orders_cancel_reason_modify_order =>
      'I want to modify the order';

  @override
  String get my_orders_cancel_reason_ordered_by_mistake =>
      'I ordered by mistake';

  @override
  String get my_orders_cancel_reason_price_not_suitable =>
      'The price is not suitable';

  @override
  String get my_orders_cancel_reason_other => 'Other';

  @override
  String get my_orders_complaint_sheet_title => 'Submit Complaint';

  @override
  String get my_orders_complaint_sheet_subtitle =>
      'Write the issue details and attach images if needed';

  @override
  String get my_orders_complaint_sheet_hint => 'Write complaint details';

  @override
  String get my_orders_complaint_sheet_attach_images => 'Attach Images';

  @override
  String my_orders_complaint_sheet_attached_images(int count) {
    return '$count image(s) attached';
  }

  @override
  String get my_orders_complaint_sheet_send => 'Send';

  @override
  String my_orders_cancelled_feedback(String reason) {
    return 'Order cancelled: $reason';
  }

  @override
  String get my_orders_complaint_submitted_feedback => 'Complaint submitted';

  @override
  String get my_orders_complaint_received => 'Complaint Received';

  @override
  String get my_orders_complaint_under_review => 'Complaint Under Review';

  @override
  String get my_orders_complaint_resolved => 'Complaint Resolved';

  @override
  String get my_orders_support_case_title => 'Support Case';

  @override
  String get my_orders_support_case_history_title => 'Case History';

  @override
  String get my_orders_support_case_details_title => 'Case Details';

  @override
  String get my_orders_support_case_timeline_title => 'Customer Timeline';

  @override
  String get my_orders_support_case_empty_details =>
      'Choose a case to view its details.';

  @override
  String get my_orders_support_case_action => 'Contact Support';

  @override
  String get my_orders_support_case_view => 'View Case';

  @override
  String get my_orders_support_case_created => 'Support case submitted';

  @override
  String get my_orders_support_case_sheet_title => 'Create Support Case';

  @override
  String get my_orders_support_case_sheet_subtitle =>
      'Describe the issue and attach files before sending the case.';

  @override
  String get my_orders_support_case_sheet_hint => 'Write what happened';

  @override
  String get my_orders_support_case_sheet_attach_files => 'Attach Files';

  @override
  String my_orders_support_case_sheet_attached_files(int count) {
    return '$count file(s) attached';
  }

  @override
  String get my_orders_support_case_sheet_send => 'Send Case';

  @override
  String get my_orders_support_case_type_complaint => 'Complaint';

  @override
  String get my_orders_support_case_type_return_request => 'Return Request';

  @override
  String get my_orders_support_case_type_generic => 'Support';

  @override
  String get my_orders_support_case_type_label => 'Case type';

  @override
  String get my_orders_support_case_reason_label => 'Reason';

  @override
  String get my_orders_support_case_queue_label => 'Queue';

  @override
  String get my_orders_support_case_priority_label => 'Priority';

  @override
  String get my_orders_support_case_status_label => 'Status';

  @override
  String get my_orders_support_case_settlement_label => 'Settlement';

  @override
  String get my_orders_support_case_waiting_for_reply =>
      'The case is waiting for your reply now.';

  @override
  String get my_orders_support_case_case_details_label => 'Case details';

  @override
  String get my_orders_support_case_approved_amount_label => 'Approved amount';

  @override
  String get my_orders_support_case_coupon_code_label => 'Coupon code';

  @override
  String get my_orders_support_case_expires_at_label => 'Expires at';

  @override
  String get my_orders_support_case_redeemed_label => 'Redeemed';

  @override
  String get my_orders_support_case_copy_code => 'Copy code';

  @override
  String get my_orders_support_case_code_copied => 'Code copied';

  @override
  String get my_orders_support_case_admin_decision_label => 'Admin decision';

  @override
  String get my_orders_support_case_send_update => 'Send update';

  @override
  String get my_orders_support_case_messages_title => 'Messages';

  @override
  String get my_orders_support_case_messages_empty =>
      'No visible messages yet.';

  @override
  String get my_orders_support_case_actor_you => 'You';

  @override
  String get my_orders_support_case_actor_support => 'Support';

  @override
  String get my_orders_support_case_preview_image_error =>
      'Unable to preview image';

  @override
  String get my_orders_support_case_priority_high => 'High';

  @override
  String get my_orders_support_case_priority_medium => 'Medium';

  @override
  String get my_orders_support_case_priority_low => 'Low';

  @override
  String get my_orders_support_case_queue_finance => 'Finance';

  @override
  String get my_orders_support_case_queue_support => 'Support';

  @override
  String get my_orders_support_case_queue_operations => 'Operations';

  @override
  String get my_orders_support_case_settlement_pending_review =>
      'Pending review';

  @override
  String get my_orders_support_case_settlement_cash_refunded => 'Cash refunded';

  @override
  String get my_orders_support_case_settlement_coupon_issued => 'Coupon issued';

  @override
  String get my_orders_support_case_settlement_coupon_redeemed =>
      'Coupon redeemed';

  @override
  String get my_orders_support_case_settlement_rejected => 'Rejected';

  @override
  String get my_orders_support_case_settlement_approved => 'Approved';

  @override
  String get my_orders_support_case_evidence_guidance =>
      'If more evidence is requested, please review the latest note and contact support or wait for the next update.';

  @override
  String get my_orders_support_case_status_submitted => 'Submitted';

  @override
  String get my_orders_support_case_status_in_review => 'In Review';

  @override
  String get my_orders_support_case_status_awaiting_customer_evidence =>
      'Awaiting Evidence';

  @override
  String get my_orders_support_case_status_approved => 'Approved';

  @override
  String get my_orders_support_case_status_rejected => 'Rejected';

  @override
  String get my_orders_support_case_status_resolved => 'Resolved';

  @override
  String get my_orders_support_case_status_unknown => 'Updated';

  @override
  String get my_orders_support_case_reason_payment_issue => 'Payment issue';

  @override
  String get my_orders_support_case_reason_delivery_delay => 'Delivery delay';

  @override
  String get my_orders_support_case_reason_prep_delay => 'Preparation delay';

  @override
  String get my_orders_support_case_reason_fraud => 'Fraud';

  @override
  String get my_orders_support_case_reason_fraud_suspicion => 'Fraud suspicion';

  @override
  String get order_pending => 'Pending';

  @override
  String get order_shipped => 'Shipped';

  @override
  String get order_delivered => 'Delivered';

  @override
  String get order_cancelled => 'Cancelled';

  @override
  String get payment_method => 'Payment Method';

  @override
  String get credit_debit_card => 'Credit/Debit Card';

  @override
  String get credit_card_subtitle => 'Visa, Mastercard, Mada';

  @override
  String get apple_pay => 'Apple Pay';

  @override
  String get apple_pay_subtitle => 'Fast and secure payment';

  @override
  String get cash_on_delivery => 'Cash on Delivery';

  @override
  String get cash_on_delivery_subtitle => 'Pay cash when order arrives';

  @override
  String get bank_transfer => 'Bank Transfer';

  @override
  String get bank_transfer_subtitle => 'Direct transfer from bank';

  @override
  String get shopping => 'shopping';

  @override
  String get delivery_otp_title => 'Delivery Verification';

  @override
  String get delivery_otp_subtitle =>
      'Enter the verification code sent to you for delivery confirmation';

  @override
  String get delivery_otp_sent_to => 'Code sent to';

  @override
  String get delivery_otp_verify_button => 'Verify Delivery';

  @override
  String get delivery_otp_resend => 'Resend Code';

  @override
  String get delivery_otp_resend_success =>
      'Verification code resent successfully';

  @override
  String get delivery_otp_verified => 'Delivery verified successfully';

  @override
  String get delivery_otp_invalid_code => 'Invalid verification code';

  @override
  String get delivery_otp_required => 'Please enter verification code';

  @override
  String get delivery_otp_expired => 'Verification code has expired';

  @override
  String get delivery_otp_attempts_exceeded =>
      'Maximum verification attempts exceeded';

  @override
  String get delivery_otp_remaining_attempts => 'Remaining attempts';

  @override
  String get delivery_otp_timer_prefix => 'Resend code in';

  @override
  String get delivery_otp_seconds => 'seconds';

  @override
  String get delivery_rating_delivered_to => 'Delivered to';

  @override
  String get delivery_rating_your_feeling =>
      'How do you feel about the courier?';

  @override
  String get delivery_rating_your_rating => 'Your Rating';

  @override
  String get delivery_rating_write_comment =>
      'Write about the courier (optional)';

  @override
  String get delivery_rating_comment_hint =>
      'Example: Very fast and friendly, thank you...';

  @override
  String get delivery_rating_cancel => 'Cancel';

  @override
  String get delivery_rating_submit => 'Submit';

  @override
  String get delivery_code_title => 'Your Delivery Verification Code';

  @override
  String get delivery_code_share_instruction =>
      'Please share this code with your delivery courier';

  @override
  String get delivery_code_share_label => 'Share This Code';

  @override
  String get delivery_code_shared_button => 'Code Shared';

  @override
  String get delivery_code_generate_new => 'Generate New Code';

  @override
  String get order_success_title => 'Order Successful';

  @override
  String get order_success_subtitle =>
      'Thank you for your order! Your order will be delivered soon';

  @override
  String get courier_name => 'Courier Name';

  @override
  String get delegate_values => 'Delegate Values';

  @override
  String get continue_shopping => 'Continue Shopping';

  @override
  String get view_order_details => 'View Order Details';

  @override
  String get delivery_get_otp => 'verification code';

  @override
  String get delivery_datetime_title => 'Delivery Date & Time';

  @override
  String get select_date_time => 'Select date and time';

  @override
  String get select_delivery_time => 'Select delivery time';

  @override
  String get delivery_time_selected => 'Selected delivery time';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get delivery_time_note =>
      'Delivery time may vary based on availability';

  @override
  String get reset => 'Reset';

  @override
  String get delivery_code_section_title => 'Delivery Code';

  @override
  String get otp_verification_code => 'OTP Verification Code';

  @override
  String get otp_show_instruction =>
      'Press to view verification code upon order receipt';

  @override
  String get view_otp_code => 'View OTP Code';

  @override
  String get location_accuracy_dialog_title => 'Enable location accuracy';

  @override
  String get location_accuracy_dialog_message =>
      'To detect your current location more precisely and speed up delivery, we will ask your device to enable the recommended location settings.';

  @override
  String get location_accuracy_dialog_hint =>
      'A system prompt may appear next to confirm location access or improve accuracy. You can continue now or try again later.';

  @override
  String get location_accuracy_dialog_continue => 'Continue';

  @override
  String get location_accuracy_dialog_not_now => 'Not now';

  @override
  String get home_empty_title =>
      'No products or categories are available right now';

  @override
  String get home_empty_description =>
      'We could not load any content for the home page at the moment. Pull to refresh or try again in a little while.';

  @override
  String get profile_guest_title => 'You are browsing as a guest';

  @override
  String get profile_guest_subtitle =>
      'Log in or create an account to access your orders, favorites, and personal details.';

  @override
  String get profile_guest_explore_title => 'Available for now';

  @override
  String get profile_guest_addresses_subtitle =>
      'You can add an address, but syncing your data requires signing in';

  @override
  String get location_building_details_page_title => 'Building details';

  @override
  String get location_save_address => 'Save address';

  @override
  String get location_building_details_heading => 'Enter building details';

  @override
  String get location_building_details_subtitle =>
      'Add the building and apartment details to complete your address';

  @override
  String get location_address_label_title => 'Address label *';

  @override
  String get location_address_label_hint => 'Choose an address label';

  @override
  String get location_address_label_required =>
      'Please choose an address label';

  @override
  String get location_address_label_home => 'Home';

  @override
  String get location_address_label_work => 'Work';

  @override
  String get location_address_label_other => 'Other';

  @override
  String get location_building_number_label => 'Building number *';

  @override
  String get location_building_number_hint => 'Example: 15';

  @override
  String get location_building_number_required => 'Building number is required';

  @override
  String get location_floor_number_label => 'Floor number';

  @override
  String get location_floor_number_hint => 'Example: 3';

  @override
  String get location_apartment_number_label => 'Apartment number';

  @override
  String get location_apartment_number_hint => 'Example: 5';

  @override
  String get location_manual_address_page_title => 'Enter address manually';

  @override
  String get location_confirm_address => 'Confirm address';

  @override
  String get location_manual_address_heading => 'Enter your address details';

  @override
  String get location_manual_address_subtitle =>
      'Fill in the following details to add your new address';

  @override
  String get location_edit_address_page_title => 'Edit address';

  @override
  String get location_update_address => 'Update address';

  @override
  String get location_edit_address_heading => 'Edit your address details';

  @override
  String get location_edit_address_subtitle =>
      'Update the following details and save your changes';

  @override
  String get location_address_details_label => 'Detailed address *';

  @override
  String get location_address_details_hint =>
      'Example: Street 28, central Dammam';

  @override
  String get location_address_details_required =>
      'Detailed address is required';

  @override
  String get location_city_label => 'City *';

  @override
  String get location_city_hint => 'Example: Dammam';

  @override
  String get location_city_required => 'City is required';

  @override
  String get location_area_label => 'Area *';

  @override
  String get location_area_hint => 'Example: Al Aziziyah';

  @override
  String get location_area_required => 'Area is required';

  @override
  String addresses_summary_count(Object count) {
    return 'Saved addresses';
  }

  @override
  String addresses_summary_count_badge(Object count) {
    return '$count';
  }

  @override
  String addresses_summary_default(String label) {
    return 'Current default: $label';
  }

  @override
  String get addresses_primary_label => 'Primary address';

  @override
  String get addresses_default => 'Default';

  @override
  String get addresses_current => 'Current address';

  @override
  String get addresses_set_default => 'Set as default';

  @override
  String get addresses_edit => 'Edit';

  @override
  String get addresses_delete => 'Delete';

  @override
  String get addresses_delete_title => 'Delete address';

  @override
  String addresses_delete_confirm(String label) {
    return 'Do you want to delete \"$label\"?';
  }

  @override
  String get addresses_delete_success => 'Address deleted successfully';

  @override
  String addresses_set_default_success(String label) {
    return '\"$label\" was set as the default address';
  }

  @override
  String get addresses_edit_success => 'Address updated successfully';

  @override
  String addresses_meta_building(String value) {
    return 'Building $value';
  }

  @override
  String addresses_meta_floor(String value) {
    return 'Floor $value';
  }

  @override
  String addresses_meta_apartment(String value) {
    return 'Apartment $value';
  }

  @override
  String get profile_role_label => 'Role';

  @override
  String get profile_status_label => 'Status';

  @override
  String get profile_status_active => 'Active';

  @override
  String get profile_edit_subtitle =>
      'Update your name, phone number, and email';

  @override
  String get profile_addresses_subtitle =>
      'Manage delivery addresses and saved locations';

  @override
  String get profile_orders_subtitle =>
      'Review your current and previous orders easily';

  @override
  String get profile_language_subtitle => 'Manage the app language';

  @override
  String get profile_notifications_subtitle =>
      'Control alerts and notifications';

  @override
  String get profile_password_subtitle =>
      'Update your password to keep your account safe';

  @override
  String get profile_help_subtitle => 'Contact us or browse the help center';

  @override
  String get profile_faq_subtitle => 'Quick questions and answers to help you';

  @override
  String get profile_about_subtitle =>
      'Learn more about the app and current version';

  @override
  String get profile_privacy_subtitle =>
      'Privacy, terms, and legal information';

  @override
  String get profile_logout_subtitle => 'Sign out from this device';

  @override
  String get delivery_unavailable_title => 'Delivery Unavailable';

  @override
  String get delivery_unavailable_hint =>
      'Please choose another store or change your delivery address';

  @override
  String get delivery_unavailable_dismiss => 'Got it';

  @override
  String get delivery_unavailable_change_address => 'Change Address';

  @override
  String get checkout_login_title => 'Sign in to continue';

  @override
  String get checkout_login_message =>
      'To complete checkout, you need to sign in first, or finish registration if you do not have an account yet.';

  @override
  String get checkout_login_helper =>
      'If you already have an account, you can sign in from the next screen';

  @override
  String get checkout_login_action => 'Continue';

  @override
  String get error_max_open_cases_exceeded =>
      'You have reached the maximum number of open requests';

  @override
  String get error_duplicate_return_request =>
      'A return request already exists for this order';

  @override
  String get error_return_window_expired => 'The return window has expired';

  @override
  String get refund_lifecycle_pending => 'Processing';

  @override
  String get refund_lifecycle_processed => 'Refunded';

  @override
  String get refund_lifecycle_failed => 'Refund failed';

  @override
  String get refund_lifecycle_not_applicable => 'Not applicable';

  @override
  String get refund_lifecycle_title => 'Refund Status';

  @override
  String get refund_lifecycle_step_approved => 'Approved';

  @override
  String get refund_lifecycle_step_processing => 'Processing';

  @override
  String get refund_lifecycle_step_done => 'Completed';

  @override
  String get notifications_delete_all_title => 'Delete all notifications';

  @override
  String get notifications_delete_all_message =>
      'Delete all notifications? This cannot be undone.';

  @override
  String get notifications_delete_all_confirm => 'Delete';

  @override
  String get notifications_preferences_title => 'Notification Settings';

  @override
  String get notifications_push_enabled => 'Push Notifications';

  @override
  String get notifications_push_enabled_subtitle =>
      'Receive push notifications on this device';

  @override
  String get notifications_sound_title => 'Notification Sound';

  @override
  String get notifications_sound_default => 'Default';

  @override
  String get notifications_sound_silent => 'Silent';

  @override
  String get notifications_sound_chime => 'Chime';

  @override
  String get notifications_sound_alert => 'Alert';

  @override
  String get product_not_available_title => 'Product no longer available';

  @override
  String get product_not_available_description =>
      'This product is currently unavailable. You can browse other products.';

  @override
  String get checkout_unavailable_items_confirm_title =>
      'Some items are unavailable';

  @override
  String checkout_unavailable_items_confirm_message(int count) {
    return 'The selected vendor cannot provide all $count unavailable cart items. Continue and remove them from the order?';
  }

  @override
  String get checkout_unavailable_items_confirm_continue => 'Continue';
}
