import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/screens/auth/reset_password/reset_password_view_model.dart';
import 'package:wishing_well/utils/input_validators.dart';
import 'package:wishing_well/utils/password_validator.dart';
import '../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('PasswordValidator', () {
    late PasswordValidator<CreateAccountPasswordRequirements> validator;

    setUp(() {
      validator = PasswordValidator<CreateAccountPasswordRequirements>();
    });

    group(TestGroups.initialState, () {
      test('has no met requirements initially', () {
        expect(validator.metRequirements, isEmpty);
      });
    });

    group(TestGroups.behavior, () {
      test('checkRequirements updates met requirements correctly', () {
        final requirements = {
          CreateAccountPasswordRequirements.adequateLength:
              InputValidators.hasAdequateLength,
          CreateAccountPasswordRequirements.containsUppercase:
              InputValidators.hasUppercase,
          CreateAccountPasswordRequirements.containsLowercase:
              InputValidators.hasLowercase,
          CreateAccountPasswordRequirements.containsDigit:
              InputValidators.hasDigit,
          CreateAccountPasswordRequirements.containsSpecial:
              InputValidators.hasSpecialCharacter,
        };

        validator.checkRequirements('TestPassword123!', requirements);

        expect(validator.metRequirements.length, equals(5));

        // Now test checkPasswordsMatch separately
        validator.checkPasswordsMatch(
          'TestPassword123!',
          'TestPassword123!',
          CreateAccountPasswordRequirements.matching,
        );

        expect(validator.metRequirements.length, equals(6));
        expect(
          validator.metRequirements.contains(
            CreateAccountPasswordRequirements.adequateLength,
          ),
          isTrue,
        );
      });

      test('checkRequirements removes requirements when not met', () {
        final requirements = {
          CreateAccountPasswordRequirements.adequateLength:
              InputValidators.hasAdequateLength,
          CreateAccountPasswordRequirements.containsUppercase:
              InputValidators.hasUppercase,
        };

        validator.checkRequirements('TestPassword123!', requirements);
        expect(validator.metRequirements.length, equals(2));

        // Check requirement with weak password
        validator.checkRequirements('weak', requirements);
        expect(validator.metRequirements.length, equals(0));
      });

      test('checkPasswordsMatch adds matching requirement', () {
        validator.checkPasswordsMatch(
          'TestPassword123!',
          'TestPassword123!',
          CreateAccountPasswordRequirements.matching,
        );

        expect(
          validator.metRequirements.contains(
            CreateAccountPasswordRequirements.matching,
          ),
          isTrue,
        );
      });

      test('checkPasswordsMatch removes matching when different', () {
        validator.checkPasswordsMatch(
          'TestPassword123!',
          'DifferentPassword456!',
          CreateAccountPasswordRequirements.matching,
        );

        expect(
          validator.metRequirements.contains(
            CreateAccountPasswordRequirements.matching,
          ),
          isFalse,
        );
      });

      test(
        'checkPasswordsMatch does not add matching when one password is empty',
        () {
          validator.checkPasswordsMatch(
            'TestPassword123!',
            '',
            CreateAccountPasswordRequirements.matching,
          );

          expect(
            validator.metRequirements.contains(
              CreateAccountPasswordRequirements.matching,
            ),
            isFalse,
          );
        },
      );

      test('reset clears all requirements', () {
        validator.checkRequirements('TestPassword123!', {
          CreateAccountPasswordRequirements.adequateLength:
              InputValidators.hasAdequateLength,
        });

        expect(validator.metRequirements, isNotEmpty);

        validator.reset();

        expect(validator.metRequirements, isEmpty);
      });

      test('reset does not notifyListeners when already empty', () {
        var listenerCallCount = 0;
        validator.addListener(() {
          listenerCallCount++;
        });

        validator.reset();

        expect(listenerCallCount, equals(0));
      });
    });

    group(TestGroups.stateChanges, () {
      test('notifyListeners is called when requirement is added', () {
        var listenerCallCount = 0;
        validator.addListener(() {
          listenerCallCount++;
        });

        validator.checkRequirements('TestPassword123!', {
          CreateAccountPasswordRequirements.adequateLength:
              InputValidators.hasAdequateLength,
        });

        expect(listenerCallCount, equals(1));
      });

      test('notifyListeners is called when requirement is removed', () {
        // First add a requirement
        validator.checkRequirements('TestPassword123!', {
          CreateAccountPasswordRequirements.adequateLength:
              InputValidators.hasAdequateLength,
        });

        var listenerCallCount = 0;
        validator.addListener(() {
          listenerCallCount++;
        });

        // Now remove it
        validator.checkRequirements('weak', {
          CreateAccountPasswordRequirements.adequateLength:
              InputValidators.hasAdequateLength,
        });

        expect(listenerCallCount, equals(1));
      });
    });

    group('PasswordValidator with ResetPasswordRequirements', () {
      late PasswordValidator<ResetPasswordRequirements> resetValidator;

      setUp(() {
        resetValidator = PasswordValidator<ResetPasswordRequirements>();
      });

      test('works with different enum type', () {
        final requirements = {
          ResetPasswordRequirements.adequateLength:
              InputValidators.hasAdequateLength,
        };

        resetValidator.checkRequirements('TestPassword123!', requirements);

        expect(
          resetValidator.metRequirements.contains(
            ResetPasswordRequirements.adequateLength,
          ),
          isTrue,
        );
      });
    });
  });
}
