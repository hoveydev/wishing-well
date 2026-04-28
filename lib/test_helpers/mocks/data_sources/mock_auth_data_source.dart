import 'package:wishing_well/data/data_sources/auth/auth_data_source.dart';

/// Mock implementation of [AuthDataSource] for testing.
///
/// This mock allows configuring success/error responses for each method
/// and tracking method calls for verification in tests.
class MockAuthDataSource implements AuthDataSource {
  /// Creates a mock with default success responses.
  MockAuthDataSource({
    this.mockUserId,
    this.mockAccessToken,
    this.mockUserFirstName,
    this.signInWithPasswordResult,
    this.signInWithPasswordError,
    this.signUpResult,
    this.signUpError,
    this.signOutError,
    this.resetPasswordForEmailError,
    this.updateUserPasswordResult,
    this.updateUserPasswordError,
    this.signInWithGoogleError,
  });

  /// The user ID to return for [currentUserId].
  String? mockUserId;

  /// The access token to return for [currentAccessToken].
  String? mockAccessToken;

  /// The first name to return for [userFirstName].
  String? mockUserFirstName;

  /// The result to return from [signInWithPassword].
  /// If null, returns a default success response.
  Map<String, dynamic>? signInWithPasswordResult;

  /// The exception to throw from [signInWithPassword].
  /// Takes precedence over [signInWithPasswordResult].
  Exception? signInWithPasswordError;

  /// The result to return from [signUp].
  /// If null, returns a default success response.
  Map<String, dynamic>? signUpResult;

  /// The exception to throw from [signUp].
  /// Takes precedence over [signUpResult].
  Exception? signUpError;

  /// The exception to throw from [signOut].
  Exception? signOutError;

  /// The exception to throw from [resetPasswordForEmail].
  Exception? resetPasswordForEmailError;

  /// The result to return from [updateUserPassword].
  /// If null, returns a default success response.
  Map<String, dynamic>? updateUserPasswordResult;

  /// The exception to throw from [updateUserPassword].
  /// Takes precedence over [updateUserPasswordResult].
  Exception? updateUserPasswordError;

  /// The exception to throw from [signInWithGoogle].
  Exception? signInWithGoogleError;

  /// Tracks whether [signInWithPassword] was called.
  bool signInWithPasswordCalled = false;

  /// Tracks whether [signUp] was called.
  bool signUpCalled = false;

  /// The emailRedirectTo passed to the last [signUp] call.
  String? lastSignUpEmailRedirectTo;

  /// Tracks whether [signOut] was called.
  bool signOutCalled = false;

  /// Tracks whether [resetPasswordForEmail] was called.
  bool resetPasswordForEmailCalled = false;

  /// Tracks whether [updateUserPassword] was called.
  bool updateUserPasswordCalled = false;

  /// Tracks whether [signInWithGoogle] was called.
  bool signInWithGoogleCalled = false;

  @override
  String? get currentUserId => mockUserId;

  @override
  String? get currentAccessToken => mockAccessToken;

  @override
  String? get userFirstName => mockUserFirstName;

  @override
  Future<Map<String, dynamic>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    signInWithPasswordCalled = true;
    if (signInWithPasswordError != null) {
      throw signInWithPasswordError!;
    }
    return signInWithPasswordResult ??
        {
          'user_id': 'test-user-id',
          'aud': 'authenticated',
          'email': email,
          'access_token': 'test-access-token',
          'refresh_token': 'test-refresh-token',
        };
  }

  @override
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? emailRedirectTo,
  }) async {
    signUpCalled = true;
    lastSignUpEmailRedirectTo = emailRedirectTo;
    if (signUpError != null) {
      throw signUpError!;
    }
    return signUpResult ??
        {
          'user_id': 'test-user-id',
          'email': email,
          'access_token': 'test-access-token',
          'refresh_token': 'test-refresh-token',
        };
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
    if (signOutError != null) {
      throw signOutError!;
    }
  }

  @override
  Future<void> resetPasswordForEmail(String email, {String? redirectTo}) async {
    resetPasswordForEmailCalled = true;
    if (resetPasswordForEmailError != null) {
      throw resetPasswordForEmailError!;
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserPassword({
    required String email,
    required String newPassword,
  }) async {
    updateUserPasswordCalled = true;
    if (updateUserPasswordError != null) {
      throw updateUserPasswordError!;
    }
    return updateUserPasswordResult ??
        {'user_id': 'test-user-id', 'email': email};
  }

  @override
  Future<void> signInWithGoogle() async {
    signInWithGoogleCalled = true;
    if (signInWithGoogleError != null) {
      throw signInWithGoogleError!;
    }
  }
}
