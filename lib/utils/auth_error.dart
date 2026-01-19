sealed class AuthError<T> {
  const AuthError();
}

enum LoginErrorType {
  none,
  noPasswordNoEmail,
  noEmail,
  badEmail,
  noPassword,
  unknown,
}

enum CreateAccountErrorType {
  none,
  noEmail,
  badEmail,
  passwordRequirementsNotMet,
  unknown,
}

enum ForgotPasswordErrorType { none, noEmail, badEmail, unknown }

enum ResetPasswordErrorType { none, passwordRequirementsNotMet, unknown }

enum ProfileErrorType { none, unknown }

class UIAuthError<T> extends AuthError<T> {
  const UIAuthError(this.type);
  final T type;
}

class SupabaseAuthError<T> extends AuthError<T> {
  const SupabaseAuthError(this.message);
  final String message;
}
