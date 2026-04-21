import 'package:wishing_well/data/data_sources/auth/auth_data_source.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/result.dart';

/// Implementation of [AuthRepository] using an [AuthDataSource].
///
/// This class contains the business logic for authentication,
/// including state management, error handling, and `Result<T>` transformations.
/// The actual Supabase calls are delegated to the [AuthDataSource].
class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({required AuthDataSource dataSource})
    : _dataSource = dataSource;

  final AuthDataSource _dataSource;

  @override
  bool get isAuthenticated => _dataSource.currentAccessToken != null;

  @override
  String? get userFirstName => _dataSource.userFirstName;

  @override
  String? get currentUserId => _dataSource.currentUserId;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    AppLogger.debug('Attempting login for: $email', context: 'AuthRepository');

    try {
      final response = await _dataSource.signInWithPassword(
        email: email,
        password: password,
      );

      final aud = response['aud'] as String?;
      final isAuthenticated = aud == 'authenticated';
      final accessToken = response['access_token'] as String?;

      if (isAuthenticated && accessToken != null) {
        AppLogger.info('Login successful', context: 'AuthRepository');
        return const Result.ok(null);
      } else {
        AppLogger.warning(
          'Login returned unexpected audience: $aud',
          context: 'AuthRepository',
        );
        return Result.error(Exception('unknown issue'));
      }
    } on Exception catch (err, stackTrace) {
      AppLogger.error(
        'Login failed: $err',
        context: 'AuthRepository',
        error: err,
        stackTrace: stackTrace,
      );
      _logConnectionHintIfNeeded(err, 'AuthRepository.login');
      return Result.error(err);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    AppLogger.debug('Attempting logout', context: 'AuthRepository');

    try {
      await _dataSource.signOut();
      AppLogger.info('Logout successful', context: 'AuthRepository');
      return const Result.ok(null);
    } on Exception catch (err, stackTrace) {
      AppLogger.error(
        'Logout failed: $err',
        context: 'AuthRepository',
        error: err,
        stackTrace: stackTrace,
      );
      _logConnectionHintIfNeeded(err, 'AuthRepository.logout');
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
    AppLogger.debug(
      'Attempting to create account for: $email',
      context: 'AuthRepository',
    );

    try {
      await _dataSource.signUp(email: email, password: password);
      AppLogger.info('Account creation successful', context: 'AuthRepository');
      return const Result.ok(null);
    } on Exception catch (err, stackTrace) {
      AppLogger.error(
        'Account creation failed: $err',
        context: 'AuthRepository',
        error: err,
        stackTrace: stackTrace,
      );
      _logConnectionHintIfNeeded(err, 'AuthRepository.createAccount');
      return Result.error(err);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> sendPasswordResetRequest({required String email}) async {
    AppLogger.debug(
      'Sending password reset request for: $email',
      context: 'AuthRepository',
    );

    try {
      await _dataSource.resetPasswordForEmail(email);
      AppLogger.info('Password reset request sent', context: 'AuthRepository');
      return const Result.ok(null);
    } on Exception catch (err, stackTrace) {
      AppLogger.error(
        'Password reset request failed: $err',
        context: 'AuthRepository',
        error: err,
        stackTrace: stackTrace,
      );
      _logConnectionHintIfNeeded(
        err,
        'AuthRepository.sendPasswordResetRequest',
      );
      return Result.error(err);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> resetUserPassword({
    required String email,
    required String newPassword,
  }) async {
    AppLogger.debug(
      'Resetting password for: $email',
      context: 'AuthRepository',
    );

    try {
      await _dataSource.updateUserPassword(
        email: email,
        newPassword: newPassword,
      );
      AppLogger.info('Password reset successful', context: 'AuthRepository');
      return const Result.ok(null);
    } on Exception catch (err, stackTrace) {
      AppLogger.error(
        'Password reset failed: $err',
        context: 'AuthRepository',
        error: err,
        stackTrace: stackTrace,
      );
      _logConnectionHintIfNeeded(err, 'AuthRepository.resetUserPassword');
      return Result.error(err);
    } finally {
      notifyListeners();
    }
  }

  void _logConnectionHintIfNeeded(Exception err, String context) {
    final message = err.toString();
    if (message.contains('Connection refused') ||
        message.contains('SocketException')) {
      AppLogger.warning(
        'Hint: Connection refused — this often means the app is targeting a '
        'local Supabase instance that is not running. '
        'Run `supabase start` or change _environment in lib/main.dart.',
        context: context,
      );
    }
  }
}
