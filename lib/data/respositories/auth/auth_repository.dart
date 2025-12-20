import 'package:flutter/foundation.dart';
import 'package:wishing_well/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  /// Returns true when user is logged in
  bool get isAuthenticated;

  /// Login
  Future<Result<void>> login({required String email, required String password});

  /// Logout
  Future<Result<void>> logout();

  /// Create Account
  Future<Result<void>> createAccount({
    required String email,
    required String password,
  });

  /// Send password reset
  Future<Result<void>> sendPasswordResetRequest({required String email});
}
