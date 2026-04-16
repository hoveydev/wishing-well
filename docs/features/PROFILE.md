# Profile Feature

## Overview

The **Profile** feature provides account management for the authenticated user. In its current form it exposes a single action — logging out — but is designed as the extensible home for future account-level settings.

## Feature Scope

### What It Does
- Displays a logout button
- Calls `AuthRepository.logout()` with a loading overlay
- Navigates to the login screen on successful logout
- Shows an error dialog if logout fails

### What It Doesn't Do (Out of Scope)
- Display user profile information (name, email, avatar)
- Allow editing of account details
- Manage notification preferences
- Delete the account

## Architecture

### MVVM Structure

```
presentation (ProfileScreen) → state management (ProfileViewModel) → data (AuthRepository)
```

### File Organization

```
lib/features/profile/
├── profile_screen.dart
└── profile_view_model.dart

test/
├── unit_tests/screens/profile/profile_view_model_test.dart
└── ui_tests/screens/profile/profile_screen_test.dart
```

> **Note**: The profile feature does not yet have a demo app. The home demo provides access to profile navigation for manual testing.

## Components

### ProfileScreen

**File**: `lib/features/profile/profile_screen.dart`

**Responsibility**: Pure presentation layer — renders the profile UI and delegates interactions to `ProfileViewModel`.

**Key Features**:
- Listens to `ProfileViewModel` for error state
- Displays an error dialog when `hasAlert` is true
- Wraps content in an `AppScreen` with a menu bar for back navigation

**Constructor**:
```dart
ProfileScreen({required this.viewModel, super.key});
```

### ProfileViewModel

**File**: `lib/features/profile/profile_view_model.dart`

**Responsibility**: Executes logout and surfaces any errors.

**Public API** (`ProfileViewModelContract`):
```dart
void tapCloseButton(BuildContext context);
Future<void> tapLogoutButton(BuildContext context);
AuthError<ProfileErrorType> get authError;
bool get hasAlert;
void clearError();
```

**Error Types**:
```dart
enum ProfileErrorType { none, unknown }
```

**How It Works**:
1. Shows loading overlay via `LoadingController`
2. Calls `AuthRepository.logout()`
3. On success: navigates to login with `context.goNamed(Routes.login.name)`, hides loader
4. On `AuthApiException`: surfaces `SupabaseAuthError(message)`, hides loader
5. On other errors: surfaces `UIAuthError(unknown)`, hides loader

## Navigation

### Route

```dart
Routes.profile → '/profile'
```

Accessed from the home screen's app bar. Uses a `slideUpTransition`.

### Navigation Flow

```
HomeScreen (app bar action)
  ↓
ProfileScreen
  ↓ tapLogoutButton() success
LoginScreen
```

## Testing

### Unit Tests

**File**: `test/unit_tests/screens/profile/profile_view_model_test.dart` — **3 tests**

**Coverage**: Successful logout navigation, error state on failure, `clearError()` reset.

### UI Tests

**File**: `test/ui_tests/screens/profile/profile_screen_test.dart` — **6 tests**

**Coverage**: Logout button rendering, error dialog display, navigation callbacks.

## Error Handling

| Scenario | Behavior | User Experience |
|----------|----------|-----------------|
| Logout success | Navigates to login | User returned to login screen |
| API error | `SupabaseAuthError` set | Error dialog with API message |
| Unknown error | `UIAuthError(unknown)` set | Generic error dialog |

## Future Enhancements

### Phase 2
- Display user name and email
- Edit profile information
- Upload/change profile picture

### Phase 3
- Push notification preferences
- App theme / accessibility settings
- Account deletion

---
