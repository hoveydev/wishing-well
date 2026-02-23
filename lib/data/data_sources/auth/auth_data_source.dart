/// Abstract data source for authentication operations.
///
/// This interface abstracts the Supabase Auth API, allowing for
/// easy testing by mocking the data source layer.
abstract class AuthDataSource {
  /// Returns the current session's user ID if authenticated, null otherwise.
  String? get currentUserId;

  /// Returns the current session's access token if authenticated, or null.
  String? get currentAccessToken;

  /// Signs in a user with email and password.
  ///
  /// Returns a map containing user data on success.
  /// Throws an exception on failure.
  Future<Map<String, dynamic>> signInWithPassword({
    required String email,
    required String password,
  });

  /// Signs up a new user with email and password.
  ///
  /// Returns a map containing user data on success.
  /// Throws an exception on failure.
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? emailRedirectTo,
  });

  /// Signs out the current user.
  ///
  /// Throws an exception on failure.
  Future<void> signOut();

  /// Sends a password reset email to the given email address.
  ///
  /// Throws an exception on failure.
  Future<void> resetPasswordForEmail(String email, {String? redirectTo});

  /// Updates the current user's password using a recovery token.
  ///
  /// Returns a map containing user data on success.
  /// Throws an exception on failure.
  Future<Map<String, dynamic>> updateUserPassword({
    required String email,
    required String newPassword,
    required String token,
  });

  /// Returns the user's first name from metadata, if available.
  String? get userFirstName;
}
