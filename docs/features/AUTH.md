# Auth Feature

## Overview

The **Auth** feature provides the full authentication flow for the Wishing Well app: signing in, creating a new account, requesting a password reset link, and setting a new password via a deep link. It is the app's entry point — all authenticated routes require passing through this feature first.

## Feature Scope

### What It Does
- Validates and submits email/password credentials to sign users in
- Creates new accounts with email + password (with real-time password requirement feedback)
- Sends a password-reset email to a provided address
- Accepts a reset token from a deep link and updates the user's password
- Shows inline validation errors and API-level error messages throughout

### What It Doesn't Do (Out of Scope)
- Third-party / OAuth sign-in (e.g., Sign in with Apple or Google)
- Email verification before login (handled server-side)
- Session refresh or token management (handled by Supabase SDK)
- Account deletion

## Architecture

### MVVM Structure

```
presentation (Screen) → state management (ViewModel) → data (AuthRepository)
```

Each sub-screen (login, create account, forgot password, reset password) has its own Screen + ViewModel pair. All four share the same `AuthRepository` dependency and the same `AuthError<T>` sealed class for error propagation.

### File Organization

```
lib/features/auth/
├── login/
│   ├── login_screen.dart
│   ├── login_view_model.dart
│   └── components/
│       ├── login_header.dart
│       ├── login_inputs.dart
│       └── login_buttons.dart
├── create_account/
│   ├── create_account_screen.dart
│   ├── create_account_view_model.dart
│   └── components/
│       ├── create_account_header.dart
│       ├── create_account_inputs.dart
│       ├── create_account_button.dart
│       ├── create_account_password_checklist.dart
│       └── create_account_inline_error.dart
├── forgot_password/
│   ├── forgot_password_screen.dart
│   ├── forgot_password_view_model.dart
│   └── components/
│       ├── forgot_password_header.dart
│       ├── forgot_password_input.dart
│       └── forgot_password_button.dart
├── reset_password/
│   ├── reset_password_screen.dart
│   ├── reset_password_view_model.dart
│   └── components/
│       ├── reset_password_header.dart
│       ├── reset_password_inputs.dart
│       ├── reset_password_button.dart
│       ├── reset_password_checklist.dart
│       └── reset_password_inline_error.dart
└── demo/
    ├── auth_demo.dart
    ├── auth_demo_providers.dart
    └── auth_demo_router.dart

test/
├── unit_tests/screens/auth/
│   ├── login/login_view_model_test.dart
│   ├── create_account/create_account_view_model_test.dart
│   ├── forgot_password/forgot_password_view_model_test.dart
│   └── reset_password/reset_password_view_model_test.dart
└── ui_tests/screens/auth/
    ├── login/login_screen_test.dart
    ├── create_account/create_account_screen_test.dart
    ├── forgot_password/forgot_password_screen_test.dart
    └── reset_password/reset_password_screen_test.dart
```

## Components

### LoginScreen

**File**: `lib/features/auth/login/login_screen.dart`

**Responsibility**: Entry point for authenticated users; collects email and password.

**Key Features**:
- Email input, password input, and three action buttons (sign in, create account, forgot password)
- Reads `?accountConfirmed=true` query parameter and shows a confirmation overlay when arriving from the create-account flow
- Delegates all business logic to `LoginViewModel`

**Constructor**:
```dart
LoginScreen({required this.viewModel, super.key});
```

### LoginViewModel

**File**: `lib/features/auth/login/login_view_model.dart`

**Responsibility**: Validates credentials and drives the login API call.

**Public API** (`LoginViewModelContract`):
```dart
void updateEmailField(String email);
void updatePasswordField(String password);
TextEditingController get emailInputController;
TextEditingController get passwordInputController;
bool get hasAlert;
AuthError<LoginErrorType> get authError;
void clearError();
void tapForgotPasswordButton(BuildContext context);
Future<void> tapLoginButton(BuildContext context);
void tapCreateAccountButton(BuildContext context);
void clearAccountConfirmationQuery(BuildContext context);
```

**Error Types**:
```dart
enum LoginErrorType {
  none,
  noPasswordNoEmail,
  noEmail,
  badEmail,
  noPassword,
  unknown,
}
```

