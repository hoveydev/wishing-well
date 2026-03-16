enum Routes {
  home('/home'),
  profile('/profile'),
  login('/login'),
  forgotPassword('/forgot-password'),
  resetPassword('/reset-password'), // forgot-password/reset-password
  createAccount('/create-account'),
  addWisher('/add-wisher'), // add-wisher
  addWisherDetails('details'); // add-wisher/details

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
