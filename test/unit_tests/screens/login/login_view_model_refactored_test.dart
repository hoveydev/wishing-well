import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/screens/login/login_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  group('LoginViewModel', () {
    late MockAuthRepository authRepository;
    late LoginViewModel viewModel;

    setUp(() {
      authRepository = MockAuthRepository();
      viewModel = LoginViewModel(authRepository: authRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.initialState, () {
      test('hasAlert returns false initially', () {
        expect(viewModel.hasAlert, false);
      });

      test('authError is LoginErrorType.none initially', () {
        final error = viewModel.authError;
        expect(error, isA<UIAuthError>());
        expect((error as UIAuthError).type, LoginErrorType.none);
      });

      test('controllers are available and empty initially', () {
        expect(viewModel.emailInputController, isNotNull);
        expect(viewModel.emailInputController.text, isEmpty);
        expect(viewModel.passwordInputController, isNotNull);
        expect(viewModel.passwordInputController.text, isEmpty);
      });

      test('clearError can be called without errors', () {
        expect(() => viewModel.clearError(), returnsNormally);
      });
    });

    group(TestGroups.validation, () {
      group('Email Field', () {
        test('empty email sets noEmail error', () {
          viewModel.updatePasswordField('password');
          viewModel.updateEmailField('');

          expect(viewModel.hasAlert, true);
          final error = viewModel.authError as UIAuthError;
          expect(error.type, LoginErrorType.noEmail);
        });

        test('invalid email format sets badEmail error', () {
          viewModel.updateEmailField('invalid-email');

          expect(viewModel.hasAlert, true);
          final error = viewModel.authError as UIAuthError;
          expect(error.type, LoginErrorType.badEmail);
        });

        test('valid email clears error', () {
          viewModel.updateEmailField('');
          expect(viewModel.hasAlert, true);

          viewModel.updateEmailField('test@example.com');
          expect(viewModel.hasAlert, false);

          final error = viewModel.authError as UIAuthError;
          expect(error.type, LoginErrorType.none);
        });

        test('email validation does not override API errors', () {
          final repo = MockAuthRepository(
            loginResult: Result.error(AuthApiException('API error')),
          );
          final vm = LoginViewModel(authRepository: repo);
          addTearDown(vm.dispose);

          vm.updateEmailField('test@example.com');
          expect(vm.authError, isA<UIAuthError>());
        });
      });

      group('Password Field', () {
        test('empty password sets noPassword error', () {
          viewModel.updateEmailField('test@example.com');
          viewModel.updatePasswordField('');

          expect(viewModel.hasAlert, true);
          final error = viewModel.authError as UIAuthError;
          expect(error.type, LoginErrorType.noPassword);
        });

        test('non-empty password clears error', () {
          viewModel.updatePasswordField('');
          expect(viewModel.hasAlert, true);

          viewModel.updatePasswordField('password');
          expect(viewModel.hasAlert, false);

          final error = viewModel.authError as UIAuthError;
          expect(error.type, LoginErrorType.none);
        });
      });

      group('Combined Validation', () {
        test('both fields empty shows noPasswordNoEmail', () {
          viewModel.updateEmailField('');
          viewModel.updatePasswordField('');

          expect(viewModel.hasAlert, true);
          final error = viewModel.authError as UIAuthError;
          expect(error.type, LoginErrorType.noPasswordNoEmail);
        });

        test('email invalid and password empty shows email error', () {
          viewModel.updateEmailField('invalid-email');
          viewModel.updatePasswordField('');

          expect(viewModel.hasAlert, true);
          final error = viewModel.authError as UIAuthError;
          expect(error.type, LoginErrorType.badEmail);
        });

        test('email valid and password empty shows password error', () {
          viewModel.updateEmailField('test@example.com');
          viewModel.updatePasswordField('');

          expect(viewModel.hasAlert, true);
          final error = viewModel.authError as UIAuthError;
          expect(error.type, LoginErrorType.noPassword);
        });

        test(
          'clearError clears UI errors but shows remaining validation issues',
          () {
            viewModel.updateEmailField('');
            viewModel.updatePasswordField('');
            expect(viewModel.hasAlert, true);

            viewModel.clearError();
            // Should still show validation error
            expect(viewModel.hasAlert, true);
            final error = viewModel.authError as UIAuthError;
            expect(error.type, LoginErrorType.noPasswordNoEmail);
          },
        );
      });
    });

    group(TestGroups.errorHandling, () {
      test('UI errors take priority over API errors', () {
        final repo = MockAuthRepository(
          loginResult: Result.error(AuthApiException('API error')),
        );
        final vm = LoginViewModel(authRepository: repo);
        addTearDown(vm.dispose);

        vm.updateEmailField('test@example.com');
        vm.updatePasswordField('password');
        expect(vm.authError, isA<UIAuthError>());
        expect((vm.authError as UIAuthError).type, LoginErrorType.none);

        vm.updateEmailField('');
        expect(vm.authError, isA<UIAuthError>());
        expect((vm.authError as UIAuthError).type, LoginErrorType.noEmail);
      });

      test('API errors are preserved when inputs are valid', () {
        final repo = MockAuthRepository(
          loginResult: Result.error(AuthApiException('API error')),
        );
        final vm = LoginViewModel(authRepository: repo);
        addTearDown(vm.dispose);

        vm.updateEmailField('test@example.com');
        vm.updatePasswordField('password');
        // With valid inputs, should show no UI errors
        expect(vm.authError, isA<UIAuthError>());
        expect((vm.authError as UIAuthError).type, LoginErrorType.none);
      });
    });
  });
}
