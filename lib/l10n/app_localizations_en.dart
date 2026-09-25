// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FitSho';

  @override
  String get appNamePersian => 'فیت‌شو';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginWithMobile => 'Login with mobile number';

  @override
  String get loginSubtitle =>
      'Enter your Iranian mobile number to receive a verification code';

  @override
  String get mobileNumberLabel => 'Mobile number';

  @override
  String get mobileNumberHint => '09XXXXXXXXX';

  @override
  String get invalidMobileNumber => 'Enter a valid mobile number (09XXXXXXXXX)';

  @override
  String get sendOtp => 'Send verification code';

  @override
  String get legalAgreementPrefix =>
      'By logging in or signing up for FitSho, you agree to our ';

  @override
  String get legalTermsLink => 'Terms & Conditions';

  @override
  String get legalAgreementMiddle => ' and ';

  @override
  String get legalPrivacyLink => 'Privacy Policy';

  @override
  String get legalAgreementSuffix => '.';

  @override
  String get legalTermsTitle => 'Terms & Conditions';

  @override
  String get legalTermsContent =>
      'Welcome to FitSho. By using this app, you agree to the following:\n\n1. Medical Disclaimer: FitSho is an AI-based smart assistant. All provided plans are suggestions. If you have a specific illness, pregnancy, or special medical conditions, be sure to consult a doctor before starting a diet.\n\n2. Accuracy of Information: Responsibility for the accuracy of entered information (weight, height, age) lies with the user.\n\n3. Fair Use: Any attempt at unauthorized data extraction or abuse of the app\'s AI is prohibited.\n\n4. Changes: FitSho reserves the right to update its rules at any time to improve services.';

  @override
  String get legalPrivacyTitle => 'Privacy Policy';

  @override
  String get legalPrivacyContent =>
      'Your privacy is a red line for FitSho:\n\n1. Data Collection: We receive your physical information solely to accurately calculate diets and calorie counting.\n\n2. Data Security: All your data is kept encrypted on our secure servers.\n\n3. No Sharing: FitSho will never share your personal or contact information with advertising companies or third parties.\n\n4. Right to Delete Data: You can permanently delete your account and all associated data at any time through profile settings.';

  @override
  String get gotIt => 'Got it';

  @override
  String get otpTitle => 'Verification code';

  @override
  String otpSubtitle(String mobile) {
    return 'Enter the 6-digit code sent to $mobile';
  }

  @override
  String get verifyOtp => 'Verify and continue';

  @override
  String get resendOtp => 'Resend code';

  @override
  String resendOtpCountdown(String time) {
    return 'Resend code in $time';
  }

  @override
  String get resendOtpCountdownPrefix => 'Resend code in';

  @override
  String get resendOtpCountdownSuffix => '';

  @override
  String get editMobileNumber => 'Edit number';

  @override
  String get otpEnterInstruction => 'Enter the 6-digit verification code';

  @override
  String get otpSentSuccess => 'Verification code sent';

  @override
  String get otpInvalid => 'Enter the 6-digit verification code';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navWeeklyPlan => 'Weekly Plan';

  @override
  String get navSupplements => 'Supplements';

  @override
  String get navProfile => 'Profile';

  @override
  String get profileTabTitle => 'Profile';

  @override
  String get profileTabDescription => 'Profile and settings — Phase 6';

  @override
  String get displayNameLabel => 'Display name';

  @override
  String get displayNameHint => 'Enter your name';

  @override
  String get displayNameRequired => 'Display name is required';

  @override
  String get noDisplayName => 'No name set';

  @override
  String get saveProfile => 'Save changes';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String get logout => 'Log out';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get contactUsTitle => 'Contact us';

  @override
  String get contactUsSubtitle => 'Questions or feedback? Send us an email.';

  @override
  String get contactUsNoMailApp =>
      'No email app found. The address was copied instead.';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountConfirmation =>
      'This will permanently delete your account and all your data. This action cannot be undone.';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get errorTitle => 'Error';

  @override
  String routeNotFound(String path) {
    return 'Route not found: $path';
  }

  @override
  String get managePreferences => 'Dietary preferences';

  @override
  String get preferencesTitle => 'Preferences';

  @override
  String get preferencesSubtitle =>
      'Choose dietary restrictions and cuisines you prefer. These help personalize recipe suggestions.';

  @override
  String get preferencesEmptyHint =>
      'You have not set preferences yet. Select options below and save.';

  @override
  String get dietaryRestrictionsSection => 'Dietary restrictions';

  @override
  String get preferredCuisinesSection => 'Preferred cuisines';

  @override
  String get savePreferences => 'Save preferences';

  @override
  String get deletePreferences => 'Delete preferences';

  @override
  String get deletePreferencesTitle => 'Delete preferences';

  @override
  String get deletePreferencesConfirmation =>
      'Are you sure you want to delete your preferences?';

  @override
  String get preferencesSavedSuccess => 'Preferences saved successfully';

  @override
  String get preferencesDeletedSuccess => 'Preferences deleted successfully';

  @override
  String get retry => 'Retry';

  @override
  String get dietaryVegan => 'Vegan';

  @override
  String get dietaryVegetarian => 'Vegetarian';

  @override
  String get dietaryGlutenFree => 'Gluten-free';

  @override
  String get dietaryDairyFree => 'Dairy-free';

  @override
  String get dietaryHalal => 'Halal';

  @override
  String get dietaryLowCarb => 'Low-carb';

  @override
  String get dietaryNutFree => 'Nut-free';

  @override
  String get cuisinePersian => 'Persian';

  @override
  String get cuisineItalian => 'Italian';

  @override
  String get cuisineMediterranean => 'Mediterranean';

  @override
  String get cuisineIndian => 'Indian';

  @override
  String get cuisineChinese => 'Chinese';

  @override
  String get cuisineMexican => 'Mexican';

  @override
  String get cuisineTurkish => 'Turkish';

  @override
  String get cuisineFrench => 'French';

  @override
  String get aiProviderFailure =>
      'AI service is temporarily unavailable. Please try again.';

  @override
  String get networkError =>
      'No internet connection. Check your network and try again.';

  @override
  String get pressBackAgainToExit => 'Press back again to exit';

  @override
  String get sessionExpired => 'Your session has expired. Please log in again.';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get save => 'Save';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get dietOnboardingTitle => 'Diet profile';

  @override
  String get dietOnboardingSubtitle =>
      'Enter your details to get a personalized weekly plan.';

  @override
  String get dietAgeLabel => 'Age (years)';

  @override
  String get dietHeightLabel => 'Height (cm)';

  @override
  String get dietWeightLabel => 'Weight (kg)';

  @override
  String get dietGenderLabel => 'Gender';

  @override
  String get dietGenderMale => 'Male';

  @override
  String get dietGenderFemale => 'Female';

  @override
  String get dietJobLabel => 'Job (optional)';

  @override
  String get dietGoalLabel => 'Goal';

  @override
  String get dietGoalNotesLabel => 'Goal notes (optional)';

  @override
  String get dietActivityLevelLabel => 'Activity level';

  @override
  String get dietDoesExerciseLabel => 'I exercise';

  @override
  String get dietExerciseTypeLabel => 'Exercise type';

  @override
  String get dietExerciseDaysLabel => 'Exercise days per week (1–7)';

  @override
  String get dietDietaryPreferencesLabel => 'Dietary preferences';

  @override
  String get dietAllergiesLabel => 'Allergies (optional)';

  @override
  String get dietSaveProfile => 'Save profile';

  @override
  String get dietProfileEditTitle => 'Edit diet profile';

  @override
  String get dietRegeneratePromptTitle => 'Update your weekly plan?';

  @override
  String get dietRegeneratePromptBody =>
      'Your details have changed. Would you like to regenerate your weekly plan based on the new information?';

  @override
  String get dietRegenerateConfirm => 'Yes, regenerate';

  @override
  String get dietRegenerateDismiss => 'Not now';

  @override
  String get dietPlanRegenerated =>
      'A new weekly plan was generated successfully';

  @override
  String get dietFormValidationError => 'Please complete all required fields';

  @override
  String get dietDaySaturday => 'Saturday';

  @override
  String get dietDaySunday => 'Sunday';

  @override
  String get dietDayMonday => 'Monday';

  @override
  String get dietDayTuesday => 'Tuesday';

  @override
  String get dietDayWednesday => 'Wednesday';

  @override
  String get dietDayThursday => 'Thursday';

  @override
  String get dietDayFriday => 'Friday';

  @override
  String get dietSlotBreakfast => 'Breakfast';

  @override
  String get dietSlotMorningSnack => 'Morning snack';

  @override
  String get dietSlotLunch => 'Lunch';

  @override
  String get dietSlotAfternoonSnack => 'Afternoon snack';

  @override
  String get dietSlotDinner => 'Dinner';

  @override
  String get dietGeneratePlan => 'Generate weekly plan';

  @override
  String get dietIAteThis => 'I ate this';

  @override
  String get dietLastMealTitle => 'Last meal';

  @override
  String get dietMealTimesSettings => 'Meal times';

  @override
  String get dietSupplementsTitle => 'Supplements';

  @override
  String get dietSupplementsEmpty => 'No supplements yet';

  @override
  String get dietSupplementsEmptySubtitle =>
      'Add supplements or medications to get reminded at the right time.';

  @override
  String get dietNoPlanYet => 'No plan yet. Tap generate to create one.';

  @override
  String get dietNoPlanYetSubtitle =>
      'Generate an AI-powered weekly plan based on your profile.';

  @override
  String get dietWeeklyPlanTitle => 'Weekly plan';

  @override
  String dietDailyCalorieTarget(String calories) {
    return 'Daily calorie target: $calories kcal';
  }

  @override
  String get dietIngredientsTitle => 'Ingredients';

  @override
  String dietCaloriesShort(String value) {
    return '$value cal';
  }

  @override
  String dietProteinShort(String value) {
    return 'Protein ${value}g';
  }

  @override
  String dietCarbsShort(String value) {
    return 'Carbs ${value}g';
  }

  @override
  String dietFatShort(String value) {
    return 'Fat ${value}g';
  }

  @override
  String get dietUnknownMeal => 'Unknown meal';

  @override
  String get dietGoalLoseWeight => 'Lose weight';

  @override
  String get dietGoalMaintainWeight => 'Maintain weight';

  @override
  String get dietGoalGainWeight => 'Gain weight / muscle';

  @override
  String get dietActivitySedentary => 'Sedentary';

  @override
  String get dietActivityLight => 'Lightly active';

  @override
  String get dietActivityModerate => 'Moderately active';

  @override
  String get dietActivityVeryActive => 'Very active';

  @override
  String get dietActivityExtraActive => 'Extra active';

  @override
  String get dietAddSupplement => 'Add supplement';

  @override
  String get dietEditSupplement => 'Edit supplement';

  @override
  String get dietSupplementNameLabel => 'Supplement name';

  @override
  String get dietSupplementDosageLabel => 'Dosage / instructions';

  @override
  String get dietSupplementTimesLabel => 'Reminder times';

  @override
  String get dietAddTime => 'Add time';

  @override
  String get dietSupplementLinkedMealLabel => 'Linked meal';

  @override
  String get dietNone => 'None';

  @override
  String get dietHistoryTitle => 'Diet History';

  @override
  String get dietHistoryEmpty => 'No diet history found';

  @override
  String get dietSlotNotificationLabel => 'Receive reminder notification';

  @override
  String get dietHistoryDeleteConfirmTitle => 'Delete plan';

  @override
  String get dietHistoryDeleteConfirmBody =>
      'Are you sure you want to delete this diet plan?';

  @override
  String get dietHistoryDeleteConfirmConfirm => 'Delete';

  @override
  String get dietHistoryDeleteConfirmCancel => 'Cancel';

  @override
  String get dietHistoryDeleteSuccess => 'Plan deleted successfully';

  @override
  String dietHoursLeft(String hours) {
    return '$hours hours left';
  }

  @override
  String get dietDailyProgress => 'Daily progress';

  @override
  String get dietHealthStats => 'Health stats';

  @override
  String get dietDailyWaterGoal => 'Daily water goal';

  @override
  String dietLiters(String value) {
    return '$value Liters';
  }

  @override
  String dietDailyCalories(String value) {
    return '$value daily calories';
  }

  @override
  String get dietSupplementsRequirementHint =>
      'To add and manage supplements, you first need to generate your meal plan from the dashboard.';

  @override
  String get dietSupplementUpdateError => 'Error updating supplement status';

  @override
  String get dietEaten => 'Eaten ✓';

  @override
  String get dietDailyMealSlots => 'Daily meals';

  @override
  String get dietRegenerateButton => 'Generate new plan';

  @override
  String get dietWeightChangedTitle => 'Your weight has changed!';

  @override
  String get dietWeightChangedSubtitle =>
      'Would you like a new plan to be generated based on your new profile?';

  @override
  String get dietAgeValidation => 'Please enter a valid value';

  @override
  String get dietHeightValidation => 'Please enter a valid value';

  @override
  String get dietWeightValidation => 'Please enter a valid value';

  @override
  String get dietExerciseDaysValidation => 'Please enter a valid value';

  @override
  String get dietBmiUnderweight => 'Underweight';

  @override
  String get dietBmiNormal => 'Normal';

  @override
  String get dietBmiOverweight => 'Overweight';

  @override
  String get dietBmiObesity => 'Obese';

  @override
  String dietCaloriesRemaining(String value) {
    return '$value calories remaining';
  }

  @override
  String get dietOverConsumed => 'Over-consumed!';

  @override
  String get dietComplianceHigh => 'Great! keep going 🏆';

  @override
  String get dietComplianceLow => 'Try a bit harder, you can do it! 💪';

  @override
  String get dietComplianceLabel => 'Diet compliance';

  @override
  String get dietDailyCalorieTargetLabel => 'Daily calorie target';

  @override
  String dietTdeeLabel(String value) {
    return 'TDEE: $value';
  }

  @override
  String dietBmiLabel(String status) {
    return 'BMI ($status)';
  }

  @override
  String get view => 'View';

  @override
  String get dietReminderTitle => 'Diet Reminder';

  @override
  String get dietReminderBody => 'Your meal time is near.';

  @override
  String get dietSupplementLinkedMealRequired =>
      'Please select the linked meal';

  @override
  String get forceUpdateTitle => 'Mandatory update';

  @override
  String get forceUpdateMessage =>
      'To continue using the app, you must update to the latest version.';

  @override
  String get optionalUpdateTitle => 'New version available';

  @override
  String get optionalUpdateMessage =>
      'A new version of FitSho is available. Would you like to update?';

  @override
  String get updateNow => 'Update now';

  @override
  String get later => 'Later';

  @override
  String get skip => 'Skip';

  @override
  String get start => 'Start';

  @override
  String get onboardingTitle1 => 'Smart Meal Planning';

  @override
  String get onboardingSubtitle1 =>
      'Get personalized meal plans with FitSho\'s artificial intelligence.';

  @override
  String get onboardingTitle2 => 'Track Daily Progress';

  @override
  String get onboardingSubtitle2 =>
      'Easily record and manage your calorie intake and workout activities.';

  @override
  String get onboardingTitle3 => 'Achieve Ideal Body';

  @override
  String get onboardingSubtitle3 =>
      'We are with you every step of the way to achieve your health goals.';

  @override
  String get aiGeneratingPlanTitle => 'AI is analyzing...';

  @override
  String get aiGeneratingPlanMessage =>
      'Please be patient, FitSho\'s AI is formulating the best meal plan based on your physique and goals.';

  @override
  String get dietCalorieGoalCompleted => 'Calorie goal completed 🎯';

  @override
  String get dietGeneratePlanAction => 'Generate Plan';

  @override
  String get dietChangePlanTitle => 'Change Diet Plan';

  @override
  String get dietChangePlanLimit => 'Limit 3 times per week';

  @override
  String dietRemainingSwaps(String value) {
    return '$value remaining';
  }

  @override
  String get dietWeeklyLimitReached =>
      'You have changed your diet 3 times this week.';

  @override
  String get dietSwapMealTooltip => 'Swap meal';

  @override
  String dietRemainingMealSwaps(String value) {
    return '$value meal swaps remaining today';
  }

  @override
  String dietMealTimeSameError(String meal1, String meal2) {
    return 'Meal times for \"$meal1\" and \"$meal2\" cannot be the same.';
  }

  @override
  String dietMealTimeOrderError(String laterMeal, String earlierMeal) {
    return '\"$laterMeal\" must be scheduled after \"$earlierMeal\".';
  }

  @override
  String dietMealTimeGapError(String meal1, String meal2) {
    return 'Leave at least 60 minutes between \"$meal1\" and \"$meal2\".';
  }

  @override
  String dietMealReminderTitle(String meal) {
    return '$meal time 🥗';
  }

  @override
  String dietMealReminderBody(String meal) {
    return 'It\'s time for your $meal.';
  }

  @override
  String notificationMealReminderTitle(String slot) {
    return '$slot Reminder';
  }

  @override
  String notificationMealTimeForSlot(String slot) {
    return 'It\'s time for $slot.';
  }

  @override
  String get notificationDietPlanSummary => 'Diet Plan';

  @override
  String get notificationMealTicker => 'Meal Reminder';

  @override
  String get notificationMealChannelName => 'Meal Reminders';

  @override
  String get notificationMealChannelDesc =>
      'Notifications for scheduled meal times';

  @override
  String get autostartPromptTitle => 'Accurate Meal Reminders';

  @override
  String get autostartPromptBody =>
      'To ensure your diet reminders work accurately even when the app is closed, please grant background activity (AutoStart) permission to FitSho.';

  @override
  String get autostartPromptEnable => 'Enable';

  @override
  String get autostartPromptLater => 'Later';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get workoutOnboardingTitle => 'Workout Profile Setup';

  @override
  String get workoutStepDisciplines => 'Select Disciplines';

  @override
  String get workoutStepStyleLevel => 'Level & Style';

  @override
  String get workoutStepGoal => 'Workout Goal';

  @override
  String get workoutStepConditions => 'Conditions & Equipment';

  @override
  String get workoutStepInjuries => 'Injuries & Health';

  @override
  String get workoutMaxDisciplinesWarning =>
      'You can select a maximum of 2 disciplines.';

  @override
  String get workoutMedicalReferralWarning =>
      'Due to severe pain or injury, please consult a physician before starting exercise.';

  @override
  String get workoutNoInjuries => 'No injuries';

  @override
  String get workoutPainLevel => 'Pain level (0 to 10):';

  @override
  String get workoutInjuryNotes => 'Injury notes (optional)';

  @override
  String get workoutDaysPerWeek => 'Days per week:';

  @override
  String get workoutSessionMinutes => 'Session minutes:';

  @override
  String get workoutLocation => 'Workout location:';

  @override
  String get workoutEquipment => 'Available equipment:';

  @override
  String get workoutSaveProfile => 'Save & Continue';

  @override
  String get workoutTabTitle => 'Workout';

  @override
  String get workoutGeneratePlan => 'Generate Workout Plan';

  @override
  String workoutRemainingGenerations(int count) {
    return '$count generations left this week';
  }

  @override
  String workoutRemainingSwaps(int count) {
    return '$count swaps left today';
  }

  @override
  String get workoutNeedDietFirst =>
      'Please complete your diet profile first to access workout features.';

  @override
  String get workoutGoToDietOnboarding => 'Complete Diet Profile';

  @override
  String get workoutNoPlanYet => 'No workout plan yet';

  @override
  String get workoutNoPlanYetSubtitle =>
      'Generate a personalized workout plan tailored to your fitness goals.';

  @override
  String get workoutNewPlan => 'New Plan';

  @override
  String get workoutProgressionNotes => 'Progression Notes';

  @override
  String get workoutSafetyNotes => 'Safety Notes';

  @override
  String get workoutWarmup => 'Warm-up';

  @override
  String get workoutMain => 'Main Workout';

  @override
  String get workoutCooldown => 'Cool-down';

  @override
  String get workoutRestDay => 'Rest & Recovery Day';

  @override
  String get workoutRestDayDesc =>
      'Today is dedicated to muscle recovery. Ensure adequate rest, sleep, and hydration.';

  @override
  String workoutSetsReps(int sets, String reps) {
    return '$sets sets × $reps reps';
  }

  @override
  String workoutSetsDuration(int sets, int sec) {
    return '$sets sets × ${sec}s';
  }

  @override
  String workoutRest(int sec) {
    return 'Rest: ${sec}s';
  }

  @override
  String workoutRpe(String rpe) {
    return 'RPE: $rpe';
  }

  @override
  String get workoutSwapExercise => 'Swap Exercise';

  @override
  String get workoutMedicalReferralTitle => 'Medical Referral Required';

  @override
  String get workoutMedicalReferralDialogGotIt => 'I Understand';

  @override
  String get workoutGeneratingPlanTitle => 'Generating Workout Plan...';

  @override
  String get workoutGeneratingPlanMessage =>
      'Your customized workout plan is being prepared based on your health and goals.';

  @override
  String get workoutToday => 'Today';

  @override
  String get workoutFocusMuscles => 'Focus Muscles:';

  @override
  String workoutDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String get workoutEditProfile => 'Edit Workout Profile';

  @override
  String get workoutProfileSaved => 'Workout profile saved successfully';

  @override
  String get workoutRestShort => 'Rest';

  @override
  String workoutSetsOnly(int sets) {
    return '$sets sets';
  }

  @override
  String get workoutWeeklyGenerationsTitle => 'Weekly Generations';

  @override
  String get workoutDailySwapsTitle => 'Daily Swaps';

  @override
  String get workoutSelectDisciplinesHint =>
      'Please select 1 or 2 disciplines you prefer:';

  @override
  String get workoutFitnessLevelLabel => 'Fitness level:';

  @override
  String workoutDisciplineStyleLabel(String discipline) {
    return '$discipline style:';
  }

  @override
  String get workoutSelectGoalHint => 'Select your primary goal:';

  @override
  String workoutDaysCount(int count) {
    return '$count days';
  }

  @override
  String workoutMinutesCount(int count) {
    return '$count min';
  }

  @override
  String get workoutInjuriesLabel => 'Injuries or painful areas:';

  @override
  String workoutExerciseSwappedSuccess(int remaining) {
    return 'Exercise swapped successfully. $remaining swaps left today.';
  }

  @override
  String get workoutHistoryTitle => 'Workout History';

  @override
  String get workoutHistoryEmpty => 'No workout history found';

  @override
  String get workoutHistoryDeleteConfirmTitle => 'Delete Workout Plan';

  @override
  String get workoutHistoryDeleteConfirmBody =>
      'Are you sure you want to delete this workout plan?';

  @override
  String get workoutHistoryDeleteConfirmConfirm => 'Delete';

  @override
  String get workoutHistoryDeleteConfirmCancel => 'Cancel';

  @override
  String get workoutHistoryDeleteSuccess => 'Plan deleted successfully';

  @override
  String get workoutPlanDetailTitle => 'Workout Plan Details';

  @override
  String get workoutRegeneratePromptTitle => 'Update your workout plan?';

  @override
  String get workoutRegeneratePromptBody =>
      'Your details have changed. Would you like to regenerate your workout plan based on the new information?';

  @override
  String get workoutRegenerateConfirm => 'Yes, regenerate';

  @override
  String get workoutRegenerateDismiss => 'Not now';

  @override
  String get workoutPlanRegenerated =>
      'A new workout plan was generated successfully';
}
