import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'FitSho'**
  String get appName;

  /// No description provided for @appNamePersian.
  ///
  /// In en, this message translates to:
  /// **'فیت‌شو'**
  String get appNamePersian;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginWithMobile.
  ///
  /// In en, this message translates to:
  /// **'Login with mobile number'**
  String get loginWithMobile;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your Iranian mobile number to receive a verification code'**
  String get loginSubtitle;

  /// No description provided for @mobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumberLabel;

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'09XXXXXXXXX'**
  String get mobileNumberHint;

  /// No description provided for @invalidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number (09XXXXXXXXX)'**
  String get invalidMobileNumber;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get sendOtp;

  /// No description provided for @legalAgreementPrefix.
  ///
  /// In en, this message translates to:
  /// **'By logging in or signing up for FitSho, you agree to our '**
  String get legalAgreementPrefix;

  /// No description provided for @legalTermsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get legalTermsLink;

  /// No description provided for @legalAgreementMiddle.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get legalAgreementMiddle;

  /// No description provided for @legalPrivacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalPrivacyLink;

  /// No description provided for @legalAgreementSuffix.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get legalAgreementSuffix;

  /// No description provided for @legalTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get legalTermsTitle;

  /// No description provided for @legalTermsContent.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FitSho. By using this app, you agree to the following:\n\n1. Medical Disclaimer: FitSho is an AI-based smart assistant. All provided plans are suggestions. If you have a specific illness, pregnancy, or special medical conditions, be sure to consult a doctor before starting a diet.\n\n2. Accuracy of Information: Responsibility for the accuracy of entered information (weight, height, age) lies with the user.\n\n3. Fair Use: Any attempt at unauthorized data extraction or abuse of the app\'s AI is prohibited.\n\n4. Changes: FitSho reserves the right to update its rules at any time to improve services.'**
  String get legalTermsContent;

  /// No description provided for @legalPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalPrivacyTitle;

  /// No description provided for @legalPrivacyContent.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is a red line for FitSho:\n\n1. Data Collection: We receive your physical information solely to accurately calculate diets and calorie counting.\n\n2. Data Security: All your data is kept encrypted on our secure servers.\n\n3. No Sharing: FitSho will never share your personal or contact information with advertising companies or third parties.\n\n4. Right to Delete Data: You can permanently delete your account and all associated data at any time through profile settings.'**
  String get legalPrivacyContent;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {mobile}'**
  String otpSubtitle(String mobile);

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify and continue'**
  String get verifyOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendOtp;

  /// No description provided for @resendOtpCountdown.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String resendOtpCountdown(String time);

  /// No description provided for @resendOtpCountdownPrefix.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get resendOtpCountdownPrefix;

  /// No description provided for @resendOtpCountdownSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get resendOtpCountdownSuffix;

  /// No description provided for @editMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Edit number'**
  String get editMobileNumber;

  /// No description provided for @otpEnterInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code'**
  String get otpEnterInstruction;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get otpSentSuccess;

  /// No description provided for @otpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code'**
  String get otpInvalid;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navWeeklyPlan.
  ///
  /// In en, this message translates to:
  /// **'Weekly Plan'**
  String get navWeeklyPlan;

  /// No description provided for @navSupplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get navSupplements;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @profileTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTabTitle;

  /// No description provided for @profileTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Profile and settings — Phase 6'**
  String get profileTabDescription;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayNameLabel;

  /// No description provided for @displayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get displayNameHint;

  /// No description provided for @displayNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Display name is required'**
  String get displayNameRequired;

  /// No description provided for @noDisplayName.
  ///
  /// In en, this message translates to:
  /// **'No name set'**
  String get noDisplayName;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveProfile;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  /// No description provided for @contactUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUsTitle;

  /// No description provided for @contactUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Questions or feedback? Send us an email.'**
  String get contactUsSubtitle;

  /// No description provided for @contactUsNoMailApp.
  ///
  /// In en, this message translates to:
  /// **'No email app found. The address was copied instead.'**
  String get contactUsNoMailApp;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all your data. This action cannot be undone.'**
  String get deleteAccountConfirmation;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Route not found: {path}'**
  String routeNotFound(String path);

  /// No description provided for @managePreferences.
  ///
  /// In en, this message translates to:
  /// **'Dietary preferences'**
  String get managePreferences;

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTitle;

  /// No description provided for @preferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose dietary restrictions and cuisines you prefer. These help personalize recipe suggestions.'**
  String get preferencesSubtitle;

  /// No description provided for @preferencesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'You have not set preferences yet. Select options below and save.'**
  String get preferencesEmptyHint;

  /// No description provided for @dietaryRestrictionsSection.
  ///
  /// In en, this message translates to:
  /// **'Dietary restrictions'**
  String get dietaryRestrictionsSection;

  /// No description provided for @preferredCuisinesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferred cuisines'**
  String get preferredCuisinesSection;

  /// No description provided for @savePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save preferences'**
  String get savePreferences;

  /// No description provided for @deletePreferences.
  ///
  /// In en, this message translates to:
  /// **'Delete preferences'**
  String get deletePreferences;

  /// No description provided for @deletePreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete preferences'**
  String get deletePreferencesTitle;

  /// No description provided for @deletePreferencesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your preferences?'**
  String get deletePreferencesConfirmation;

  /// No description provided for @preferencesSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved successfully'**
  String get preferencesSavedSuccess;

  /// No description provided for @preferencesDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Preferences deleted successfully'**
  String get preferencesDeletedSuccess;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @dietaryVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietaryVegan;

  /// No description provided for @dietaryVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietaryVegetarian;

  /// No description provided for @dietaryGlutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-free'**
  String get dietaryGlutenFree;

  /// No description provided for @dietaryDairyFree.
  ///
  /// In en, this message translates to:
  /// **'Dairy-free'**
  String get dietaryDairyFree;

  /// No description provided for @dietaryHalal.
  ///
  /// In en, this message translates to:
  /// **'Halal'**
  String get dietaryHalal;

  /// No description provided for @dietaryLowCarb.
  ///
  /// In en, this message translates to:
  /// **'Low-carb'**
  String get dietaryLowCarb;

  /// No description provided for @dietaryNutFree.
  ///
  /// In en, this message translates to:
  /// **'Nut-free'**
  String get dietaryNutFree;

  /// No description provided for @cuisinePersian.
  ///
  /// In en, this message translates to:
  /// **'Persian'**
  String get cuisinePersian;

  /// No description provided for @cuisineItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get cuisineItalian;

  /// No description provided for @cuisineMediterranean.
  ///
  /// In en, this message translates to:
  /// **'Mediterranean'**
  String get cuisineMediterranean;

  /// No description provided for @cuisineIndian.
  ///
  /// In en, this message translates to:
  /// **'Indian'**
  String get cuisineIndian;

  /// No description provided for @cuisineChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get cuisineChinese;

  /// No description provided for @cuisineMexican.
  ///
  /// In en, this message translates to:
  /// **'Mexican'**
  String get cuisineMexican;

  /// No description provided for @cuisineTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get cuisineTurkish;

  /// No description provided for @cuisineFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get cuisineFrench;

  /// No description provided for @aiProviderFailure.
  ///
  /// In en, this message translates to:
  /// **'AI service is temporarily unavailable. Please try again.'**
  String get aiProviderFailure;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get networkError;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get sessionExpired;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @dietOnboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Diet profile'**
  String get dietOnboardingTitle;

  /// No description provided for @dietOnboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to get a personalized weekly plan.'**
  String get dietOnboardingSubtitle;

  /// No description provided for @dietAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age (years)'**
  String get dietAgeLabel;

  /// No description provided for @dietHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get dietHeightLabel;

  /// No description provided for @dietWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get dietWeightLabel;

  /// No description provided for @dietGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get dietGenderLabel;

  /// No description provided for @dietGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get dietGenderMale;

  /// No description provided for @dietGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get dietGenderFemale;

  /// No description provided for @dietJobLabel.
  ///
  /// In en, this message translates to:
  /// **'Job (optional)'**
  String get dietJobLabel;

  /// No description provided for @dietGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get dietGoalLabel;

  /// No description provided for @dietGoalNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal notes (optional)'**
  String get dietGoalNotesLabel;

  /// No description provided for @dietActivityLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get dietActivityLevelLabel;

  /// No description provided for @dietDoesExerciseLabel.
  ///
  /// In en, this message translates to:
  /// **'I exercise'**
  String get dietDoesExerciseLabel;

  /// No description provided for @dietExerciseTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise type'**
  String get dietExerciseTypeLabel;

  /// No description provided for @dietExerciseDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise days per week (1–7)'**
  String get dietExerciseDaysLabel;

  /// No description provided for @dietDietaryPreferencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Dietary preferences'**
  String get dietDietaryPreferencesLabel;

  /// No description provided for @dietAllergiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Allergies (optional)'**
  String get dietAllergiesLabel;

  /// No description provided for @dietSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get dietSaveProfile;

  /// No description provided for @dietProfileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit diet profile'**
  String get dietProfileEditTitle;

  /// No description provided for @dietRegeneratePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Update your weekly plan?'**
  String get dietRegeneratePromptTitle;

  /// No description provided for @dietRegeneratePromptBody.
  ///
  /// In en, this message translates to:
  /// **'Your details have changed. Would you like to regenerate your weekly plan based on the new information?'**
  String get dietRegeneratePromptBody;

  /// No description provided for @dietRegenerateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, regenerate'**
  String get dietRegenerateConfirm;

  /// No description provided for @dietRegenerateDismiss.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get dietRegenerateDismiss;

  /// No description provided for @dietPlanRegenerated.
  ///
  /// In en, this message translates to:
  /// **'A new weekly plan was generated successfully'**
  String get dietPlanRegenerated;

  /// No description provided for @dietFormValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required fields'**
  String get dietFormValidationError;

  /// No description provided for @dietDaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get dietDaySaturday;

  /// No description provided for @dietDaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get dietDaySunday;

  /// No description provided for @dietDayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get dietDayMonday;

  /// No description provided for @dietDayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get dietDayTuesday;

  /// No description provided for @dietDayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get dietDayWednesday;

  /// No description provided for @dietDayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get dietDayThursday;

  /// No description provided for @dietDayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get dietDayFriday;

  /// No description provided for @dietSlotBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get dietSlotBreakfast;

  /// No description provided for @dietSlotMorningSnack.
  ///
  /// In en, this message translates to:
  /// **'Morning snack'**
  String get dietSlotMorningSnack;

  /// No description provided for @dietSlotLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get dietSlotLunch;

  /// No description provided for @dietSlotAfternoonSnack.
  ///
  /// In en, this message translates to:
  /// **'Afternoon snack'**
  String get dietSlotAfternoonSnack;

  /// No description provided for @dietSlotDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dietSlotDinner;

  /// No description provided for @dietGeneratePlan.
  ///
  /// In en, this message translates to:
  /// **'Generate weekly plan'**
  String get dietGeneratePlan;

  /// No description provided for @dietIAteThis.
  ///
  /// In en, this message translates to:
  /// **'I ate this'**
  String get dietIAteThis;

  /// No description provided for @dietLastMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Last meal'**
  String get dietLastMealTitle;

  /// No description provided for @dietMealTimesSettings.
  ///
  /// In en, this message translates to:
  /// **'Meal times'**
  String get dietMealTimesSettings;

  /// No description provided for @dietSupplementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get dietSupplementsTitle;

  /// No description provided for @dietSupplementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No supplements yet'**
  String get dietSupplementsEmpty;

  /// No description provided for @dietSupplementsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add supplements or medications to get reminded at the right time.'**
  String get dietSupplementsEmptySubtitle;

  /// No description provided for @dietNoPlanYet.
  ///
  /// In en, this message translates to:
  /// **'No plan yet. Tap generate to create one.'**
  String get dietNoPlanYet;

  /// No description provided for @dietNoPlanYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate an AI-powered weekly plan based on your profile.'**
  String get dietNoPlanYetSubtitle;

  /// No description provided for @dietWeeklyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly plan'**
  String get dietWeeklyPlanTitle;

  /// No description provided for @dietDailyCalorieTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily calorie target: {calories} kcal'**
  String dietDailyCalorieTarget(String calories);

  /// No description provided for @dietIngredientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get dietIngredientsTitle;

  /// No description provided for @dietCaloriesShort.
  ///
  /// In en, this message translates to:
  /// **'{value} cal'**
  String dietCaloriesShort(String value);

  /// No description provided for @dietProteinShort.
  ///
  /// In en, this message translates to:
  /// **'Protein {value}g'**
  String dietProteinShort(String value);

  /// No description provided for @dietCarbsShort.
  ///
  /// In en, this message translates to:
  /// **'Carbs {value}g'**
  String dietCarbsShort(String value);

  /// No description provided for @dietFatShort.
  ///
  /// In en, this message translates to:
  /// **'Fat {value}g'**
  String dietFatShort(String value);

  /// No description provided for @dietUnknownMeal.
  ///
  /// In en, this message translates to:
  /// **'Unknown meal'**
  String get dietUnknownMeal;

  /// No description provided for @dietGoalLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose weight'**
  String get dietGoalLoseWeight;

  /// No description provided for @dietGoalMaintainWeight.
  ///
  /// In en, this message translates to:
  /// **'Maintain weight'**
  String get dietGoalMaintainWeight;

  /// No description provided for @dietGoalGainWeight.
  ///
  /// In en, this message translates to:
  /// **'Gain weight / muscle'**
  String get dietGoalGainWeight;

  /// No description provided for @dietActivitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get dietActivitySedentary;

  /// No description provided for @dietActivityLight.
  ///
  /// In en, this message translates to:
  /// **'Lightly active'**
  String get dietActivityLight;

  /// No description provided for @dietActivityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderately active'**
  String get dietActivityModerate;

  /// No description provided for @dietActivityVeryActive.
  ///
  /// In en, this message translates to:
  /// **'Very active'**
  String get dietActivityVeryActive;

  /// No description provided for @dietActivityExtraActive.
  ///
  /// In en, this message translates to:
  /// **'Extra active'**
  String get dietActivityExtraActive;

  /// No description provided for @dietAddSupplement.
  ///
  /// In en, this message translates to:
  /// **'Add supplement'**
  String get dietAddSupplement;

  /// No description provided for @dietEditSupplement.
  ///
  /// In en, this message translates to:
  /// **'Edit supplement'**
  String get dietEditSupplement;

  /// No description provided for @dietSupplementNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplement name'**
  String get dietSupplementNameLabel;

  /// No description provided for @dietSupplementDosageLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage / instructions'**
  String get dietSupplementDosageLabel;

  /// No description provided for @dietSupplementTimesLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder times'**
  String get dietSupplementTimesLabel;

  /// No description provided for @dietAddTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get dietAddTime;

  /// No description provided for @dietSupplementLinkedMealLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked meal'**
  String get dietSupplementLinkedMealLabel;

  /// No description provided for @dietNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get dietNone;

  /// No description provided for @dietHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Diet History'**
  String get dietHistoryTitle;

  /// No description provided for @dietHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No diet history found'**
  String get dietHistoryEmpty;

  /// No description provided for @dietSlotNotificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Receive reminder notification'**
  String get dietSlotNotificationLabel;

  /// No description provided for @dietHistoryDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete plan'**
  String get dietHistoryDeleteConfirmTitle;

  /// No description provided for @dietHistoryDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this diet plan?'**
  String get dietHistoryDeleteConfirmBody;

  /// No description provided for @dietHistoryDeleteConfirmConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dietHistoryDeleteConfirmConfirm;

  /// No description provided for @dietHistoryDeleteConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dietHistoryDeleteConfirmCancel;

  /// No description provided for @dietHistoryDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Plan deleted successfully'**
  String get dietHistoryDeleteSuccess;

  /// No description provided for @dietHoursLeft.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours left'**
  String dietHoursLeft(String hours);

  /// No description provided for @dietDailyProgress.
  ///
  /// In en, this message translates to:
  /// **'Daily progress'**
  String get dietDailyProgress;

  /// No description provided for @dietHealthStats.
  ///
  /// In en, this message translates to:
  /// **'Health stats'**
  String get dietHealthStats;

  /// No description provided for @dietDailyWaterGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily water goal'**
  String get dietDailyWaterGoal;

  /// No description provided for @dietLiters.
  ///
  /// In en, this message translates to:
  /// **'{value} Liters'**
  String dietLiters(String value);

  /// No description provided for @dietDailyCalories.
  ///
  /// In en, this message translates to:
  /// **'{value} daily calories'**
  String dietDailyCalories(String value);

  /// No description provided for @dietSupplementsRequirementHint.
  ///
  /// In en, this message translates to:
  /// **'To add and manage supplements, you first need to generate your meal plan from the dashboard.'**
  String get dietSupplementsRequirementHint;

  /// No description provided for @dietSupplementUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error updating supplement status'**
  String get dietSupplementUpdateError;

  /// No description provided for @dietEaten.
  ///
  /// In en, this message translates to:
  /// **'Eaten ✓'**
  String get dietEaten;

  /// No description provided for @dietDailyMealSlots.
  ///
  /// In en, this message translates to:
  /// **'Daily meals'**
  String get dietDailyMealSlots;

  /// No description provided for @dietRegenerateButton.
  ///
  /// In en, this message translates to:
  /// **'Generate new plan'**
  String get dietRegenerateButton;

  /// No description provided for @dietWeightChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your weight has changed!'**
  String get dietWeightChangedTitle;

  /// No description provided for @dietWeightChangedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Would you like a new plan to be generated based on your new profile?'**
  String get dietWeightChangedSubtitle;

  /// No description provided for @dietAgeValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid value'**
  String get dietAgeValidation;

  /// No description provided for @dietHeightValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid value'**
  String get dietHeightValidation;

  /// No description provided for @dietWeightValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid value'**
  String get dietWeightValidation;

  /// No description provided for @dietExerciseDaysValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid value'**
  String get dietExerciseDaysValidation;

  /// No description provided for @dietBmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get dietBmiUnderweight;

  /// No description provided for @dietBmiNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get dietBmiNormal;

  /// No description provided for @dietBmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get dietBmiOverweight;

  /// No description provided for @dietBmiObesity.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get dietBmiObesity;

  /// No description provided for @dietCaloriesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{value} calories remaining'**
  String dietCaloriesRemaining(String value);

  /// No description provided for @dietOverConsumed.
  ///
  /// In en, this message translates to:
  /// **'Over-consumed!'**
  String get dietOverConsumed;

  /// No description provided for @dietComplianceHigh.
  ///
  /// In en, this message translates to:
  /// **'Great! keep going 🏆'**
  String get dietComplianceHigh;

  /// No description provided for @dietComplianceLow.
  ///
  /// In en, this message translates to:
  /// **'Try a bit harder, you can do it! 💪'**
  String get dietComplianceLow;

  /// No description provided for @dietComplianceLabel.
  ///
  /// In en, this message translates to:
  /// **'Diet compliance'**
  String get dietComplianceLabel;

  /// No description provided for @dietDailyCalorieTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily calorie target'**
  String get dietDailyCalorieTargetLabel;

  /// No description provided for @dietTdeeLabel.
  ///
  /// In en, this message translates to:
  /// **'TDEE: {value}'**
  String dietTdeeLabel(String value);

  /// No description provided for @dietBmiLabel.
  ///
  /// In en, this message translates to:
  /// **'BMI ({status})'**
  String dietBmiLabel(String status);

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @dietReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Diet Reminder'**
  String get dietReminderTitle;

  /// No description provided for @dietReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Your meal time is near.'**
  String get dietReminderBody;

  /// No description provided for @dietSupplementLinkedMealRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select the linked meal'**
  String get dietSupplementLinkedMealRequired;

  /// No description provided for @forceUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Mandatory update'**
  String get forceUpdateTitle;

  /// No description provided for @forceUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'To continue using the app, you must update to the latest version.'**
  String get forceUpdateMessage;

  /// No description provided for @optionalUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get optionalUpdateTitle;

  /// No description provided for @optionalUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of FitSho is available. Would you like to update?'**
  String get optionalUpdateMessage;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Smart Meal Planning'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Get personalized meal plans with FitSho\'s artificial intelligence.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Track Daily Progress'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Easily record and manage your calorie intake and workout activities.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Achieve Ideal Body'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'We are with you every step of the way to achieve your health goals.'**
  String get onboardingSubtitle3;

  /// No description provided for @aiGeneratingPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'AI is analyzing...'**
  String get aiGeneratingPlanTitle;

  /// No description provided for @aiGeneratingPlanMessage.
  ///
  /// In en, this message translates to:
  /// **'Please be patient, FitSho\'s AI is formulating the best meal plan based on your physique and goals.'**
  String get aiGeneratingPlanMessage;

  /// No description provided for @dietCalorieGoalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Calorie goal completed 🎯'**
  String get dietCalorieGoalCompleted;

  /// No description provided for @dietGeneratePlanAction.
  ///
  /// In en, this message translates to:
  /// **'Generate Plan'**
  String get dietGeneratePlanAction;

  /// No description provided for @dietChangePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Diet Plan'**
  String get dietChangePlanTitle;

  /// No description provided for @dietChangePlanLimit.
  ///
  /// In en, this message translates to:
  /// **'Limit 3 times per week'**
  String get dietChangePlanLimit;

  /// No description provided for @dietRemainingSwaps.
  ///
  /// In en, this message translates to:
  /// **'{value} remaining'**
  String dietRemainingSwaps(String value);

  /// No description provided for @dietWeeklyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You have changed your diet 3 times this week.'**
  String get dietWeeklyLimitReached;

  /// No description provided for @dietSwapMealTooltip.
  ///
  /// In en, this message translates to:
  /// **'Swap meal'**
  String get dietSwapMealTooltip;

  /// No description provided for @dietRemainingMealSwaps.
  ///
  /// In en, this message translates to:
  /// **'{value} meal swaps remaining today'**
  String dietRemainingMealSwaps(String value);

  /// No description provided for @dietMealTimeSameError.
  ///
  /// In en, this message translates to:
  /// **'Meal times for \"{meal1}\" and \"{meal2}\" cannot be the same.'**
  String dietMealTimeSameError(String meal1, String meal2);

  /// No description provided for @dietMealTimeOrderError.
  ///
  /// In en, this message translates to:
  /// **'\"{laterMeal}\" must be scheduled after \"{earlierMeal}\".'**
  String dietMealTimeOrderError(String laterMeal, String earlierMeal);

  /// No description provided for @dietMealTimeGapError.
  ///
  /// In en, this message translates to:
  /// **'Leave at least 60 minutes between \"{meal1}\" and \"{meal2}\".'**
  String dietMealTimeGapError(String meal1, String meal2);

  /// No description provided for @dietMealReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'{meal} time 🥗'**
  String dietMealReminderTitle(String meal);

  /// No description provided for @dietMealReminderBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for your {meal}.'**
  String dietMealReminderBody(String meal);

  /// No description provided for @notificationMealReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'{slot} Reminder'**
  String notificationMealReminderTitle(String slot);

  /// No description provided for @notificationMealTimeForSlot.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for {slot}.'**
  String notificationMealTimeForSlot(String slot);

  /// No description provided for @notificationDietPlanSummary.
  ///
  /// In en, this message translates to:
  /// **'Diet Plan'**
  String get notificationDietPlanSummary;

  /// No description provided for @notificationMealTicker.
  ///
  /// In en, this message translates to:
  /// **'Meal Reminder'**
  String get notificationMealTicker;

  /// No description provided for @notificationMealChannelName.
  ///
  /// In en, this message translates to:
  /// **'Meal Reminders'**
  String get notificationMealChannelName;

  /// No description provided for @notificationMealChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications for scheduled meal times'**
  String get notificationMealChannelDesc;

  /// No description provided for @autostartPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Accurate Meal Reminders'**
  String get autostartPromptTitle;

  /// No description provided for @autostartPromptBody.
  ///
  /// In en, this message translates to:
  /// **'To ensure your diet reminders work accurately even when the app is closed, please grant background activity (AutoStart) permission to FitSho.'**
  String get autostartPromptBody;

  /// No description provided for @autostartPromptEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get autostartPromptEnable;

  /// No description provided for @autostartPromptLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get autostartPromptLater;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @workoutOnboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Profile Setup'**
  String get workoutOnboardingTitle;

  /// No description provided for @workoutStepDisciplines.
  ///
  /// In en, this message translates to:
  /// **'Select Disciplines'**
  String get workoutStepDisciplines;

  /// No description provided for @workoutStepStyleLevel.
  ///
  /// In en, this message translates to:
  /// **'Level & Style'**
  String get workoutStepStyleLevel;

  /// No description provided for @workoutStepGoal.
  ///
  /// In en, this message translates to:
  /// **'Workout Goal'**
  String get workoutStepGoal;

  /// No description provided for @workoutStepConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions & Equipment'**
  String get workoutStepConditions;

  /// No description provided for @workoutStepInjuries.
  ///
  /// In en, this message translates to:
  /// **'Injuries & Health'**
  String get workoutStepInjuries;

  /// No description provided for @workoutMaxDisciplinesWarning.
  ///
  /// In en, this message translates to:
  /// **'You can select a maximum of 2 disciplines.'**
  String get workoutMaxDisciplinesWarning;

  /// No description provided for @workoutMedicalReferralWarning.
  ///
  /// In en, this message translates to:
  /// **'Due to severe pain or injury, please consult a physician before starting exercise.'**
  String get workoutMedicalReferralWarning;

  /// No description provided for @workoutNoInjuries.
  ///
  /// In en, this message translates to:
  /// **'No injuries'**
  String get workoutNoInjuries;

  /// No description provided for @workoutPainLevel.
  ///
  /// In en, this message translates to:
  /// **'Pain level (0 to 10):'**
  String get workoutPainLevel;

  /// No description provided for @workoutInjuryNotes.
  ///
  /// In en, this message translates to:
  /// **'Injury notes (optional)'**
  String get workoutInjuryNotes;

  /// No description provided for @workoutDaysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Days per week:'**
  String get workoutDaysPerWeek;

  /// No description provided for @workoutSessionMinutes.
  ///
  /// In en, this message translates to:
  /// **'Session minutes:'**
  String get workoutSessionMinutes;

  /// No description provided for @workoutLocation.
  ///
  /// In en, this message translates to:
  /// **'Workout location:'**
  String get workoutLocation;

  /// No description provided for @workoutEquipment.
  ///
  /// In en, this message translates to:
  /// **'Available equipment:'**
  String get workoutEquipment;

  /// No description provided for @workoutSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get workoutSaveProfile;

  /// No description provided for @workoutTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workoutTabTitle;

  /// No description provided for @workoutGeneratePlan.
  ///
  /// In en, this message translates to:
  /// **'Generate Workout Plan'**
  String get workoutGeneratePlan;

  /// No description provided for @workoutRemainingGenerations.
  ///
  /// In en, this message translates to:
  /// **'{count} generations left this week'**
  String workoutRemainingGenerations(int count);

  /// No description provided for @workoutRemainingSwaps.
  ///
  /// In en, this message translates to:
  /// **'{count} swaps left today'**
  String workoutRemainingSwaps(int count);

  /// No description provided for @workoutNeedDietFirst.
  ///
  /// In en, this message translates to:
  /// **'Please complete your diet profile first to access workout features.'**
  String get workoutNeedDietFirst;

  /// No description provided for @workoutGoToDietOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Complete Diet Profile'**
  String get workoutGoToDietOnboarding;

  /// No description provided for @workoutNoPlanYet.
  ///
  /// In en, this message translates to:
  /// **'No workout plan yet'**
  String get workoutNoPlanYet;

  /// No description provided for @workoutNoPlanYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate a personalized workout plan tailored to your fitness goals.'**
  String get workoutNoPlanYetSubtitle;

  /// No description provided for @workoutNewPlan.
  ///
  /// In en, this message translates to:
  /// **'New Plan'**
  String get workoutNewPlan;

  /// No description provided for @workoutProgressionNotes.
  ///
  /// In en, this message translates to:
  /// **'Progression Notes'**
  String get workoutProgressionNotes;

  /// No description provided for @workoutSafetyNotes.
  ///
  /// In en, this message translates to:
  /// **'Safety Notes'**
  String get workoutSafetyNotes;

  /// No description provided for @workoutWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get workoutWarmup;

  /// No description provided for @workoutMain.
  ///
  /// In en, this message translates to:
  /// **'Main Workout'**
  String get workoutMain;

  /// No description provided for @workoutCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get workoutCooldown;

  /// No description provided for @workoutRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest & Recovery Day'**
  String get workoutRestDay;

  /// No description provided for @workoutRestDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Today is dedicated to muscle recovery. Ensure adequate rest, sleep, and hydration.'**
  String get workoutRestDayDesc;

  /// No description provided for @workoutSetsReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets × {reps} reps'**
  String workoutSetsReps(int sets, String reps);

  /// No description provided for @workoutSetsDuration.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets × {sec}s'**
  String workoutSetsDuration(int sets, int sec);

  /// No description provided for @workoutRest.
  ///
  /// In en, this message translates to:
  /// **'Rest: {sec}s'**
  String workoutRest(int sec);

  /// No description provided for @workoutRpe.
  ///
  /// In en, this message translates to:
  /// **'RPE: {rpe}'**
  String workoutRpe(String rpe);

  /// No description provided for @workoutSwapExercise.
  ///
  /// In en, this message translates to:
  /// **'Swap Exercise'**
  String get workoutSwapExercise;

  /// No description provided for @workoutMedicalReferralTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Referral Required'**
  String get workoutMedicalReferralTitle;

  /// No description provided for @workoutMedicalReferralDialogGotIt.
  ///
  /// In en, this message translates to:
  /// **'I Understand'**
  String get workoutMedicalReferralDialogGotIt;

  /// No description provided for @workoutGeneratingPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Generating Workout Plan...'**
  String get workoutGeneratingPlanTitle;

  /// No description provided for @workoutGeneratingPlanMessage.
  ///
  /// In en, this message translates to:
  /// **'Your customized workout plan is being prepared based on your health and goals.'**
  String get workoutGeneratingPlanMessage;

  /// No description provided for @workoutToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get workoutToday;

  /// No description provided for @workoutFocusMuscles.
  ///
  /// In en, this message translates to:
  /// **'Focus Muscles:'**
  String get workoutFocusMuscles;

  /// No description provided for @workoutDuration.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String workoutDuration(int minutes);

  /// No description provided for @workoutEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Workout Profile'**
  String get workoutEditProfile;

  /// No description provided for @workoutProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Workout profile saved successfully'**
  String get workoutProfileSaved;

  /// No description provided for @workoutRestShort.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get workoutRestShort;

  /// No description provided for @workoutSetsOnly.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets'**
  String workoutSetsOnly(int sets);

  /// No description provided for @workoutWeeklyGenerationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Generations'**
  String get workoutWeeklyGenerationsTitle;

  /// No description provided for @workoutDailySwapsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Swaps'**
  String get workoutDailySwapsTitle;

  /// No description provided for @workoutSelectDisciplinesHint.
  ///
  /// In en, this message translates to:
  /// **'Please select 1 or 2 disciplines you prefer:'**
  String get workoutSelectDisciplinesHint;

  /// No description provided for @workoutFitnessLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Fitness level:'**
  String get workoutFitnessLevelLabel;

  /// No description provided for @workoutDisciplineStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'{discipline} style:'**
  String workoutDisciplineStyleLabel(String discipline);

  /// No description provided for @workoutSelectGoalHint.
  ///
  /// In en, this message translates to:
  /// **'Select your primary goal:'**
  String get workoutSelectGoalHint;

  /// No description provided for @workoutDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String workoutDaysCount(int count);

  /// No description provided for @workoutMinutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String workoutMinutesCount(int count);

  /// No description provided for @workoutInjuriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Injuries or painful areas:'**
  String get workoutInjuriesLabel;

  /// No description provided for @workoutExerciseSwappedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exercise swapped successfully. {remaining} swaps left today.'**
  String workoutExerciseSwappedSuccess(int remaining);

  /// No description provided for @workoutHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout History'**
  String get workoutHistoryTitle;

  /// No description provided for @workoutHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No workout history found'**
  String get workoutHistoryEmpty;

  /// No description provided for @workoutHistoryDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Workout Plan'**
  String get workoutHistoryDeleteConfirmTitle;

  /// No description provided for @workoutHistoryDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this workout plan?'**
  String get workoutHistoryDeleteConfirmBody;

  /// No description provided for @workoutHistoryDeleteConfirmConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get workoutHistoryDeleteConfirmConfirm;

  /// No description provided for @workoutHistoryDeleteConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get workoutHistoryDeleteConfirmCancel;

  /// No description provided for @workoutHistoryDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Plan deleted successfully'**
  String get workoutHistoryDeleteSuccess;

  /// No description provided for @workoutPlanDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Plan Details'**
  String get workoutPlanDetailTitle;

  /// No description provided for @workoutRegeneratePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Update your workout plan?'**
  String get workoutRegeneratePromptTitle;

  /// No description provided for @workoutRegeneratePromptBody.
  ///
  /// In en, this message translates to:
  /// **'Your details have changed. Would you like to regenerate your workout plan based on the new information?'**
  String get workoutRegeneratePromptBody;

  /// No description provided for @workoutRegenerateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, regenerate'**
  String get workoutRegenerateConfirm;

  /// No description provided for @workoutRegenerateDismiss.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get workoutRegenerateDismiss;

  /// No description provided for @workoutPlanRegenerated.
  ///
  /// In en, this message translates to:
  /// **'A new workout plan was generated successfully'**
  String get workoutPlanRegenerated;
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
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
