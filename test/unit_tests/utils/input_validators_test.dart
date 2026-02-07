import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/input_validators.dart';

void main() {
  group('InputValidators', () {
    group('Email Validation', () {
      test('isEmailEmpty returns true for empty string', () {
        expect(InputValidators.isEmailEmpty(''), true);
      });

      test('isEmailEmpty returns false for non-empty string', () {
        expect(InputValidators.isEmailEmpty('test@email.com'), false);
      });

      test('isEmailValid returns true for valid email', () {
        expect(InputValidators.isEmailValid('test@email.com'), true);
        expect(
          InputValidators.isEmailValid('user.name+tag@example.co.uk'),
          true,
        );
      });

      test('isEmailValid returns false for invalid email', () {
        expect(InputValidators.isEmailValid('invalid'), false);
        expect(InputValidators.isEmailValid('invalid@'), false);
        expect(InputValidators.isEmailValid('@example.com'), false);
        expect(InputValidators.isEmailValid('noatsign.com'), false);
        expect(InputValidators.isEmailValid(' spaces@email.com'), false);
      });
    });

    group('Password Validation', () {
      test('isPasswordEmpty returns true for empty password', () {
        expect(InputValidators.isPasswordEmpty(''), true);
      });

      test('isPasswordEmpty returns false for non-empty password', () {
        expect(InputValidators.isPasswordEmpty('password123'), false);
      });

      test('hasAdequateLength returns true for 12+ characters', () {
        expect(InputValidators.hasAdequateLength('TwelveChars!'), true);
        expect(InputValidators.hasAdequateLength('VeryLongPassword123!'), true);
      });

      test('hasAdequateLength returns false for less than 12 characters', () {
        expect(InputValidators.hasAdequateLength('Short1!'), false);
        expect(InputValidators.hasAdequateLength('ElevenCh1!'), false);
      });

      test('hasUppercase returns true when uppercase present', () {
        expect(InputValidators.hasUppercase('PASSWORD'), true);
        expect(InputValidators.hasUppercase('PassWord123'), true);
        expect(InputValidators.hasUppercase('pAssword!'), true);
      });

      test('hasUppercase returns false when no uppercase', () {
        expect(InputValidators.hasUppercase('password'), false);
        expect(InputValidators.hasUppercase('password123!'), false);
        expect(InputValidators.hasUppercase(''), false);
      });

      test('hasLowercase returns true when lowercase present', () {
        expect(InputValidators.hasLowercase('password'), true);
        expect(InputValidators.hasLowercase('PassWord123'), true);
        expect(InputValidators.hasLowercase('PASSword!'), true);
      });

      test('hasLowercase returns false when no lowercase', () {
        expect(InputValidators.hasLowercase('PASSWORD'), false);
        expect(InputValidators.hasLowercase('PASSWORD123!'), false);
        expect(InputValidators.hasLowercase(''), false);
      });

      test('hasDigit returns true when digit present', () {
        expect(InputValidators.hasDigit('password1'), true);
        expect(InputValidators.hasDigit('Pass123Word'), true);
        expect(InputValidators.hasDigit('123'), true);
      });

      test('hasDigit returns false when no digit', () {
        expect(InputValidators.hasDigit('password'), false);
        expect(InputValidators.hasDigit('Password!'), false);
        expect(InputValidators.hasDigit(''), false);
      });

      test('hasSpecialCharacter returns true when special char present', () {
        expect(InputValidators.hasSpecialCharacter('password!'), true);
        expect(InputValidators.hasSpecialCharacter('Pass@word'), true);
        expect(InputValidators.hasSpecialCharacter('Test#123'), true);
      });

      test('hasSpecialCharacter returns false when no special char', () {
        expect(InputValidators.hasSpecialCharacter('password'), false);
        expect(InputValidators.hasSpecialCharacter('Password123'), false);
        expect(InputValidators.hasSpecialCharacter(''), false);
      });

      test('passwordsMatch returns true when passwords match', () {
        expect(
          InputValidators.passwordsMatch('password123', 'password123'),
          true,
        );
        expect(InputValidators.passwordsMatch('Test@123', 'Test@123'), true);
        expect(InputValidators.passwordsMatch('', ''), true);
      });

      test('passwordsMatch returns false when passwords do not match', () {
        expect(
          InputValidators.passwordsMatch('password123', 'password456'),
          false,
        );
        expect(InputValidators.passwordsMatch('Test@123', 'test@123'), false);
        expect(InputValidators.passwordsMatch('Password1', 'password1'), false);
      });
    });
  });
}
