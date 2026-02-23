import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';
import '../../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('MockAuthRepository', () {
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
    });

    tearDown(() {
      mockRepository.dispose();
    });

    group(TestGroups.initialState, () {
      test('is a ChangeNotifier', () {
        expect(mockRepository, isA<ChangeNotifier>());
      });

      test('has isAuthenticated getter', () {
        expect(mockRepository.isAuthenticated, isA<bool>());
      });

      test('returns false by default', () {
        expect(mockRepository.isAuthenticated, false);
      });

      test('has login method', () {
        expect(
          mockRepository.login(email: 'any@email.com', password: 'any'),
          isA<Future<Result<void>>>(),
        );
      });

      test('has logout method', () {
        expect(mockRepository.logout(), isA<Future<Result<void>>>());
      });

      test('has create account method', () {
        expect(
          mockRepository.createAccount(email: 'any@email.com', password: 'any'),
          isA<Future<Result<void>>>(),
        );
      });

      test('has forgot password method', () {
        expect(
          mockRepository.sendPasswordResetRequest(email: 'any@email.com'),
          isA<Future<Result<void>>>(),
        );
      });

      test('has reset password method', () {
        expect(
          mockRepository.resetUserPassword(
            email: 'any@email.com',
            newPassword: 'any',
            token: 'any',
          ),
          isA<Future<Result<void>>>(),
        );
      });
    });

    group(TestGroups.behavior, () {
      test('returns true after successful login', () async {
        mockRepository = MockAuthRepository(loginResult: const Result.ok(null));
        await mockRepository.login(email: 'any@email.com', password: 'any');

        expect(mockRepository.isAuthenticated, true);
      });

      test('returns false after logout', () async {
        mockRepository = MockAuthRepository(
          loginResult: const Result.ok(null),
          logoutResult: const Result.ok(null),
        );
        await mockRepository.login(email: 'any@email.com', password: 'any');
        expect(mockRepository.isAuthenticated, true);

        await mockRepository.logout();
        expect(mockRepository.isAuthenticated, false);
      });

      test('keeps false after failed login', () async {
        mockRepository = MockAuthRepository(
          loginResult: Result.error(Exception('error')),
        );
        await mockRepository.login(email: 'any@email.com', password: 'any');

        expect(mockRepository.isAuthenticated, false);
      });
    });

    group('Login', () {
      test('returns ok on success and notifies listeners', () async {
        mockRepository = MockAuthRepository(loginResult: const Result.ok(null));
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        final result = await mockRepository.login(
          email: 'any@email.com',
          password: 'any',
        );

        expect(result, isA<Ok<void>>());
        expect(notified, true);
      });

      test('returns error on failure and notifies listeners', () async {
        mockRepository = MockAuthRepository(
          loginResult: Result.error(Exception('error')),
        );
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        final result = await mockRepository.login(
          email: 'any@email.com',
          password: 'any',
        );

        expect(result, isA<Error<void>>());
        expect(notified, true);
      });

      test('can be called multiple times', () async {
        mockRepository = MockAuthRepository(
          loginResult: const Result.ok(null),
          logoutResult: const Result.ok(null),
        );
        final result1 = await mockRepository.login(
          email: 'any@email.com',
          password: 'any',
        );
        expect(result1, isA<Ok<void>>());
        expect(mockRepository.isAuthenticated, true);

        await mockRepository.logout();

        final result2 = await mockRepository.login(
          email: 'any@email.com',
          password: 'any',
        );
        expect(result2, isA<Ok<void>>());
        expect(mockRepository.isAuthenticated, true);
      });
    });

    group('Logout', () {
      test(
        'returns ok, notifies listeners, and updates isAuthenticated',
        () async {
          mockRepository = MockAuthRepository(
            loginResult: const Result.ok(null),
            logoutResult: const Result.ok(null),
          );
          await mockRepository.login(email: 'any@email.com', password: 'any');
          expect(mockRepository.isAuthenticated, true);

          var notified = false;
          mockRepository.addListener(() {
            notified = true;
          });

          final result = await mockRepository.logout();

          expect(result, isA<Ok<void>>());
          expect(notified, true);
          expect(mockRepository.isAuthenticated, false);
        },
      );
    });

    group('Create Account', () {
      test('returns ok on success and notifies listeners', () async {
        mockRepository = MockAuthRepository(
          createAccountResult: const Result.ok(null),
        );
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        final result = await mockRepository.createAccount(
          email: 'any@email.com',
          password: 'any',
        );

        expect(result, isA<Ok<void>>());
        expect(notified, true);
      });

      test('returns error on failure and notifies listeners', () async {
        mockRepository = MockAuthRepository(
          createAccountResult: Result.error(Exception('error')),
        );
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        final result = await mockRepository.createAccount(
          email: 'any@email.com',
          password: 'any',
        );

        expect(result, isA<Error<void>>());
        expect(notified, true);
      });

      test('can be called multiple times', () async {
        mockRepository = MockAuthRepository(
          createAccountResult: const Result.ok(null),
          logoutResult: const Result.ok(null),
        );
        final result1 = await mockRepository.createAccount(
          email: 'any@email.com',
          password: 'any',
        );
        expect(result1, isA<Ok<void>>());

        await mockRepository.logout();

        final result2 = await mockRepository.createAccount(
          email: 'any@email.com',
          password: 'any',
        );
        expect(result2, isA<Ok<void>>());
      });
    });

    group('Send Password Reset Request', () {
      test('returns ok on success and notifies listeners', () async {
        mockRepository = MockAuthRepository(
          sendPasswordResetRequestResult: const Result.ok(null),
        );
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        final result = await mockRepository.sendPasswordResetRequest(
          email: 'any@email.com',
        );

        expect(result, isA<Ok<void>>());
        expect(notified, true);
      });

      test('returns error on failure and notifies listeners', () async {
        mockRepository = MockAuthRepository(
          sendPasswordResetRequestResult: Result.error(Exception('error')),
        );
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        final result = await mockRepository.sendPasswordResetRequest(
          email: 'any@email.com',
        );

        expect(result, isA<Error<void>>());
        expect(notified, true);
      });

      test('can be called multiple times', () async {
        mockRepository = MockAuthRepository(
          sendPasswordResetRequestResult: const Result.ok(null),
          logoutResult: const Result.ok(null),
        );
        final result1 = await mockRepository.sendPasswordResetRequest(
          email: 'any@email.com',
        );
        expect(result1, isA<Ok<void>>());

        await mockRepository.logout();

        final result2 = await mockRepository.sendPasswordResetRequest(
          email: 'any@email.com',
        );
        expect(result2, isA<Ok<void>>());
      });
    });

    group('Reset User Password', () {
      test('returns ok on success and notifies listeners', () async {
        mockRepository = MockAuthRepository(
          resetUserPasswordResult: const Result.ok(null),
        );
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        final result = await mockRepository.resetUserPassword(
          email: 'any@email.com',
          newPassword: 'any',
          token: 'any',
        );

        expect(result, isA<Ok<void>>());
        expect(notified, true);
      });

      test('returns error on failure and notifies listeners', () async {
        mockRepository = MockAuthRepository(
          resetUserPasswordResult: Result.error(Exception('error')),
        );
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        final result = await mockRepository.resetUserPassword(
          email: 'any@email.com',
          newPassword: 'any',
          token: 'any',
        );

        expect(result, isA<Error<void>>());
        expect(notified, true);
      });

      test('can be called multiple times', () async {
        mockRepository = MockAuthRepository(
          resetUserPasswordResult: const Result.ok(null),
          logoutResult: const Result.ok(null),
        );
        final result1 = await mockRepository.resetUserPassword(
          email: 'any@email.com',
          newPassword: 'any',
          token: 'any',
        );
        expect(result1, isA<Ok<void>>());

        await mockRepository.logout();

        final result2 = await mockRepository.resetUserPassword(
          email: 'any@email.com',
          newPassword: 'any',
          token: 'any',
        );
        expect(result2, isA<Ok<void>>());
      });
    });

    group('ChangeNotifier Behavior', () {
      test('notifies listeners exactly once on login', () async {
        mockRepository = MockAuthRepository(loginResult: const Result.ok(null));
        var notifyCount = 0;
        mockRepository.addListener(() {
          notifyCount++;
        });

        await mockRepository.login(email: 'any@email.com', password: 'any');

        expect(notifyCount, 1);
      });

      test('notifies listeners exactly once on logout', () async {
        mockRepository = MockAuthRepository(
          loginResult: const Result.ok(null),
          logoutResult: const Result.ok(null),
        );
        await mockRepository.login(email: 'any@email.com', password: 'any');

        var notifyCount = 0;
        mockRepository.addListener(() {
          notifyCount++;
        });

        await mockRepository.logout();

        expect(notifyCount, 1);
      });

      test('can remove listeners', () async {
        mockRepository = MockAuthRepository(
          loginResult: const Result.ok(null),
          logoutResult: const Result.ok(null),
        );
        var notifyCount = 0;
        void listener() {
          notifyCount++;
        }

        mockRepository.addListener(listener);
        await mockRepository.login(email: 'any@email.com', password: 'any');
        expect(notifyCount, 1);

        mockRepository.removeListener(listener);
        await mockRepository.logout();
        expect(notifyCount, 1);
      });

      test('can have multiple listeners', () async {
        mockRepository = MockAuthRepository(loginResult: const Result.ok(null));
        var listener1Count = 0;
        var listener2Count = 0;

        mockRepository.addListener(() {
          listener1Count++;
        });
        mockRepository.addListener(() {
          listener2Count++;
        });

        await mockRepository.login(email: 'any@email.com', password: 'any');

        expect(listener1Count, 1);
        expect(listener2Count, 1);
      });
    });

    group(TestGroups.stateChanges, () {
      test('login -> logout -> login flow', () async {
        mockRepository = MockAuthRepository(
          loginResult: const Result.ok(null),
          logoutResult: const Result.ok(null),
        );
        expect(mockRepository.isAuthenticated, false);

        await mockRepository.login(email: 'any@email.com', password: 'any');
        expect(mockRepository.isAuthenticated, true);

        await mockRepository.logout();
        expect(mockRepository.isAuthenticated, false);

        await mockRepository.login(email: 'any@email.com', password: 'any');
        expect(mockRepository.isAuthenticated, true);
      });

      test('multiple failed logins do not change state', () async {
        mockRepository = MockAuthRepository(
          loginResult: Result.error(Exception('error')),
        );
        expect(mockRepository.isAuthenticated, false);

        await mockRepository.login(email: 'any@email.com', password: 'any');
        expect(mockRepository.isAuthenticated, false);

        await mockRepository.login(email: 'any2@email.com', password: 'any2');
        expect(mockRepository.isAuthenticated, false);
      });
    });
  });
}
