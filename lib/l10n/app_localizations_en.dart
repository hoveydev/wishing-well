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
  String get authSignInWithGoogle => 'Sign in with Google';

  @override
  String get authGoogleSignInCancelled => 'Google sign-in was cancelled';

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
  String get errorUnknown => 'An unknown error occurred. Please try again';

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

  @override
  String get loading => 'Loading';

  @override
  String get success => 'Success';

  @override
  String get appBarDismiss => 'Dismiss';

  @override
  String get appBarProfile => 'Profile';

  @override
  String get appBarClose => 'Close';

  @override
  String get logout => 'Logout';

  @override
  String get errorAlertTitle => 'Oh no!';

  @override
  String get ok => 'Ok';

  @override
  String get wishers => 'Wishers';

  @override
  String get viewAll => 'View All';

  @override
  String get add => 'Add';

  @override
  String get addWisherScreenHeader => 'Add a Wisher';

  @override
  String get addWisherScreenDescription =>
      'A Wisher is someone special in your life — a friend, partner, family member, or anyone who brings a little extra light into your world. They are the people you love to celebrate through both life’s big moments and the quiet, everyday surprises that simply say, “I was thinking of you.”';

  @override
  String get addFromContacts => 'Add From Contacts';

  @override
  String get contactImportPermissionDenied =>
      'Contacts permission was denied. Please allow access to continue.';

  @override
  String get contactImportUnexpectedFailure =>
      'We couldn\'t access your contacts right now. Please try again.';

  @override
  String contactImportSuccessNamed(String name) {
    return '$name added from contacts.';
  }

  @override
  String contactImportSuccessMultiple(int count) {
    return '$count contacts added from contacts.';
  }

  @override
  String contactImportPartialSuccess(int importedCount, int failedCount) {
    return 'Added $importedCount contacts. $failedCount couldn\'t be added.';
  }

  @override
  String get contactImportFailureSingle =>
      'We couldn\'t add the selected contact. Please try again.';

  @override
  String get contactImportFailureMultiple =>
      'We couldn\'t add the selected contacts. Please try again.';

  @override
  String contactImportDuplicateWarningSingle(String name) {
    return '$name is already a registered wisher. Add them anyway?';
  }

  @override
  String contactImportDuplicateWarningMultiple(int count) {
    return '$count selected contacts already match existing wishers. Add them anyway?';
  }

  @override
  String get continueAction => 'Continue';

  @override
  String get addManually => 'Add Manually';

  @override
  String get manualAddWisherScreenHeader => 'Enter Wisher Details';

  @override
  String get manualAddWisherScreenSubtext =>
      'The more we know now, the more meaningful the gifts can be later.';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get save => 'Save Wisher';

  @override
  String get errorFirstNameRequired => 'First name cannot be empty';

  @override
  String get errorLastNameRequired => 'Last name cannot be empty';

  @override
  String get errorBothNamesRequired => 'First and last name cannot be empty';

  @override
  String get selectImageSource => 'Select Image Source';

  @override
  String get chooseAPhoto => 'Choose a Photo';

  @override
  String get chooseAFile => 'Choose a File';

  @override
  String get wishersErrorTitle => 'Error Loading Wishers';

  @override
  String get wishersErrorMessage =>
      'Something went wrong while loading your wishers. Please try again.';

  @override
  String get tryAgain => 'retry';

  @override
  String wisherCreatedSuccess(String name) {
    return '$name has been added!';
  }

  @override
  String wisherUpdatedSuccess(String name) {
    return '$name has been updated!';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get wisherDeleteConfirmTitle => 'Delete Wisher?';

  @override
  String wisherDeleteConfirmMessage(String name) {
    return 'Are you sure you want to delete $name? This cannot be undone.';
  }

  @override
  String get appBarEdit => 'Edit';

  @override
  String get editWisherScreenHeader => 'Edit Wisher Details';

  @override
  String get editWisherScreenSubtext =>
      'Update the details below to keep your wisher\'s information current.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get deleteWisher => 'Delete Wisher';

  @override
  String get errorNoChanges => 'No changes were made.';

  @override
  String get allWishersTitle => 'All Wishers';

  @override
  String get allWishersEmpty => 'No wishers yet';

  @override
  String get allWishersSearchPlaceholder => 'Search Wishers';

  @override
  String get allWishersNoResults => 'No Wishers found';

  @override
  String get homeComingUpEmpty => 'Nothing yet';

  @override
  String get appBarBack => 'Back';

  @override
  String get deepLinkError =>
      'This link has expired or is no longer valid. Please return to the login screen and resubmit for a new link.';

  @override
  String get datePickerTitle => 'Select a Date';

  @override
  String get datePickerConfirm => 'Confirm';

  @override
  String get datePickerClearDate => 'Clear date';

  @override
  String get datePickerPreviousMonth => 'Previous month';

  @override
  String get datePickerNextMonth => 'Next month';

  @override
  String get birthday => 'Birthday';

  @override
  String get giftOccasions => 'Gift Occasions';

  @override
  String get giftInterests => 'Gift Interests';

  @override
  String get birthdayPlaceholder => 'Add birthday';

  @override
  String get giftOccasionsPlaceholder => 'Select gift occasions';

  @override
  String get giftInterestsPlaceholder => 'Select gift interests';

  @override
  String get occasionChristmas => 'Christmas';

  @override
  String get occasionHanukkah => 'Hanukkah';

  @override
  String get occasionKwanzaa => 'Kwanzaa';

  @override
  String get occasionDiwali => 'Diwali';

  @override
  String get occasionEid => 'Eid';

  @override
  String get occasionValentinesDay => 'Valentine\'s Day';

  @override
  String get occasionMothersDay => 'Mother\'s Day';

  @override
  String get occasionFathersDay => 'Father\'s Day';

  @override
  String get occasionEaster => 'Easter';

  @override
  String get occasionNewYears => 'New Year\'s';

  @override
  String get interestBooks => 'Books';

  @override
  String get interestElectronics => 'Electronics';

  @override
  String get interestClothing => 'Clothing';

  @override
  String get interestJewelry => 'Jewelry';

  @override
  String get interestArt => 'Art';

  @override
  String get interestHomeAndGarden => 'Home & Garden';

  @override
  String get interestSports => 'Sports';

  @override
  String get interestBeauty => 'Beauty';

  @override
  String get interestFoodAndDrink => 'Food & Drink';

  @override
  String get interestTravel => 'Travel';

  @override
  String get interestGamesAndToys => 'Games & Toys';

  @override
  String get done => 'Done';
}
