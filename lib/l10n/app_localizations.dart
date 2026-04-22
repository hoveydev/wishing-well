import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'WishingWell'**
  String get appName;

  /// The tagline of the application
  ///
  /// In en, this message translates to:
  /// **'Your personal well for thoughtful giving'**
  String get appTagline;

  /// Label for the email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// Label for the password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// Label for the confirm password field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// Text for the sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// Text for the create account link
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get authCreateAccount;

  /// Text for the create account button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccountButton;

  /// Text for the forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// Text for the reset password button/header
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// Label for the submit button
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get authSubmit;

  /// Error message when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get errorInvalidEmail;

  /// Error message when email is empty
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get errorEmailRequired;

  /// Error message when password is empty
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get errorPasswordRequired;

  /// Error message when both email and password are empty
  ///
  /// In en, this message translates to:
  /// **'Email and password cannot be empty'**
  String get errorEmailPasswordRequired;

  /// Error message when password does not meet requirements
  ///
  /// In en, this message translates to:
  /// **'Password does not meet above requirements'**
  String get errorPasswordRequirements;

  /// Generic error message when an unknown error occurs
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured. Please try again'**
  String get errorUnknown;

  /// Header for login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to WishingWell'**
  String get loginScreenHeader;

  /// Subtext for login screen
  ///
  /// In en, this message translates to:
  /// **'Please enter your credentials below'**
  String get loginScreenSubtext;

  /// Header for Forgot Password screen
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordScreenHeader;

  /// Subtext for Forgot Password screen
  ///
  /// In en, this message translates to:
  /// **'Enter your email address below to receive a password reset link'**
  String get forgotPasswordScreenSubtext;

  /// Forgot password confirmation screen header
  ///
  /// In en, this message translates to:
  /// **'Reset Password Request Sent!'**
  String get forgotPasswordConfirmationHeader;

  /// Forgot password screen instructions on password reset
  ///
  /// In en, this message translates to:
  /// **'Please check your email for password reset instructions.'**
  String get forgotPasswordConfirmationMessage;

  /// Header for Create Account screen
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAccountScreenHeader;

  /// Create account confirmation screen header
  ///
  /// In en, this message translates to:
  /// **'Account Successfully Created!'**
  String get createAccountConfirmationHeader;

  /// Create account confirmation screen instructions on account confirmation
  ///
  /// In en, this message translates to:
  /// **'Please check your email to confirm your account. Your account must be confirmed before you are able to log in.'**
  String get createAccountConfirmationMessage;

  /// Account confirmation screen header
  ///
  /// In en, this message translates to:
  /// **'Account Confirmed!'**
  String get accountConfirmationHeader;

  /// Account confirmation screen info message
  ///
  /// In en, this message translates to:
  /// **'You may now securely log in to WishingWell'**
  String get accountConfirmationMessage;

  /// Header for Reset Password screen
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordScreenHeader;

  /// Subtext for Reset Password screen
  ///
  /// In en, this message translates to:
  /// **'Enter and confirm your new password below'**
  String get resetPasswordScreenSubtext;

  /// Reset password confirmation screen header
  ///
  /// In en, this message translates to:
  /// **'Password Successfully Reset!'**
  String get resetPasswordConfirmationHeader;

  /// Reset password confirmation screen info on reset confirmation
  ///
  /// In en, this message translates to:
  /// **'You may now log in with your new password'**
  String get resetPasswordConfirmationMessage;

  /// Header for password requirements checklist
  ///
  /// In en, this message translates to:
  /// **'Password must include:'**
  String get passwordRequirementsHeader;

  /// Minimum characters requirement for password
  ///
  /// In en, this message translates to:
  /// **'At least 12 characters'**
  String get passwordRequirementsMinChars;

  /// Uppercase letter requirement for password
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter'**
  String get passwordRequirementsUppercase;

  /// Lowercase letter requirement for password
  ///
  /// In en, this message translates to:
  /// **'One lowercase letter'**
  String get passwordRequirementsLowercase;

  /// Number requirement for password
  ///
  /// In en, this message translates to:
  /// **'One number'**
  String get passwordRequirementsDigit;

  /// Special character requirement for password
  ///
  /// In en, this message translates to:
  /// **'One special character'**
  String get passwordRequirementsSpecialChar;

  /// Matching passwords requirement
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get passwordRequirementsMatching;

  /// Welcome header on home screen without name
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get homeWelcome;

  /// Welcome header on home screen with name
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String homeWelcomeWithName(String name);

  /// Title for coming up section on home
  ///
  /// In en, this message translates to:
  /// **'Coming Up'**
  String get homeComingUp;

  /// Accessibility label for loading state
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// Accessibility label for success indicator
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Accessibility label for dismiss button in app bar
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get appBarDismiss;

  /// Accessibility label for profile button in app bar
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get appBarProfile;

  /// Accessibility label for close button in app bar
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get appBarClose;

  /// Label for logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Title for error alert modal
  ///
  /// In en, this message translates to:
  /// **'Oh no!'**
  String get errorAlertTitle;

  /// Ok text
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// Title for wishers section
  ///
  /// In en, this message translates to:
  /// **'Wishers'**
  String get wishers;

  /// Text for view all button
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Text for add Wisher item
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Header for add wisher screen
  ///
  /// In en, this message translates to:
  /// **'Add a Wisher'**
  String get addWisherScreenHeader;

  /// Description explaining what a wisher is
  ///
  /// In en, this message translates to:
  /// **'A Wisher is someone special in your life — a friend, partner, family member, or anyone who brings a little extra light into your world. They are the people you love to celebrate through both life’s big moments and the quiet, everyday surprises that simply say, “I was thinking of you.”'**
  String get addWisherScreenDescription;

  /// Button text for adding wisher from contacts
  ///
  /// In en, this message translates to:
  /// **'Add From Contacts'**
  String get addFromContacts;

  /// Error shown when contacts permission is denied during add from contacts
  ///
  /// In en, this message translates to:
  /// **'Contacts permission was denied. Please allow access to continue.'**
  String get contactImportPermissionDenied;

  /// Error shown when add from contacts fails unexpectedly before import
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t access your contacts right now. Please try again.'**
  String get contactImportUnexpectedFailure;

  /// Success message shown when a single contact is imported successfully
  ///
  /// In en, this message translates to:
  /// **'{name} added from contacts.'**
  String contactImportSuccessNamed(String name);

  /// Success message shown when multiple contacts are imported successfully
  ///
  /// In en, this message translates to:
  /// **'{count} contacts added from contacts.'**
  String contactImportSuccessMultiple(int count);

  /// Success message shown when some selected contacts are imported and some fail
  ///
  /// In en, this message translates to:
  /// **'Added {importedCount} contacts. {failedCount} couldn\'t be added.'**
  String contactImportPartialSuccess(int importedCount, int failedCount);

  /// Error shown when a single selected contact could not be imported
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t add the selected contact. Please try again.'**
  String get contactImportFailureSingle;

  /// Error shown when multiple selected contacts could not be imported
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t add the selected contacts. Please try again.'**
  String get contactImportFailureMultiple;

  /// Warning shown before importing a contact whose name matches an existing wisher
  ///
  /// In en, this message translates to:
  /// **'{name} is already a registered wisher. Add them anyway?'**
  String contactImportDuplicateWarningSingle(String name);

  /// Warning shown before importing multiple contacts whose names match existing wishers
  ///
  /// In en, this message translates to:
  /// **'{count} selected contacts already match existing wishers. Add them anyway?'**
  String contactImportDuplicateWarningMultiple(int count);

  /// Label for continue action button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Button text for adding wisher manually
  ///
  /// In en, this message translates to:
  /// **'Add Manually'**
  String get addManually;

  /// Header for manual add wisher screen
  ///
  /// In en, this message translates to:
  /// **'Enter Wisher Details'**
  String get manualAddWisherScreenHeader;

  /// Subtext for manual add wisher screen
  ///
  /// In en, this message translates to:
  /// **'The more we know now, the more meaningful the gifts can be later.'**
  String get manualAddWisherScreenSubtext;

  /// Label for first name input field
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Label for last name input field
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Save button text on Add Wisher Details screen
  ///
  /// In en, this message translates to:
  /// **'Save Wisher'**
  String get save;

  /// Error message when first name is required
  ///
  /// In en, this message translates to:
  /// **'First name cannot be empty'**
  String get errorFirstNameRequired;

  /// Error message when last name is required
  ///
  /// In en, this message translates to:
  /// **'Last name cannot be empty'**
  String get errorLastNameRequired;

  /// Error message when both first and last name are required
  ///
  /// In en, this message translates to:
  /// **'First and last name cannot be empty'**
  String get errorBothNamesRequired;

  /// Title for image source selection menu
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// Option to choose a photo from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose a Photo'**
  String get chooseAPhoto;

  /// Option to choose a file from device
  ///
  /// In en, this message translates to:
  /// **'Choose a File'**
  String get chooseAFile;

  /// Error title when wishers fail to load
  ///
  /// In en, this message translates to:
  /// **'Error Loading Wishers'**
  String get wishersErrorTitle;

  /// Error message when wishers fail to load
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading your wishers. Please try again.'**
  String get wishersErrorMessage;

  /// Button text to retry an action
  ///
  /// In en, this message translates to:
  /// **'retry'**
  String get tryAgain;

  /// Success message when a wisher is created
  ///
  /// In en, this message translates to:
  /// **'{name} has been added!'**
  String wisherCreatedSuccess(String name);

  /// Success message when a wisher is updated
  ///
  /// In en, this message translates to:
  /// **'{name} has been updated!'**
  String wisherUpdatedSuccess(String name);

  /// Label for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Title for wisher delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Wisher?'**
  String get wisherDeleteConfirmTitle;

  /// Body for wisher delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This cannot be undone.'**
  String wisherDeleteConfirmMessage(String name);

  /// Accessibility label for edit button in app bar
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get appBarEdit;

  /// Header for edit wisher screen
  ///
  /// In en, this message translates to:
  /// **'Edit Wisher Details'**
  String get editWisherScreenHeader;

  /// Subtext for edit wisher screen
  ///
  /// In en, this message translates to:
  /// **'Update the details below to keep your wisher\'s information current.'**
  String get editWisherScreenSubtext;

  /// Save button text on Edit Wisher screen
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Label for delete wisher button
  ///
  /// In en, this message translates to:
  /// **'Delete Wisher'**
  String get deleteWisher;

  /// Error message when no changes were made to wisher
  ///
  /// In en, this message translates to:
  /// **'No changes were made.'**
  String get errorNoChanges;

  /// Title for the all wishers screen
  ///
  /// In en, this message translates to:
  /// **'All Wishers'**
  String get allWishersTitle;

  /// Message shown when there are no wishers on the all wishers screen
  ///
  /// In en, this message translates to:
  /// **'No wishers yet'**
  String get allWishersEmpty;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
