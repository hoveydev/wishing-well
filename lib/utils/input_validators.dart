class InputValidators {
  static final RegExp _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static bool isEmailValid(String email) => _emailRegex.hasMatch(email);

  static bool isEmailEmpty(String email) => email.isEmpty;

  static bool isPasswordEmpty(String password) => password.isEmpty;

  static bool hasAdequateLength(String password) => password.length >= 12;

  static bool hasUppercase(String password) =>
      password.contains(RegExp(r'[A-Z]'));

  static bool hasLowercase(String password) =>
      password.contains(RegExp(r'[a-z]'));

  static bool hasDigit(String password) => password.contains(RegExp(r'[0-9]'));

  static bool hasSpecialCharacter(String password) =>
      password.contains(RegExp(r'[^a-zA-Z0-9]'));

  static bool passwordsMatch(String passwordOne, String passwordTwo) =>
      passwordOne == passwordTwo;
}
