import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/screens/profile_screen/profile_viewmodel.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  late _TestAuthRepository authRepository;
  late ProfileViewModel viewModel;

  setUp(() {
    authRepository = _TestAuthRepository(logoutResult: const Result.ok(null));
    viewModel = ProfileViewModel(authRepository: authRepository);
  });

  group('ProfileViewModel', () {
    test('hasAlert returns false when no error', () {
      expect(viewModel.hasAlert, false);
    });

    test('authError is ProfileErrorType.none initially', () {
      final error = viewModel.authError;
      expect(error, isA<UIAuthError>());
      expect((error as UIAuthError).type, ProfileErrorType.none);
    });

    test('clearError can be called without error', () {
      expect(() => viewModel.clearError(), returnsNormally);
      expect(viewModel.hasAlert, false);
    });
  });
}

class _TestAuthRepository extends AuthRepository {
  _TestAuthRepository({required this.logoutResult});

  final Result<void> logoutResult;

  @override
  bool get isAuthenticated => true;

  @override
  String? get userFirstName => null;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> logout() async => logoutResult;

  @override
  Future<Result<void>> createAccount({
    required String email,
    required String password,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> sendPasswordResetRequest({
    required String email,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> resetUserPassword({
    required String email,
    required String newPassword,
    required String token,
  }) async => const Result.ok(null);
}
