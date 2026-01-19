import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  group('AuthRepository', () {
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
    });

    tearDown(() {
      mockRepository.dispose();
    });

    group('Contract', () {
      test('Is a ChangeNotifier', () {
        expect(mockRepository, isA<ChangeNotifier>());
      });

      test('Has isAuthenticated Getter', () {
        expect(mockRepository.isAuthenticated, isA<bool>());
      });

      test('Has Login Method', () {
        expect(
          mockRepository.login(email: 'any@email.com', password: 'any'),
          isA<Future<Result<void>>>(),
        );
      });

      test('Has Logout Method', () {
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
    });

    group('isAuthenticated', () {
      test('returns false by default', () {
        expect(mockRepository.isAuthenticated, false);
      });

      test('Returns true After Successful Login', () async {
        mockRepository = MockAuthRepository(loginResult: const Result.ok(null));
        await mockRepository.login(email: 'any@email.com', password: 'any');

        expect(mockRepository.isAuthenticated, true);
      });

      test('Returns false After Logout', () async {
        mockRepository = MockAuthRepository(
          loginResult: const Result.ok(null),
          logoutResult: const Result.ok(null),
        );
        await mockRepository.login(email: 'any@email.com', password: 'any');
        expect(mockRepository.isAuthenticated, true);

        await mockRepository.logout();
        expect(mockRepository.isAuthenticated, false);
      });

      test('Keeps false After Failed Login', () async {
        mockRepository = MockAuthRepository(
          loginResult: Result.error(Exception('error')),
        );
        await mockRepository.login(email: 'any@email.com', password: 'any');

        expect(mockRepository.isAuthenticated, false);
      });
    });

    group('Login', () {
      test('Returns Ok on Success and Notifies Listeners', () async {
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

      test('Returns Error on Failure and Notifies Listeners', () async {
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

      test('Can be Called Multiple Times', () async {
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

    group('logout', () {
      test(
        'Returns Ok, Notifies Listeners, and Updates isAuthenticated',
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

    group('sendPasswordResetRequest', () {
      test('Returns Ok on Success and Notifies Listeners', () async {
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

      test('Returns Error on Failure and Notifies Listeners', () async {
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

      test('Can be Called Multiple Times', () async {
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

    group('resetUserPassword', () {
      test('Returns Ok on Success and Notifies Listeners', () async {
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

      test('Returns Error on Failure and Notifies Listeners', () async {
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

      test('Can be Called Multiple Times', () async {
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

    group('createAccount', () {
      test('Returns Ok on Success and Notifies Listeners', () async {
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

      test('Returns Error on Failure and Notifies Listeners', () async {
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

      test('Can be Called Multiple Times', () async {
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

    group('ChangeNotifier Behavior', () {
      test('Notifies Listeners Exactly once on Login', () async {
        mockRepository = MockAuthRepository(loginResult: const Result.ok(null));
        var notifyCount = 0;
        mockRepository.addListener(() {
          notifyCount++;
        });

        await mockRepository.login(email: 'any@email.com', password: 'any');

        expect(notifyCount, 1);
      });

      test('Notifies Listeners Exactly Once on Logout', () async {
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

      test('Can Remove Listeners', () async {
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

      test('Can Have Multiple Listeners', () async {
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

    group('State Transitions', () {
      test('Login -> Logout -> Login Flow', () async {
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

      test('Multiple Failed Logins do not Change State', () async {
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
