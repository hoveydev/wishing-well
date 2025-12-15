import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/result.dart';

class MockAuthRepository extends AuthRepository {
  @override
  bool get isAuthenticated => _isAuthenticated;

  bool _isAuthenticated = false;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    if (email == 'email@email.com' && password == 'password') {
      _isAuthenticated = true;
      notifyListeners();
      return const Result.ok(null);
    } else {
      notifyListeners();
      return Result.error(Exception('invalid username and password'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    if (isAuthenticated == true) {
      notifyListeners();
      _isAuthenticated = false;
      return const Result.ok(null);
    } else {
      notifyListeners();
      return Result.error(Exception('no valid user is logged in'));
    }
  }
}
