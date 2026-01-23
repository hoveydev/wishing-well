import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  late MockAuthRepository authRepository;
  late ForgotPasswordViewModel viewModel;

  setUp(() {
    authRepository = MockAuthRepository();
    viewModel = ForgotPasswordViewModel(authRepository: authRepository);
  });

  group('ForgotPasswordViewModel - Initial State', () {
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

  group('ForgotPasswordViewModel - Email Field Real-time Validation', () {
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

  group('ForgotPasswordViewModel - Combined Error Handling', () {
    test('clears all errors when clearError is called', () {
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      viewModel.clearError();
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ForgotPasswordErrorType.none);
    });
  });

  group('ForgotPasswordViewModel - Error Priority', () {
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
}