**How It Works**:
1. Each field update triggers validation and recomputes the combined error state
2. On `tapLoginButton()`: validates all fields; if invalid, surfaces error without API call
3. If valid: shows loading overlay, calls `AuthRepository.login()`, navigates to home on success or surfaces the API error on failure

---

### CreateAccountScreen

**File**: `lib/features/auth/create_account/create_account_screen.dart`

**Responsibility**: Collects email and two matching passwords for new account creation.

**Key Features**:
- Dismisses keyboard on outside tap
- Displays a live password-requirements checklist powered by `PasswordValidator`
- Shows inline error alert when validation fails

### CreateAccountViewModel

**File**: `lib/features/auth/create_account/create_account_view_model.dart`

**Public API** (`CreateAccountViewModelContract`):
```dart
void updateEmailField(String email);
void updatePasswordOneField(String password);
void updatePasswordTwoField(String password);
Set<CreateAccountPasswordRequirements> get metPasswordRequirements;
bool get hasAlert;
AuthError<CreateAccountErrorType> get authError;
void clearError();
Future<void> tapCreateAccountButton(BuildContext context);
void tapDismissButton(BuildContext context);
```

**Password Requirements**:
```dart
enum CreateAccountPasswordRequirements {
  adequateLength,     // 8+ characters
  containsUppercase,
  containsLowercase,
  containsDigit,
  containsSpecial,
  matching,           // Both password fields agree
}
```

**How It Works**:
1. Each password field change runs `PasswordValidator`, which tracks met requirements and notifies listeners via `ChangeNotifier`
2. `metPasswordRequirements` caches the `Set` to provide a stable reference for `ListenableBuilder`
3. On `tapCreateAccountButton()`: validates, calls `AuthRepository.createAccount()`, shows success overlay, then navigates to login

---

### ForgotPasswordScreen

**File**: `lib/features/auth/forgot_password/forgot_password_screen.dart`

**Responsibility**: Collects an email address and triggers a password-reset email.

### ForgotPasswordViewModel

**File**: `lib/features/auth/forgot_password/forgot_password_view_model.dart`

**Public API** (`ForgotPasswordViewModelContract`):
```dart
void updateEmailField(String email);
bool get hasAlert;
AuthError<ForgotPasswordErrorType> get authError;
void clearError();
Future<void> tapSendResetLinkButton(BuildContext context);
void tapDismissButton(BuildContext context);
```

**Error Types**:
```dart
enum ForgotPasswordErrorType { none, noEmail, badEmail, unknown }
```

**How It Works**:
1. Validates email format on each keystroke
2. On `tapSendResetLinkButton()`: calls `AuthRepository.sendPasswordResetRequest()`, shows success overlay, navigates to login

---

### ResetPasswordScreen

**File**: `lib/features/auth/reset_password/reset_password_screen.dart`

**Responsibility**: Accepts two matching passwords and submits them along with the token from the deep link.

**Key Features**:
- Live password-requirements checklist (same requirements as create account)
- Close button navigates back to login (future: open confirmation modal)

### ResetPasswordViewModel

**File**: `lib/features/auth/reset_password/reset_password_view_model.dart`

**Constructor**:
```dart
ResetPasswordViewModel({
  required AuthRepository authRepository,
  required String email,
  required String token,
})
```

**Public API** (`ResetPasswordViewModelContract`):
```dart
void updatePasswordOneField(String password);
void updatePasswordTwoField(String password);
Set<CreateAccountPasswordRequirements> get metPasswordRequirements;
bool get hasAlert;
AuthError<ResetPasswordErrorType> get authError;
void clearError();
Future<void> tapResetPasswordButton(BuildContext context);
void tapCloseButton(BuildContext context);
```

**Error Types**:
```dart
enum ResetPasswordErrorType { none, passwordRequirementsNotMet, unknown }
```

**How It Works**:
1. `email` and `token` are extracted from deep-link query parameters by the router and passed to the ViewModel
2. On `tapResetPasswordButton()`: validates requirements, calls `AuthRepository.resetUserPassword()`, shows success overlay, navigates to login

## Navigation

### Route Definitions

**File**: `lib/routing/routes.dart`

```dart
Routes.login           → '/login'
Routes.createAccount   → '/create-account'
Routes.forgotPassword  → '/forgot-password'
Routes.resetPassword   → '/reset-password'  (nested under forgotPassword)
```

