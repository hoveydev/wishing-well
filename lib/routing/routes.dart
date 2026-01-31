enum Routes {
  home('/home'),
  profile('/profile'),
  login('/login'),
  forgotPassword('/forgot-password'),
  forgotPasswordConfirm('confirm'), // forgot-password/confirm
  resetPassword('/reset-password'), // forgot-password/reset-password
  resetPasswordConfirmation(
    'confirm',
  ), // forgot-password/reset-password/confirm
  createAccount('/create-account'),
  createAccountConfirm('confirm'), // create-account/confirm
  accountConfirm('account-confirm'), // create-account/account-confirm
  addWisher('/add-wisher'); // add-wisher

  const Routes(this.path);
  final String path;

  String get name => _toKebabCase(toString().split('.').last);

  String _toKebabCase(String input) => input
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (m) => '-${m.group(0)!.toLowerCase()}',
      )
      .toLowerCase();
}
