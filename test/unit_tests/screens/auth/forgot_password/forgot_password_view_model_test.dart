import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/result.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';

void main() {
  late MockAuthRepository authRepository;
  late ForgotPasswordViewModel viewModel;

  setUp(() {
    authRepository = MockAuthRepository();
    viewModel = ForgotPasswordViewModel(authRepository: authRepository);
  });

  group(TestGroups.initialState, () {
    test('hasAlert returns false when no error', () {
      expect(viewModel.hasAlert, false);
    });

    test('authError is ForgotPasswordErrorType.none initially', () {
      final error = viewModel.authError;
      expect(error, isA<UIAuthError>());
      expect((error as UIAuthError).type, ForgotPasswordErrorType.none);
    });

    test('clearError can be called without error', () {
      expect(() => viewModel.clearError(), returnsNormally);
      expect(viewModel.hasAlert, false);
    });
  });

  group(TestGroups.validation, () {
    test('updateEmailField with empty email sets noEmail error', () {
      viewModel.updateEmailField('test@example.com');
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ForgotPasswordErrorType.noEmail);
    });

    test('updateEmailField with invalid email format sets badEmail error', () {
      viewModel.updateEmailField('invalid-email');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ForgotPasswordErrorType.badEmail);
    });

    test('updateEmailField with valid email clears error', () {
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      viewModel.updateEmailField('test@example.com');
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ForgotPasswordErrorType.none);
    });

    test('updateEmailField does not create SupabaseAuthError', () {
      final repo = MockAuthRepository(
        sendPasswordResetRequestResult: Result.error(
          AuthApiException('API error'),
        ),
      );
      final vm = ForgotPasswordViewModel(authRepository: repo);
      vm.updateEmailField('test@example.com');
      expect(vm.authError, isA<UIAuthError>());
    });
  });

  group(TestGroups.errorHandling, () {
    test('clears all errors when clearError is called', () {
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      viewModel.clearError();
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ForgotPasswordErrorType.none);
    });
  });

  group(TestGroups.errorHandling, () {
    test('UI errors are shown for invalid inputs', () {
      final repo = MockAuthRepository(
        sendPasswordResetRequestResult: Result.error(
          AuthApiException('API error'),
        ),
      );
      final vm = ForgotPasswordViewModel(authRepository: repo);
      vm.updateEmailField('test@example.com');
      expect(vm.authError, isA<UIAuthError>());
    });

    test('UI errors change based on input', () {
      final repo = MockAuthRepository(
        sendPasswordResetRequestResult: Result.error(
          AuthApiException('API error'),
        ),
      );
      final vm = ForgotPasswordViewModel(authRepository: repo);
      vm.updateEmailField('test@example.com');
      expect(vm.authError, isA<UIAuthError>());
      vm.updateEmailField('');
      expect(vm.authError, isA<UIAuthError>());
      expect(
        (vm.authError as UIAuthError).type,
        ForgotPasswordErrorType.noEmail,
      );
    });
  });

  group(TestGroups.behavior, () {
    test(
      'updateEmailField with leading/trailing whitespace fails validation',
      () {
        // Validation doesn't trim - whitespace around email makes it invalid
        viewModel.updateEmailField('  test@example.com  ');
        expect(viewModel.hasAlert, true);
        final error = viewModel.authError as UIAuthError;
        expect(error.type, ForgotPasswordErrorType.badEmail);
      },
    );

    test('updateEmailField with whitespace-only becomes badEmail', () {
      // Whitespace fails regex - it's badEmail not noEmail
      viewModel.updateEmailField('   ');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ForgotPasswordErrorType.badEmail);
    });

    test('clearError can be called multiple times', () {
      viewModel.updateEmailField('');
      viewModel.clearError();
      viewModel.clearError();
      viewModel.clearError();
      expect(viewModel.hasAlert, false);
    });

    test('error state transitions: valid -> invalid email', () {
      viewModel.updateEmailField('valid@email.com');
      expect(viewModel.hasAlert, false);

      viewModel.updateEmailField('invalid');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ForgotPasswordErrorType.badEmail);
    });

    test('error state transitions: invalid email -> empty', () {
      viewModel.updateEmailField('invalid');
      expect(viewModel.hasAlert, true);

      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ForgotPasswordErrorType.noEmail);
    });

    test('ViewModel contract is implemented correctly', () {
      final contract = viewModel as ForgotViewModelContract;
      contract.updateEmailField('test@email.com');
      expect(contract.hasAlert, false);

      contract.updateEmailField('');
      expect(contract.hasAlert, true);

      contract.clearError();
      expect(contract.hasAlert, false);
    });
  });

  group('Error Type Tests', () {
    test('all ForgotPasswordErrorType values are handled', () {
      // Test none
      expect(
        ForgotPasswordErrorType.values,
        contains(ForgotPasswordErrorType.none),
      );
      // Test noEmail
      expect(
        ForgotPasswordErrorType.values,
        contains(ForgotPasswordErrorType.noEmail),
      );
      // Test badEmail
      expect(
        ForgotPasswordErrorType.values,
        contains(ForgotPasswordErrorType.badEmail),
      );
      // Test unknown
      expect(
        ForgotPasswordErrorType.values,
        contains(ForgotPasswordErrorType.unknown),
      );

      expect(ForgotPasswordErrorType.values.length, 4);
    });

    test('UIAuthError stores the error type correctly', () {
      const error = UIAuthError(ForgotPasswordErrorType.noEmail);
      expect(error.type, ForgotPasswordErrorType.noEmail);
    });

    test('SupabaseAuthError stores the message correctly', () {
      const error = SupabaseAuthError<ForgotPasswordErrorType>('Network error');
      expect(error.message, 'Network error');
    });
  });

  tearDown(() {
    viewModel.dispose();
  });
}