### Navigation Flow

```
LoginScreen
  ↓ tapCreateAccountButton()
CreateAccountScreen
  ↓ success
LoginScreen (with ?accountConfirmed=true)

LoginScreen
  ↓ tapForgotPasswordButton()
ForgotPasswordScreen
  ↓ success
LoginScreen

(deep link: /reset-password?email=...&token=...)
ResetPasswordScreen
  ↓ success or close
LoginScreen
```

## Shared Error System

All auth ViewModels use the same sealed `AuthError<T>` class:

```dart
sealed class AuthError<T> { const AuthError(); }

class UIAuthError<T> extends AuthError<T> {
  const UIAuthError(this.type);
  final T type; // One of the feature-specific error enums
}

class SupabaseAuthError<T> extends AuthError<T> {
  const SupabaseAuthError(this.message);
  final String message; // Raw API message
}
```

This allows the UI to distinguish between local validation errors (show inline) and API errors (show via `LoadingController` overlay).

## Demo

**File**: `lib/features/auth/demo/`

**Scenario**: `AuthDemoScenario.success`

**Available Scenarios**:
- `success` — all API calls succeed after a 2-second delay
- `error` — all API calls return an error after a 2-second delay
- `loading` — API calls never resolve (tests loading states)

**Demo Router Initial Route**: `/login`

After a successful demo login, redirects to `/?demoLoginSuccess=true` and displays a success overlay explaining that production would navigate to home.

## Testing

### Unit Tests

| File | Tests |
|------|-------|
| `unit_tests/screens/auth/login/login_view_model_test.dart` | 27 |
| `unit_tests/screens/auth/create_account/create_account_view_model_test.dart` | 36 |
| `unit_tests/screens/auth/forgot_password/forgot_password_view_model_test.dart` | 19 |
| `unit_tests/screens/auth/reset_password/reset_password_view_model_test.dart` | 26 |

**Coverage**: Validation rules, error state transitions, navigation calls, API success/failure paths, password requirements tracking.

### UI Tests

| File | Tests |
|------|-------|
| `ui_tests/screens/auth/login/login_screen_test.dart` | 21 |
| `ui_tests/screens/auth/create_account/create_account_screen_test.dart` | 14 |
| `ui_tests/screens/auth/forgot_password/forgot_password_screen_test.dart` | 10 |
| `ui_tests/screens/auth/reset_password/reset_password_screen_test.dart` | 14 |

**Coverage**: Screen rendering, error display, button interactions, password checklist visibility, account confirmation overlay.

## Error Handling

| Scenario | Behavior | User Experience |
|----------|----------|-----------------|
| Empty email | `UIAuthError(noEmail)` | Inline error message |
| Invalid email format | `UIAuthError(badEmail)` | Inline error message |
| Empty password | `UIAuthError(noPassword)` | Inline error message |
| Both fields empty | `UIAuthError(noPasswordNoEmail)` | Inline error message |
| API error | `SupabaseAuthError(message)` | Error overlay with API message |
| Unknown error | `UIAuthError(unknown)` | Generic error overlay |

## Key Design Decisions

### 1. Combined Error State
Each ViewModel merges field-level and API errors into a single `_authError` property. This simplifies the screen — it only needs to observe one value.

### 2. TextEditingControllers Managed by ViewModel
Login's `TextEditingController` instances live in the ViewModel so the ViewModel can clear them on navigation (e.g., clearing fields when moving to forgot password). This prevents stale input from appearing if the user navigates back.

### 3. Password Requirements as a Cached Set
`CreateAccountViewModel` caches `metPasswordRequirements` as `_cachedMetRequirements` and invalidates it when `PasswordValidator` notifies. Without caching, `ListenableBuilder` would receive a new `Set` instance on every build, preventing equality checks and causing unnecessary rebuilds.

### 4. Reset Password via Deep Link
`ResetPasswordViewModel` receives `email` and `token` from the router rather than from user input. This keeps the screen stateless regarding token management; the deep-link handler owns that responsibility.

## Future Enhancements

- OAuth / social sign-in providers
- Biometric authentication
- "Remember me" / persistent session UI option
- Close button on reset password shows a confirmation modal before discarding changes

---
