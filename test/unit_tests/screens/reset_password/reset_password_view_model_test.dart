import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/screens/reset_password/reset_password_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  late MockAuthRepository authRepository;
  late ResetPasswordViewModel viewModel;

  setUp(() {
    authRepository = MockAuthRepository();
    viewModel = ResetPasswordViewModel(
      authRepository: authRepository,
      email: 'test@example.com',
      token: 'test-token',
    );
  });

  group('ResetPasswordViewmodel - Initial State', () {
    test('hasAlert returns false when no error', () {
      expect(viewModel.hasAlert, false);
    });

    test('authError is ResetPasswordErrorType.none initially', () {
      final error = viewModel.authError;
      expect(error, isA<UIAuthError>());
      expect((error as UIAuthError).type, ResetPasswordErrorType.none);
    });

    test('metPasswordRequirements is empty initially', () {
      expect(viewModel.metPasswordRequirements, isEmpty);
    });

    test('clearError can be called without error', () {
      expect(() => viewModel.clearError(), returnsNormally);
      expect(viewModel.hasAlert, false);
    });
  });

  group('ResetPasswordViewmodel - Password One Field Real-time Validation', () {
    test('updatePasswordOneField with short password'
        'does not meet length requirement', () {
      viewModel.updatePasswordOneField('short');
      expect(
        viewModel.metPasswordRequirements.contains(
          ResetPasswordRequirements.adequateLength,
        ),
        false,
      );
    });

    test(
      'updatePasswordOneField with adequate length meets length requirement',
      () {
        viewModel.updatePasswordOneField('Aa1!Aa1!Aa1!');
        expect(
          viewModel.metPasswordRequirements.contains(
            ResetPasswordRequirements.adequateLength,
          ),
          true,
        );
      },
    );

    test(
      'updatePasswordOneField without uppercase does not meet requirement',
      () {
        viewModel.updatePasswordOneField('password123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            ResetPasswordRequirements.containsUppercase,
          ),
          false,
        );
      },
    );

    test('updatePasswordOneField with uppercase meets requirement', () {
      viewModel.updatePasswordOneField('Password123!');
      expect(
        viewModel.metPasswordRequirements.contains(
          ResetPasswordRequirements.containsUppercase,
        ),
        true,
      );
    });

    test(
      'updatePasswordOneField without lowercase does not meet requirement',
      () {
        viewModel.updatePasswordOneField('PASSWORD123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            ResetPasswordRequirements.containsLowercase,
          ),
          false,
        );
      },
    );

    test('updatePasswordOneField with lowercase meets requirement', () {
      viewModel.updatePasswordOneField('PASSWORDa123!');
      expect(
        viewModel.metPasswordRequirements.contains(
          ResetPasswordRequirements.containsLowercase,
        ),
        true,
      );
    });

    test('updatePasswordOneField without digit does not meet requirement', () {
      viewModel.updatePasswordOneField('PasswordTest!');
      expect(
        viewModel.metPasswordRequirements.contains(
          ResetPasswordRequirements.containsDigit,
        ),
        false,
      );
    });

    test('updatePasswordOneField with digit meets requirement', () {
      viewModel.updatePasswordOneField('PasswordTest!1');
      expect(
        viewModel.metPasswordRequirements.contains(
          ResetPasswordRequirements.containsDigit,
        ),
        true,
      );
    });

    test('updatePasswordOneField without special'
        'character does not meet requirement', () {
      viewModel.updatePasswordOneField('PasswordTest123');
      expect(
        viewModel.metPasswordRequirements.contains(
          ResetPasswordRequirements.containsSpecial,
        ),
        false,
      );
    });

    test('updatePasswordOneField with special character meets requirement', () {
      viewModel.updatePasswordOneField('PasswordTest123!');
      expect(
        viewModel.metPasswordRequirements.contains(
          ResetPasswordRequirements.containsSpecial,
        ),
        true,
      );
    });

    test(
      'updatePasswordOneField sets password error when requirements not met',
      () {
        viewModel.updatePasswordOneField('short');
        expect(viewModel.hasAlert, true);
        final error = viewModel.authError as UIAuthError;
        expect(error.type, ResetPasswordErrorType.passwordRequirementsNotMet);
      },
    );

    test('updatePasswordOneField clears error when requirements are met', () {
      viewModel.updatePasswordOneField('short');
      viewModel.updatePasswordTwoField('short');
      expect(viewModel.hasAlert, true);
      viewModel.updatePasswordOneField('ValidPassword123!');
      viewModel.updatePasswordTwoField('ValidPassword123!');
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ResetPasswordErrorType.none);
    });

    test('updatePasswordOneField does not create SupabaseAuthError', () {
      final repo = MockAuthRepository(
        resetUserPasswordResult: Result.error(AuthApiException('API error')),
      );
      final vm = ResetPasswordViewModel(
        authRepository: repo,
        email: 'test@example.com',
        token: 'test-token',
      );
      vm.updatePasswordOneField('ValidPassword123!');
      expect(vm.authError, isA<UIAuthError>());
    });
  });

  group('ResetPasswordViewmodel - Password Two Field Real-time Validation', () {
    test(
      'updatePasswordTwoField without matching does not meet requirement',
      () {
        viewModel.updatePasswordOneField('ValidPassword123!');
        viewModel.updatePasswordTwoField('DifferentPassword123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            ResetPasswordRequirements.matching,
          ),
          false,
        );
      },
    );

    test('updatePasswordTwoField with matching meets requirement', () {
      viewModel.updatePasswordOneField('ValidPassword123!');
      viewModel.updatePasswordTwoField('ValidPassword123!');
      expect(
        viewModel.metPasswordRequirements.contains(
          ResetPasswordRequirements.matching,
        ),
        true,
      );
    });

    test(
      'updatePasswordTwoField removes matching when first password changes',
      () {
        viewModel.updatePasswordOneField('ValidPassword123!');
        viewModel.updatePasswordTwoField('ValidPassword123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            ResetPasswordRequirements.matching,
          ),
          true,
        );
        viewModel.updatePasswordOneField('DifferentPassword123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            ResetPasswordRequirements.matching,
          ),
          false,
        );
      },
    );

    test('updatePasswordTwoField does not create SupabaseAuthError', () {
      final repo = MockAuthRepository(
        resetUserPasswordResult: Result.error(AuthApiException('API error')),
      );
      final vm = ResetPasswordViewModel(
        authRepository: repo,
        email: 'test@example.com',
        token: 'test-token',
      );
      vm.updatePasswordOneField('ValidPassword123!');
      expect(vm.authError, isA<UIAuthError>());
    });
  });

  group('ResetPasswordViewmodel - Password Requirements Real-time Updates', () {
    test('all requirements are met with valid password', () {
      viewModel.updatePasswordOneField('ValidPassword123!');
      viewModel.updatePasswordTwoField('ValidPassword123!');
      expect(
        viewModel.metPasswordRequirements.containsAll(
          ResetPasswordRequirements.values,
        ),
        true,
      );
    });

    test(
      'matching requirement only appears when both passwords have values',
      () {
        viewModel.updatePasswordOneField('ValidPassword123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            ResetPasswordRequirements.matching,
          ),
          false,
        );
        viewModel.updatePasswordTwoField('ValidPassword123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            ResetPasswordRequirements.matching,
          ),
          true,
        );
      },
    );
  });

  group('ResetPasswordViewmodel - Combined Error Handling', () {
    test('clears all errors when clearError is called', () {
      viewModel.updatePasswordOneField('short');
      expect(viewModel.hasAlert, true);
      viewModel.clearError();
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, ResetPasswordErrorType.none);
    });
  });

  group('ResetPasswordViewmodel - Error Priority', () {
    test('UI errors are shown for invalid inputs', () {
      final repo = MockAuthRepository(
        resetUserPasswordResult: Result.error(AuthApiException('API error')),
      );
      final vm = ResetPasswordViewModel(
        authRepository: repo,
        email: 'test@example.com',
        token: 'test-token',
      );
      vm.updatePasswordOneField('ValidPassword123!');
      vm.updatePasswordTwoField('ValidPassword123!');
      expect(vm.authError, isA<UIAuthError>());
      expect((vm.authError as UIAuthError).type, ResetPasswordErrorType.none);
    });

    test('UI errors change based on input', () {
      final repo = MockAuthRepository(
        resetUserPasswordResult: Result.error(AuthApiException('API error')),
      );
      final vm = ResetPasswordViewModel(
        authRepository: repo,
        email: 'test@example.com',
        token: 'test-token',
      );
      vm.updatePasswordOneField('ValidPassword123!');
      vm.updatePasswordTwoField('ValidPassword123!');
      expect(vm.authError, isA<UIAuthError>());
      expect((vm.authError as UIAuthError).type, ResetPasswordErrorType.none);
      vm.updatePasswordOneField('short');
      expect(vm.authError, isA<UIAuthError>());
      expect(
        (vm.authError as UIAuthError).type,
        ResetPasswordErrorType.passwordRequirementsNotMet,
      );
    });
  });
}
