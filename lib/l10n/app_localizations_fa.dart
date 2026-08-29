// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appName => 'FitSho';

  @override
  String get appNamePersian => 'فیت‌شو';

  @override
  String get loginTitle => 'ورود';

  @override
  String get loginWithMobile => 'ورود با شماره موبایل';

  @override
  String get loginSubtitle =>
      'شماره موبایل خود را وارد کنید تا کد تأیید برایتان ارسال شود';

  @override
  String get mobileNumberLabel => 'شماره موبایل';

  @override
  String get mobileNumberHint => '09XXXXXXXXX';

  @override
  String get invalidMobileNumber =>
      'شماره موبایل معتبر وارد کنید (09XXXXXXXXX)';

  @override
  String get sendOtp => 'ارسال کد تأیید';

  @override
  String get legalAgreementPrefix => 'با ورود یا ثبت‌نام در فیت‌شو، ';

  @override
  String get legalTermsLink => 'شرایط و قوانین';

  @override
  String get legalAgreementMiddle => ' و ';

  @override
  String get legalPrivacyLink => 'سیاست حریم خصوصی';

  @override
  String get legalAgreementSuffix => ' ما را می‌پذیرید.';

  @override
  String get legalTermsTitle => 'شرایط و قوانین';

  @override
  String get legalTermsContent =>
      'به فیت‌شو خوش آمدید. با استفاده از این اپلیکیشن، شما با موارد زیر موافقت می‌کنید:\n\n۱. سلب مسئولیت پزشکی: فیت‌شو یک دستیار هوشمند بر پایه هوش مصنوعی است. تمامی برنامه‌های ارائه شده جنبه پیشنهادی دارند. اگر بیماری خاص، بارداری یا شرایط پزشکی ویژه‌ای دارید، حتماً قبل از شروع رژیم با پزشک مشورت کنید.\n\n۲. صحت اطلاعات: مسئولیت دقت اطلاعات وارد شده (وزن، قد، سن) بر عهده کاربر است.\n\n۳. استفاده منصفانه: هرگونه تلاش برای استخراج غیرمجاز داده‌ها یا سوءاستفاده از هوش مصنوعی اپلیکیشن ممنوع است.\n\n۴. تغییرات: فیت‌شو حق دارد در هر زمان قوانین خود را برای بهبود خدمات بروزرسانی کند.';

  @override
  String get legalPrivacyTitle => 'سیاست حریم خصوصی';

  @override
  String get legalPrivacyContent =>
      'حریم خصوصی شما برای فیت‌شو خط قرمز است:\n\n۱. جمع‌آوری داده‌ها: ما اطلاعات فیزیکی شما را صرفاً برای محاسبه دقیق رژیم و کالری‌شمار دریافت می‌کنیم.\n\n۲. امنیت داده‌ها: تمامی داده‌های شما به صورت رمزنگاری شده در سرورهای امن ما نگهداری می‌شوند.\n\n۳. عدم اشتراک‌گذاری: فیت‌شو اطلاعات شخصی یا تماس شما را به هیچ عنوان در اختیار شرکت‌های تبلیغاتی یا اشخاص ثالث قرار نمی‌دهد.\n\n۴. حق حذف داده: شما در هر زمان می‌توانید از طریق تنظیمات پروفایل، حساب کاربری و تمام داده‌های مرتبط با خود را به صورت دائمی حذف کنید.';

  @override
  String get gotIt => 'متوجه شدم';

  @override
  String get otpTitle => 'کد تأیید';

  @override
  String otpSubtitle(String mobile) {
    return 'کد ۶ رقمی ارسال‌شده به $mobile را وارد کنید';
  }

  @override
  String get verifyOtp => 'تأیید و ادامه';

  @override
  String get resendOtp => 'ارسال مجدد کد';

  @override
  String resendOtpCountdown(String time) {
    return 'ارسال مجدد تا $time دیگر';
  }

  @override
  String get resendOtpCountdownPrefix => 'ارسال مجدد تا';

  @override
  String get resendOtpCountdownSuffix => 'دیگر';

  @override
  String get editMobileNumber => 'ویرایش شماره';

  @override
  String get otpEnterInstruction => 'کد ۶ رقمی ارسال‌شده را وارد کنید';

  @override
  String get otpSentSuccess => 'کد تأیید ارسال شد';

  @override
  String get otpInvalid => 'کد تأیید ۶ رقمی را وارد کنید';

  @override
  String get navDashboard => 'داشبورد';

  @override
  String get navWeeklyPlan => 'برنامه هفتگی';

  @override
  String get navSupplements => 'مکمل‌ها';

  @override
  String get navProfile => 'پروفایل';

  @override
  String get profileTabTitle => 'پروفایل';

  @override
  String get profileTabDescription => 'پروفایل و تنظیمات — Phase 6';

  @override
  String get displayNameLabel => 'نام نمایشی';

  @override
  String get displayNameHint => 'نام خود را وارد کنید';

  @override
  String get displayNameRequired => 'نام نمایشی الزامی است';

  @override
  String get noDisplayName => 'نام ثبت نشده';

  @override
  String get saveProfile => 'ذخیره تغییرات';

  @override
  String get profileUpdatedSuccess => 'پروفایل با موفقیت به‌روزرسانی شد';

  @override
  String get logout => 'خروج از حساب';

  @override
  String get logoutTitle => 'خروج';

  @override
  String get logoutConfirmation => 'آیا مطمئن هستید که می‌خواهید خارج شوید؟';

  @override
  String get contactUsTitle => 'تماس با ما';

  @override
  String get contactUsSubtitle => 'سوال یا پیشنهادی داری؟ برامون ایمیل بزن.';

  @override
  String get contactUsNoMailApp => 'اپلیکیشن ایمیل پیدا نشد. آدرس کپی شد.';

  @override
  String get deleteAccount => 'حذف حساب کاربری';

  @override
  String get deleteAccountTitle => 'حذف حساب کاربری';

  @override
  String get deleteAccountConfirmation =>
      'با این کار حساب کاربری و تمام اطلاعات شما برای همیشه حذف خواهد شد. این عملیات قابل بازگشت نیست.';

  @override
  String get confirm => 'تأیید';

  @override
  String get cancel => 'انصراف';

  @override
  String get errorTitle => 'خطا';

  @override
  String routeNotFound(String path) {
    return 'مسیر یافت نشد: $path';
  }

  @override
  String get managePreferences => 'ترجیحات غذایی';

  @override
  String get preferencesTitle => 'ترجیحات';

  @override
  String get preferencesSubtitle =>
      'محدودیت‌های غذایی و سبک‌های آشپزی مورد علاقه خود را انتخاب کنید تا پیشنهاد دستور پخت شخصی‌سازی شود.';

  @override
  String get preferencesEmptyHint =>
      'هنوز ترجیحی ثبت نکرده‌اید. گزینه‌ها را انتخاب و ذخیره کنید.';

  @override
  String get dietaryRestrictionsSection => 'محدودیت‌های غذایی';

  @override
  String get preferredCuisinesSection => 'سبک‌های آشپزی';

  @override
  String get savePreferences => 'ذخیره ترجیحات';

  @override
  String get deletePreferences => 'حذف ترجیحات';

  @override
  String get deletePreferencesTitle => 'حذف ترجیحات';

  @override
  String get deletePreferencesConfirmation =>
      'آیا مطمئن هستید که می‌خواهید ترجیحات خود را حذف کنید؟';

  @override
  String get preferencesSavedSuccess => 'ترجیحات با موفقیت ذخیره شد';

  @override
  String get preferencesDeletedSuccess => 'ترجیحات با موفقیت حذف شد';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get dietaryVegan => 'وگان';

  @override
  String get dietaryVegetarian => 'گیاهخواری';

  @override
  String get dietaryGlutenFree => 'بدون گلوتن';

  @override
  String get dietaryDairyFree => 'بدون لبنیات';

  @override
  String get dietaryHalal => 'حلال';

  @override
  String get dietaryLowCarb => 'کم‌کربوهیدرات';

  @override
  String get dietaryNutFree => 'بدون آجیل';

  @override
  String get cuisinePersian => 'ایرانی';

  @override
  String get cuisineItalian => 'ایتالیایی';

  @override
  String get cuisineMediterranean => 'مدیترانه‌ای';

  @override
  String get cuisineIndian => 'هندی';

  @override
  String get cuisineChinese => 'چینی';

  @override
  String get cuisineMexican => 'مکزیکی';

  @override
  String get cuisineTurkish => 'ترکی';

  @override
  String get cuisineFrench => 'فرانسوی';

  @override
  String get aiProviderFailure =>
      'سرویس هوش مصنوعی موقتاً در دسترس نیست. لطفاً دوباره تلاش کنید.';

  @override
  String get networkError =>
      'اتصال اینترنت برقرار نیست. شبکه را بررسی و دوباره تلاش کنید.';

  @override
  String get pressBackAgainToExit => 'برای خروج دوباره دکمه بازگشت را بزنید';

  @override
  String get sessionExpired =>
      'نشست شما منقضی شده است. لطفاً دوباره وارد شوید.';

  @override
  String get genericError => 'خطایی رخ داد. لطفاً دوباره تلاش کنید.';

  @override
  String get save => 'ذخیره';

  @override
  String get next => 'بعدی';

  @override
  String get back => 'قبلی';

  @override
  String get edit => 'ویرایش';

  @override
  String get delete => 'حذف';

  @override
  String get dietOnboardingTitle => 'پروفایل رژیم غذایی';

  @override
  String get dietOnboardingSubtitle =>
      'اطلاعات خود را وارد کنید تا برنامه هفتگی شخصی‌سازی‌شده دریافت کنید.';

  @override
  String get dietAgeLabel => 'سن (سال)';

  @override
  String get dietHeightLabel => 'قد (سانتی‌متر)';

  @override
  String get dietWeightLabel => 'وزن (کیلوگرم)';

  @override
  String get dietGenderLabel => 'جنسیت';

  @override
  String get dietGenderMale => 'مرد';

  @override
  String get dietGenderFemale => 'زن';

  @override
  String get dietJobLabel => 'شغل (اختیاری)';

  @override
  String get dietGoalLabel => 'هدف';

  @override
  String get dietGoalNotesLabel => 'توضیحات هدف (اختیاری)';

  @override
  String get dietActivityLevelLabel => 'سطح فعالیت';

  @override
  String get dietDoesExerciseLabel => 'ورزش می‌کنم';

  @override
  String get dietExerciseTypeLabel => 'نوع ورزش';

  @override
  String get dietExerciseDaysLabel => 'روز ورزش در هفته (۱–۷)';

  @override
  String get dietDietaryPreferencesLabel => 'ترجیحات غذایی';

  @override
  String get dietAllergiesLabel => 'حساسیت‌ها (اختیاری)';

  @override
  String get dietSaveProfile => 'ذخیره پروفایل';

  @override
  String get dietProfileEditTitle => 'ویرایش پروفایل رژیم';

  @override
  String get dietRegeneratePromptTitle => 'برنامه هفتگی به‌روزرسانی شود؟';

  @override
  String get dietRegeneratePromptBody =>
      'مشخصات شما تغییر کرد. می‌خواهید برنامه غذایی هفتگی بر اساس اطلاعات جدید دوباره ساخته شود؟';

  @override
  String get dietRegenerateConfirm => 'بله، بازتولید کن';

  @override
  String get dietRegenerateDismiss => 'فعلاً نه';

  @override
  String get dietPlanRegenerated => 'برنامه هفتگی جدید با موفقیت ساخته شد';

  @override
  String get dietFormValidationError => 'لطفاً فیلدهای الزامی را تکمیل کنید';

  @override
  String get dietDaySaturday => 'شنبه';

  @override
  String get dietDaySunday => 'یکشنبه';

  @override
  String get dietDayMonday => 'دوشنبه';

  @override
  String get dietDayTuesday => 'سه‌شنبه';

  @override
  String get dietDayWednesday => 'چهارشنبه';

  @override
  String get dietDayThursday => 'پنجشنبه';

  @override
  String get dietDayFriday => 'جمعه';

  @override
  String get dietSlotBreakfast => 'صبحانه';

  @override
  String get dietSlotMorningSnack => 'میان‌وعده صبح';

  @override
  String get dietSlotLunch => 'ناهار';

  @override
  String get dietSlotAfternoonSnack => 'میان‌وعده عصر';

  @override
  String get dietSlotDinner => 'شام';

  @override
  String get dietGeneratePlan => 'تولید برنامه هفتگی';

  @override
  String get dietIAteThis => 'خوردم';

  @override
  String get dietLastMealTitle => 'آخرین وعده';

  @override
  String get dietMealTimesSettings => 'زمان وعده‌ها';

  @override
  String get dietSupplementsTitle => 'مکمل‌ها';

  @override
  String get dietSupplementsEmpty => 'هنوز مکملی ثبت نشده';

  @override
  String get dietSupplementsEmptySubtitle =>
      'مکمل‌ها و داروهای خود را اضافه کنید تا در زمان مناسب یادآوری بگیرید.';

  @override
  String get dietNoPlanYet => 'هنوز برنامه‌ای ندارید. دکمه تولید را بزنید.';

  @override
  String get dietNoPlanYetSubtitle =>
      'یک برنامه هفتگی هوشمند بر اساس پروفایل خودت تولید کن.';

  @override
  String get dietWeeklyPlanTitle => 'برنامه هفتگی';

  @override
  String dietDailyCalorieTarget(String calories) {
    return 'هدف کالری روزانه: $calories کیلوکالری';
  }

  @override
  String get dietIngredientsTitle => 'مواد لازم';

  @override
  String dietCaloriesShort(String value) {
    return '$value کالری';
  }

  @override
  String dietProteinShort(String value) {
    return 'پروتئین ${value}g';
  }

  @override
  String dietCarbsShort(String value) {
    return 'کرب ${value}g';
  }

  @override
  String dietFatShort(String value) {
    return 'چربی ${value}g';
  }

  @override
  String get dietUnknownMeal => 'وعده نامشخص';

  @override
  String get dietGoalLoseWeight => 'کاهش وزن';

  @override
  String get dietGoalMaintainWeight => 'حفظ وزن';

  @override
  String get dietGoalGainWeight => 'افزایش وزن / عضله';

  @override
  String get dietActivitySedentary => 'کم‌تحرک';

  @override
  String get dietActivityLight => 'فعالیت سبک';

  @override
  String get dietActivityModerate => 'فعالیت متوسط';

  @override
  String get dietActivityVeryActive => 'فعالیت زیاد';

  @override
  String get dietActivityExtraActive => 'فعالیت بسیار زیاد';

  @override
  String get dietAddSupplement => 'افزودن مکمل';

  @override
  String get dietEditSupplement => 'ویرایش مکمل';

  @override
  String get dietSupplementNameLabel => 'نام مکمل';

  @override
  String get dietSupplementDosageLabel => 'دوز / نحوه مصرف';

  @override
  String get dietSupplementTimesLabel => 'ساعات یادآوری';

  @override
  String get dietAddTime => 'افزودن ساعت';

  @override
  String get dietSupplementLinkedMealLabel => 'وعده مرتبط (اختیاری)';

  @override
  String get dietNone => 'بدون ارتباط';

  @override
  String get dietHistoryTitle => 'تاریخچه رژیم‌ها';

  @override
  String get dietHistoryEmpty => 'تاریخچه‌ای یافت نشد';

  @override
  String get dietSlotNotificationLabel => 'دریافت اعلان یادآوری';

  @override
  String get dietHistoryDeleteConfirmTitle => 'حذف برنامه';

  @override
  String get dietHistoryDeleteConfirmBody =>
      'آیا از حذف این برنامه رژیمی اطمینان دارید؟';

  @override
  String get dietHistoryDeleteConfirmConfirm => 'حذف';

  @override
  String get dietHistoryDeleteConfirmCancel => 'انصراف';

  @override
  String get dietHistoryDeleteSuccess => 'برنامه با موفقیت حذف شد';
}
