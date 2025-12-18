// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'WishingWell';

  @override
  String get appTagline => 'Your personal well for thoughtful giving';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get loginErrorNoPasswordNoEmail =>
      'Email and password cannot be empty';

  @override
  String get loginErrorNoEmail => 'Email cannot be empty';

  @override
  String get loginErrorNoPassword => 'Password cannot be empty';

  @override
  String get loginErrorBadEmail => 'Invalid email format';

  @override
  String get loginErrorUnknown => 'An unknown error occured. Please try again';

  @override
  String get forgotPasswordHeader => 'Forgot Password';

  @override
  String get forgotPasswordSubtext =>
      'Enter your email address below to receive a password reset link.';

  @override
  String get createAccountButtonLabel => 'Create Account';

  @override
  String get createAccountSubtext => 'Please enter your credentials below';

  @override
  String get createAccountErrorBadEmail => 'Invalid email format';

  @override
  String get createAccountErrorNoPasswordNoEmail =>
      'Email and password cannot be empty';

  @override
  String get createAccountErrorNoEmail => 'Email cannot be empty';

  @override
  String get createAccountErrorNoPassword => 'Password cannot be empty';

  @override
  String get createAccountErrorPasswordTooShort =>
      'Password must be at least 12 characters long';

  @override
  String get createAccountErrorPasswordNoUppercase =>
      'Password must contain at least 1 uppercase letter';

  @override
  String get createAccountErrorPasswordNoLowercase =>
      'Password must contain at least 1 lowercase letter';

  @override
  String get createAccountErrorPasswordNoDigit =>
      'Password must contain at least 1 digit';

  @override
  String get createAccountErrorPasswordNoSpecial =>
      'Password must contain at least 1 special character';

  @override
  String get createAccountErrorPasswordsDontMatch => 'Passwords must match';

  @override
  String get createAccountErrorUnknown =>
      'An unknown error occured. Please try again';

  @override
  String get createAccountConfirmationHeader => 'Account Successfully Created!';

  @override
  String get createAccountConfirmationInfoMessage =>
      'Please check your email to confirm your account. Your account must be confirmed before you are able to log in.';

  @override
  String get forgotPasswordConfirmationHeader => 'Reset Password Request Sent!';

  @override
  String get forgotPasswordConfirmationInfoMessage =>
      'Please check your email for password reset instructions.';

  @override
  String get forgotPasswordErrorUnknown =>
      'An unknown error occured. Please try again';

  @override
  String get submit => 'Submit';
}
