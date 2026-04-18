// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get error_no_internet_connection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get error_no_internet_connection_desc =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';

  @override
  String get error_connection_timeout => 'انتهت مهلة الاتصال بالسيرفر';

  @override
  String get error_connection_timeout_desc =>
      'استغرق الاتصال وقتاً طويلاً. يرجى المحاولة مرة أخرى';

  @override
  String get error_receive_timeout => 'انتهت مهلة استلام الرد من السيرفر';

  @override
  String get error_receive_timeout_desc =>
      'استغرق الخادم وقتاً طويلاً للرد. يرجى المحاولة مرة أخرى';

  @override
  String get error_send_timeout => 'انتهت مهلة إرسال الطلب للسيرفر';

  @override
  String get error_send_timeout_desc =>
      'فشل في إرسال البيانات إلى الخادم. يرجى المحاولة مرة أخرى';

  @override
  String get error_server_error => 'خطأ في الخادم';

  @override
  String get error_server_error_desc =>
      'حدث خطأ في الخادم. يرجى المحاولة لاحقاً';

  @override
  String get error_internal_server_error => 'خطأ داخلي في الخادم';

  @override
  String get error_internal_server_error_desc =>
      'واجه الخادم خطأ داخلي. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_gateway => 'بوابة سيئة';

  @override
  String get error_bad_gateway_desc =>
      'تلقى الخادم استجابة غير صالحة. يرجى المحاولة لاحقاً';

  @override
  String get error_service_unavailable => 'الخدمة غير متاحة';

  @override
  String get error_service_unavailable_desc =>
      'الخدمة غير متاحة مؤقتاً. يرجى المحاولة لاحقاً';

  @override
  String get error_gateway_timeout => 'انتهت مهلة البوابة';

  @override
  String get error_gateway_timeout_desc =>
      'انتهت مهلة البوابة. يرجى المحاولة لاحقاً';

  @override
  String get error_bad_request => 'الطلب غير صحيح';

  @override
  String get properties_empty_message_favourite =>
      'You have not added any properties to your favorites.';

  @override
  String get error_bad_request_desc =>
      'يحتوي الطلب على بيانات غير صالحة. يرجى التحقق من المدخلات';

  @override
  String get error_unauthorized => 'غير مصرح، سجّل دخولك من جديد';

  @override
  String get error_unauthorized_desc =>
      'أنت غير مصرح للوصول إلى هذا المورد. يرجى تسجيل الدخول مرة أخرى';

  @override
  String get error_forbidden => 'ما عندك صلاحية';

  @override
  String get error_forbidden_desc => 'ليس لديك إذن للوصول إلى هذا المورد';

  @override
  String get error_not_found => 'المورد غير موجود';

  @override
  String get error_not_found_desc => 'المورد المطلوب غير موجود';

  @override
  String get error_method_not_allowed => 'الطريقة غير مسموحة';

  @override
  String get error_method_not_allowed_desc =>
      'هذه الطريقة غير مسموحة لهذا المورد';

  @override
  String get error_not_acceptable => 'غير مقبول';

  @override
  String get error_not_acceptable_desc => 'الطلب غير مقبول';

  @override
  String get error_request_timeout => 'انتهت مهلة الطلب';

  @override
  String get error_request_timeout_desc =>
      'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى';

  @override
  String get error_conflict => 'صار تعارض في البيانات';

  @override
  String get error_conflict_desc => 'يوجد تعارض مع الحالة الحالية للمورد';

  @override
  String get error_gone => 'المورد غير متاح';

  @override
  String get error_gone_desc => 'المورد المطلوب لم يعد متاحاً';

  @override
  String get error_length_required => 'الطول مطلوب';

  @override
  String get error_length_required_desc => 'يجب أن يحدد الطلب طول المحتوى';

  @override
  String get error_precondition_failed => 'فشل الشرط المسبق';

  @override
  String get error_precondition_failed_desc => 'فشل شرط مسبق واحد أو أكثر';

  @override
  String get error_payload_too_large => 'الحمولة كبيرة جداً';

  @override
  String get error_payload_too_large_desc => 'حمولة الطلب كبيرة جداً';

  @override
  String get error_uri_too_long => 'الرابط طويل جداً';

  @override
  String get error_uri_too_long_desc => 'رابط الطلب طويل جداً';

  @override
  String get lead_send_error => 'حدث خطأ أثناء إرسال طلب التواصل';

  @override
  String get lead_info_collected => 'تم جمع معلومات العميل المحتمل بنجاح';

  @override
  String get lead_offline_mode => 'تم حفظ معلومات التواصل محلياً';

  @override
  String get error_unsupported_media_type => 'نوع الوسائط غير مدعوم';

  @override
  String get error_unsupported_media_type_desc => 'نوع الوسائط غير مدعوم';

  @override
  String get error_range_not_satisfiable => 'النطاق غير قابل للتحقيق';

  @override
  String get error_range_not_satisfiable_desc => 'لا يمكن تحقيق النطاق المطلوب';

  @override
  String get error_expectation_failed => 'فشل التوقع';

  @override
  String get error_expectation_failed_desc =>
      'لا يمكن تلبية التوقع المحدد في حقل رأس الطلب';

  @override
  String get error_too_many_requests => 'طلبات كثيرة جداً';

  @override
  String get error_too_many_requests_desc =>
      'لقد أرسلت طلبات كثيرة جداً. يرجى المحاولة لاحقاً';

  @override
  String get error_unknown => 'صار خطأ غير متوقع';

  @override
  String get error_unknown_desc => 'حدث خطأ غير معروف. يرجى المحاولة مرة أخرى';

  @override
  String get error_cancelled => 'تم إلغاء الطلب';

  @override
  String get error_cancelled_desc => 'تم إلغاء الطلب';

  @override
  String get error_other => 'حدث خطأ';

  @override
  String get error_other_desc => 'حدث خطأ. يرجى المحاولة مرة أخرى';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get contact_support => 'تواصل مع الدعم';

  @override
  String get go_back => 'العودة';

  @override
  String get refresh => 'تحديث';

  @override
  String get check_connection => 'فحص الاتصال';

  @override
  String get login => 'تسجيل دخول';

  @override
  String get name_is_required => 'الاسم مطلوب!';

  @override
  String get name_is_not_valid => 'الاسم مو صحيح';

  @override
  String get email_is_required => 'الإيميل مطلوب!';

  @override
  String get email_is_not_valid => 'الإيميل مو صحيح';

  @override
  String get password_is_required => 'كلمة المرور مطلوبة!';

  @override
  String get password_is_not_valid => 'كلمة المرور مو صحيحة';

  @override
  String get password_must_be_at_least_6_characters =>
      'كلمة المرور لازم تكون 6 أحرف على الأقل';

  @override
  String get passwords_do_not_match => 'كلمات المرور مو نفس الشي';

  @override
  String get confirm_password_is_required => 'تأكيد كلمة المرور مطلوب!';

  @override
  String get confirm_password_is_not_valid => 'تأكيد كلمة المرور مو صحيح';

  @override
  String get password_and_confirm_password_must_be_same =>
      'كلمة المرور وتأكيدها لازم يكونون نفس الشي';

  @override
  String get phone_number_is_required => 'رقم الجوال مطلوب!';

  @override
  String get phone_number_is_not_valid => 'رقم الجوال مو صحيح';

  @override
  String get this_field_is_required => 'هذا الحقل مطلوب';

  @override
  String get error => 'صار خطأ';

  @override
  String get start_button => 'ابدأ الحين';

  @override
  String get location_service_disabled => 'خدمة الموقع مقفلة';

  @override
  String get location_permission_denied => 'تم رفض إذن الموقع';

  @override
  String get location_permission_denied_forever => 'تم رفض إذن الموقع نهائيًا';

  @override
  String get location_service_disabled_message =>
      'خدمة الموقع غير مفعلة. يرجى تفعيل خدمة الموقع من الإعدادات ثم المحاولة مرة أخرى.';

  @override
  String get location_permission_denied_message =>
      'يحتاج التطبيق إلى إذن الوصول للموقع لتحديد موقعك الحالي. يرجى السماح بالوصول للموقع.';

  @override
  String get location_permission_denied_forever_message =>
      'تم رفض إذن الوصول للموقع نهائيًا. يرجى الذهاب إلى إعدادات التطبيق وتفعيل إذن الموقع.';

  @override
  String get location_search_temporarily_unavailable =>
      'البحث غير متاح مؤقتًا، يرجى المحاولة لاحقًا.';

  @override
  String get location_rate_limit_retry =>
      'يرجى الانتظار قليلًا قبل المحاولة مرة أخرى.';

  @override
  String get location_start_title => 'الموقع';

  @override
  String get location_start_subtitle =>
      'حدد موقعك لنتمكن من توصيل طلباتك بسرعة ودقة';

  @override
  String location_start_selected_subtitle(String address) {
    return 'تم اختيار الموقع: $address';
  }

  @override
  String get location_select_on_map => 'اختيار الموقع من الخريطة';

  @override
  String get location_use_current_location => 'استخدام موقعي الحالي';

  @override
  String get location_enter_address_manually => 'أدخل العنوان يدويًا';

  @override
  String get location_map_search_hint => 'ابحث عن موقع...';

  @override
  String get location_map_drag_hint => 'حرّك الخريطة لاختيار الموقع';

  @override
  String get location_map_confirm => 'تأكيد الموقع';

  @override
  String get auth_title => 'ابدأ معنا الحين';

  @override
  String get auth_subtitle_login => 'هلا فيك! سجّل دخولك';

  @override
  String get auth_subtitle_signup => 'سو حساب جديد وابدأ';

  @override
  String get login_hero_badge => 'مرحبا بعودتك';

  @override
  String get login_hero_title => 'تسجيل الدخول';

  @override
  String get login_hero_subtitle => 'سجل الدخول للمتابعة واستعراض المنتجات';

  @override
  String get login_section_badge => 'عضو';

  @override
  String get login_section_title => 'تسجيل دخول';

  @override
  String get login_section_description =>
      'أدخل بريدك الإلكتروني أو رقم الجوال وكلمة المرور للوصول إلى حسابك.';

  @override
  String get register_hero_badge => 'ابدأ التسوق';

  @override
  String get register_screen_title => 'إنشاء حساب';

  @override
  String get register_hero_subtitle =>
      'أنشئ حسابك بخطوات بسيطة وابدأ التسوق بسهولة.';

  @override
  String get register_section_badge => 'حساب جديد';

  @override
  String get register_form_title => 'سجّل حساب جديد';

  @override
  String get register_form_description => 'أدخل بياناتك الأساسية للبدء.';

  @override
  String get toggle_login => 'تسجيل دخول';

  @override
  String get toggle_signup => 'تسجيل جديد';

  @override
  String get label_full_name => 'الاسم الكامل';

  @override
  String get label_email => 'الإيميل';

  @override
  String get label_phone => 'رقم الجوال';

  @override
  String get label_password => 'كلمة المرور';

  @override
  String get hint_full_name => 'محمد أحمد';

  @override
  String get hint_email => 'example@gmail.com';

  @override
  String get hint_email_or_phone => 'example@email.com أو 5xxxxxxxx';

  @override
  String get label_email_or_phone => 'إيميل أو رقم الجوال';

  @override
  String get hint_phone => '05xxxxxxxx';

  @override
  String get hint_password => '********';

  @override
  String get btn_login => 'تسجيل دخول';

  @override
  String get btn_signup => 'انشاء حساب';

  @override
  String get btn_forgot_password => 'نسيت كلمة المرور؟';

  @override
  String get forget_password_title => 'نسيت كلمة المرور';

  @override
  String get forget_password_description =>
      'اكتب رقم جوالك أو إيميلك وبنرسل لك كود';

  @override
  String get forget_password_hero_badge => 'استعادة الوصول';

  @override
  String get forget_password_hero_subtitle =>
      'سنساعدك على استعادة الوصول بسرعة حتى تتمكن من متابعة استخدام حسابك بسهولة.';

  @override
  String get forget_password_section_badge => 'استعادة';

  @override
  String get btn_send_verification_code => 'إرسال الكود';

  @override
  String get msg_verification_code_sent => 'تم إرسال الكود';

  @override
  String get reset_password_title => 'تغيير كلمة المرور';

  @override
  String get reset_password_description_prefix => 'أدخل الكود اللي انرسل لـ';

  @override
  String get reset_password_otp_hero_badge => 'تأكيد الرمز';

  @override
  String get reset_password_otp_hero_subtitle =>
      'أدخل الرمز الذي أرسلناه لك حتى تتمكن من متابعة تعيين كلمة مرور جديدة بأمان.';

  @override
  String get reset_password_otp_section_badge => 'رمز التحقق';

  @override
  String get reset_password_hero_badge => 'تأمين الحساب';

  @override
  String get reset_password_hero_subtitle =>
      'اختر كلمة مرور أقوى وحافظ على أمان حسابك في كل مرة تسجل فيها الدخول.';

  @override
  String get reset_password_section_badge => 'أمان';

  @override
  String get label_verification_code => 'كود التحقق';

  @override
  String get hint_verification_code => 'اكتب الكود';

  @override
  String get label_new_password => 'كلمة مرور جديدة';

  @override
  String get hint_new_password => 'اكتب كلمة المرور الجديدة';

  @override
  String get btn_confirm => 'تاكيد';

  @override
  String get msg_password_reset_success => 'تم تغيير كلمة المرور';

  @override
  String get verification_code_required => 'اكتب كود التحقق';

  @override
  String get verification_code_invalid => 'الكود غلط';

  @override
  String get otp_description => 'اكتب الكود اللي انرسل لك';

  @override
  String get otp_code_sent_to => 'انرسل الكود لـ';

  @override
  String get otp_verify_button => 'تحقق';

  @override
  String get otp_complete_code_required => 'اكتب الكود كامل';

  @override
  String get otp_success_message => 'تم تفعيل الحساب';

  @override
  String get otp_hero_badge => 'تأكيد الحساب';

  @override
  String get otp_hero_subtitle => 'أدخل الرمز المرسل إليك لإكمال تفعيل الحساب.';

  @override
  String get otp_section_badge => 'تحقق';

  @override
  String get otp_screen_title => 'كود التحقق';

  @override
  String get otp_screen_subtitle => 'اكتب الكود عشان تأكد حسابك';

  @override
  String get social_divider => 'أو كمّل باستخدام';

  @override
  String get btn_login_google => 'جوجل';

  @override
  String get btn_login_apple => 'أبل';

  @override
  String get footer_have_account => 'عندك حساب؟ ';

  @override
  String get footer_no_account => 'ما عندك حساب؟ ';

  @override
  String get footer_action_login => 'دخول';

  @override
  String get footer_action_signup => 'تسجيل';

  @override
  String get deliver_to => 'التوصيل إلى';

  @override
  String get location => 'السعوديه';

  @override
  String get search_hint => 'ابحث عن منتجات أو متاجر...';

  @override
  String get search_marketplace_title => 'البحث في التسوق';

  @override
  String get search_start_title => 'ابدأ البحث';

  @override
  String get search_start_description =>
      'اكتب اسم المنتج وسيتم تحميل النتائج تدريجيًا مع التصفح.';

  @override
  String get search_empty_title => 'لا توجد نتائج';

  @override
  String get search_empty_description =>
      'جرّب كلمة بحث مختلفة أو وسّع نطاق البحث.';

  @override
  String search_in_brand_products(String brandName) {
    return 'ابحث في منتجات $brandName';
  }

  @override
  String get home_search_hint_dairy => '🧀 ابحث عن منتجات الألبان...';

  @override
  String get home_search_hint_vegetables => '🥬 ابحث عن الخضروات الطازجة...';

  @override
  String get home_search_hint_fruits => '🍎 ابحث عن الفواكه الموسمية...';

  @override
  String get home_search_hint_meat => '🍗 ابحث عن اللحوم والدواجن...';

  @override
  String get home_search_hint_drinks => '☕ ابحث عن المشروبات والقهوة...';

  @override
  String get home_search_hint_bakery => '🥐 ابحث عن المخبوزات والحلويات...';

  @override
  String get home_search_hint_spices => '🌶️ ابحث عن التوابل والبقوليات...';

  @override
  String get home_search_hint_cleaning => '🧴 ابحث عن المنظفات المنزلية...';

  @override
  String get home_search_hint_oils => '🫒 ابحث عن الزيوت والسمن...';

  @override
  String get home_search_hint_nuts => '🥜 ابحث عن المكسرات والياميش...';

  @override
  String get home_search_hint_canned =>
      '🥫 ابحث عن المعلبات والوجبات السريعة...';

  @override
  String get home_search_hint_baby => '🍼 ابحث عن أغذية الأطفال...';

  @override
  String get banner_tag => 'عرض محدود';

  @override
  String get banner_title => 'خضار طازجة\nخصم يوصل 40%';

  @override
  String get banner_subtitle => 'تسوّق صحي كل يوم';

  @override
  String get banner_action => 'تسوّق الحين';

  @override
  String get section_special_offers => 'عروض';

  @override
  String get special_offers_unavailable => 'لا توجد عروض خاصة متاحه';

  @override
  String get section_best_selling => 'الأكثر مبيع';

  @override
  String get best_selling_unavailable => 'لا توجد منتجات الاكثر مبيعا متاحه';

  @override
  String get section_brands => 'العلامات التجارية';

  @override
  String get brands_unavailable => 'لا توجد علامات تجارية متاحه';

  @override
  String get brands_empty_description =>
      'لا توجد علامات تجارية متاحة حاليًا. اسحب للتحديث أو جرّب مرة أخرى بعد قليل.';

  @override
  String get brands_listing_subtitle =>
      'تصفّح العلامات التجارية المتاحة واختر ما يناسبك بسهولة.';

  @override
  String brands_count_badge(int count) {
    return '$count علامة';
  }

  @override
  String get section_featured => 'مميزة';

  @override
  String get featured_unavailable => 'لا توجد منتجات مميزة متاحه';

  @override
  String get section_recommended => 'مقترح لك';

  @override
  String get recommended_unavailable => 'لا توجد منتجات مقترحة متاحه';

  @override
  String get section_explore => 'استكشف أكثر';

  @override
  String get explore_more_unavailable => 'لا توجد منتجات استكشاف متاحه';

  @override
  String get see_all => 'عرض الكل';

  @override
  String get add_to_cart => 'أضف للسلة';

  @override
  String get nav_home => 'الرئيسية';

  @override
  String get nav_categories => 'الأقسام';

  @override
  String get categ => 'الأقسام';

  @override
  String get nav_cart => 'السلة';

  @override
  String get nav_orders => 'طلباتي';

  @override
  String get nav_profile => 'حسابي';

  @override
  String get start_page_title => 'اطلب كل اللي تحتاجه بسهولة';

  @override
  String get start_page_subtitle => 'توصيل سريع لكل احتياجاتك';

  @override
  String get start_page_button => 'ابدأ الحين';

  @override
  String get profile_title => 'حسابي';

  @override
  String get edit_avatar => 'تعديل الصورة';

  @override
  String get personal_info => 'معلوماتي';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'رقم الجوال';

  @override
  String get date_of_birth => 'تاريخ الميلاد';

  @override
  String get gender => 'الجنس';

  @override
  String get addresses => 'العناوين';

  @override
  String get add_address => 'أضف عنوان';

  @override
  String get change_address => 'تغيير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notifications_empty_title => 'لا توجد إشعارات';

  @override
  String brand_product_count(int count) {
    return '$count منتج';
  }

  @override
  String get dark_mode => 'الوضع الليلي';

  @override
  String get account => 'الحساب';

  @override
  String get change_password => 'تغيير كلمة المرور';

  @override
  String get help_support => 'الدعم والمساعدة';

  @override
  String get help_support_header_title => 'كيف يمكننا مساعدتك؟';

  @override
  String get help_support_header_subtitle =>
      'تواصل معنا وسنرد على استفسارك قريبًا.';

  @override
  String get about_app => 'عن التطبيق';

  @override
  String get developer => 'المطور';

  @override
  String get version => 'الإصدار';

  @override
  String get contact_us => 'تواصل معنا';

  @override
  String get contact_whatsapp => 'واتساب';

  @override
  String get contact_whatsapp_subtitle => 'تواصل معنا عبر واتساب';

  @override
  String get contact_phone_subtitle => 'اتصل بنا مباشرة';

  @override
  String get select_language => 'اختر اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get about_app_title => 'عن التطبيق';

  @override
  String get app_name => 'تطبيق زدانا للتسوّق';

  @override
  String get version_label => 'الإصدار';

  @override
  String get release_date => 'تاريخ الإصدار';

  @override
  String get app_description =>
      'منصة زادانا للتسوق متعدد البائعين تعيد تعريف تجربة التسوق الخاصة بك. آلاف البائعين، مئات الآلاف من المنتجات، وفئات لا حصر لها… كل ما تحتاجه هو مجرد نقرة واحدة.\n\nمع شبكتنا الواسعة من البائعين، من الأعمال المحلية إلى العلامات التجارية العالمية، نقدم لمستخدمينا أوسع مجموعة من المنتجات، مع توفير تجربة تسوق سلسة من خلال بنية تحتية آمنة للدفع وخيارات شحن سريعة.\n\nفي زادانا، لا تشتري المنتجات فقط؛ بل تكتشف، وتقارن، وتجد أفضل الأسعار، وتربح مع العروض الحصرية. سواء كنت مهتمًا بالموضة، أو الإلكترونيات، أو المنزل والحياة، زادانا دائمًا معك.\n\nوجهتك الجديدة للتسوق: زادانا';

  @override
  String get ok => 'تمام';

  @override
  String get login_success => 'تم تسجيل الدخول';

  @override
  String get register_success => 'تم إنشاء الحساب، فعّل الإيميل';

  @override
  String get legal => 'القوانين';

  @override
  String get terms_conditions => 'الشروط والأحكام';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get faq_track_order_question => 'كيف يمكنني تتبع طلبي؟';

  @override
  String get faq_track_order_answer =>
      'يمكنك تتبع طلبك من صفحة طلباتي، ثم فتح الطلب الذي تريد متابعة حالته.';

  @override
  String get faq_payment_methods_question => 'ما هي طرق الدفع المتاحة؟';

  @override
  String get faq_payment_methods_answer =>
      'ندعم بطاقات الدفع المختلفة والمحافظ الإلكترونية والدفع عند الاستلام حسب المتاح.';

  @override
  String get faq_return_product_question => 'كيف يمكنني إرجاع منتج؟';

  @override
  String get faq_return_product_answer =>
      'يمكنك طلب الإرجاع من صفحة تفاصيل الطلب خلال فترة الإرجاع المسموح بها.';

  @override
  String get faq_contact_support_question => 'كيف أتواصل مع الدعم؟';

  @override
  String get faq_contact_support_answer =>
      'يمكنك التواصل معنا من خلال صفحة الدعم والمساعدة أو عبر وسائل التواصل المتاحة داخل التطبيق.';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String get logout_confirm => 'متأكد تبغى تسجل خروج؟';

  @override
  String get cart_title => 'سلتي';

  @override
  String cart_items_count(Object count) {
    return '$count منتجات';
  }

  @override
  String get current_vendor => 'المتجر الحالي';

  @override
  String get change_vendor => 'تغيير المتجر';

  @override
  String get vendor_change_warning =>
      'تغيير المتجر بيأثر على السلة، تبغى تكمل؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get promo_code => 'كود خصم';

  @override
  String get apply => 'تطبيق';

  @override
  String get subtotal => 'المجموع';

  @override
  String get shipping => 'الشحن';

  @override
  String get discount => 'الخصم';

  @override
  String get total => 'الإجمالي';

  @override
  String get checkout => 'إتمام الطلب';

  @override
  String get cart_empty => 'السلة فارغة';

  @override
  String get cart_empty_description => 'لا توجد منتجات في سلة التسوق';

  @override
  String get cart_empty_message => 'ابدأ تسوق وحط منتجات';

  @override
  String get shop_now => 'تسوّق الحين';

  @override
  String get delete_item => 'حذف المنتج';

  @override
  String get delete_item_confirm => 'تبغى تحذف المنتج؟';

  @override
  String get available_vendors => 'المتاجر';

  @override
  String get sar => 'ر.س';

  @override
  String get free => 'مجاني';

  @override
  String get quantity => 'الكمية';

  @override
  String get error_bad_certificate => 'شهادة الأمان غير صالحة';

  @override
  String get error_request_cancelled => 'تم إلغاء الطلب';

  @override
  String get error_no_internet => 'ما فيه إنترنت';

  @override
  String get offline_connection_issue_title => 'مشكله ف الاتصال';

  @override
  String get offline_connection_issue_message =>
      'تحقق من الانترنت وحاول مره اخري';

  @override
  String get error_no_response => 'ما وصل رد من السيرفر';

  @override
  String get error_validation => 'البيانات المدخلة غير صحيحة';

  @override
  String get error_server => 'خطأ بالسيرفر';

  @override
  String get locationServicesDisabled => 'خدمات الموقع مقفلة';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الموقع';

  @override
  String get locationPermissionDeniedForever => 'تم رفض إذن الموقع نهائيًا';

  @override
  String get unknownError => 'صار شيء غلط';

  @override
  String get product_details => 'تفاصيل المنتج';

  @override
  String get product_description => 'وصف المنتج';

  @override
  String get product_description_text => 'منتج ممتاز وجودته عالية.';

  @override
  String get quantity_label => 'الكمية:';

  @override
  String get add_to_cart_button => 'أضف للسلة';

  @override
  String get added_to_favorites => 'انضاف للمفضلة';

  @override
  String get removed_from_favorites => 'انحذف من المفضلة';

  @override
  String product_added_to_cart(Object quantity, Object name) {
    return 'تم إضافة $quantity من $name';
  }

  @override
  String get egp => 'ج.م';

  @override
  String get buy_now => 'اشتر الحين';

  @override
  String get store_price_comparison => 'مقارنة أسعار المتاجر';

  @override
  String get fresh_products => 'منتجات طازجة';

  @override
  String get nutrition_info => 'المعلومات الغذائية';

  @override
  String get high_fiber => 'غني بالألياف';

  @override
  String get high_protein => 'غني بالبروتين';

  @override
  String get natural_100 => 'طبيعي 100%';

  @override
  String get available => 'متوفر';

  @override
  String get not_available => 'غير متوفر';

  @override
  String get redirecting_to_checkout => 'جاري تحويلك لإتمام الطلب...';

  @override
  String get cart => 'سلة التسوق';

  @override
  String get product => 'منتج';

  @override
  String get clear_all => 'حذف الكل';

  @override
  String get delete_item_confirmation => 'حذف';

  @override
  String get delete => 'حذف';

  @override
  String get no => 'لا';

  @override
  String get clear_cart => 'تفريغ السلة';

  @override
  String get clear_cart_confirmation => 'متأكد تبغى تحذف كل المنتجات من السلة؟';

  @override
  String get start_shopping => 'ابدأ التسوق';

  @override
  String get start_shopping_message => 'ابدأ التسوق وأضف منتجات للسلة';

  @override
  String get item => 'منتج';

  @override
  String get complete_from => 'كمّل من';

  @override
  String get compare => 'قارن';

  @override
  String get select_vendor_to_show_price => 'اختر المتجر لعرض السعر';

  @override
  String get comparison_results => 'نتائج المقارنة';

  @override
  String get save_amount => 'وفّر';

  @override
  String get if_buy_from => 'إذا شريت من';

  @override
  String get cheapest => 'الأرخص';

  @override
  String get more_expensive_by => 'أغلى بـ';

  @override
  String get currently_selected => 'المحدد حاليًا';

  @override
  String get select_one_more_vendor => 'اختر متجر إضافي على الأقل';

  @override
  String get compare_prices => 'قارن الأسعار';

  @override
  String get select_cheapest => 'اختيار';

  @override
  String get select_vendors_to_compare => 'اختر المتاجر للمقارنة';

  @override
  String get select_2_to_3_vendors => 'اختر من متجرين إلى 3 متاجر للمقارنة';

  @override
  String get category_vegetables => 'الخضار';

  @override
  String get category_fruits => 'الفواكه';

  @override
  String get category_meat => 'اللحوم';

  @override
  String get category_poultry => 'الدواجن';

  @override
  String get category_dairy => 'الألبان';

  @override
  String get category_bakery => 'المخبوزات';

  @override
  String get category_beverages => 'المشروبات';

  @override
  String get category_household => 'المنزل';

  @override
  String get category_personal_care => 'العناية الشخصية';

  @override
  String get category_snacks => 'الوجبات الخفيفة';

  @override
  String get sort_newest => 'الأحدث';

  @override
  String get sort_newest_desc => 'المنتجات المضافة مؤخرًا';

  @override
  String get sort_price_low => 'السعر من الأقل للأعلى';

  @override
  String get sort_price_low_desc => 'من الأرخص إلى الأغلى';

  @override
  String get sort_price_high => 'السعر من الأعلى للأقل';

  @override
  String get sort_price_high_desc => 'من الأغلى إلى الأرخص';

  @override
  String get sort_best_selling => 'الأكثر مبيعًا';

  @override
  String get sort_best_selling_desc => 'المنتجات الأكثر شراءً';

  @override
  String get sort_highest_rated => 'الأعلى تقييمًا';

  @override
  String get sort_highest_rated_desc => 'بناءً على تقييم العملاء';

  @override
  String get sort_alphabetical => 'أبجدي';

  @override
  String get sort_alphabetical_desc => 'من أ إلى ي';

  @override
  String get filter_title => 'فلترة المنتجات';

  @override
  String get sort_title => 'ترتيب المنتجات';

  @override
  String get search_hint_category => 'ابحث عن خضار، فواكه، لحوم...';

  @override
  String get filter_button => 'تصنيف';

  @override
  String get sort_button => 'ترتيب';

  @override
  String get all_categories => 'الكل';

  @override
  String get select_product_type => 'اختر نوع المنتج';

  @override
  String get category => 'التصنيف';

  @override
  String get price_range => 'نطاق السعر';

  @override
  String get brand_filter_category_title => 'الفئة';

  @override
  String get brand_filter_type_title => 'النوع';

  @override
  String get brand_filter_unit_title => 'الكمية';

  @override
  String get brand_filter_accessories => 'الإكسسوارات';

  @override
  String get brand_filter_chargers => 'الشواحن';

  @override
  String get brand_filter_phone_cases => 'أغطية الهاتف';

  @override
  String get brand_filter_cables => 'الكابلات';

  @override
  String get brand_filter_adapters => 'المحوّلات';

  @override
  String get brand_filter_headphones => 'سماعات الرأس';

  @override
  String get brand_filter_speakers => 'السماعات';

  @override
  String get brand_filter_power_banks => 'الباور بانك';

  @override
  String get brand_filter_screen_protectors => 'حمايات الشاشة';

  @override
  String get currency => 'ريال';

  @override
  String get filter_type => 'النوع';

  @override
  String get filter_part => 'الجزء';

  @override
  String get filter_brand => 'البراند';

  @override
  String get filter_category_title => 'التصنيف';

  @override
  String get filter_subcategory_title => 'التصنيف الفرعي';

  @override
  String get filter_apply => 'تطبيق تصنيف';

  @override
  String get show_more => 'عرض المزيد';

  @override
  String get show_less => 'عرض أقل';

  @override
  String get favorites => 'المفضلة';

  @override
  String get favorites_empty => 'المفضلة فارغة';

  @override
  String get favorites_empty_message => 'لا توجد منتجات في قائمة المفضلة';

  @override
  String get clear_favorites => 'حذف كل المفضلة';

  @override
  String get clear_favorites_confirmation =>
      'متأكد تبغى تحذف كل المنتجات من المفضلة؟';

  @override
  String get invoice_details => 'تفاصيل الطلب';

  @override
  String get processing => 'جاري التنفيذ...';

  @override
  String get order_success => 'تم الطلب!';

  @override
  String get order_number => 'رقم الطلب';

  @override
  String get payment_successful => 'تم الدفع!';

  @override
  String get payment_success_message => 'طلبك وصلنا وبيوصلك قريب';

  @override
  String get estimated_delivery => 'وقت التوصيل';

  @override
  String get minutes => 'دقائق';

  @override
  String get track_order => 'تتبع الطلب';

  @override
  String get back_to_home => 'رجوع للرئيسية';

  @override
  String get my_orders_title => 'طلباتي';

  @override
  String get my_orders_subtitle => 'تابع طلباتك بسهولة';

  @override
  String get active_orders_tab => 'الحالية';

  @override
  String get completed_orders_tab => 'السابقة';

  @override
  String get returned_orders_tab => 'المرتجعات';

  @override
  String get order_returning => 'قيد الإرجاع';

  @override
  String get no_active_orders => 'ما عندك طلبات حالية';

  @override
  String get no_previous_orders => 'لا يوجد طلبات سابقة';

  @override
  String get no_returning_orders => 'لا يوجد طلبات قيد الارجاع';

  @override
  String get my_orders_order_date => 'تاريخ الطلب';

  @override
  String get my_orders_created_at => 'تم الإنشاء بتاريخ';

  @override
  String get my_orders_items => 'المنتجات';

  @override
  String get my_orders_items_count => 'عدد المنتجات';

  @override
  String get my_orders_piece_count => 'عدد القطع';

  @override
  String get my_orders_unit_price => 'سعر القطعة';

  @override
  String my_orders_quantity_badge(int quantity) {
    return '$quantity x';
  }

  @override
  String get my_orders_view_details => 'عرض التفاصيل';

  @override
  String get my_orders_cancel_order => 'إلغاء الطلب';

  @override
  String get my_orders_reorder => 'إعادة الطلب';

  @override
  String get my_orders_rate_order => 'قيّم الطلب';

  @override
  String get my_orders_reorder_button => 'إعادة الطلب';

  @override
  String get my_orders_return_request => 'طلب إرجاع';

  @override
  String get my_orders_follow_up => 'متابعة';

  @override
  String get my_orders_submit_complaint => 'تقديم شكوى';

  @override
  String get my_orders_details_title => 'تفاصيل الطلب';

  @override
  String get my_orders_order_summary_title => 'ملخص الطلب';

  @override
  String get my_orders_delivery_otp_title => 'رمز التسليم';

  @override
  String get my_orders_view_otp => 'عرض رمز OTP';

  @override
  String get my_orders_complaint_status_title => 'حالة الشكوى';

  @override
  String get my_orders_cancel_sheet_title => 'إلغاء الطلب';

  @override
  String get my_orders_cancel_sheet_subtitle =>
      'يرجى اختيار سبب الإلغاء قبل تأكيد الطلب';

  @override
  String get my_orders_cancel_sheet_reason_label => 'سبب الإلغاء';

  @override
  String get my_orders_cancel_sheet_note_hint =>
      'اكتب ملاحظة إضافية (اختياري)...';

  @override
  String get my_orders_cancel_sheet_back => 'تراجع';

  @override
  String get my_orders_cancel_sheet_confirm => 'تأكيد الإلغاء';

  @override
  String get my_orders_cancel_reason_delay => 'تأخر في تجهيز الطلب';

  @override
  String get my_orders_cancel_reason_changed_mind => 'غيرت رأيي';

  @override
  String get my_orders_cancel_reason_modify_order => 'أريد تعديل الطلب';

  @override
  String get my_orders_cancel_reason_ordered_by_mistake => 'طلبت بالخطأ';

  @override
  String get my_orders_cancel_reason_price_not_suitable => 'السعر غير مناسب';

  @override
  String get my_orders_cancel_reason_other => 'أخرى';

  @override
  String get my_orders_complaint_sheet_title => 'تقديم شكوى';

  @override
  String get my_orders_complaint_sheet_subtitle =>
      'اكتب تفاصيل المشكلة وأرفق صورًا إن لزم';

  @override
  String get my_orders_complaint_sheet_hint => 'اكتب تفاصيل الشكوى';

  @override
  String get my_orders_complaint_sheet_attach_images => 'إرفاق صور';

  @override
  String my_orders_complaint_sheet_attached_images(int count) {
    return 'تم إرفاق $count صورة';
  }

  @override
  String get my_orders_complaint_sheet_send => 'إرسال';

  @override
  String my_orders_cancelled_feedback(String reason) {
    return 'تم إلغاء الطلب: $reason';
  }

  @override
  String get my_orders_complaint_submitted_feedback => 'تم تقديم الشكوى';

  @override
  String get my_orders_complaint_received => 'تم استلام الشكوى';

  @override
  String get my_orders_complaint_under_review => 'الشكوى تحت المراجعة';

  @override
  String get my_orders_complaint_resolved => 'تم حل الشكوى';

  @override
  String get order_pending => 'قيد التنفيذ';

  @override
  String get order_shipped => 'انشحن';

  @override
  String get order_delivered => 'تم التوصيل';

  @override
  String get order_cancelled => 'ملغي';

  @override
  String get payment_method => 'طريقة الدفع';

  @override
  String get credit_debit_card => 'بطاقة';

  @override
  String get credit_card_subtitle => 'فيزا، ماستركارد، مدى';

  @override
  String get apple_pay => 'أبل باي';

  @override
  String get apple_pay_subtitle => 'دفع سريع وآمن';

  @override
  String get cash_on_delivery => 'الدفع عند الاستلام';

  @override
  String get cash_on_delivery_subtitle => 'ادفع كاش وقت استلام الطلب';

  @override
  String get bank_transfer => 'تحويل بنكي';

  @override
  String get bank_transfer_subtitle => 'تحويل مباشر من البنك';

  @override
  String get shopping => 'تسوق';

  @override
  String get delivery_otp_title => 'تأكيد التوصيل';

  @override
  String get delivery_otp_subtitle =>
      'أدخل رمز التحقق المرسل إليك لتأكيد التوصيل';

  @override
  String get delivery_otp_sent_to => 'تم إرسال الرمز إلى';

  @override
  String get delivery_otp_verify_button => 'تأكيد التوصيل';

  @override
  String get delivery_otp_resend => 'إعادة إرسال الرمز';

  @override
  String get delivery_otp_resend_success => 'تم إعادة إرسال رمز التحقق';

  @override
  String get delivery_otp_verified => 'تم تأكيد التوصيل';

  @override
  String get delivery_otp_invalid_code => 'رمز التحقق غير صحيح';

  @override
  String get delivery_otp_required => 'الرجاء إدخال رمز التحقق';

  @override
  String get delivery_otp_expired => 'انتهت صلاحية رمز التحقق';

  @override
  String get delivery_otp_attempts_exceeded =>
      'تم تجاوز الحد الأقصى لمحاولات التحقق';

  @override
  String get delivery_otp_remaining_attempts => 'المحاولات المتبقية';

  @override
  String get delivery_otp_timer_prefix => 'إعادة الإرسال خلال';

  @override
  String get delivery_otp_seconds => 'ثانية';

  @override
  String get delivery_rating_delivered_to => 'تم التوصيل إلى';

  @override
  String get delivery_rating_your_feeling => 'كيف شعورك تجاه المندوب؟';

  @override
  String get delivery_rating_your_rating => 'تقييمك';

  @override
  String get delivery_rating_write_comment => 'اكتب عن المندوب (اختياري)';

  @override
  String get delivery_rating_comment_hint =>
      'مثال: سريع جداً وابتسامته جميلة، شكراً...';

  @override
  String get delivery_rating_cancel => 'إلغاء';

  @override
  String get delivery_rating_submit => 'إرسال';

  @override
  String get delivery_code_title => 'رمز التحقق من التوصيل الخاص بك';

  @override
  String get delivery_code_share_instruction =>
      'يرجى مشاركة هذا الرمز مع مندوب التوصيل الخاص بك';

  @override
  String get delivery_code_share_label => 'شارك هذا الرمز';

  @override
  String get delivery_code_shared_button => 'تم مشاركة الرمز';

  @override
  String get delivery_code_generate_new => 'إنشاء رمز جديد';

  @override
  String get order_success_title => 'تم نجاح الطلب';

  @override
  String get order_success_subtitle => 'شكراً لطلبك! سيتم توصيل طلبك قريباً';

  @override
  String get courier_name => 'اسم المندوب';

  @override
  String get delegate_values => 'قيم المندوب';

  @override
  String get continue_shopping => 'مواصلة التسوق';

  @override
  String get view_order_details => 'عرض تفاصيل الطلب';

  @override
  String get delivery_get_otp => 'رمز التحقق';

  @override
  String get delivery_datetime_title => 'تاريخ ووقت التسليم';

  @override
  String get select_date_time => 'حدد التاريخ والوقت';

  @override
  String get select_delivery_time => 'اختر وقت التسليم';

  @override
  String get delivery_time_selected => 'تم تحديد وقت التسليم';

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'غداً';

  @override
  String get delivery_time_note => 'قد يختلف وقت التسليم حسب التوفر';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get delivery_code_section_title => 'رمز التسليم';

  @override
  String get otp_verification_code => 'رمز التحقق OTP';

  @override
  String get otp_show_instruction => 'اضغط لعرض رمز التحقق عند استلام الطلب';

  @override
  String get view_otp_code => 'عرض رمز OTP';

  @override
  String get location_accuracy_dialog_title => 'تفعيل دقة الموقع';

  @override
  String get location_accuracy_dialog_message =>
      'للحصول على موقعك الحالي بدقة أكبر وتسريع التوصيل، سنطلب من الجهاز تفعيل إعدادات الموقع المناسبة.';

  @override
  String get location_accuracy_dialog_hint =>
      'قد تظهر لك نافذة من النظام لتأكيد استخدام الموقع أو تحسين دقته. يمكنك المتابعة أو المحاولة لاحقًا.';

  @override
  String get location_accuracy_dialog_continue => 'متابعة';

  @override
  String get location_accuracy_dialog_not_now => 'ليس الآن';

  @override
  String get home_empty_title => 'لا توجد منتجات أو أقسام متاحة الآن';

  @override
  String get home_empty_description =>
      'لم يصلنا أي محتوى للصفحة الرئيسية حاليًا. اسحب للتحديث أو جرّب مرة أخرى بعد قليل.';

  @override
  String get profile_guest_title => 'أنت تتصفح كزائر';

  @override
  String get profile_guest_subtitle =>
      'سجّل الدخول أو أنشئ حسابًا للوصول إلى الطلبات والمفضلة وبياناتك الشخصية.';

  @override
  String get profile_guest_explore_title => 'متاح لك الآن';

  @override
  String get profile_guest_addresses_subtitle =>
      'يمكنك إضافة عنوان، لكن مزامنة البيانات تحتاج إلى تسجيل الدخول';

  @override
  String get location_building_details_page_title => 'تفاصيل المبنى';

  @override
  String get location_save_address => 'حفظ العنوان';

  @override
  String get location_building_details_heading => 'أدخل تفاصيل المبنى';

  @override
  String get location_building_details_subtitle =>
      'أضف تفاصيل المبنى والشقة لإكمال عنوانك';

  @override
  String get location_address_label_title => 'تسمية العنوان *';

  @override
  String get location_address_label_hint => 'اختر تسمية العنوان';

  @override
  String get location_address_label_required => 'يرجى اختيار تسمية العنوان';

  @override
  String get location_address_label_home => 'المنزل';

  @override
  String get location_address_label_work => 'العمل';

  @override
  String get location_address_label_other => 'أخرى';

  @override
  String get location_building_number_label => 'رقم المبنى *';

  @override
  String get location_building_number_hint => 'مثال: 15';

  @override
  String get location_building_number_required => 'رقم المبنى مطلوب';

  @override
  String get location_floor_number_label => 'رقم الطابق';

  @override
  String get location_floor_number_hint => 'مثال: 3';

  @override
  String get location_apartment_number_label => 'رقم الشقة';

  @override
  String get location_apartment_number_hint => 'مثال: 5';

  @override
  String get location_manual_address_page_title => 'إدخال العنوان يدويًا';

  @override
  String get location_confirm_address => 'تأكيد العنوان';

  @override
  String get location_manual_address_heading => 'أدخل تفاصيل عنوانك';

  @override
  String get location_manual_address_subtitle =>
      'املأ البيانات التالية لإضافة عنوانك الجديد';

  @override
  String get location_edit_address_page_title => 'تعديل العنوان';

  @override
  String get location_update_address => 'تحديث العنوان';

  @override
  String get location_edit_address_heading => 'عدّل تفاصيل عنوانك';

  @override
  String get location_edit_address_subtitle =>
      'حدّث البيانات التالية ثم احفظ التغييرات';

  @override
  String get location_address_details_label => 'العنوان التفصيلي *';

  @override
  String get location_address_details_hint =>
      'مثال: شارع الجمهورية، بجوار مسجد النور';

  @override
  String get location_address_details_required => 'العنوان التفصيلي مطلوب';

  @override
  String get location_city_label => 'المدينة *';

  @override
  String get location_city_hint => 'مثال: القاهرة';

  @override
  String get location_city_required => 'المدينة مطلوبة';

  @override
  String get location_area_label => 'المنطقة *';

  @override
  String get location_area_hint => 'مثال: المعادي';

  @override
  String get location_area_required => 'المنطقة مطلوبة';

  @override
  String addresses_summary_count(Object count) {
    return 'العناوين المحفوظة';
  }

  @override
  String addresses_summary_count_badge(Object count) {
    return '$count';
  }

  @override
  String addresses_summary_default(String label) {
    return 'الافتراضي الحالي: $label';
  }

  @override
  String get addresses_primary_label => 'العنوان الرئيسي';

  @override
  String get addresses_default => 'افتراضي';

  @override
  String get addresses_current => 'العنوان الحالي';

  @override
  String get addresses_set_default => 'اجعله افتراضي';

  @override
  String get addresses_edit => 'تعديل';

  @override
  String get addresses_delete => 'حذف';

  @override
  String get addresses_delete_title => 'حذف العنوان';

  @override
  String addresses_delete_confirm(String label) {
    return 'هل تريد حذف عنوان \"$label\"؟';
  }

  @override
  String get addresses_delete_success => 'تم حذف العنوان بنجاح';

  @override
  String addresses_set_default_success(String label) {
    return 'تم تحديد \"$label\" كعنوان افتراضي';
  }

  @override
  String get addresses_edit_success => 'تم تحديث العنوان بنجاح';

  @override
  String addresses_meta_building(String value) {
    return 'مبنى $value';
  }

  @override
  String addresses_meta_floor(String value) {
    return 'دور $value';
  }

  @override
  String addresses_meta_apartment(String value) {
    return 'شقة $value';
  }

  @override
  String get profile_role_label => 'الدور';

  @override
  String get profile_status_label => 'الحالة';

  @override
  String get profile_status_active => 'نشط';

  @override
  String get profile_edit_subtitle => 'حدّث اسمك ورقمك والبريد الإلكتروني';

  @override
  String get profile_addresses_subtitle =>
      'إدارة عناوين التوصيل والموقع المحفوظ';

  @override
  String get profile_orders_subtitle => 'راجع طلباتك الحالية والسابقة بسهولة';

  @override
  String get profile_language_subtitle => 'إدارة لغة التطبيق';

  @override
  String get profile_notifications_subtitle => 'تحكم في الإشعارات والتنبيهات';

  @override
  String get profile_password_subtitle => 'حدّث كلمة المرور لحماية حسابك';

  @override
  String get profile_help_subtitle => 'تواصل معنا أو اطّلع على المساعدة';

  @override
  String get profile_faq_subtitle => 'أسئلة وإجابات سريعة تساعدك';

  @override
  String get profile_about_subtitle => 'اعرف أكثر عن التطبيق والإصدار الحالي';

  @override
  String get profile_privacy_subtitle => 'الخصوصية والشروط والأحكام';

  @override
  String get profile_logout_subtitle => 'تسجيل الخروج من هذا الجهاز';
}
