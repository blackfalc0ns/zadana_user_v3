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
      'فضلاً تأكد من اتصالك بالإنترنت وحاول مرة ثانية';

  @override
  String get error_connection_timeout => 'انتهت مهلة الاتصال بالسيرفر';

  @override
  String get error_connection_timeout_desc =>
      'الاتصال طول أكثر من المتوقع. حاول مرة ثانية';

  @override
  String get error_receive_timeout => 'انتهت مهلة استلام الرد من السيرفر';

  @override
  String get error_receive_timeout_desc => 'السيرفر طول بالرد. حاول مرة ثانية';

  @override
  String get error_send_timeout => 'انتهت مهلة إرسال الطلب للسيرفر';

  @override
  String get error_send_timeout_desc =>
      'ما قدرنا نرسل البيانات للسيرفر. حاول مرة ثانية';

  @override
  String get error_server_error => 'خطأ في السيرفر';

  @override
  String get error_server_error_desc => 'صار خطأ في السيرفر. حاول لاحقًا';

  @override
  String get error_internal_server_error => 'خطأ داخلي في السيرفر';

  @override
  String get error_internal_server_error_desc =>
      'السيرفر واجه خطأ داخلي. حاول لاحقًا';

  @override
  String get error_bad_gateway => 'حدث خطأ مؤقت';

  @override
  String get error_bad_gateway_desc =>
      'صار خطأ وقت الاتصال بالسيرفر. حاول مرة ثانية';

  @override
  String get error_service_unavailable => 'الخدمة غير متاحة';

  @override
  String get error_service_unavailable_desc =>
      'الخدمة غير متاحة مؤقتًا. حاول لاحقًا';

  @override
  String get error_gateway_timeout => 'انتهت مهلة البوابة';

  @override
  String get error_gateway_timeout_desc => 'انتهت مهلة البوابة. حاول لاحقًا';

  @override
  String get reviewsFor => 'مراجعات ل';

  @override
  String get error_bad_request => 'الطلب غير صحيح';

  @override
  String get properties_empty_message_favourite => 'ما أضفت أي منتجات للمفضلة.';

  @override
  String get error_bad_request_desc =>
      'الطلب فيه بيانات غير صحيحة. فضلاً تأكد من المدخلات';

  @override
  String get error_unauthorized => 'غير مصرح، سجّل دخولك من جديد';

  @override
  String get error_unauthorized_desc =>
      'ما عندك صلاحية للوصول. فضلاً سجّل دخولك من جديد';

  @override
  String get error_forbidden => 'ما عندك صلاحية';

  @override
  String get error_forbidden_desc => 'ما عندك إذن للوصول لهذا المورد';

  @override
  String get error_not_found => 'المورد غير موجود';

  @override
  String get error_not_found_desc => 'المورد المطلوب مو موجود';

  @override
  String get error_method_not_allowed => 'الطريقة غير مسموحة';

  @override
  String get error_method_not_allowed_desc => 'هالطريقة غير مسموحة لهذا المورد';

  @override
  String get error_not_acceptable => 'غير مقبول';

  @override
  String get error_not_acceptable_desc => 'الطلب غير مقبول';

  @override
  String get error_request_timeout => 'انتهت مهلة الطلب';

  @override
  String get error_request_timeout_desc => 'انتهت مهلة الطلب. حاول مرة ثانية';

  @override
  String get error_conflict => 'صار تعارض في البيانات';

  @override
  String get error_conflict_desc => 'فيه تعارض مع الحالة الحالية للمورد';

  @override
  String get error_gone => 'المورد غير متاح';

  @override
  String get error_gone_desc => 'المورد المطلوب ما عاد متاح';

  @override
  String get error_length_required => 'الطول مطلوب';

  @override
  String get error_length_required_desc => 'لازم يحدد الطلب طول المحتوى';

  @override
  String get error_precondition_failed => 'فشل الشرط المسبق';

  @override
  String get error_precondition_failed_desc => 'فشل شرط مسبق واحد أو أكثر';

  @override
  String get error_payload_too_large => 'الحمولة كبيرة جداً';

  @override
  String get error_payload_too_large_desc => 'حجم الطلب كبير مرة';

  @override
  String get error_uri_too_long => 'الرابط طويل جداً';

  @override
  String get error_uri_too_long_desc => 'رابط الطلب طويل مرة';

  @override
  String get lead_send_error => 'صار خطأ وقت إرسال طلب التواصل';

  @override
  String get lead_info_collected => 'جمعنا معلومات العميل المحتمل بنجاح';

  @override
  String get lead_offline_mode => 'حفظنا معلومات التواصل على الجهاز';

  @override
  String get error_unsupported_media_type => 'نوع الوسائط غير مدعوم';

  @override
  String get error_unsupported_media_type_desc => 'نوع الوسائط غير مدعوم';

  @override
  String get error_range_not_satisfiable => 'النطاق غير قابل للتحقيق';

  @override
  String get error_range_not_satisfiable_desc => 'ما نقدر نحقق النطاق المطلوب';

  @override
  String get error_expectation_failed => 'فشل التوقع';

  @override
  String get error_expectation_failed_desc =>
      'ما نقدر نلبي التوقع المحدد في رأس الطلب';

  @override
  String get error_too_many_requests => 'طلبات كثيرة جداً';

  @override
  String get error_too_many_requests_desc =>
      'أرسلت طلبات كثيرة مرة. حاول لاحقًا';

  @override
  String get error_unknown => 'صار خطأ غير متوقع';

  @override
  String get error_unknown_desc => 'صار خطأ غير معروف. حاول مرة ثانية';

  @override
  String get error_cancelled => 'انلغى الطلب';

  @override
  String get error_cancelled_desc => 'انلغى الطلب';

  @override
  String get error_other => 'حدث خطأ';

  @override
  String get error_other_desc => 'صار خطأ. حاول مرة ثانية';

  @override
  String get retry => 'حاول مرة ثانية';

  @override
  String get contact_support => 'كلم الدعم';

  @override
  String get go_back => 'رجوع';

  @override
  String get refresh => 'تحديث';

  @override
  String get check_connection => 'شيّك الاتصال';

  @override
  String get login => 'تسجيل دخول';

  @override
  String get continue_as_guest => 'الدخول كزائر';

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
  String get this_field_is_required => 'هالحقل مطلوب';

  @override
  String get error => 'صار خطأ';

  @override
  String get start_button => 'ابدأ الحين';

  @override
  String get location_service_disabled => 'خدمة الموقع مقفلة';

  @override
  String get location_permission_denied => 'انرفض إذن الموقع';

  @override
  String get location_permission_denied_forever => 'انرفض إذن الموقع نهائيًا';

  @override
  String get location_service_disabled_message =>
      'خدمة الموقع غير مفعلة. فعّلها من الإعدادات ثم حاول مرة ثانية.';

  @override
  String get location_permission_denied_message =>
      'التطبيق يحتاج إذن الموقع عشان يحدد موقعك الحالي. فضلاً اسمح بالوصول للموقع.';

  @override
  String get location_permission_denied_forever_message =>
      'انرفض إذن الوصول للموقع نهائيًا. فضلاً روح لإعدادات التطبيق وفعّل إذن الموقع.';

  @override
  String get location_search_temporarily_unavailable =>
      'البحث غير متاح مؤقتًا، حاول لاحقًا.';

  @override
  String get location_rate_limit_retry => 'انتظر شوي قبل ما تحاول مرة ثانية.';

  @override
  String get location_start_title => 'الموقع';

  @override
  String get location_start_subtitle => 'حدد موقعك عشان نوصل طلباتك بسرعة ودقة';

  @override
  String location_start_selected_subtitle(String address) {
    return 'اخترنا الموقع: $address';
  }

  @override
  String get location_select_on_map => 'اختر الموقع من الخريطة';

  @override
  String get location_use_current_location => 'استخدم موقعي الحالي';

  @override
  String get location_enter_address_manually => 'اكتب العنوان يدويًا';

  @override
  String get location_map_search_hint => 'ابحث عن موقع...';

  @override
  String get location_map_drag_hint => 'حرّك الخريطة عشان تختار الموقع';

  @override
  String get location_map_confirm => 'أكد الموقع';

  @override
  String get auth_title => 'ابدأ معنا الحين';

  @override
  String get auth_subtitle_login => 'هلا فيك! سجّل دخولك';

  @override
  String get auth_subtitle_signup => 'سو حساب جديد وابدأ';

  @override
  String get login_hero_badge => 'هلا برجعتك';

  @override
  String get login_hero_title => 'تسجيل الدخول';

  @override
  String get login_hero_subtitle => 'سجّل دخولك عشان تكمل وتشوف المنتجات';

  @override
  String get login_section_badge => 'عضو';

  @override
  String get login_section_title => 'تسجيل دخول';

  @override
  String get login_section_description =>
      'اكتب إيميلك أو رقم جوالك وكلمة المرور عشان تدخل حسابك.';

  @override
  String get register_hero_badge => 'ابدأ التسوق';

  @override
  String get register_screen_title => 'إنشاء حساب جديد';

  @override
  String get register_hero_subtitle =>
      'سو حسابك بخطوات بسيطة وابدأ التسوق بسهولة.';

  @override
  String get register_section_badge => 'حساب جديد';

  @override
  String get register_form_title => 'سجّل حساب جديد';

  @override
  String get register_form_description => 'اكتب بياناتك الأساسية عشان تبدأ.';

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
  String get label_phone_optional => 'رقم الجوال (اختياري)';

  @override
  String get label_optional_parenthetical => '(اختياري)';

  @override
  String get label_password => 'كلمة المرور';

  @override
  String get hint_full_name => 'محمد أحمد';

  @override
  String get hint_email => 'example@gmail.com';

  @override
  String get hint_email_or_phone => 'example@email.com';

  @override
  String get label_email_or_phone => 'البريد الالكتروني';

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
  String get forget_password_hero_badge => 'استرجاع الدخول';

  @override
  String get forget_password_hero_subtitle =>
      'بنساعدك ترجع لحسابك بسرعة وتكمل استخدامه بسهولة.';

  @override
  String get forget_password_section_badge => 'استعادة';

  @override
  String get btn_send_verification_code => 'إرسال الكود';

  @override
  String get msg_verification_code_sent => 'أرسلنا الكود';

  @override
  String get reset_password_title => 'تغيير كلمة المرور';

  @override
  String get reset_password_description_prefix => 'اكتب الكود اللي انرسل لـ';

  @override
  String get reset_password_otp_hero_badge => 'تأكيد الكود';

  @override
  String get reset_password_otp_hero_subtitle =>
      'اكتب الكود اللي أرسلناه لك عشان تعيّن كلمة مرور جديدة بأمان.';

  @override
  String get reset_password_otp_section_badge => 'كود التحقق';

  @override
  String get reset_password_hero_badge => 'تأمين الحساب';

  @override
  String get reset_password_hero_subtitle =>
      'اختر كلمة مرور أقوى وخلك مطمّن على حسابك كل مرة تسجل دخول.';

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
  String get msg_password_reset_success => 'تغيّرت كلمة المرور';

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
  String get otp_success_message => 'تفعّل الحساب';

  @override
  String get otp_resend_code => 'إعادة إرسال الكود';

  @override
  String get otp_resend_success => 'أرسلنا كود التحقق من جديد';

  @override
  String otp_resend_cooldown(Object seconds) {
    return 'تقدر تعيد الإرسال بعد $seconds ثانية';
  }

  @override
  String get otp_hero_badge => 'تأكيد الحساب';

  @override
  String get otp_hero_subtitle =>
      'اكتب الكود اللي وصلك عشان تكمل تفعيل الحساب.';

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
  String get footer_action_signup => 'تسجيل حساب';

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
      'اكتب اسم المنتج وبنحمّل النتائج تدريجيًا وأنت تتصفح.';

  @override
  String get search_empty_title => 'ما فيه نتائج';

  @override
  String get search_empty_description =>
      'جرّب كلمة بحث ثانية أو وسّع نطاق البحث.';

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
  String get special_offers_unavailable => 'ما فيه عروض خاصة متاحة';

  @override
  String get section_best_selling => 'الأكثر مبيع';

  @override
  String get best_selling_unavailable => 'ما فيه منتجات أكثر مبيعًا متاحة';

  @override
  String get section_brands => 'العلامات التجارية';

  @override
  String get brands_unavailable => 'ما فيه براندات متاحة';

  @override
  String get brands_empty_description =>
      'ما فيه براندات متاحة حاليًا. اسحب للتحديث أو جرّب بعد شوي.';

  @override
  String get brands_listing_subtitle =>
      'تصفّح البراندات المتاحة واختر ما يناسبك بسهولة.';

  @override
  String brands_count_badge(int count) {
    return '$count علامة';
  }

  @override
  String get section_featured => 'مميزة';

  @override
  String get featured_unavailable => 'ما فيه منتجات مميزة متاحة';

  @override
  String get section_recommended => 'مقترح لك';

  @override
  String get recommended_unavailable => 'ما فيه منتجات مقترحة متاحة';

  @override
  String get section_explore => 'استكشف أكثر';

  @override
  String get explore_more_unavailable => 'ما فيه منتجات للاستكشاف متاحة';

  @override
  String get similar_products => 'منتجات مشابهة';

  @override
  String get see_all => 'عرض الكل';

  @override
  String get add_to_cart => 'أضف للسلة';

  @override
  String get add_button => 'إضافة';

  @override
  String get select_size => 'اختر المقاس:';

  @override
  String variant_sizes_count(Object count) {
    return '$count أحجام';
  }

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
  String get notifications_empty_title => 'ما فيه إشعارات';

  @override
  String get notifications_empty_description =>
      'أنت متابع كل جديد حاليًا. هنا بتظهر تحديثات الطلبات والتنبيهات المهمة أول بأول.';

  @override
  String get notifications_mark_all_read => 'اعتبار الكل مقروء';

  @override
  String get notifications_mark_all_read_confirm_title =>
      'تأكيد اعتبار الكل مقروء';

  @override
  String get notifications_mark_all_read_confirm_message =>
      'تبغى تعتبر كل الإشعارات الحالية مقروءة؟';

  @override
  String get notifications_preferences_saved => 'حفظنا الإعدادات';

  @override
  String notifications_unread_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إشعار غير مقروء',
      many: '$count إشعارًا غير مقروء',
      few: '$count إشعارات غير مقروءة',
      two: 'إشعاران غير مقروءين',
      one: 'إشعار واحد غير مقروء',
      zero: 'ما فيه إشعارات غير مقروءة',
    );
    return '$_temp0';
  }

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
  String get help_support_header_subtitle => 'كلمنا وبنرد عليك قريب.';

  @override
  String get about_app => 'عن التطبيق';

  @override
  String get developer => 'المطور';

  @override
  String get version => 'الإصدار';

  @override
  String get contact_us => 'كلمنا';

  @override
  String get contact_whatsapp => 'واتساب';

  @override
  String get contact_whatsapp_subtitle => 'كلمنا عبر واتساب';

  @override
  String get contact_phone_subtitle => 'اتصل علينا مباشرة';

  @override
  String get select_language => 'اختر اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get about_app_title => 'عن التطبيق';

  @override
  String get app_name => 'تطبيق زدانا للتسوق';

  @override
  String get version_label => 'الإصدار';

  @override
  String get release_date => 'تاريخ الإصدار';

  @override
  String get app_description =>
      'منصة زادانا للتسوق متعدد البائعين تعيد تعريف تجربة التسوق الخاصة بك. آلاف البائعين، مئات الآلاف من المنتجات، وفئات لا حصر لها… كل ما تحتاجه هو مجرد نقرة واحدة.\n\nمع شبكتنا الواسعة من البائعين، من الأعمال المحلية إلى البراندات العالمية، نقدم لمستخدمينا أوسع مجموعة من المنتجات، مع توفير تجربة تسوق سلسة من خلال بنية تحتية آمنة للدفع وخيارات شحن سريعة.\n\nفي زادانا، لا تشتري المنتجات فقط؛ بل تكتشف، وتقارن، وتجد أفضل الأسعار، وتربح مع العروض الحصرية. سواء كنت مهتمًا بالموضة، أو الإلكترونيات، أو المنزل والحياة، زادانا دائمًا معك.\n\nوجهتك الجديدة للتسوق: زادانا';

  @override
  String get ok => 'تمام';

  @override
  String get login_success => 'سجلت دخولك بنجاح';

  @override
  String get register_success => 'تم إنشاء الحساب، فعّل الإيميل';

  @override
  String get legal => 'القوانين';

  @override
  String get terms_conditions => 'الشروط والأحكام';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get sign_up_terms_prefix => 'أوافق على ';

  @override
  String get sign_up_terms_and => ' و';

  @override
  String get sign_up_terms_suffix => ' الخاصة بتطبيق زدانا.';

  @override
  String get sign_up_terms_required =>
      'يجب الموافقة على الشروط والأحكام وسياسة الخصوصية لإنشاء الحساب.';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get faq_track_order_question => 'كيف أتتبع طلبي؟';

  @override
  String get faq_track_order_answer =>
      'تقدر تتبع طلبك من صفحة طلباتي، وبعدها افتح الطلب اللي تبغى تتابع حالته.';

  @override
  String get faq_payment_methods_question => 'وش طرق الدفع المتاحة؟';

  @override
  String get faq_payment_methods_answer =>
      'ندعم بطاقات الدفع المختلفة والمحافظ الإلكترونية والدفع وقت الاستلام حسب المتاح.';

  @override
  String get faq_return_product_question => 'كيف أقدر أرجع منتج؟';

  @override
  String get faq_return_product_answer =>
      'تقدر تطلب الإرجاع من صفحة تفاصيل الطلب خلال فترة الإرجاع المسموح بها.';

  @override
  String get faq_contact_support_question => 'كيف أكلم الدعم؟';

  @override
  String get faq_contact_support_answer =>
      'تقدر تكلمنا من صفحة الدعم والمساعدة أو عبر وسائل التواصل المتاحة داخل التطبيق.';

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
  String get shipping => 'التوصيل';

  @override
  String get fulfillment => 'طريقة الاستلام';

  @override
  String get discount => 'الخصم';

  @override
  String get vat => 'ضريبة القيمة المضافة';

  @override
  String get cod_fee => 'رسوم الدفع وقت الاستلام';

  @override
  String get total => 'الإجمالي';

  @override
  String get checkout => 'إكمال الطلب';

  @override
  String get cart_empty => 'السلة فارغة';

  @override
  String get cart_empty_description => 'ما فيه منتجات في السلة';

  @override
  String get cart_empty_message => 'ابدأ تسوق وحط منتجات';

  @override
  String get cart_unavailable_products_title => 'منتجات غير متوفرة';

  @override
  String cart_unavailable_products_message(int count) {
    return '$count من المنتجات غير متوفرة في هذا المتجر';
  }

  @override
  String get cart_checkout_blocked_unavailable_products =>
      'لا يمكن إكمال الطلب لوجود منتجات غير متوفرة';

  @override
  String get cart_checkout_unavailable_hint =>
      'راجع المنتجات غير المتوفرة قبل إكمال الطلب';

  @override
  String cart_unavailable_checkout_dialog_message(int count) {
    return 'يوجد $count منتجات غير متوفرة حاليًا في هذا المتجر. احذفها أو اختر متجرًا آخر ثم حاول مرة أخرى.';
  }

  @override
  String get cart_unavailable_checkout_dialog_action => 'مراجعة السلة';

  @override
  String get shop_now => 'تسوّق الحين';

  @override
  String get delete_item => 'حذف المنتج';

  @override
  String get delete_item_confirm => 'تبغى تحذف المنتج؟';

  @override
  String get delete_category_title => 'حذف التصفيه';

  @override
  String get delete_category_confirm => 'تبغى تحذف التصفية؟';

  @override
  String get delete_category_tooltip => 'حذف التصفيه ';

  @override
  String get clear_filters_title => 'حذف التصفيه';

  @override
  String get clear_filters_confirm =>
      'بنحذف السعر والبراند وأي تصفية مفعلة حاليًا. تبغى تكمل؟';

  @override
  String get available_vendors => 'المتاجر';

  @override
  String get sar => 'ريال';

  @override
  String get free => 'مجاني';

  @override
  String get quantity => 'الكمية';

  @override
  String get error_bad_certificate => 'شهادة الأمان غير صالحة';

  @override
  String get error_request_cancelled => 'انلغى الطلب';

  @override
  String get error_no_internet => 'ما فيه إنترنت';

  @override
  String get offline_connection_issue_title => 'مشكلة في الاتصال';

  @override
  String get offline_connection_issue_message =>
      'تأكد من الإنترنت وحاول مرة ثانية';

  @override
  String get error_no_response => 'ما وصل رد من السيرفر';

  @override
  String get error_validation => 'البيانات المدخلة غير صحيحة';

  @override
  String get error_server => 'خطأ بالسيرفر';

  @override
  String get locationServicesDisabled => 'خدمات الموقع مقفلة';

  @override
  String get locationPermissionDenied => 'انرفض إذن الموقع';

  @override
  String get locationPermissionDeniedForever => 'انرفض إذن الموقع نهائيًا';

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
    return 'أضفنا $quantity من $name';
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
  String get yes => 'نعم';

  @override
  String get redirecting_to_checkout => 'جاري تحويلك لإكمال الطلب...';

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
  String get select_vendor_to_show_price => 'اختار المتجر عشان يطلع لك السعر';

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
  String get currently_selected => 'المحدد الآن';

  @override
  String get select_one_more_vendor => 'اختر متجر إضافي واحد على الأقل';

  @override
  String get compare_prices => 'سعر المنتج في المتجر';

  @override
  String get select_cheapest => 'اختيار';

  @override
  String get select_vendors_to_compare => 'اختر المتاجر عشان تقارن';

  @override
  String get select_2_to_3_vendors => 'اختر من متجرين إلى 3 متاجر عشان تقارن';

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
  String get sort_newest_desc => 'المنتجات المضافة جديد';

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
  String get sort_best_selling_desc => 'المنتجات الأكثر طلبًا';

  @override
  String get sort_highest_rated => 'الأعلى تقييمًا';

  @override
  String get sort_highest_rated_desc => 'حسب تقييم العملاء';

  @override
  String get sort_alphabetical => 'أبجدي';

  @override
  String get sort_alphabetical_desc => 'من أ إلى ي';

  @override
  String get filter_title => 'فلترة المنتجات';

  @override
  String get sort_title => 'رتّب المنتجات';

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
  String get brand_filter_package_type_title => 'نوع العبوة';

  @override
  String get brand_filter_measurement_unit_title => 'وحدة القياس';

  @override
  String get brand_filter_measurement_value_title => 'الحجم';

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
  String get show_more => 'اعرض المزيد';

  @override
  String get show_less => 'اعرض أقل';

  @override
  String get favorites => 'المفضلة';

  @override
  String get favorites_empty => 'المفضلة فارغة';

  @override
  String get favorites_empty_message => 'ما فيه منتجات في المفضلة';

  @override
  String get clear_favorites => 'حذف كل المفضلة';

  @override
  String get clear_favorites_confirmation =>
      'متأكد تبغى تحذف كل المنتجات من المفضلة؟';

  @override
  String get invoice_details => 'تفاصيل الطلب';

  @override
  String get processing => 'قاعدين ننفذ...';

  @override
  String get order_success => 'تم إرسال الطلب!';

  @override
  String get order_number => 'رقم الطلب';

  @override
  String get payment_successful => 'تم الدفع بنجاح!';

  @override
  String get payment_success_message => 'طلبك وصلنا وبيوصلك قريب';

  @override
  String get payment_confirmation_failed => 'فشل تأكيد الدفع';

  @override
  String get payment_confirmation_failed_message =>
      'ما تأكد الدفع بنجاح، والطلب باقي ينتظر الدفع. تقدر تتابع الطلب أو تحاول مرة ثانية لاحقًا.';

  @override
  String get estimated_delivery => 'وقت التوصيل';

  @override
  String get minutes => 'دقائق';

  @override
  String get track_order => 'تتبع الطلب';

  @override
  String get back_to_home => 'رجوع للرئيسية';

  @override
  String get track_order_order_placed => 'استلمنا الطلب';

  @override
  String get track_order_vendor_confirmed => 'المتجر أكد الطلب';

  @override
  String get track_order_waiting_vendor_confirmation => 'بانتظار تأكيد المتجر';

  @override
  String get track_order_preparing => 'جاري تجهيز الطلب';

  @override
  String get track_order_out_for_delivery => 'الطلب طلع للتوصيل';

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
  String get no_previous_orders => 'ما عندك طلبات سابقة';

  @override
  String get no_returning_orders => 'ما عندك طلبات قيد الإرجاع';

  @override
  String get my_orders_order_date => 'تاريخ الطلب';

  @override
  String get my_orders_created_at => 'اننشأ بتاريخ';

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
  String get my_orders_view_details => 'شوف التفاصيل';

  @override
  String get my_orders_cancel_order => 'إلغاء الطلب';

  @override
  String get my_orders_reorder => 'اطلب مرة ثانية';

  @override
  String get my_orders_rate_order => 'قيّم الطلب';

  @override
  String get my_orders_reorder_button => 'اطلب مرة ثانية';

  @override
  String get my_orders_return_request => 'طلب إلغاء';

  @override
  String get my_orders_retry_payment => 'إعادة الدفع';

  @override
  String get my_orders_follow_up => 'متابعة';

  @override
  String get my_orders_submit_complaint => 'تقديم شكوى';

  @override
  String get my_orders_details_title => 'تفاصيل الطلب';

  @override
  String get my_orders_delete_title => 'تبغى تحذف هالطلب؟';

  @override
  String get my_orders_delete_message =>
      'بنحذف الطلب نهائيًا من قائمتك إذا كان الحذف متاح له.';

  @override
  String get my_orders_order_summary_title => 'ملخص الطلب';

  @override
  String get my_orders_delivery_otp_title => 'رمز التسليم';

  @override
  String get my_orders_view_otp => 'شوف كود OTP';

  @override
  String get my_orders_complaint_status_title => 'حالة الشكوى';

  @override
  String get my_orders_cancel_sheet_title => 'إلغاء الطلب';

  @override
  String get my_orders_cancel_sheet_subtitle =>
      'فضلاً اختر سبب الإلغاء قبل تأكيد الطلب';

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
  String get my_orders_cancel_confirm_title => 'تأكيد إلغاء الطلب؟';

  @override
  String get my_orders_cancel_confirm_message =>
      'تأكد إنك تبغى تلغي هالطلب قبل ما تكمل.';

  @override
  String get my_orders_cancel_reason_delay => 'تأخر في تجهيز الطلب';

  @override
  String get my_orders_cancel_reason_changed_mind => 'غيرت رأيي';

  @override
  String get my_orders_cancel_reason_modify_order => 'أبغى أعدل الطلب';

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
      'اكتب تفاصيل المشكلة وأرفق صور إذا احتجت';

  @override
  String get my_orders_complaint_sheet_hint => 'اكتب تفاصيل الشكوى';

  @override
  String get my_orders_complaint_sheet_attach_images => 'إرفاق صور';

  @override
  String my_orders_complaint_sheet_attached_images(int count) {
    return 'أرفقنا $count صورة';
  }

  @override
  String get my_orders_complaint_sheet_send => 'إرسال';

  @override
  String my_orders_cancelled_feedback(String reason) {
    return 'انلغى الطلب: $reason';
  }

  @override
  String get my_orders_complaint_submitted_feedback => 'أرسلنا الشكوى';

  @override
  String get my_orders_complaint_received => 'استلمنا الشكوى';

  @override
  String get my_orders_complaint_under_review => 'الشكوى تحت المراجعة';

  @override
  String get my_orders_complaint_resolved => 'انحلت الشكوى';

  @override
  String get my_orders_support_case_title => 'حالة الدعم';

  @override
  String get my_orders_support_case_history_title => 'سجل الحالات';

  @override
  String get my_orders_support_case_details_title => 'تفاصيل الحالة';

  @override
  String get my_orders_support_case_timeline_title => 'التحديثات الظاهرة لك';

  @override
  String get my_orders_support_case_empty_details =>
      'اختر حالة عشان تشوف تفاصيلها.';

  @override
  String get my_orders_support_case_action => 'الدعم والمساعدة';

  @override
  String get my_orders_support_case_view => 'شوف الحالة';

  @override
  String get my_orders_support_case_created => 'أرسلنا الحالة بنجاح';

  @override
  String get my_orders_support_case_sheet_title => 'إنشاء حالة دعم';

  @override
  String get my_orders_support_case_sheet_subtitle =>
      'اشرح المشكلة وأرفق الملفات قبل ما ترسل الحالة.';

  @override
  String get my_orders_support_case_sheet_hint => 'اكتب ما حدث';

  @override
  String get my_orders_support_case_sheet_attach_files => 'إرفاق ملفات';

  @override
  String my_orders_support_case_sheet_attached_files(int count) {
    return 'أرفقنا $count ملف';
  }

  @override
  String get my_orders_support_case_sheet_send => 'إرسال الحالة';

  @override
  String get my_orders_support_case_type_complaint => 'شكوى';

  @override
  String get my_orders_support_case_type_return_request => 'طلب إرجاع';

  @override
  String get my_orders_support_case_type_generic => 'دعم';

  @override
  String get my_orders_support_case_type_label => 'نوع الحالة';

  @override
  String get my_orders_support_case_reason_label => 'السبب';

  @override
  String get my_orders_support_case_queue_label => 'القسم';

  @override
  String get my_orders_support_case_priority_label => 'الأولوية';

  @override
  String get my_orders_support_case_status_label => 'الحالة';

  @override
  String get my_orders_support_case_settlement_label => 'حالة التسوية';

  @override
  String get my_orders_support_case_waiting_for_reply =>
      'النظام ينتظر ردك الحين.';

  @override
  String get my_orders_support_case_case_details_label => 'تفاصيل الحالة';

  @override
  String get my_orders_support_case_approved_amount_label => 'المبلغ المعتمد';

  @override
  String get my_orders_support_case_coupon_code_label => 'كود الكوبون';

  @override
  String get my_orders_support_case_expires_at_label => 'ينتهي في';

  @override
  String get my_orders_support_case_redeemed_label => 'استخدمته';

  @override
  String get my_orders_support_case_copy_code => 'نسخ الكود';

  @override
  String get my_orders_support_case_code_copied => 'نسخنا الكود';

  @override
  String get my_orders_support_case_admin_decision_label => 'قرار الإدارة';

  @override
  String get my_orders_support_case_send_update => 'إرسال متابعة';

  @override
  String get my_orders_support_case_messages_title => 'المحادثة';

  @override
  String get my_orders_support_case_messages_empty =>
      'ما فيه رسائل ظاهرة إلى الآن.';

  @override
  String get my_orders_support_case_actor_you => 'أنت';

  @override
  String get my_orders_support_case_actor_support => 'الدعم';

  @override
  String get my_orders_support_case_preview_image_error =>
      'ما قدرنا نعرض الصورة';

  @override
  String get my_orders_support_case_priority_high => 'عالية';

  @override
  String get my_orders_support_case_priority_medium => 'متوسطة';

  @override
  String get my_orders_support_case_priority_low => 'منخفضة';

  @override
  String get my_orders_support_case_queue_finance => 'المالية';

  @override
  String get my_orders_support_case_queue_support => 'الدعم';

  @override
  String get my_orders_support_case_queue_operations => 'العمليات';

  @override
  String get my_orders_support_case_settlement_pending_review => 'قيد المراجعة';

  @override
  String get my_orders_support_case_settlement_cash_refunded =>
      'استرجعنا المبلغ كاش';

  @override
  String get my_orders_support_case_settlement_coupon_issued => 'أصدرنا كوبون';

  @override
  String get my_orders_support_case_settlement_coupon_redeemed =>
      'استخدمت الكوبون';

  @override
  String get my_orders_support_case_settlement_rejected => 'انرفض';

  @override
  String get my_orders_support_case_settlement_approved => 'تمت الموافقة';

  @override
  String get my_orders_support_case_evidence_guidance =>
      'إذا طُلبت أدلة إضافية، راجع آخر ملاحظة ظاهرة لك وكلم الدعم أو انتظر التحديث القادم.';

  @override
  String get my_orders_support_case_status_submitted => 'انرسل';

  @override
  String get my_orders_support_case_status_in_review => 'قيد المراجعة';

  @override
  String get my_orders_support_case_status_awaiting_customer_evidence =>
      'بانتظار أدلة إضافية';

  @override
  String get my_orders_support_case_status_approved => 'تمت الموافقة';

  @override
  String get my_orders_support_case_status_rejected => 'انرفض';

  @override
  String get my_orders_support_case_status_resolved => 'انحلت';

  @override
  String get my_orders_support_case_status_unknown => 'تحدثت الحالة';

  @override
  String get my_orders_support_case_reason_payment_issue => 'مشكلة في الدفع';

  @override
  String get my_orders_support_case_reason_delivery_delay => 'تأخر في التوصيل';

  @override
  String get my_orders_support_case_reason_prep_delay => 'تأخير في التجهيز';

  @override
  String get my_orders_support_case_reason_fraud => 'احتيال';

  @override
  String get my_orders_support_case_reason_fraud_suspicion => 'اشتباه احتيال';

  @override
  String get order_pending => 'قيد التنفيذ';

  @override
  String get order_shipped => 'انشحن';

  @override
  String get order_delivered => 'وصل الطلب';

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
  String get apple_pay_unavailable =>
      'أبل باي غير متاح ببطاقة مؤهلة على هذا الجهاز. أضف بطاقة مدعومة إلى المحفظة أو ارجع واختر طريقة دفع أخرى.';

  @override
  String get cash_on_delivery => 'الدفع وقت الاستلام';

  @override
  String get cash_on_delivery_subtitle => 'ادفع كاش عند استلام الطلب';

  @override
  String get bank_transfer => 'تحويل بنكي';

  @override
  String get bank_transfer_subtitle => 'تحويل مباشر من البنك';

  @override
  String get shopping => 'تسوق';

  @override
  String get delivery_otp_title => 'أكد التوصيل';

  @override
  String get delivery_otp_subtitle =>
      'اكتب كود التحقق اللي وصلك عشان تأكد التوصيل';

  @override
  String get delivery_otp_sent_to => 'أرسلنا الكود إلى';

  @override
  String get delivery_otp_verify_button => 'أكد التوصيل';

  @override
  String get delivery_otp_resend => 'إعادة إرسال الكود';

  @override
  String get delivery_otp_resend_success => 'أرسلنا كود التحقق من جديد';

  @override
  String get delivery_otp_verified => 'تأكد التوصيل';

  @override
  String get delivery_otp_invalid_code => 'كود التحقق غير صحيح';

  @override
  String get delivery_otp_required => 'فضلاً اكتب كود التحقق';

  @override
  String get delivery_otp_expired => 'انتهت صلاحية كود التحقق';

  @override
  String get delivery_otp_attempts_exceeded =>
      'تجاوزت الحد الأقصى لمحاولات التحقق';

  @override
  String get delivery_otp_remaining_attempts => 'المحاولات المتبقية';

  @override
  String get delivery_otp_timer_prefix => 'إعادة الإرسال خلال';

  @override
  String get delivery_otp_seconds => 'ثانية';

  @override
  String get delivery_rating_delivered_to => 'وصلنا إلى';

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
  String get delivery_code_title => 'كود التحقق من التوصيل الخاص بك';

  @override
  String get delivery_code_share_instruction =>
      'فضلاً شارك هالكود مع مندوب التوصيل';

  @override
  String get delivery_code_share_label => 'شارك هالكود';

  @override
  String get delivery_code_shared_button => 'تمت مشاركة الكود';

  @override
  String get delivery_code_generate_new => 'إنشاء كود جديد';

  @override
  String get order_success_title => 'تم طلبك بنجاح';

  @override
  String get order_success_subtitle => 'شكرًا لطلبك! طلبك بيوصلك قريب';

  @override
  String get courier_name => 'اسم المندوب';

  @override
  String get delegate_values => 'قيم المندوب';

  @override
  String get continue_shopping => 'كمل التسوق';

  @override
  String get view_order_details => 'شوف تفاصيل الطلب';

  @override
  String get delivery_get_otp => 'كود التحقق';

  @override
  String get delivery_datetime_title => 'تاريخ ووقت التسليم';

  @override
  String get select_date_time => 'حدد التاريخ والوقت';

  @override
  String get select_delivery_time => 'اختر وقت التسليم';

  @override
  String get delivery_time_selected => 'حددنا وقت التسليم';

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'بكرة';

  @override
  String get delivery_time_note => 'قد يختلف وقت التسليم حسب التوفر';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get delivery_code_section_title => 'رمز التسليم';

  @override
  String get otp_verification_code => 'كود التحقق OTP';

  @override
  String get otp_show_instruction => 'اضغط لعرض كود التحقق عند استلام الطلب';

  @override
  String get view_otp_code => 'شوف كود OTP';

  @override
  String get location_accuracy_dialog_title => 'تفعيل دقة الموقع';

  @override
  String get location_accuracy_dialog_message =>
      'عشان نحدد موقعك بدقة أكبر ونسرّع التوصيل، بنطلب من الجهاز تفعيل إعدادات الموقع المناسبة.';

  @override
  String get location_accuracy_dialog_hint =>
      'ممكن تطلع لك نافذة من النظام لتأكيد استخدام الموقع أو تحسين دقته. تقدر تكمل أو تحاول لاحقًا.';

  @override
  String get location_accuracy_dialog_continue => 'متابعة';

  @override
  String get location_accuracy_dialog_not_now => 'مو الحين';

  @override
  String get home_empty_title => 'ما فيه منتجات أو أقسام متاحة الآن';

  @override
  String get home_empty_description =>
      'ما وصلنا أي محتوى للصفحة الرئيسية حاليًا. اسحب للتحديث أو جرّب بعد شوي.';

  @override
  String get profile_guest_title => 'أنت تتصفح كزائر';

  @override
  String get profile_guest_subtitle =>
      'سجّل دخولك أو سو حساب عشان توصل لطلباتك والمفضلة وبياناتك الشخصية.';

  @override
  String get profile_guest_explore_title => 'متاح لك الحين';

  @override
  String get profile_guest_addresses_subtitle =>
      'تقدر تضيف عنوان، لكن مزامنة البيانات تحتاج تسجيل دخول';

  @override
  String get location_building_details_page_title => 'تفاصيل المبنى';

  @override
  String get location_save_address => 'حفظ العنوان';

  @override
  String get location_building_details_heading => 'اكتب تفاصيل المبنى';

  @override
  String get location_building_details_subtitle =>
      'أضف تفاصيل المبنى والشقة عشان تكمل عنوانك';

  @override
  String get location_address_label_title => 'تسمية العنوان *';

  @override
  String get location_address_label_hint => 'اختر اسم العنوان';

  @override
  String get location_address_label_required => 'فضلاً اختر اسم العنوان';

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
  String get location_floor_number_label => 'رقم الدور';

  @override
  String get location_floor_number_hint => 'مثال: 3';

  @override
  String get location_apartment_number_label => 'رقم الشقة';

  @override
  String get location_apartment_number_hint => 'مثال: 5';

  @override
  String get location_manual_address_page_title => 'إدخال العنوان يدويًا';

  @override
  String get location_confirm_address => 'أكد العنوان';

  @override
  String get location_manual_address_heading => 'اكتب تفاصيل عنوانك';

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
      'حدّث البيانات التالية وبعدها احفظ التغييرات';

  @override
  String get location_address_details_label => 'العنوان التفصيلي *';

  @override
  String get location_address_details_hint => 'مثال: شارع ٢٨ وسط الدمام';

  @override
  String get location_address_details_required => 'العنوان التفصيلي مطلوب';

  @override
  String get location_city_label => 'المدينة *';

  @override
  String get location_city_hint => 'مثال: الدمام';

  @override
  String get location_city_required => 'المدينة مطلوبة';

  @override
  String get location_area_label => 'المنطقة *';

  @override
  String get location_area_hint => 'مثال: العزيزية';

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
    return 'العنوان الافتراضي الحالي: $label';
  }

  @override
  String get addresses_primary_label => 'العنوان الرئيسي';

  @override
  String get addresses_default => 'افتراضي';

  @override
  String get addresses_current => 'العنوان الحالي';

  @override
  String get addresses_set_default => 'خلّه افتراضي';

  @override
  String get addresses_edit => 'تعديل';

  @override
  String get addresses_delete => 'حذف';

  @override
  String get addresses_delete_title => 'حذف العنوان';

  @override
  String addresses_delete_confirm(String label) {
    return 'تبغى تحذف عنوان \"$label\"؟';
  }

  @override
  String get addresses_delete_success => 'حذفنا العنوان بنجاح';

  @override
  String addresses_set_default_success(String label) {
    return 'تم تحديد \"$label\" كعنوان افتراضي';
  }

  @override
  String get addresses_edit_success => 'حدثنا العنوان بنجاح';

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
  String get profile_edit_subtitle => 'حدّث اسمك ورقمك وإيميلك';

  @override
  String get profile_addresses_subtitle =>
      'إدارة عناوين التوصيل والموقع المحفوظ';

  @override
  String get profile_orders_subtitle => 'راجع طلباتك الحالية والسابقة بسهولة';

  @override
  String get profile_language_subtitle => 'تحكم بلغة التطبيق';

  @override
  String get profile_notifications_subtitle => 'تحكم بالإشعارات والتنبيهات';

  @override
  String get profile_password_subtitle => 'حدّث كلمة المرور عشان تحمي حسابك';

  @override
  String get profile_help_subtitle => 'كلمنا أو اطّلع على المساعدة';

  @override
  String get profile_faq_subtitle => 'أسئلة وإجابات سريعة تساعدك';

  @override
  String get profile_about_subtitle => 'اعرف أكثر عن التطبيق والإصدار الحالي';

  @override
  String get profile_privacy_subtitle => 'الخصوصية والشروط والأحكام';

  @override
  String get profile_logout_subtitle => 'تسجيل الخروج من هالجهاز';

  @override
  String get account_deleted_message => 'تم حذف الحساب.';

  @override
  String get account_close_action => 'حذف الحساب';

  @override
  String get account_close_title => 'حذف الحساب؟';

  @override
  String get account_close_description =>
      'لن تتمكن من تسجيل الدخول بهذا الحساب. ستُحذف بياناتك الشخصية من العرض، بينما يبقى سجل الطلبات للمنصة فقط.';

  @override
  String get account_close_confirmation_label => 'اكتب DELETE للتأكيد';

  @override
  String get account_close_confirmation_required =>
      'اكتب DELETE بحروف كبيرة للتأكيد.';

  @override
  String get account_close_password_required => 'أدخل كلمة المرور.';

  @override
  String get account_close_invalid_password => 'كلمة المرور غير صحيحة.';

  @override
  String get delivery_unavailable_title => 'التوصيل غير متاح';

  @override
  String get delivery_unavailable_hint =>
      'فضلاً اختر متجر ثاني أو غيّر عنوان التوصيل';

  @override
  String get delivery_unavailable_dismiss => 'فهمت';

  @override
  String get delivery_unavailable_change_address => 'تغيير العنوان';

  @override
  String get checkout_login_title => 'سجّل الدخول للمتابعة';

  @override
  String get checkout_login_message =>
      'لإكمال الطلب، نحتاج أولًا إلى تسجيل دخولك أو إكمال التسجيل إذا لم يكن لديك حساب بعد.';

  @override
  String get checkout_login_helper =>
      'إذا عندك حساب، تقدر تسجّل دخولك من الشاشة الجاية';

  @override
  String get checkout_login_action => 'متابعة';

  @override
  String get error_max_open_cases_exceeded =>
      'وصلت للحد الأقصى من الطلبات المفتوحة';

  @override
  String get error_duplicate_return_request =>
      'فيه طلب استرجاع مفتوح لهالطلب بالفعل';

  @override
  String get error_return_window_expired => 'انتهت فترة الاسترجاع';

  @override
  String get refund_lifecycle_pending => 'قيد المعالجة';

  @override
  String get refund_lifecycle_processed => 'تم الاسترجاع';

  @override
  String get refund_lifecycle_failed => 'فشل الاسترجاع';

  @override
  String get refund_lifecycle_not_applicable => 'لا ينطبق';

  @override
  String get refund_lifecycle_title => 'حالة الاسترجاع';

  @override
  String get refund_lifecycle_step_approved => 'تمت الموافقة';

  @override
  String get refund_lifecycle_step_processing => 'جاري المعالجة';

  @override
  String get refund_lifecycle_step_done => 'مكتمل';

  @override
  String get notifications_delete_all_title => 'حذف جميع الإشعارات';

  @override
  String get notifications_delete_all_message =>
      'تبغى تحذف كل الإشعارات؟ ما تقدر تتراجع عن هالإجراء.';

  @override
  String get notifications_delete_all_confirm => 'حذف';

  @override
  String get notifications_preferences_title => 'إعدادات الإشعارات';

  @override
  String get notifications_push_enabled => 'الإشعارات';

  @override
  String get notifications_push_enabled_subtitle => 'استقبل إشعارات على الجهاز';

  @override
  String get notifications_sound_title => 'صوت الإشعار';

  @override
  String get notifications_sound_default => 'الافتراضي';

  @override
  String get notifications_sound_silent => 'صامت';

  @override
  String get notifications_sound_chime => 'رنين';

  @override
  String get notifications_sound_alert => 'تنبيه';

  @override
  String get product_not_available_title => 'هالمنتج ما عاد متاح';

  @override
  String get product_not_available_description =>
      'هالمنتج غير متوفر حاليًا. تقدر تتصفح منتجات ثانية.';

  @override
  String get checkout_unavailable_items_confirm_title =>
      'عندك منتجات مو متوفرة';

  @override
  String get checkout_unavailable_items_confirm_message =>
      'المتجر اللي اخترته ما يوفّر كل منتجات سلتك. تبي نشيل المنتجات اللي مو متوفرة ونكمّل طلبك؟';

  @override
  String get checkout_unavailable_items_confirm_continue => 'كمّل الطلب';

  @override
  String get cart_items_unavailable_at_address_branch =>
      'بعض المنتجات غير متوفرة في فرع عنوانك الحالي. يرجى حذفها أو تغيير العنوان.';

  @override
  String get pickup_branch_selector_title => 'اختر فرع الاستلام';

  @override
  String get pickup_branch_selector_hint =>
      'تظهر الفروع المتاحة في مدينتك فقط، ويمكن اختيار الفروع التي تتوفر بها جميع منتجات السلة.';

  @override
  String get pickup_branch_selector_empty =>
      'لا توجد فروع استلام متاحة في هذه المدينة حاليًا.';

  @override
  String get pickup_branch_selector_cart_unavailable =>
      'لا يوجد فرع في هذه المدينة يوفر جميع منتجات السلة حاليًا.';

  @override
  String get pickup_branch_primary => 'الفرع الرئيسي';

  @override
  String get pickup_branch_cart_available => 'متاح لجميع منتجات السلة';

  @override
  String pickup_branch_cart_unavailable(int count) {
    return 'غير متاح لـ $count من منتجات السلة';
  }

  @override
  String get profile_photo_camera => 'الكاميرا';

  @override
  String get profile_photo_library => 'المعرض';

  @override
  String get profile_photo_invalid_format =>
      'اختر صورة بصيغة JPG أو PNG أو WEBP أو GIF أو BMP.';

  @override
  String get profile_photo_too_large => 'اختر صورة بحجم أقل من 5 ميجابايت.';

  @override
  String get profile_photo_updated => 'تم تحديث الصورة الشخصية.';

  @override
  String get profile_photo_removed => 'تم حذف الصورة الشخصية.';

  @override
  String get profile_photo_edit_tooltip => 'تعديل الصورة الشخصية';

  @override
  String get profile_updated => 'تم تحديث البيانات بنجاح';

  @override
  String get profile_update_action => 'تحديث';

  @override
  String get checkout_add_phone_action => 'إضافة الرقم';

  @override
  String get pickup_branch_title => 'فرع الاستلام';

  @override
  String get pickup_code_title => 'كود الاستلام';

  @override
  String get pickup_code_instruction =>
      'اعرض هذا الكود للتاجر عند استلام طلبك.';

  @override
  String get pickup_code_resend => 'إعادة إرسال الكود';

  @override
  String pickup_code_expires(String dateTime) {
    return 'ينتهي الكود: $dateTime';
  }

  @override
  String pickup_deadline(String dateTime) {
    return 'مهلة الاستلام حتى: $dateTime';
  }

  @override
  String get pickup_from_branch => 'الاستلام من الفرع';

  @override
  String get fulfillment_pickup_label => 'استلام من الفرع';

  @override
  String get fulfillment_pickup_subtitle => 'تسليم الطلب من الفرع';

  @override
  String get pickup_change_branch => 'غيّر الفرع';

  @override
  String get pickup_select_branch_first =>
      'ياليت تختار الفرع اللي بتستلم منه طلبك أول، وبعدها تقدر تكمّل الطلب.';

  @override
  String get pickup_complete_order_unavailable =>
      'اختَر فرع الاستلام أول لإكمال طلبك.';
}
