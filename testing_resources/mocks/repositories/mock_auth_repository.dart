import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/result.dart';

class MockAuthRepository extends AuthRepository {
  MockAuthRepository({
    Result<void>? logoutResult,
    Result<void>? loginResult,
    Result<void>? createAccountResult,
    Result<void>? sendPasswordResetRequestResult,
    Result<void>? resetUserPasswordResult,
  }) : logoutResult = logoutResult ?? const Result.ok(null),
       loginResult = loginResult ?? const Result.ok(null),
       createAccountResult = createAccountResult ?? const Result.ok(null),
       sendPasswordResetRequestResult =
           sendPasswordResetRequestResult ?? const Result.ok(null),
       resetUserPasswordResult =
           resetUserPasswordResult ?? const Result.ok(null);

  final Result<void> logoutResult;
  final Result<void> loginResult;
  final Result<void> createAccountResult;
  final Result<void> sendPasswordResetRequestResult;
  final Result<void> resetUserPasswordResult;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get userFirstName => 'TestUser';

  bool _isAuthenticated = false;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    if (loginResult is Ok) {
      _isAuthenticated = true;
    }
    notifyListeners();
    return loginResult;
  }

  @override
  Future<Result<void>> logout() async {
    if (loginResult is Ok) {
      _isAuthenticated = false;
    }
    notifyListeners();
    return logoutResult;
  }

  @override
  Future<Result<void>> createAccount({
    required String email,
    required String password,
  }) async {
    notifyListeners();
    return createAccountResult;
  }

  @override
  Future<Result<void>> sendPasswordResetRequest({required String email}) async {
    notifyListeners();
    return sendPasswordResetRequestResult;
  }

  @override
  Future<Result<void>> resetUserPassword({
    required String email,
    required String newPassword,
    required String token,
  }) async {
    notifyListeners();
    return resetUserPasswordResult;
  }
}
