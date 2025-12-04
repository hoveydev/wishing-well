import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository_remote.dart';
import 'package:wishing_well/result.dart';

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
  });
}
