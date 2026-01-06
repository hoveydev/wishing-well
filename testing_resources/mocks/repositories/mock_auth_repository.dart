import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/result.dart';

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
    } else if (email == 'supabase.error@email.com') {
      notifyListeners();
      return Result.error(AuthApiException('supabase error'));
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

  @override
  Future<Result<void>> createAccount({
    required String email,
    required String password,
  }) async {
    if (email == 'new.account@email.com' &&
        password == 'passwordPASSWORD123@#') {
      notifyListeners();
      return const Result.ok(null);
    } else if (email == 'supabase.error@email.com') {
      notifyListeners();
      return Result.error(AuthApiException('supabase error'));
    } else {
      notifyListeners();
      return Result.error(Exception('generic error'));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetRequest({required String email}) async {
    if (email == 'forgot.password@email.com') {
      notifyListeners();
      return const Result.ok(null);
    } else if (email == 'supabase.error@email.com') {
      notifyListeners();
      return Result.error(AuthApiException('supabase error'));
    } else {
      notifyListeners();
      return Result.error(Exception('unknown service error'));
    }
  }

  @override
  Future<Result<void>> resetUserPassword({
    required String email,
    required String newPassword,
    required String token,
  }) async {
    if (token == 'valid-token') {
      notifyListeners();
      return const Result.ok(null);
    } else if (token == 'supabase-error-token') {
      notifyListeners();
      return Result.error(AuthApiException('supabase error'));
    } else {
      notifyListeners();
      return Result.error(Exception('unknown service error'));
    }
  }
}
