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
  String get email;

  /// Label for the password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for the confirm password field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Text for the forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Text for the sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Text for the create account link
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAccount;

  /// Login error message when both email and password are empty
  ///
  /// In en, this message translates to:
  /// **'Email and password cannot be empty'**
  String get loginErrorNoPasswordNoEmail;

  /// Login error message when email is empty
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get loginErrorNoEmail;

  /// Login Error message when password is empty
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get loginErrorNoPassword;

  /// Login error message when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get loginErrorBadEmail;

  /// Login error message when supabase call has an error
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured. Please try again'**
  String get loginErrorUnknown;

  /// Header for Forgot Password screen
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordHeader;

  /// Subtext for Forgot Password screen
  ///
  /// In en, this message translates to:
  /// **'Enter your email address below to receive a password reset link'**
  String get forgotPasswordSubtext;

  /// Create account button label
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButtonLabel;

  /// Create account error message when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter your credentials below'**
  String get createAccountSubtext;

  /// Create account error message when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get createAccountErrorBadEmail;

  /// Create account error message when email is empty
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get createAccountErrorNoEmail;

  /// Create account error message when password is not valid
  ///
  /// In en, this message translates to:
  /// **'Password does not meet above requirements'**
  String get createAccountErrorPasswordNotValid;

  /// Create account error message when supabase call has an error
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured. Please try again'**
  String get createAccountErrorUnknown;

  /// Create account confirmation screen header
  ///
  /// In en, this message translates to:
  /// **'Account Successfully Created!'**
  String get createAccountConfirmationHeader;

  /// Create account confirmation screen instructions on account confirmation
  ///
  /// In en, this message translates to:
  /// **'Please check your email to confirm your account. Your account must be confirmed before you are able to log in.'**
  String get createAccountConfirmationInfoMessage;

  /// Forgot password confirmation screen header
  ///
  /// In en, this message translates to:
  /// **'Reset Password Request Sent!'**
  String get forgotPasswordConfirmationHeader;

  /// Forgot password screen instructions on password reset
  ///
  /// In en, this message translates to:
  /// **'Please check your email for password reset instructions.'**
  String get forgotPasswordConfirmationInfoMessage;

  /// Forgot password error message when supabase call has an error
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured. Please try again'**
  String get forgotPasswordErrorUnknown;

  /// Account confirmation screen header
  ///
  /// In en, this message translates to:
  /// **'Account Confirmed!'**
  String get accountConfirmationHeader;

  /// Account confirmation screen info message
  ///
  /// In en, this message translates to:
  /// **'You may now securely log in to WishingWell'**
  String get accountConfirmationInfoMessage;

  /// Reset password button label
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButtonLabel;

  /// Header for Reset Password screen
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordHeader;

  /// Subtext for Reset Password screen
  ///
  /// In en, this message translates to:
  /// **'Enter and confirm your new password below'**
  String get resetPasswordSubtext;

  /// Create account error message when password is not valid
  ///
  /// In en, this message translates to:
  /// **'Password does not meet above requirements'**
  String get resetPasswordErrorPasswordNotValid;

  /// Reset password error message when supabase call has an error
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured. Please try again'**
  String get resetPasswordErrorUnknown;

  /// Reset password confirmation screen header
  ///
  /// In en, this message translates to:
  /// **'Password Successfully Reset!'**
  String get resetPasswordConfirmationHeader;

  /// Reset password confirmation screen info on reset confirmation
  ///
  /// In en, this message translates to:
  /// **'You may now log in with your new password'**
  String get resetPasswordConfirmationInfoMessage;

  /// Header for password requirements checklist
  ///
  /// In en, this message translates to:
  /// **'Password must include:'**
  String get passwordRequirementsHeader;

  /// Minimum characters requirement for password requirements checklist
  ///
  /// In en, this message translates to:
  /// **'At least 12 characters'**
  String get passwordRequirementsMinimumChars;

  /// Uppercase letter requirement for password requirements checklist
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter'**
  String get passwordRequirementsUppercase;

  /// Lowercase letter requirement for password requirements checklist
  ///
  /// In en, this message translates to:
  /// **'One lowercase letter'**
  String get passwordRequirementsLowercase;

  /// Number requirement for password requirements checklist
  ///
  /// In en, this message translates to:
  /// **'One number'**
  String get passwordRequirementsDigit;

  /// Special character requirement for password requirements checklist
  ///
  /// In en, this message translates to:
  /// **'One special character'**
  String get passwordRequirementsSpecialChar;

  /// Matching passwords requirement for password requirements checklist
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get passwordRequirementsMatching;

  /// Label for submit button on Forgot Password screen
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// header for home screen (no name)
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeHeader;

  /// header for home screen with name
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeHeaderWithName(String name);

  /// title for coming up section on home
  ///
  /// In en, this message translates to:
  /// **'Coming Up'**
  String get comingUpTitle;
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
