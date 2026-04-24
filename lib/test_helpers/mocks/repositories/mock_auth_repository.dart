import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/result.dart';

/// Mock implementation of [AuthRepository] for testing and demo purposes.
///
/// Provides configurable results and optional delays to simulate various
/// authentication scenarios.
///
/// Example usage:
/// ```dart
/// final repo = MockAuthRepository(
///   loginResult: Result.error(Exception('Invalid credentials')),
///   loginDelay: const Duration(seconds: 2),
/// );
/// ```
class MockAuthRepository extends AuthRepository {
  MockAuthRepository({
    /// Result to return from logout operations
    Result<void>? logoutResult,

    /// Result to return from login operations
    Result<void>? loginResult,

    /// Result to return from account creation
    Result<void>? createAccountResult,

    /// Result to return from password reset request
    Result<void>? sendPasswordResetRequestResult,

    /// Result to return from password reset
    Result<void>? resetUserPasswordResult,

    /// User ID to return after successful authentication
    String? userId,

    /// Optional delay for login operations (useful for demo loading states)
    Duration? loginDelay,

    /// Optional delay for createAccount operations
    Duration? createAccountDelay,

    /// Optional delay for sendPasswordResetRequest operations
    Duration? sendPasswordResetRequestDelay,

    /// Optional delay for resetUserPassword operations
    Duration? resetUserPasswordDelay,
  }) : logoutResult = logoutResult ?? const Result.ok(null),
       loginResult = loginResult ?? const Result.ok(null),
       createAccountResult = createAccountResult ?? const Result.ok(null),
       sendPasswordResetRequestResult =
           sendPasswordResetRequestResult ?? const Result.ok(null),
       resetUserPasswordResult =
           resetUserPasswordResult ?? const Result.ok(null),
       _userId = userId,
       _loginDelay = loginDelay,
       _createAccountDelay = createAccountDelay,
       _sendPasswordResetRequestDelay = sendPasswordResetRequestDelay,
       _resetUserPasswordDelay = resetUserPasswordDelay;

  final String? _userId;
  final Duration? _loginDelay;
  final Duration? _createAccountDelay;
  final Duration? _sendPasswordResetRequestDelay;
  final Duration? _resetUserPasswordDelay;

  final Result<void> logoutResult;
  final Result<void> loginResult;
  final Result<void> createAccountResult;
  final Result<void> sendPasswordResetRequestResult;
  final Result<void> resetUserPasswordResult;

  bool _isAuthenticated = false;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get userFirstName => 'TestUser';

  @override
  String? get currentUserId => _authenticatedUserId;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    // Add delay if specified
    if (_loginDelay != null) {
      await Future.delayed(_loginDelay);
    }
    if (loginResult is Ok) {
      _isAuthenticated = true;
      _authenticatedUserId =
          _userId ?? 'mock-user-${DateTime.now().millisecondsSinceEpoch}';
    }
    notifyListeners();
    return loginResult;
  }

  String? _authenticatedUserId;

  @override
  Future<Result<void>> logout() async {
    if (loginResult is Ok) {
      _isAuthenticated = false;
      _authenticatedUserId = null;
    }
    notifyListeners();
    return logoutResult;
  }

  @override
  Future<Result<void>> createAccount({
    required String email,
    required String password,
  }) async {
    // Add delay if specified
    if (_createAccountDelay != null) {
      await Future.delayed(_createAccountDelay);
    }
    notifyListeners();
    return createAccountResult;
  }

  @override
  Future<Result<void>> sendPasswordResetRequest({required String email}) async {
    // Add delay if specified
    if (_sendPasswordResetRequestDelay != null) {
      await Future.delayed(_sendPasswordResetRequestDelay);
    }
    notifyListeners();
    return sendPasswordResetRequestResult;
  }

  @override
  Future<Result<void>> resetUserPassword({
    required String email,
    required String newPassword,
  }) async {
    // Add delay if specified
    if (_resetUserPasswordDelay != null) {
      await Future.delayed(_resetUserPasswordDelay);
    }
    notifyListeners();
    return resetUserPasswordResult;
  }
}
