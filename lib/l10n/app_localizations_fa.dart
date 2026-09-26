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
  String get dietSupplementLinkedMealLabel => 'وعده مرتبط';

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

  @override
  String dietHoursLeft(String hours) {
    return '$hours ساعت دیگر';
  }

  @override
  String get dietDailyProgress => 'پیشرفت روزانه';

  @override
  String get dietHealthStats => 'آمار سلامت';

  @override
  String get dietDailyWaterGoal => 'هدف آب روزانه';

  @override
  String dietLiters(String value) {
    return '$value لیتر';
  }

  @override
  String dietDailyCalories(String value) {
    return '$value کالری روزانه';
  }

  @override
  String get dietSupplementsRequirementHint =>
      'برای افزودن مکمل و مدیریت آن‌ها، ابتدا باید از بخش داشبورد برنامه‌ی غذایی خود را تولید کنید.';

  @override
  String get dietSupplementUpdateError => 'خطا در بروزرسانی وضعیت مکمل';

  @override
  String get dietEaten => 'خورده شد ✓';

  @override
  String get dietDailyMealSlots => 'وعده‌های روزانه';

  @override
  String get dietRegenerateButton => 'تولید برنامه جدید';

  @override
  String get dietWeightChangedTitle => 'وزن شما تغییر کرده است!';

  @override
  String get dietWeightChangedSubtitle =>
      'مایلید برنامه جدیدی بر اساس مشخصات جدیدتان تولید شود؟';

  @override
  String get dietAgeValidation => 'لطفاً مقدار صحیح را وارد کنید';

  @override
  String get dietHeightValidation => 'لطفاً مقدار صحیح را وارد کنید';

  @override
  String get dietWeightValidation => 'لطفاً مقدار صحیح را وارد کنید';

  @override
  String get dietExerciseDaysValidation => 'لطفاً مقدار صحیح را وارد کنید';

  @override
  String get dietBmiUnderweight => 'کمبود وزن';

  @override
  String get dietBmiNormal => 'نرمال';

  @override
  String get dietBmiOverweight => 'اضافه وزن';

  @override
  String get dietBmiObesity => 'چاقی';

  @override
  String dietCaloriesRemaining(String value) {
    return '$value کالری باقی‌مانده';
  }

  @override
  String get dietOverConsumed => 'بیش از حد مصرف شده!';

  @override
  String get dietComplianceHigh => 'عالیه! همینجوری ادامه بده 🏆';

  @override
  String get dietComplianceLow => 'کمی بیشتر تلاش کن، تو می‌تونی! 💪';

  @override
  String get dietComplianceLabel => 'پایبندی به رژیم';

  @override
  String get dietDailyCalorieTargetLabel => 'هدف کالری روزانه';

  @override
  String dietTdeeLabel(String value) {
    return 'کالری مورد نیاز (TDEE): $value';
  }

  @override
  String dietBmiLabel(String status) {
    return 'BMI ($status)';
  }

  @override
  String get view => 'مشاهده';

  @override
  String get dietReminderTitle => 'یادآوری رژیم';

  @override
  String get dietReminderBody => 'زمان وعده غذایی شما نزدیک است.';

  @override
  String get dietSupplementLinkedMealRequired =>
      'لطفاً وعده غذایی مرتبط را انتخاب کنید';

  @override
  String get forceUpdateTitle => 'بروزرسانی الزامی';

  @override
  String get forceUpdateMessage =>
      'برای ادامه‌ی استفاده باید اپلیکیشن را به آخرین نسخه بروزرسانی کنید.';

  @override
  String get optionalUpdateTitle => 'نسخه جدید موجود است';

  @override
  String get optionalUpdateMessage =>
      'نسخه جدید اپلیکیشن فیت‌شو منتشر شده است. مایل به بروزرسانی هستید؟';

  @override
  String get updateNow => 'بروزرسانی';

  @override
  String get later => 'بعداً';

  @override
  String get skip => 'رد کردن';

  @override
  String get start => 'شروع';

  @override
  String get onboardingTitle1 => 'برنامه‌ریزی هوشمند غذا';

  @override
  String get onboardingSubtitle1 =>
      'با هوش مصنوعی فیت‌شو، برنامه غذایی شخصی‌سازی شده دریافت کنید.';

  @override
  String get onboardingTitle2 => 'پیگیری پیشرفت روزانه';

  @override
  String get onboardingSubtitle2 =>
      'کالری‌های دریافتی و فعالیت‌های ورزمی خود را به سادگی ثبت و مدیریت کنید.';

  @override
  String get onboardingTitle3 => 'رسیدن به اندام ایده‌آل';

  @override
  String get onboardingSubtitle3 =>
      'ما در هر قدم همراه شما هستیم تا به اهداف سلامتی خود برسید.';

  @override
  String get aiGeneratingPlanTitle => 'هوش مصنوعی در حال بررسی...';

  @override
  String get aiGeneratingPlanMessage =>
      'لطفاً صبور باشید، هوش مصنوعی فیت‌شو در حال تدوین بهترین برنامه غذایی بر اساس فیزیک و اهداف شماست.';

  @override
  String get dietCalorieGoalCompleted => 'هدف کالری تکمیل شد 🎯';

  @override
  String get dietGeneratePlanAction => 'تولید برنامه';

  @override
  String get dietChangePlanTitle => 'تغییر رژیم غذایی';

  @override
  String get dietChangePlanLimit => 'محدودیت ۳ بار در هفته';

  @override
  String dietRemainingSwaps(String value) {
    return '$value بار باقی‌مانده';
  }

  @override
  String get dietWeeklyLimitReached =>
      'شما در این هفته ۳ بار رژیم خود را تغییر داده‌اید.';

  @override
  String get dietSwapMealTooltip => 'جایگزین کن';

  @override
  String dietRemainingMealSwaps(String value) {
    return '$value بار جایگزینی امروز باقی مانده';
  }

  @override
  String dietMealTimeSameError(String meal1, String meal2) {
    return 'ساعت وعده «$meal1» و «$meal2» نمی‌تواند یکسان باشد.';
  }

  @override
  String dietMealTimeOrderError(String laterMeal, String earlierMeal) {
    return 'ساعت وعده «$laterMeal» باید بعد از «$earlierMeal» باشد.';
  }

  @override
  String dietMealTimeGapError(String meal1, String meal2) {
    return 'فاصله زمانی بین وعده «$meal1» و «$meal2» باید حداقل ۶۰ دقیقه باشد.';
  }

  @override
  String dietMealReminderTitle(String meal) {
    return 'زمان $meal 🥗';
  }

  @override
  String dietMealReminderBody(String meal) {
    return 'نوبت میل کردن وعده $meal فرا رسیده است.';
  }

  @override
  String notificationMealReminderTitle(String slot) {
    return 'یادآوری $slot';
  }

  @override
  String notificationMealTimeForSlot(String slot) {
    return 'زمان صرف $slot است.';
  }

  @override
  String get notificationDietPlanSummary => 'برنامه غذایی';

  @override
  String get notificationMealTicker => 'یادآور وعده غذایی';

  @override
  String get notificationMealChannelName => 'یادآور وعده‌های غذایی';

  @override
  String get notificationMealChannelDesc =>
      'اعلان‌های زمان‌بندی‌شده برای وعده‌های غذایی';

  @override
  String get autostartPromptTitle => 'یادآور دقیق وعده‌ها';

  @override
  String get autostartPromptBody =>
      'برای اینکه یادآورهای رژیم شما حتی در زمان بسته بودن اپلیکیشن دقیق کار کنند، لطفاً با زدن دکمه زیر، اجازه فعالیت در پس‌زمینه (AutoStart) را به فیت‌شو بدهید.';

  @override
  String get autostartPromptEnable => 'فعالسازی';

  @override
  String get autostartPromptLater => 'بعداً';

  @override
  String appVersion(String version) {
    return 'نسخه $version';
  }

  @override
  String get workoutOnboardingTitle => 'ساخت پروفایل تمرینی';

  @override
  String get workoutStepDisciplines => 'انتخاب رشته';

  @override
  String get workoutStepStyleLevel => 'سطح و سبک';

  @override
  String get workoutStepGoal => 'هدف تمرینی';

  @override
  String get workoutStepConditions => 'شرایط و تجهیزات';

  @override
  String get workoutStepInjuries => 'آسیب‌دیدگی و سلامت';

  @override
  String get workoutMaxDisciplinesWarning =>
      'حداکثر می‌توانید ۲ رشته انتخاب کنید.';

  @override
  String get workoutMedicalReferralWarning =>
      'با توجه به شرایط آسیب یا درد شدید، لطفاً پیش از شروع تمرین با پزشک یا فیزیوتراپیست مشورت کنید.';

  @override
  String get workoutNoInjuries => 'آسیب‌دیدگی ندارم';

  @override
  String get workoutPainLevel => 'سطح درد (۰ تا ۱۰):';

  @override
  String get workoutInjuryNotes => 'توضیحات تکمیلی آسیب (اختیاری)';

  @override
  String get workoutDaysPerWeek => 'روزهای تمرین در هفته:';

  @override
  String get workoutSessionMinutes => 'مدت زمان جلسه (دقیقه):';

  @override
  String get workoutLocation => 'مکان تمرین:';

  @override
  String get workoutEquipment => 'تجهیزات در دسترس:';

  @override
  String get workoutSaveProfile => 'ذخیره و ادامه';

  @override
  String get workoutTabTitle => 'تمرین';

  @override
  String get workoutGeneratePlan => 'ساخت برنامه تمرینی';

  @override
  String workoutRemainingGenerations(int count) {
    return '$count بار تا پایان هفته';
  }

  @override
  String workoutRemainingSwaps(int count) {
    return '$count تعویض باقی‌مانده امروز';
  }

  @override
  String get workoutNeedDietFirst =>
      'برای دسترسی به برنامه تمرینی، ابتدا باید پروفایل تغذیه خود را تکمیل کنید.';

  @override
  String get workoutGoToDietOnboarding => 'تکمیل پروفایل تغذیه';

  @override
  String get workoutNoPlanYet => 'هنوز برنامه تمرینی ثبت نشده است';

  @override
  String get workoutNoPlanYetSubtitle =>
      'با ثبت اطلاعات و سوابق تمرینی خود، برنامه تمرینی اختصاصی هوشمند دریافت کنید.';

  @override
  String get workoutNewPlan => 'برنامه جدید';

  @override
  String get workoutProgressionNotes => 'نکات پیشرفت';

  @override
  String get workoutSafetyNotes => 'نکات ایمنی';

  @override
  String get workoutWarmup => 'گرم کردن';

  @override
  String get workoutMain => 'تمرین اصلی';

  @override
  String get workoutCooldown => 'سرد کردن';

  @override
  String get workoutRestDay => 'روز استراحت و ریکاوری';

  @override
  String get workoutRestDayDesc =>
      'امروز روز ریکاوری و بازسازی عضلات است. استراحت کافی، خواب مناسب و آب‌رسانی به بدن را جدی بگیرید.';

  @override
  String workoutSetsReps(int sets, String reps) {
    return '$sets ست × $reps تکرار';
  }

  @override
  String workoutSetsDuration(int sets, int sec) {
    return '$sets ست × $sec ثانیه';
  }

  @override
  String workoutRest(int sec) {
    return 'استراحت: $sec ثانیه';
  }

  @override
  String workoutRpe(String rpe) {
    return 'فشار (RPE): $rpe';
  }

  @override
  String get workoutSwapExercise => 'تعویض حرکت';

  @override
  String get workoutMedicalReferralTitle => 'نیاز به ارجاع پزشکی';

  @override
  String get workoutMedicalReferralDialogGotIt => 'متوجه شدم';

  @override
  String get workoutGeneratingPlanTitle =>
      'در حال ساخت برنامه تمرینی هوشمند...';

  @override
  String get workoutGeneratingPlanMessage =>
      'برنامه تمرینی اختصاصی شما بر اساس سطح، اهداف و شرایط بدنی در حال تنظیم است.';

  @override
  String get workoutToday => 'امروز';

  @override
  String get workoutFocusMuscles => 'عضلات هدف:';

  @override
  String workoutDuration(int minutes) {
    return '$minutes دقیقه';
  }

  @override
  String get workoutEditProfile => 'ویرایش پروفایل تمرینی';

  @override
  String get workoutProfileSaved => 'پروفایل تمرینی با موفقیت ذخیره شد';

  @override
  String get workoutRestShort => 'استراحت';

  @override
  String workoutSetsOnly(int sets) {
    return '$sets ست';
  }

  @override
  String get workoutWeeklyGenerationsTitle => 'تولید هفتگی';

  @override
  String get workoutDailySwapsTitle => 'تعویض روزانه';

  @override
  String get workoutSelectDisciplinesHint =>
      'لطفاً ۱ یا ۲ رشته ورزشی مورد علاقه خود را انتخاب کنید:';

  @override
  String get workoutFitnessLevelLabel => 'سطح آمادگی جسمانی:';

  @override
  String workoutDisciplineStyleLabel(String discipline) {
    return 'سبک $discipline:';
  }

  @override
  String get workoutSelectGoalHint => 'هدف اصلی خود را انتخاب کنید:';

  @override
  String workoutDaysCount(int count) {
    return '$count روز';
  }

  @override
  String workoutMinutesCount(int count) {
    return '$count دقیقه';
  }

  @override
  String get workoutInjuriesLabel => 'آسیب‌ها یا نواحی دردناک:';

  @override
  String workoutExerciseSwappedSuccess(int remaining) {
    return 'حرکت با موفقیت تعویض شد. $remaining تعویض دیگر باقی مانده است.';
  }

  @override
  String get workoutHistoryTitle => 'تاریخچه برنامه‌های تمرینی';

  @override
  String get workoutHistoryEmpty => 'تاریخچه‌ای یافت نشد';

  @override
  String workoutHistoryDays(int count) {
    return '$count روز در هفته';
  }

  @override
  String get workoutStatusActive => 'فعال';

  @override
  String get workoutStatusArchived => 'بایگانی‌شده';

  @override
  String get workoutHistoryDeleteConfirmTitle => 'حذف برنامه تمرینی';

  @override
  String get workoutHistoryDeleteConfirmBody =>
      'آیا از حذف این برنامه تمرینی اطمینان دارید؟';

  @override
  String get workoutHistoryDeleteConfirmConfirm => 'حذف';

  @override
  String get workoutHistoryDeleteConfirmCancel => 'انصراف';

  @override
  String get workoutHistoryDeleteSuccess => 'برنامه با موفقیت حذف شد';

  @override
  String get workoutPlanDetailTitle => 'جزئیات برنامه تمرینی';

  @override
  String get workoutRegeneratePromptTitle => 'برنامه تمرینی به‌روزرسانی شود؟';

  @override
  String get workoutRegeneratePromptBody =>
      'مشخصات شما تغییر کرد. می‌خواهید برنامه تمرینی بر اساس اطلاعات جدید دوباره ساخته شود؟';

  @override
  String get workoutRegenerateConfirm => 'بله، بازتولید کن';

  @override
  String get workoutRegenerateDismiss => 'فعلاً نه';

  @override
  String get workoutPlanRegenerated => 'برنامه تمرینی جدید با موفقیت ساخته شد';
}
