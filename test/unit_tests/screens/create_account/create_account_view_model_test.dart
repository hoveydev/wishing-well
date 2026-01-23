import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/screens/create_account/create_account_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  late MockAuthRepository authRepository;
  late CreateAccountViewModel viewModel;

  setUp(() {
    authRepository = MockAuthRepository();
    viewModel = CreateAccountViewModel(authRepository: authRepository);
  });

  group('CreateAccountViewmodel - Initial State', () {
    test('hasAlert returns false when no error', () {
      expect(viewModel.hasAlert, false);
    });

    test('authError is CreateAccountErrorType.none initially', () {
      final error = viewModel.authError;
      expect(error, isA<UIAuthError>());
      expect((error as UIAuthError).type, CreateAccountErrorType.none);
    });

    test('metPasswordRequirements is empty initially', () {
      expect(viewModel.metPasswordRequirements, isEmpty);
    });

    test('clearError can be called without error', () {
      expect(() => viewModel.clearError(), returnsNormally);
    });
  });

  group('CreateAccountViewmodel - Email Field Real-time Validation', () {
    test('updateEmailField with empty email sets noEmail error', () {
      viewModel.updatePasswordOneField('ValidPassword123!');
      viewModel.updatePasswordTwoField('ValidPassword123!');
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, CreateAccountErrorType.noEmail);
    });

    test('updateEmailField with invalid email format sets badEmail error', () {
      viewModel.updateEmailField('invalid-email');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, CreateAccountErrorType.badEmail);
    });

    test('updateEmailField with valid email clears error', () {
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      viewModel.updateEmailField('test@example.com');
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, CreateAccountErrorType.none);
    });

    test('updateEmailField does not create SupabaseAuthError', () {
      final repo = MockAuthRepository(
        createAccountResult: Result.error(AuthApiException('API error')),
      );
      final vm = CreateAccountViewModel(authRepository: repo);
      vm.updateEmailField('test@example.com');
      expect(vm.authError, isA<UIAuthError>());
    });
  });

  group('CreateAccountViewmodel - Password One Field Real-time Validation', () {
    test('updatePasswordOneField with short'
        'password does not meet length requirement', () {
      viewModel.updatePasswordOneField('short');
      expect(
        viewModel.metPasswordRequirements.contains(
          CreateAccountPasswordRequirements.adequateLength,
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
            CreateAccountPasswordRequirements.adequateLength,
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
            CreateAccountPasswordRequirements.containsUppercase,
          ),
          false,
        );
      },
    );

    test('updatePasswordOneField with uppercase meets requirement', () {
      viewModel.updatePasswordOneField('Password123!');
      expect(
        viewModel.metPasswordRequirements.contains(
          CreateAccountPasswordRequirements.containsUppercase,
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
            CreateAccountPasswordRequirements.containsLowercase,
          ),
          false,
        );
      },
    );

    test('updatePasswordOneField with lowercase meets requirement', () {
      viewModel.updatePasswordOneField('PASSWORDa123!');
      expect(
        viewModel.metPasswordRequirements.contains(
          CreateAccountPasswordRequirements.containsLowercase,
        ),
        true,
      );
    });

    test('updatePasswordOneField without digit does not meet requirement', () {
      viewModel.updatePasswordOneField('PasswordTest!');
      expect(
        viewModel.metPasswordRequirements.contains(
          CreateAccountPasswordRequirements.containsDigit,
        ),
        false,
      );
    });

    test('updatePasswordOneField with digit meets requirement', () {
      viewModel.updatePasswordOneField('PasswordTest!1');
      expect(
        viewModel.metPasswordRequirements.contains(
          CreateAccountPasswordRequirements.containsDigit,
        ),
        true,
      );
    });

    test('updatePasswordOneField without special'
        'character does not meet requirement', () {
      viewModel.updatePasswordOneField('PasswordTest123');
      expect(
        viewModel.metPasswordRequirements.contains(
          CreateAccountPasswordRequirements.containsSpecial,
        ),
        false,
      );
    });

    test('updatePasswordOneField with special character meets requirement', () {
      viewModel.updatePasswordOneField('PasswordTest123!');
      expect(
        viewModel.metPasswordRequirements.contains(
          CreateAccountPasswordRequirements.containsSpecial,
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
        expect(error.type, CreateAccountErrorType.passwordRequirementsNotMet);
      },
    );

    test('updatePasswordOneField clears error when requirements are met', () {
      viewModel.updateEmailField('test@example.com');
      viewModel.updatePasswordOneField('short');
      viewModel.updatePasswordTwoField('short');
      expect(viewModel.hasAlert, true);
      viewModel.updatePasswordOneField('ValidPassword123!');
      viewModel.updatePasswordTwoField('ValidPassword123!');
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, CreateAccountErrorType.none);
    });

    test('updatePasswordOneField does not create SupabaseAuthError', () {
      final repo = MockAuthRepository(
        createAccountResult: Result.error(AuthApiException('API error')),
      );
      final vm = CreateAccountViewModel(authRepository: repo);
      vm.updateEmailField('test@example.com');
      vm.updatePasswordOneField('ValidPassword123!');
      expect(vm.authError, isA<UIAuthError>());
    });
  });

  group('CreateAccountViewmodel - Password Two Field Real-time Validation', () {
    test(
      'updatePasswordTwoField without matching does not meet requirement',
      () {
        viewModel.updatePasswordOneField('ValidPassword123!');
        viewModel.updatePasswordTwoField('DifferentPassword123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            CreateAccountPasswordRequirements.matching,
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
          CreateAccountPasswordRequirements.matching,
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
            CreateAccountPasswordRequirements.matching,
          ),
          true,
        );
        viewModel.updatePasswordOneField('DifferentPassword123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            CreateAccountPasswordRequirements.matching,
          ),
          false,
        );
      },
    );

    test('updatePasswordTwoField does not create SupabaseAuthError', () {
      final repo = MockAuthRepository(
        createAccountResult: Result.error(AuthApiException('API error')),
      );
      final vm = CreateAccountViewModel(authRepository: repo);
      vm.updateEmailField('test@example.com');
      vm.updatePasswordOneField('ValidPassword123!');
      expect(vm.authError, isA<UIAuthError>());
    });
  });

  group('CreateAccountViewmodel - Password Requirements Real-time Updates', () {
    test('all requirements are met with valid password', () {
      viewModel.updatePasswordOneField('ValidPassword123!');
      viewModel.updatePasswordTwoField('ValidPassword123!');
      expect(
        viewModel.metPasswordRequirements.containsAll(
          CreateAccountPasswordRequirements.values,
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
            CreateAccountPasswordRequirements.matching,
          ),
          false,
        );
        viewModel.updatePasswordTwoField('ValidPassword123!');
        expect(
          viewModel.metPasswordRequirements.contains(
            CreateAccountPasswordRequirements.matching,
          ),
          true,
        );
      },
    );
  });

  group('CreateAccountViewmodel - Combined Error Handling', () {
    test('shows email error when email is invalid and password is invalid', () {
      viewModel.updateEmailField('invalid-email');
      viewModel.updatePasswordOneField('short');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, CreateAccountErrorType.badEmail);
    });

    test(
      'shows password error when email is valid but password is invalid',
      () {
        viewModel.updateEmailField('test@example.com');
        viewModel.updatePasswordOneField('short');
        expect(viewModel.hasAlert, true);
        final error = viewModel.authError as UIAuthError;
        expect(error.type, CreateAccountErrorType.passwordRequirementsNotMet);
      },
    );

    test('clears all errors when clearError is called', () {
      viewModel.updateEmailField('');
      viewModel.updatePasswordOneField('short');
      expect(viewModel.hasAlert, true);
      viewModel.clearError();
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, CreateAccountErrorType.none);
    });
  });

  group('CreateAccountViewmodel - Error Priority', () {
    test('UI errors are shown for invalid inputs', () {
      final repo = MockAuthRepository(
        createAccountResult: Result.error(AuthApiException('API error')),
      );
      final vm = CreateAccountViewModel(authRepository: repo);
      vm.updateEmailField('test@example.com');
      vm.updatePasswordOneField('ValidPassword123!');
      vm.updatePasswordTwoField('ValidPassword123!');
      expect(vm.authError, isA<UIAuthError>());
      expect((vm.authError as UIAuthError).type, CreateAccountErrorType.none);
    });

    test('UI errors change based on input', () {
      final repo = MockAuthRepository(
        createAccountResult: Result.error(AuthApiException('API error')),
      );
      final vm = CreateAccountViewModel(authRepository: repo);
      vm.updateEmailField('test@example.com');
      vm.updatePasswordOneField('ValidPassword123!');
      vm.updatePasswordTwoField('ValidPassword123!');
      expect(vm.authError, isA<UIAuthError>());
      expect((vm.authError as UIAuthError).type, CreateAccountErrorType.none);
      vm.updateEmailField('');
      expect(vm.authError, isA<UIAuthError>());
      expect(
        (vm.authError as UIAuthError).type,
        CreateAccountErrorType.noEmail,
      );
    });
  });
}
