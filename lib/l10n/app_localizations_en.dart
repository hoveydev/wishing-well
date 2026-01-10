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
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authCreateAccount => 'Create an Account';

  @override
  String get authCreateAccountButton => 'Create Account';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authSubmit => 'Submit';

  @override
  String get errorInvalidEmail => 'Invalid email format';

  @override
  String get errorEmailRequired => 'Email cannot be empty';

  @override
  String get errorPasswordRequired => 'Password cannot be empty';

  @override
  String get errorEmailPasswordRequired => 'Email and password cannot be empty';

  @override
  String get errorPasswordRequirements =>
      'Password does not meet above requirements';

  @override
  String get errorUnknown => 'An unknown error occured. Please try again';

  @override
  String get loginScreenHeader => 'Welcome to WishingWell';

  @override
  String get loginScreenSubtext => 'Please enter your credentials below';

  @override
  String get forgotPasswordScreenHeader => 'Forgot Password';

  @override
  String get forgotPasswordScreenSubtext =>
      'Enter your email address below to receive a password reset link';

  @override
  String get forgotPasswordConfirmationHeader => 'Reset Password Request Sent!';

  @override
  String get forgotPasswordConfirmationMessage =>
      'Please check your email for password reset instructions.';

  @override
  String get createAccountScreenHeader => 'Create an Account';

  @override
  String get createAccountConfirmationHeader => 'Account Successfully Created!';

  @override
  String get createAccountConfirmationMessage =>
      'Please check your email to confirm your account. Your account must be confirmed before you are able to log in.';

  @override
  String get accountConfirmationHeader => 'Account Confirmed!';

  @override
  String get accountConfirmationMessage =>
      'You may now securely log in to WishingWell';

  @override
  String get resetPasswordScreenHeader => 'Reset Password';

  @override
  String get resetPasswordScreenSubtext =>
      'Enter and confirm your new password below';

  @override
  String get resetPasswordConfirmationHeader => 'Password Successfully Reset!';

  @override
  String get resetPasswordConfirmationMessage =>
      'You may now log in with your new password';

  @override
  String get passwordRequirementsHeader => 'Password must include:';

  @override
  String get passwordRequirementsMinChars => 'At least 12 characters';

  @override
  String get passwordRequirementsUppercase => 'One uppercase letter';

  @override
  String get passwordRequirementsLowercase => 'One lowercase letter';

  @override
  String get passwordRequirementsDigit => 'One number';

  @override
  String get passwordRequirementsSpecialChar => 'One special character';

  @override
  String get passwordRequirementsMatching => 'Passwords must match';

  @override
  String get homeWelcome => 'Welcome!';

  @override
  String homeWelcomeWithName(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get homeComingUp => 'Coming Up';
}
