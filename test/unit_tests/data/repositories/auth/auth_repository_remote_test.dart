import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository_remote.dart';
import 'package:wishing_well/utils/app_config.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../../testing_resources/services/mock_supabase_client.dart';
import '../../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AuthRepositoryRemote', () {
    late MockSupabaseClient mockSupabaseClient;
    late AuthRepositoryRemote repository;

    setUpAll(() async {
      await AppConfig.initialize(environment: Environment.test);
    });

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      repository = AuthRepositoryRemote(supabase: mockSupabaseClient);
    });

    group(TestGroups.initialState, () {
      test('user is not authenticated on start', () async {
        final isAuthenticated = repository.isAuthenticated;
        expect(isAuthenticated, isFalse);
      });
    });

    group('Login', () {
      test('performs successful login', () async {
        final result = await repository.login(
          email: 'EMAIL',
          password: 'PASSWORD',
        );
        expect(result, isA<Ok>());
        expect(repository.isAuthenticated, isTrue);
      });

      test('performs login error', () async {
        final result = await repository.login(
          email: 'wrong',
          password: 'wrong',
        );
        expect(result, isA<Error>());
        expect(repository.isAuthenticated, isFalse);
      });

      test('performs login with inaccurate authentication', () async {
        final result = await repository.login(
          email: 'EMAIL_WRONG_AUTH',
          password: 'PASSWORD_WRONG_AUTH',
        );
        expect(result, isA<Error>());
        expect(repository.isAuthenticated, isFalse);
      });
    });

    group('Logout', () {
      test('performs successful logout', () async {
        await repository.login(email: 'EMAIL', password: 'PASSWORD');
        final result = await repository.logout();
        expect(result, isA<Ok>());
        expect(repository.isAuthenticated, isFalse);
      });

      test('performs logout error', () async {
        final result = await repository.logout();
        expect(result, isA<Error>());
        expect(repository.isAuthenticated, isFalse);
      });
    });

    group('Create Account', () {
      test('performs successful create account', () async {
        final result = await repository.createAccount(
          email: 'EMAIL',
          password: 'PASSWORD',
        );
        expect(result, isA<Ok>());
        expect(repository.isAuthenticated, isFalse);
      });

      test('performs create account error', () async {
        final result = await repository.createAccount(
          email: 'EMAIL_WRONG',
          password: 'PASSWORD_WRONG',
        );
        expect(result, isA<Error>());
        expect(repository.isAuthenticated, isFalse);
      });
    });

    group('Send Password Reset Request', () {
      test('performs successful forgot password', () async {
        final result = await repository.sendPasswordResetRequest(
          email: 'EMAIL',
        );
        expect(result, isA<Ok>());
        expect(repository.isAuthenticated, isFalse);
      });

      test('performs forgot password error', () async {
        final result = await repository.sendPasswordResetRequest(
          email: 'EMAIL_WRONG',
        );
        expect(result, isA<Error>());
        expect(repository.isAuthenticated, isFalse);
      });
    });

    group('Reset User Password', () {
      test('performs successful reset password', () async {
        final result = await repository.resetUserPassword(
          email: 'EMAIL',
          newPassword: 'NEWPASS',
          token: 'FAKE-TOKEN',
        );
        expect(result, isA<Ok>());
        expect(repository.isAuthenticated, isFalse);
      });

      test('performs reset password error', () async {
        final result = await repository.resetUserPassword(
          email: 'EMAIL',
          newPassword: 'NEWPASS',
          token: 'WRONG-FAKE-TOKEN',
        );
        expect(result, isA<Error>());
        expect(repository.isAuthenticated, isFalse);
      });
    });
  });
}
