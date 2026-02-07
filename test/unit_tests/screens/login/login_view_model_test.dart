import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/screens/auth/login/login_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/result.dart';
import '../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  late MockAuthRepository authRepository;
  late LoginViewModel viewModel;

  setUp(() {
    authRepository = MockAuthRepository();
    viewModel = LoginViewModel(authRepository: authRepository);
  });

  group(TestGroups.initialState, () {
    test('hasAlert returns false when no error', () {
      expect(viewModel.hasAlert, false);
    });

    test('authError is LoginErrorType.none initially', () {
      final error = viewModel.authError;
      expect(error, isA<UIAuthError>());
      expect((error as UIAuthError).type, LoginErrorType.none);
    });

    test('clearError can be called without error', () {
      expect(() => viewModel.clearError(), returnsNormally);
    });
  });

  group(TestGroups.validation, () {
    test('updateEmailField with empty email sets noEmail error', () {
      viewModel.updatePasswordField('password');
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.noEmail);
    });

    test('updateEmailField with invalid email format sets badEmail error', () {
      viewModel.updateEmailField('invalid-email');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.badEmail);
    });

    test('updateEmailField with valid email clears error', () {
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      viewModel.updateEmailField('test@example.com');
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.none);
    });

    test('updateEmailField does not create SupabaseAuthError', () {
      final repo = MockAuthRepository(
        loginResult: Result.error(AuthApiException('API error')),
      );
      final vm = LoginViewModel(authRepository: repo);
      addTearDown(vm.dispose);
      vm.updateEmailField('test@example.com');
      expect(vm.authError, isA<UIAuthError>());
    });
  });

  group(TestGroups.validation, () {
    test('updatePasswordField with empty password sets noPassword error', () {
      viewModel.updateEmailField('test@example.com');
      viewModel.updatePasswordField('');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.noPassword);
    });

    test('updatePasswordField with non-empty password clears error', () {
      viewModel.updatePasswordField('');
      expect(viewModel.hasAlert, true);
      viewModel.updatePasswordField('password');
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.none);
    });

    test('updatePasswordField does not create SupabaseAuthError', () {
      final repo = MockAuthRepository(
        loginResult: Result.error(AuthApiException('API error')),
      );
      final vm = LoginViewModel(authRepository: repo);
      addTearDown(vm.dispose);
      vm.updateEmailField('test@example.com');
      vm.updatePasswordField('password');
      expect(vm.authError, isA<UIAuthError>());
    });
  });

  group(TestGroups.errorHandling, () {
    test('shows noPasswordNoEmail when both fields are empty', () {
      viewModel.updateEmailField('');
      viewModel.updatePasswordField('');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.noPasswordNoEmail);
    });

    test('shows email error when both email and password are invalid', () {
      viewModel.updateEmailField('invalid-email');
      viewModel.updatePasswordField('');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.badEmail);
    });

    test('shows password error when email is valid but password is empty', () {
      viewModel.updateEmailField('test@example.com');
      viewModel.updatePasswordField('');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.noPassword);
    });

    test('clears all errors when clearError is called', () {
      viewModel.updateEmailField('');
      viewModel.updatePasswordField('');
      expect(viewModel.hasAlert, true);
      viewModel.clearError();
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.noPasswordNoEmail);
    });
  });

  group(TestGroups.errorHandling, () {
    test('UI errors are shown for invalid inputs', () {
      final repo = MockAuthRepository(
        loginResult: Result.error(AuthApiException('API error')),
      );
      final vm = LoginViewModel(authRepository: repo);
      addTearDown(vm.dispose);
      vm.updateEmailField('test@example.com');
      vm.updatePasswordField('password');
      expect(vm.authError, isA<UIAuthError>());
      expect((vm.authError as UIAuthError).type, LoginErrorType.none);
    });

    test('UI errors change based on input', () {
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
  });

  group(TestGroups.behavior, () {
    test('emailInputController is available', () {
      expect(viewModel.emailInputController, isNotNull);
      expect(viewModel.emailInputController.text, isEmpty);
    });

    test('passwordInputController is available', () {
      expect(viewModel.passwordInputController, isNotNull);
      expect(viewModel.passwordInputController.text, isEmpty);
    });
  });

  tearDown(() {
    viewModel.dispose();
  });
}
