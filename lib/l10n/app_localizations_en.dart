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
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get loginErrorNoPasswordNoEmail =>
      'Email and password cannot be empty';

  @override
  String get loginErrorNoEmnail => 'Email cannot be empty';

  @override
  String get loginErrorNoPassword => 'Password cannot be empty';

  @override
  String get loginErrorBadEmail => 'Invalid email format';

  @override
  String get forgotPasswordHeader => 'Forgot Password';

  @override
  String get forgotPasswordSubtext =>
      'Enter your email address below to receive a password reset link.';

  @override
  String get submit => 'Submit';
}
