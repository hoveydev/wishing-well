# Auth Demo

## 🚨 DEVELOPER ONLY - DO NOT SHIP TO PRODUCTION 🚨

This demo is for development and testing purposes only. It will never be included in production builds.

## Overview

The Auth Demo showcases authentication flow scenarios including login, account creation, password reset, and forgot password. It provides a way to test different auth states without requiring a real backend.

## How to Run

### Option 1: Using main.dart (Recommended)

Edit `lib/main.dart` and change the run config:

```dart
const AppRunConfig _runConfig = AppRunConfig.authDemo;
```

Then run:
```bash
flutter run
```

### Option 2: Direct Flutter Command

```bash
flutter run -t lib/features/auth/demo/auth_demo.dart
```

## Scenarios

The demo supports three scenarios:

| Scenario | Description |
|----------|-------------|
| `success` | Successful login/signup flow with 2-second delay to show loading spinner |
| `failure` | Failed login/signup with error message, 2-second delay |
| `loading` | Indefinite loading state (simulates slow network) |

### Changing the Scenario

Edit `lib/features/auth/demo/auth_demo.dart` and change the `_scenario` constant:

```dart
const AuthDemoScenario _scenario = AuthDemoScenario.success;  // or .failure or .loading
```

## Features

- **Login Screen** - Email/password authentication with validation
- **Create Account** - New user registration flow
- **Forgot Password** - Password reset request flow
- **Reset Password** - Password reset with token validation
- **Success Handling** - Shows demo success message after login (since home route isn't available in demo)
- **Loading States** - Configurable delays to visualize loading spinners

## Architecture

```
lib/features/auth/demo/
├── auth_demo.dart              # Entry point
├── auth_demo_providers.dart    # Provider configuration & scenario enum
└── auth_demo_router.dart       # Router configuration
```

## Demo Behavior

### Post-Login Flow

Since the demo doesn't have access to the full app's home screen, after a successful login:

1. User logs in with valid credentials
2. Loading spinner displays for 2 seconds
3. App attempts to navigate to home route
4. Router intercepts and redirects back to login with `?demoSuccess=true`
5. Login screen displays success message:
   > "Login was successful. The application would route to home in production but the demo does not have this functionality."

This provides a clear indication that login succeeded while acknowledging the demo's limitations.

## Testing

Run the auth demo tests:

```bash
# Unit tests for providers
flutter test test/unit_tests/screens/auth_demo/

# UI tests for login screen demo features
flutter test test/ui_tests/screens/login/login_screen_demo_success_test.dart
```

## Mock Repository

The demo uses `MockAuthRepository` from `lib/test_helpers/mocks/repositories/mock_auth_repository.dart`. This mock supports configurable delays for all auth methods:

- `loginDelay` - Delay for login operations
- `createAccountDelay` - Delay for account creation
- `sendPasswordResetRequestDelay` - Delay for password reset requests
- `resetUserPasswordDelay` - Delay for password reset operations

## Coverage Exclusion

This demo is excluded from code coverage (see `scripts/test_coverage.sh` and `git_hooks.dart`). The exclusion pattern is:
- `scripts/test_coverage.sh`: `*/features/*/demo/*`
- `git_hooks.dart`: `/demo/` (substring match)
