import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/result.dart';

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
          mockRepository.login(email: 'email@email.com', password: 'password'),
          isA<Future<Result<void>>>(),
        );
      });

      test('Has Logout Method', () {
        expect(mockRepository.logout(), isA<Future<Result<void>>>());
      });

      test('has create account method', () {
        expect(
          mockRepository.createAccount(
            email: 'new.account@email.com',
            password: 'Password123!',
          ),
          isA<Future<Result<void>>>(),
        );
      });

      test('has forgot password method', () {
        expect(
          mockRepository.sendPasswordResetRequest(
            email: 'forgot.password@email.com',
          ),
          isA<Future<Result<void>>>(),
        );
      });
    });

    group('isAuthenticated', () {
      test('returns false by default', () {
        expect(mockRepository.isAuthenticated, false);
      });

      test('Returns true After Successful Login', () async {
        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );

        expect(mockRepository.isAuthenticated, true);
      });

      test('Returns false After Logout', () async {
        // Login first
        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );
        expect(mockRepository.isAuthenticated, true);

        // Then logout
        await mockRepository.logout();
        expect(mockRepository.isAuthenticated, false);
      });
    });

    group('Login', () {
      test('Returns Ok on Successful Login', () async {
        final result = await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );

        expect(result, isA<Ok<void>>());
      });

      test('Returns Error on Failed Login', () async {
        final result = await mockRepository.login(
          email: 'wrong@email.com',
          password: 'wrongpassword',
        );

        expect(result, isA<Error<void>>());
      });

      test('Notifies Listeners on Successful Login', () async {
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );

        expect(notified, true);
      });

      test('Notifies Listeners on Failed Login', () async {
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        await mockRepository.login(
          email: 'wrong@email.com',
          password: 'wrongpassword',
        );

        expect(notified, true);
      });

      test('Updates isAuthenticated to true on Success', () async {
        expect(mockRepository.isAuthenticated, false);

        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );

        expect(mockRepository.isAuthenticated, true);
      });

      test('Keeps isAuthenticated false on Failure', () async {
        expect(mockRepository.isAuthenticated, false);

        await mockRepository.login(
          email: 'wrong@email.com',
          password: 'wrongpassword',
        );

        expect(mockRepository.isAuthenticated, false);
      });

      test('Can be Called Multiple Times', () async {
        final result1 = await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );
        expect(result1, isA<Ok<void>>());

        await mockRepository.logout();

        final result2 = await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );
        expect(result2, isA<Ok<void>>());
      });
    });

    group('logout', () {
      test('Returns Ok on Successful Logout', () async {
        // Login first
        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );

        final result = await mockRepository.logout();

        expect(result, isA<Ok<void>>());
      });

      test('Notifies Listeners on Logout', () async {
        // Login first
        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );

        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        await mockRepository.logout();

        expect(notified, true);
      });

      test('Updates isAuthenticated to false', () async {
        // Login first
        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );
        expect(mockRepository.isAuthenticated, true);

        await mockRepository.logout();

        expect(mockRepository.isAuthenticated, false);
      });
    });

    group('forgot passowrd', () {
      test('returns \'Ok\' on successful email submission', () async {
        final result = await mockRepository.sendPasswordResetRequest(
          email: 'forgot.password@email.com',
        );

        expect(result, isA<Ok<void>>());
      });

      test('returns \'Error\' on failed email submission', () async {
        final result = await mockRepository.sendPasswordResetRequest(
          email: 'wrong@email.com',
        );

        expect(result, isA<Error<void>>());
      });

      test('notifies listeners on successful email submission', () async {
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        await mockRepository.sendPasswordResetRequest(
          email: 'forgot.password@email.com',
        );

        expect(notified, true);
      });

      test('notifies listeners on failed email submission', () async {
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        await mockRepository.sendPasswordResetRequest(email: 'wrong@email.com');

        expect(notified, true);
      });

      test('Can be Called Multiple Times', () async {
        final result1 = await mockRepository.sendPasswordResetRequest(
          email: 'forgot.password@email.com',
        );
        expect(result1, isA<Ok<void>>());

        await mockRepository.logout();

        final result2 = await mockRepository.sendPasswordResetRequest(
          email: 'forgot.password@email.com',
        );
        expect(result2, isA<Ok<void>>());
      });
    });

    group('create account', () {
      test('returns \'Ok\' on successful account creation', () async {
        final result = await mockRepository.createAccount(
          email: 'new.account@email.com',
          password: 'Password123!',
        );

        expect(result, isA<Ok<void>>());
      });

      test('returns \'Error\' on failed account creation', () async {
        final result = await mockRepository.createAccount(
          email: 'wrong@email.com',
          password: 'wrongpassword',
        );

        expect(result, isA<Error<void>>());
      });

      test('notifies listeners on successful account creation', () async {
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        await mockRepository.createAccount(
          email: 'new.account@email.com',
          password: 'Password123!',
        );

        expect(notified, true);
      });

      test('notifies listeners on failed account creation', () async {
        var notified = false;
        mockRepository.addListener(() {
          notified = true;
        });

        await mockRepository.createAccount(
          email: 'wrong@email.com',
          password: 'wrongpassword',
        );

        expect(notified, true);
      });

      test('Can be Called Multiple Times', () async {
        final result1 = await mockRepository.createAccount(
          email: 'new.account@email.com',
          password: 'Password123!',
        );
        expect(result1, isA<Ok<void>>());

        await mockRepository.logout();

        final result2 = await mockRepository.createAccount(
          email: 'new.account@email.com',
          password: 'Password123!',
        );
        expect(result2, isA<Ok<void>>());
      });
    });

    group('ChangeNotifier Behavior', () {
      test('Notifies Listeners Exactly once on Login', () async {
        var notifyCount = 0;
        mockRepository.addListener(() {
          notifyCount++;
        });

        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );

        expect(notifyCount, 1);
      });

      test('Notifies Listeners Exactly Once on Logout', () async {
        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );

        var notifyCount = 0;
        mockRepository.addListener(() {
          notifyCount++;
        });

        await mockRepository.logout();

        expect(notifyCount, 1);
      });

      test('Can Remove Listeners', () async {
        var notifyCount = 0;
        void listener() {
          notifyCount++;
        }

        mockRepository.addListener(listener);
        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );
        expect(notifyCount, 1);

        mockRepository.removeListener(listener);
        await mockRepository.logout();
        expect(notifyCount, 1); // Should not increment
      });

      test('Can Have Multiple Listeners', () async {
        var listener1Count = 0;
        var listener2Count = 0;

        mockRepository.addListener(() {
          listener1Count++;
        });
        mockRepository.addListener(() {
          listener2Count++;
        });

        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );

        expect(listener1Count, 1);
        expect(listener2Count, 1);
      });
    });

    group('Edge Cases', () {
      test('Handles Empty Email', () async {
        final result = await mockRepository.login(
          email: '',
          password: 'password',
        );

        expect(result, isA<Error<void>>());
      });

      test('Handles Empty Password', () async {
        final result = await mockRepository.login(
          email: 'email@email.com',
          password: '',
        );

        expect(result, isA<Error<void>>());
      });

      test('Handles Both Empty Credentials', () async {
        final result = await mockRepository.login(email: '', password: '');

        expect(result, isA<Error<void>>());
      });
    });

    group('State Transitions', () {
      test('Login -> Logout -> Login Flow', () async {
        // Initial state
        expect(mockRepository.isAuthenticated, false);

        // Login
        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );
        expect(mockRepository.isAuthenticated, true);

        // Logout
        await mockRepository.logout();
        expect(mockRepository.isAuthenticated, false);

        // Login again
        await mockRepository.login(
          email: 'email@email.com',
          password: 'password',
        );
        expect(mockRepository.isAuthenticated, true);
      });

      test('Multiple Failed Logins do not Change State', () async {
        expect(mockRepository.isAuthenticated, false);

        await mockRepository.login(email: 'wrong@email.com', password: 'wrong');
        expect(mockRepository.isAuthenticated, false);

        await mockRepository.login(
          email: 'wrong2@email.com',
          password: 'wrong2',
        );
        expect(mockRepository.isAuthenticated, false);
      });
    });
  });
}
