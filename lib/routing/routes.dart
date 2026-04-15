enum Routes {
  home('/home'),
  profile('/profile'),
  login('/login'),
  forgotPassword('/forgot-password'),
  resetPassword('/reset-password'), // forgot-password/reset-password
  createAccount('/create-account'),
  addWisher('/add-wisher'), // add-wisher
  addWisherDetails('details'), // add-wisher/details
  wisherDetails('/wisher-details/:id'), // wisher-details/:id
  editWisher('/edit-wisher/:id'); // edit-wisher/:id

  const Routes(this.path);
  final String path;

  String get name => _toKebabCase(toString().split('.').last);

  String _toKebabCase(String input) => input
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (m) => '-${m.group(0)!.toLowerCase()}',
      )
      .toLowerCase();

  /// Builds a route path with parameter substitution.
  ///
  /// For routes with path parameters (e.g., `/wisher-details/:id`),
  /// this method safely replaces the named parameter with the provided value.
  ///
  /// Example:
  /// ```dart
  /// Routes.wisherDetails.buildPath(id: 'abc123')
  /// // Returns: '/wisher-details/abc123'
  /// ```
  String buildPath({String? id}) {
    var result = path;
    if (id != null) {
      result = result.replaceAll(':id', id);
    }
    return result;
  }
}
