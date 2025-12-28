import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository_remote.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../../testing_resources/services/mock_supabase_client.dart';

void main() {
  group('AuthRepositoryRemote Tests', () {
    late MockSupabaseClient mockSupabaseClient;
    late AuthRepositoryRemote repository;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      repository = AuthRepositoryRemote(supabase: mockSupabaseClient);
    });

    test('User is not authenticated on start', () async {
      final isAuthenticated = repository.isAuthenticated;
      expect(isAuthenticated, isFalse);
    });

    test('Perform Successful Login', () async {
      final result = await repository.login(
        email: 'EMAIL',
        password: 'PASSWORD',
      );
      expect(result, isA<Ok>());
      expect(repository.isAuthenticated, isTrue);
    });

    test('Perform Login Error', () async {
      final result = await repository.login(email: 'wrong', password: 'wrong');
      expect(result, isA<Error>());
      expect(repository.isAuthenticated, isFalse);
    });

    test('perform login with innacurate authentication', () async {
      final result = await repository.login(
        email: 'EMAIL_WRONG_AUTH',
        password: 'PASSWORD_WRONG_AUTH',
      );
      expect(result, isA<Error>());
      expect(repository.isAuthenticated, isFalse);
    });

    test('Perform Successful Logout', () async {
      await repository.login(email: 'EMAIL', password: 'PASSWORD');
      final result = await repository.logout();
      expect(result, isA<Ok>());
      expect(repository.isAuthenticated, isFalse);
    });

    test('Perform Logout Error', () async {
      final result = await repository.logout();
      expect(result, isA<Error>());
      expect(repository.isAuthenticated, isFalse);
    });

    test('perform successful create account', () async {
      final result = await repository.createAccount(
        email: 'EMAIL',
        password: 'PASSWORD',
      );
      expect(result, isA<Ok>());
      expect(repository.isAuthenticated, isFalse);
    });

    test('perform create account error', () async {
      final result = await repository.createAccount(
        email: 'EMAIL_WRONG',
        password: 'PASSWORD_WRONG',
      );
      expect(result, isA<Error>());
      expect(repository.isAuthenticated, isFalse);
    });

    test('perform successful forgot password', () async {
      final result = await repository.sendPasswordResetRequest(email: 'EMAIL');
      expect(result, isA<Ok>());
      expect(repository.isAuthenticated, isFalse);
    });

    test('perform forgot password error', () async {
      final result = await repository.sendPasswordResetRequest(
        email: 'EMAIL_WRONG',
      );
      expect(result, isA<Error>());
      expect(repository.isAuthenticated, isFalse);
    });

    test('perform successful reset password', () async {
      final result = await repository.resetUserPassword(
        email: 'EMAIL',
        newPassword: 'NEWPASS',
        token: 'FAKE-TOKEN',
      );
      expect(result, isA<Ok>());
      expect(repository.isAuthenticated, isFalse);
    });

    test('perform reset password error', () async {
      final result = await repository.resetUserPassword(
        email: 'EMAIL',
        newPassword: 'NEWPASS',
        token: 'WRONG-FAKE-TOKEN',
      );
      expect(result, isA<Error>());
      expect(repository.isAuthenticated, isFalse);
    });
  });
}
