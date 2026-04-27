import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/result.dart';

/// Mock implementation of [AuthRepository] for integration tests.
///
/// Provides configurable results and optional delays to simulate various
/// authentication scenarios in integration tests.
///
/// This is an enhanced version of the unit test mock, optimized for
/// integration testing scenarios.
class IntegrationMockAuthRepository extends AuthRepository {
  IntegrationMockAuthRepository({
    /// Result to return from login operations
    Result<void>? loginResult,

    /// Result to return from logout operations
    Result<void>? logoutResult,

    /// Result to return from account creation
    Result<void>? createAccountResult,

    /// Result to return from password reset request
    Result<void>? sendPasswordResetRequestResult,

    /// Result to return from password reset
    Result<void>? resetUserPasswordResult,

    /// User ID to return after successful authentication
    String? userId,

    /// Optional delay for login operations
    /// (useful for testing loading states)
    Duration? loginDelay,

    /// Optional delay for createAccount operations
    Duration? createAccountDelay,

    /// Optional delay for logout operations
    Duration? logoutDelay,
  }) : _loginResult = loginResult ?? const Result.ok(null),
       _logoutResult = logoutResult ?? const Result.ok(null),
       _createAccountResult = createAccountResult ?? const Result.ok(null),
       _sendPasswordResetRequestResult =
           sendPasswordResetRequestResult ?? const Result.ok(null),
       _resetUserPasswordResult =
           resetUserPasswordResult ?? const Result.ok(null),
       _userId = userId,
       _loginDelay = loginDelay,
       _createAccountDelay = createAccountDelay,
       _logoutDelay = logoutDelay;

  final Result<void> _loginResult;
  final Result<void> _logoutResult;
  final Result<void> _createAccountResult;
  final Result<void> _sendPasswordResetRequestResult;
  final Result<void> _resetUserPasswordResult;
  final String? _userId;
  final Duration? _loginDelay;
  final Duration? _createAccountDelay;
  final Duration? _logoutDelay;

  bool _isAuthenticated = false;
  String? _authenticatedUserId;
  String? _userFirstName;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get userFirstName => _userFirstName ?? 'TestUser';

  @override
  String? get currentUserId => _authenticatedUserId;

  /// Track login call count for verification
  int get loginCallCount => _loginCallCount;
  int _loginCallCount = 0;

  /// Track logout call count for verification
  int get logoutCallCount => _logoutCallCount;
  int _logoutCallCount = 0;

  /// Track create account call count for verification
  int get createAccountCallCount => _createAccountCallCount;
  int _createAccountCallCount = 0;

  /// Reset all call counters
  void resetCallCounts() {
    _loginCallCount = 0;
    _logoutCallCount = 0;
    _createAccountCallCount = 0;
  }

  /// Reset authentication state
  void resetState() {
    _isAuthenticated = false;
    _authenticatedUserId = null;
    _userFirstName = null;
    resetCallCounts();
  }

  /// Simulate successful login
  void simulateLoginSuccess({String? userId, String? firstName}) {
    _isAuthenticated = true;
    _authenticatedUserId =
        userId ?? 'mock-user-${DateTime.now().millisecondsSinceEpoch}';
    _userFirstName = firstName ?? 'TestUser';
  }

  /// Simulate logout
  void simulateLogout() {
    _isAuthenticated = false;
    _authenticatedUserId = null;
    _userFirstName = null;
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    _loginCallCount++;
    if (_loginDelay != null) {
      await Future.delayed(_loginDelay);
    }
    if (_loginResult is Ok<void>) {
      _isAuthenticated = true;
      _authenticatedUserId =
          _userId ?? 'mock-user-${DateTime.now().millisecondsSinceEpoch}';
    }
    notifyListeners();
    return _loginResult;
  }

  @override
  Future<Result<void>> logout() async {
    _logoutCallCount++;
    if (_logoutDelay != null) {
      await Future.delayed(_logoutDelay);
    }
    if (_logoutResult is Ok<void>) {
      _isAuthenticated = false;
      _authenticatedUserId = null;
      _userFirstName = null;
    }
    notifyListeners();
    return _logoutResult;
  }

  @override
  Future<Result<void>> createAccount({
    required String email,
    required String password,
  }) async {
    _createAccountCallCount++;
    if (_createAccountDelay != null) {
      await Future.delayed(_createAccountDelay);
    }
    notifyListeners();
    return _createAccountResult;
  }

  @override
  Future<Result<void>> sendPasswordResetRequest({required String email}) async {
    if (_sendPasswordResetRequestResult is Ok) {
      // Simulate email sent
    }
    notifyListeners();
    return _sendPasswordResetRequestResult;
  }

  @override
  Future<Result<void>> resetUserPassword({
    required String email,
    required String newPassword,
  }) async {
    notifyListeners();
    return _resetUserPasswordResult;
  }

  @override
  Future<Result<void>> loginWithGoogle() async {
    notifyListeners();
    return const Result.ok(null);
  }
}
