import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/result.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({required SupabaseClient supabase})
    : _supabase = supabase;

  final SupabaseClient _supabase;
  bool _isAuthenticated = false;
  String? _userFirstName;

  @override
  bool get isAuthenticated {
    final session = _supabase.auth.currentSession;
    _isAuthenticated = session?.user.aud == 'authenticated';
    return _isAuthenticated;
  }

  // userFirstName getter is not tested because tests use MockAuthRepository
  @override
  String? get userFirstName {
    final user = _supabase.auth.currentUser;
    _userFirstName = user?.userMetadata?['first_name'];
    return _userFirstName;
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginResult = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _isAuthenticated = loginResult.user?.aud == 'authenticated';
      if (_isAuthenticated) {
        return const Result.ok(
          null,
        ); // could return the entire AuthResponse if makes sense
      } else {
        return Result.error(Exception('unknown issue'));
      }
    } on Exception catch (err) {
      return Result.error(err);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _supabase.auth.signOut();
      _isAuthenticated = false;
      return const Result.ok(null);
    } on Exception catch (err) {
      return Result.error(err);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo:
            'https://wishing-well-ayb.pages.dev/auth/account-confirm',
      );
      return const Result.ok(null);
    } on Exception catch (err) {
      return Result.error(err);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> sendPasswordResetRequest({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo:
            'https://wishing-well-ayb.pages.dev/auth/password-reset?email=$email',
      );
      return const Result.ok(null);
    } on Exception catch (err) {
      return Result.error(err);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> resetUserPassword({
    required String email,
    required String newPassword,
    required String token,
  }) async {
    try {
      final UserAttributes attributes = UserAttributes(
        email: email,
        password: newPassword,
        nonce: token,
      );
      await _supabase.auth.updateUser(attributes);
      return const Result.ok(null);
    } on Exception catch (err) {
      return Result.error(err);
    } finally {
      notifyListeners();
    }
  }
}
