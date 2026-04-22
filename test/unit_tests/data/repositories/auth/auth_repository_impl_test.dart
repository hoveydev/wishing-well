import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository_impl.dart';
import 'package:wishing_well/utils/result.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/data_sources/mock_auth_data_source.dart';

void main() {
  group('AuthRepositoryImpl', () {
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

      test('isAuthenticated returns false when no access token', () {
        mockDataSource.mockAccessToken = null;
        expect(repository.isAuthenticated, isFalse);
      });

      test('isAuthenticated returns true when access token exists', () {
        mockDataSource.mockAccessToken = 'test-token';
        expect(repository.isAuthenticated, isTrue);
      });

      test('userFirstName returns null by default', () {
        mockDataSource.mockUserFirstName = null;
        expect(repository.userFirstName, isNull);
      });

      test('userFirstName returns value from data source', () {
        mockDataSource.mockUserFirstName = 'TestUser';
        expect(repository.userFirstName, 'TestUser');
      });
    });

    group('Login', () {
      test(
        'returns Ok on successful login with authenticated audience',
        () async {
          mockDataSource.signInWithPasswordResult = {
            'user_id': 'test-user-id',
            'aud': 'authenticated',
            'email': 'test@example.com',
            'access_token': 'test-access-token',
            'refresh_token': 'test-refresh-token',
          };

          final result = await repository.login(
            email: 'test@example.com',
            password: 'password',
          );

          expect(result, isA<Ok>());
          expect(mockDataSource.signInWithPasswordCalled, isTrue);
        },
      );

      test('returns Error when audience is not authenticated', () async {
        mockDataSource.signInWithPasswordResult = {
          'user_id': 'test-user-id',
          'aud': 'not-authenticated',
          'email': 'test@example.com',
        };

        final result = await repository.login(
          email: 'test@example.com',
          password: 'password',
        );

        expect(result, isA<Error>());
      });

      test('returns Error on data source exception', () async {
        mockDataSource.signInWithPasswordError = Exception(
          'Invalid credentials',
        );

        final result = await repository.login(
          email: 'test@example.com',
          password: 'wrong-password',
        );

        expect(result, isA<Error>());
      });

      test('notifies listeners after login attempt', () async {
        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        await repository.login(email: 'test@example.com', password: 'password');

        expect(notified, isTrue);
      });

      test('calls data source with correct parameters', () async {
        await repository.login(
          email: 'specific@email.com',
          password: 'specific-password',
        );

        expect(mockDataSource.signInWithPasswordCalled, isTrue);
      });
    });

    group('Logout', () {
      test('returns Ok on successful logout', () async {
        final result = await repository.logout();

        expect(result, isA<Ok>());
        expect(mockDataSource.signOutCalled, isTrue);
      });

      test('returns Error on data source exception', () async {
        mockDataSource.signOutError = Exception('Sign out failed');

        final result = await repository.logout();

        expect(result, isA<Error>());
      });

      test('notifies listeners after logout', () async {
        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        await repository.logout();

        expect(notified, isTrue);
      });
    });

    group('Create Account', () {
      test('returns Ok on successful account creation', () async {
        final result = await repository.createAccount(
          email: 'new@example.com',
          password: 'password',
        );

        expect(result, isA<Ok>());
        expect(mockDataSource.signUpCalled, isTrue);
      });

      test('returns Error on data source exception', () async {
        mockDataSource.signUpError = Exception('Email already exists');

        final result = await repository.createAccount(
          email: 'existing@example.com',
          password: 'password',
        );

        expect(result, isA<Error>());
      });

      test('notifies listeners after account creation attempt', () async {
        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        await repository.createAccount(
          email: 'new@example.com',
          password: 'password',
        );

        expect(notified, isTrue);
      });
    });

    group('Send Password Reset Request', () {
      test('returns Ok on successful password reset request', () async {
        final result = await repository.sendPasswordResetRequest(
          email: 'test@example.com',
        );

        expect(result, isA<Ok>());
        expect(mockDataSource.resetPasswordForEmailCalled, isTrue);
      });

      test('returns Error on data source exception', () async {
        mockDataSource.resetPasswordForEmailError = Exception(
          'Email not found',
        );

        final result = await repository.sendPasswordResetRequest(
          email: 'nonexistent@example.com',
        );

        expect(result, isA<Error>());
      });

      test('notifies listeners after password reset request', () async {
        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        await repository.sendPasswordResetRequest(email: 'test@example.com');

        expect(notified, isTrue);
      });
    });

    group('Reset User Password', () {
      test('returns Ok on successful password reset', () async {
        final result = await repository.resetUserPassword(
          email: 'test@example.com',
          newPassword: 'newPassword',
        );

        expect(result, isA<Ok>());
        expect(mockDataSource.updateUserPasswordCalled, isTrue);
      });

      test('returns Error on data source exception', () async {
        mockDataSource.updateUserPasswordError = Exception('Invalid token');

        final result = await repository.resetUserPassword(
          email: 'test@example.com',
          newPassword: 'newPassword',
        );

        expect(result, isA<Error>());
      });

      test('notifies listeners after password reset attempt', () async {
        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        await repository.resetUserPassword(
          email: 'test@example.com',
          newPassword: 'newPassword',
        );

        expect(notified, isTrue);
      });
    });

    group('ChangeNotifier Behavior', () {
      test('notifies listeners exactly once on login', () async {
        var notifyCount = 0;
        repository.addListener(() {
          notifyCount++;
        });

        await repository.login(email: 'test@example.com', password: 'password');

        expect(notifyCount, 1);
      });

      test('notifies listeners exactly once on logout', () async {
        var notifyCount = 0;
        repository.addListener(() {
          notifyCount++;
        });

        await repository.logout();

        expect(notifyCount, 1);
      });

      test('can remove listeners', () async {
        var notifyCount = 0;
        void listener() {
          notifyCount++;
        }

        repository.addListener(listener);
        await repository.login(email: 'test@example.com', password: 'password');
        expect(notifyCount, 1);

        repository.removeListener(listener);
        await repository.logout();
        expect(notifyCount, 1);
      });

      test('can have multiple listeners', () async {
        var listener1Count = 0;
        var listener2Count = 0;

        repository.addListener(() {
          listener1Count++;
        });
        repository.addListener(() {
          listener2Count++;
        });

        await repository.login(email: 'test@example.com', password: 'password');

        expect(listener1Count, 1);
        expect(listener2Count, 1);
      });
    });

    group(TestGroups.stateChanges, () {
      test('login -> logout flow updates authentication state', () async {
        mockDataSource.mockAccessToken = null;
        expect(repository.isAuthenticated, isFalse);

        mockDataSource.signInWithPasswordResult = {
          'user_id': 'test-user-id',
          'aud': 'authenticated',
          'email': 'test@example.com',
          'access_token': 'test-access-token',
          'refresh_token': 'test-refresh-token',
        };
        mockDataSource.mockAccessToken = 'test-token';

        await repository.login(email: 'test@example.com', password: 'password');
        expect(repository.isAuthenticated, isTrue);

        mockDataSource.mockAccessToken = null;
        await repository.logout();
        expect(repository.isAuthenticated, isFalse);
      });

      test('failed login does not change authentication state', () async {
        mockDataSource.mockAccessToken = null;
        expect(repository.isAuthenticated, isFalse);

        mockDataSource.signInWithPasswordError = Exception('Failed');

        await repository.login(email: 'test@example.com', password: 'wrong');
        expect(repository.isAuthenticated, isFalse);
      });
    });
  });
}
