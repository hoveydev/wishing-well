import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository_impl.dart';
import 'package:wishing_well/utils/result.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/data_sources/mock_auth_data_source.dart';

void main() {
  group('AuthRepositoryImpl - Google Login', () {
    late MockAuthDataSource mockDataSource;
    late AuthRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockAuthDataSource();
      repository = AuthRepositoryImpl(dataSource: mockDataSource);
    });

    tearDown(() {
      repository.dispose();
    });

    group(TestGroups.initialState, () {
      test('is a ChangeNotifier', () {
        expect(repository, isA<ChangeNotifier>());
      });
    });

    group('Google Login', () {
      test('returns Ok on successful Google login', () async {
        final result = await repository.loginWithGoogle();

        expect(result, isA<Ok>());
        expect(mockDataSource.signInWithGoogleCalled, isTrue);
      });

      test('returns Error on data source exception', () async {
        mockDataSource.signInWithGoogleError = Exception(
          'Google sign-in failed',
        );

        final result = await repository.loginWithGoogle();

        expect(result, isA<Error>());
      });

      test('notifies listeners after Google login attempt', () async {
        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        await repository.loginWithGoogle();

        expect(notified, isTrue);
      });

      test('notifies listeners even when Google login fails', () async {
        mockDataSource.signInWithGoogleError = Exception('Failure');
        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        await repository.loginWithGoogle();

        expect(notified, isTrue);
      });

      test('calls data source signInWithGoogle', () async {
        await repository.loginWithGoogle();

        expect(mockDataSource.signInWithGoogleCalled, isTrue);
      });

      test('notifies listeners exactly once on Google login', () async {
        var notifyCount = 0;
        repository.addListener(() {
          notifyCount++;
        });

        await repository.loginWithGoogle();

        expect(notifyCount, 1);
      });
    });
  });
}
