# Wisher Details Feature

## Overview

The **Wisher Details** feature provides users with a detailed view of a specific wisher, displaying their profile information when tapped from the wishers list. This is a foundational feature that extends the app's navigation and content display capabilities.

## Feature Scope

### What It Does
- Displays detailed view of a single wisher by ID
- Navigates from the home screen's wisher list to this detail view
- Shows wisher name prominently with appropriate fallback messaging
- Provides navigation back to home screen

### What It Doesn't Do (Out of Scope)
- Edit wisher information (read-only view)
- Show wishes/items associated with the wisher
- Display transaction history or statistics
- Support filtering or searching within details

## Architecture

### MVVM Structure

The wisher details feature follows the standard MVVM (Model-View-ViewModel) pattern used throughout Wishing Well:

```
presentation (Screen) → state management (ViewModel) → data (Repository)
```

### File Organization

```
lib/features/wisher_details/
├── wisher_details_screen.dart          # UI layer (presentation)
├── wisher_details_view_model.dart      # Business logic (state management)
└── demo/
    └── wisher_details_demo.dart        # Demo/showcase for components

lib/routing/
├── routes.dart                          # Route enum (updated)
└── router.dart                          # GoRouter configuration (updated)

test/
├── unit_tests/screens/wisher_details/
│   └── wisher_details_view_model_test.dart  # ViewModel logic tests
└── ui_tests/screens/wisher_details/
    └── wisher_details_screen_test.dart      # UI rendering tests
```

## Components

### WisherDetailsScreen

**File**: `lib/features/wisher_details/wisher_details_screen.dart`

**Responsibility**: Pure presentation layer - renders the UI based on ViewModel state

**Key Features**:
- Wraps ViewModel with `ChangeNotifierProvider` for dependency injection
- Uses `Consumer` pattern to listen to state changes
- Renders loading spinner while data loads
- Shows wisher name when found
- Displays "Wisher not found" fallback message
- Includes back button via `AppMenuBar` for navigation

**Constructor**:
```dart
const WisherDetailsScreen({
  required this.viewModel,
  super.key
});
```

**State Management**: 
- Receives `WisherDetailsViewModel` via constructor injection
- Uses `Consumer<WisherDetailsViewModel>` to observe state changes
- No internal state management (stateless presentation)

### WisherDetailsViewModel

**File**: `lib/features/wisher_details/wisher_details_view_model.dart`

**Responsibility**: Business logic and state management

**Key Features**:
- Extends `ChangeNotifier` for reactive state management
- Implements `WisherDetailsViewModelContract` interface
- Loads wisher from cached repository by ID
- Manages loading state
- Notifies listeners of state changes

**Public API** (WisherDetailsViewModelContract):
```dart
Wisher? get wisher;        // The wisher being displayed (null if not found)
bool get isLoading;        // Loading state during lookup
```

**Initialization**:
```dart
WisherDetailsViewModel({
  required WisherRepository wisherRepository,
  required String wisherId,
})
```

**How It Works**:
1. On construction, calls `_loadWisher()`
2. Sets `isLoading = true` and notifies listeners
3. Searches cached wisher list for matching ID
4. Sets `wisher` to result (or null if not found)
5. Sets `isLoading = false` and notifies listeners
6. Screen automatically re-renders via Consumer pattern

## Navigation

### Route Definition

**File**: `lib/routing/routes.dart`

```dart
enum Routes {
  // ... other routes ...
  wisherDetails('/wisher-details/:id'),  // New route with :id parameter
}
```

### Route Registration

**File**: `lib/routing/router.dart`

```dart
GoRoute(
  path: Routes.wisherDetails.path,
  name: Routes.wisherDetails.name,
  pageBuilder: (context, state) => CustomTransitionPage(
    child: WisherDetailsScreen(
      viewModel: WisherDetailsViewModel(
        wisherRepository: context.read(),
        wisherId: state.pathParameters['id'] ?? '',
      ),
    ),
    transitionsBuilder: slideInRightTransition,
  ),
)
```

### Navigation Flow

```
HomeScreen (wishers list)
    ↓ (user taps wisher)
HomeViewModel.tapWisherItem() 
    ↓ (constructs path with ID)
Routes.wisherDetails.buildPath(id: wisher.id)
    ↓ (navigates with go_router)
WisherDetailsScreen ← loads via router with ID parameter
```

### Type-Safe Route Path Building

The route navigation uses the new `buildPath()` helper method for type-safe parameter substitution:

```dart
// In HomeViewModel
void tapWisherItem(BuildContext context, Wisher wisher) {
  context.push(Routes.wisherDetails.buildPath(id: wisher.id));
}

// Routes.buildPath() method ensures safe substitution
String buildPath({String? id}) {
  var result = path;
  if (id != null) {
    result = result.replaceAll(':id', id);
  }
  return result;
}
```

## Data Flow

### 1. Navigation → ViewModel Initialization

```
GoRouter state.pathParameters['id']
    ↓
WisherDetailsViewModel(wisherId: '...')
    ↓
_loadWisher() called in constructor
```

### 2. ViewModel → Repository Lookup

```
WisherDetailsViewModel._loadWisher()
    ↓
_wisherRepository.wishers (cached list)
    ↓
Finds wisher with matching ID
    ↓
Sets _wisher = foundWisher (or null if not found)
```

### 3. ViewModel → Screen Rendering

```
_isLoading = false
notifyListeners()
    ↓
Screen's Consumer<WisherDetailsViewModel> rebuilds
    ↓
Renders wisher name or "Wisher not found" message
```

## Key Design Decisions

### 1. Synchronous Data Lookup
The wisher lookup is synchronous (searches cached repository list), not async despite the `Future` return type. This is intentional:
- **Why**: Wishers are already loaded and cached in the repository by HomeViewModel
- **Benefit**: Immediate data availability, no network latency
- **Trade-off**: Loading state briefly shows spinner, but data populates instantly

### 2. Silent Failure on Not Found
When a wisher ID doesn't exist, the ViewModel sets `wisher = null` without error:
- **Why**: Graceful degradation - user sees "Wisher not found" message
- **Alternative**: Could use `Result<T>` pattern with error state
- **Current approach**: Sufficient for MVP, extensible if analytics needed later

### 3. Component Actions via Callbacks
The `WisherItem` component (used in the wishers list) receives the `onTap` action as a parameter from HomeViewModel:
- **Why**: Keeps component generic and reusable
- **Benefit**: Component doesn't know about navigation, easily testable
- **Pattern**: All user interactions in components are callbacks, not embedded logic

### 4. Routes Enum with Helper Method
Type-safe route parameter substitution via `Routes.buildPath(id: ...)`:
- **Why**: Prevents brittleness of string manipulation
- **Benefit**: Self-documenting API, centralized logic, easy to extend
- **Pattern**: Recommended for any future routes with parameters

## Testing

### Unit Tests

**File**: `test/unit_tests/screens/wisher_details/wisher_details_view_model_test.dart`

**Coverage** (16 tests):
- Initialization and state setup
- Wisher loading from cached list
- Loading state management
- Listener notifications
- Contract implementation
- Edge cases (empty ID, not found, multiple wishers)

**Key Test Pattern**:
```dart
test('finds wisher from cached list by ID', () {
  final viewModel = WisherDetailsViewModel(
    wisherRepository: mockRepository,
    wisherId: '1',
  );
  
  expect(viewModel.wisher?.id, equals('1'));
  expect(viewModel.isLoading, isFalse);
});
```

### UI Tests

**File**: `test/ui_tests/screens/wisher_details/wisher_details_screen_test.dart`

**Coverage** (16 tests):
- Screen rendering with all UI elements
- Wisher name display when found
- "Wisher not found" fallback message
- Back button functionality
- State management with Consumer pattern
- Accessibility and text styling
- Error handling with incomplete data

**Key Test Pattern**:
```dart
testWidgets('renders wisher name when wisher is found', (tester) async {
  final screen = WisherDetailsScreen(viewModel: mockViewModel);
  
  await createTestWidget(screen).pumpAndSettle();
  
  expect(find.text('Alice Test'), findsOneWidget);
  expect(find.byType(CircularProgressIndicator), findsNothing);
});
```

## Integration Points

### HomeViewModel

The wisher details feature integrates with home screen:

**File**: `lib/features/home/home_view_model.dart`

**New Method**:
```dart
void tapWisherItem(BuildContext context, Wisher wisher) {
  context.push(Routes.wisherDetails.buildPath(id: wisher.id));
}
```

**Usage**: Called when user taps a wisher in the list

### WishersList Component

The wisher list component passes the navigation callback:

**File**: `lib/components/wishers/wishers_list.dart`

```dart
WisherItem(
  wisher,
  padding,
  onTap: () => onWisherTap(wisher),  // Callback from HomeScreen
)
```

### WisherItem Component

Updated to require `onTap` callback:

**File**: `lib/components/wishers/wisher_item.dart`

```dart
class WisherItem extends StatelessWidget {
  final VoidCallback onTap;  // Required action parameter
  // ...
}
```

## Error Handling

| Scenario | Behavior | User Experience |
|----------|----------|-----------------|
| Wisher ID not found | Sets `wisher = null`, no error thrown | Shows "Wisher not found" message |
| Empty/invalid ID | Searches for match, finds nothing | Shows "Wisher not found" message |
| Repository unavailable | (Not handled - assumes pre-loaded) | Would show loading indefinitely |

**Future Improvements**:
- Add error state to ViewModel via `Result<T>` pattern
- Log "wisher not found" for analytics
- Handle stale repository cache scenarios

## Performance Considerations

- **Data Lookup**: O(n) linear search through wishers list (negligible for typical list sizes)
- **Memory**: ViewModel holds single Wisher object reference
- **Rendering**: SingleChildScrollView not needed (minimal content), efficient Consumer rebuild
- **No N+1 queries**: All wishers pre-fetched by HomeViewModel

## Future Enhancements

### Phase 2: Extended Details
- Show wish items associated with wisher
- Display transaction history
- Add wisher statistics

### Phase 3: Interactivity
- Edit wisher information
- Delete wisher
- Share wisher profile
- Add notes/comments

### Phase 4: Advanced Features
- Wisher comparison
- Wisher search/filter
- Wisher activity timeline
- Analytics integration

## Troubleshooting

### Wisher not found message displayed

**Cause**: Wisher ID doesn't exist in repository

**Solutions**:
1. Verify ID is correct (check HomeScreen wisher list)
2. Ensure HomeViewModel loaded wishers (`fetchWishers()` was called)
3. Check mock data in tests includes the wisher ID

### Screen not navigating

**Cause**: GoRouter not properly configured or route path invalid

**Solutions**:
1. Verify route added to `lib/routing/router.dart`
2. Check route name matches in `Routes.wisherDetails.name`
3. Verify wisher ID passed to `buildPath()` is not null/empty

### Loading state persists

**Cause**: Unusual if data is cached, but possible if repository not initialized

**Solutions**:
1. Check `HomeViewModel.fetchWishers()` was called before navigation
2. Verify repository cache is populated
3. Check for exceptions in logs

## Code References

- **Contract**: `WisherDetailsViewModelContract` - Public API definition
- **Route helper**: `Routes.buildPath(id: ...)` - Type-safe path building
- **Component callback pattern**: `WisherItem.onTap` - Generic action callback
- **Test helpers**: `createTestWidget()`, `MockWisherRepository` - Testing utilities

---

**Last Updated**: April 2026  
**Related Documentation**: See [TESTING_STANDARDS.md](./TESTING_STANDARDS.md), [AGENTS.md](./AGENTS.md)

---

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

**Public API** (`ForgotViewModelContract`):
```dart
void updateEmailField(String email);
bool get hasAlert;
AuthError<ForgotPasswordErrorType> get authError;
void clearError();
Future<void> tapSendResetLinkButton(BuildContext context);
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

# Home Feature

## Overview

The **Home** feature is the main authenticated screen of the app. It displays the signed-in user's list of wishers and provides navigation to add a new wisher or view an individual wisher's details.

## Feature Scope

### What It Does
- Fetches and displays the user's wishers list
- Preloads wisher profile images for instant rendering
- Refreshes the list when the app returns to the foreground
- Navigates to the wisher details screen when a wisher is tapped
- Navigates to the add wisher flow via a floating action button
- Shows skeleton loaders while data is loading
- Shows an error state when the fetch fails

### What It Doesn't Do (Out of Scope)
- Pagination or infinite scroll (loads all wishers at once)
- Search or filter wishers
- Edit wishers from the home screen
- Display wish items or transactions on the list

## Architecture

### MVVM Structure

```
presentation (HomeScreen) → state management (HomeViewModel) → data (WisherRepository, AuthRepository, ImageRepository)
```

### File Organization

```
lib/features/home/
├── home_screen.dart
├── home_view_model.dart
├── components/
│   ├── home_header.dart
│   └── home_coming_up.dart
└── demo/
    ├── home_demo.dart
    ├── home_demo_providers.dart
    └── home_demo_router.dart

test/
├── unit_tests/screens/home/home_view_model_test.dart
└── ui_tests/screens/home/home_screen_test.dart
```

## Components

### HomeScreen

**File**: `lib/features/home/home_screen.dart`

**Responsibility**: Pure presentation layer — renders the wisher list and delegates all interactions to `HomeViewModel`.

**Key Features**:
- Implements `WidgetsBindingObserver` to call `fetchWishers()` when the app returns to the foreground
- Calls `fetchWishers()` on `initState` to populate data on first load
- Renders `WishersList` component with the current wishers
- Floating action button navigates to add wisher flow

**Constructor**:
```dart
HomeScreen({required this.viewModel, super.key});
```

### HomeViewModel

**File**: `lib/features/home/home_view_model.dart`

**Responsibility**: Fetches wishers, preloads images, and exposes navigation actions.

**Public API** (`HomeViewModelContract`):
```dart
String? get firstName;           // User's first name from AuthRepository
List<Wisher> get wishers;        // Current wishers list from WisherRepository
bool get isLoadingWishers;       // Loading state forwarded from WisherRepository
Object? get wisherError;         // Non-null when last fetch failed
bool get hasWisherError;
void tapWisherItem(BuildContext context, Wisher wisher);
void tapAddWisher(BuildContext context);
```

**How It Works**:
1. Constructor adds a listener to `WisherRepository` to forward its `notifyListeners()` calls to the screen
2. `fetchWishers()` clears any previous error, calls `WisherRepository.fetchWishers()`, then preloads all profile picture URLs via `ImageRepository.preloadImages()`
3. `tapWisherItem()` navigates to `/wisher-details/:id` using `Routes.wisherDetails.buildPath(id: wisher.id)`
4. `tapAddWisher()` navigates to `/add-wisher`
5. On dispose, removes the repository listener to prevent memory leaks

## Navigation

### Route

```dart
Routes.home → '/home'
```

### Navigation Flow

```
HomeScreen (wishers list)
  ↓ tap wisher
WisherDetailsScreen

HomeScreen
  ↓ tap FAB
AddWisherLandingScreen
```

## Data Flow

```
HomeScreen.initState / onAppResume
    ↓
HomeViewModel.fetchWishers()
    ↓
WisherRepository.fetchWishers()
    ↓ success
WisherRepository notifies listeners
    ↓
HomeViewModel._onRepositoryChanged() → notifyListeners()
    ↓
Screen rebuilds with new wishers list
    ↓ (background)
ImageRepository.preloadImages(urls)
```

## Demo

**File**: `lib/features/home/demo/`

**Default Scenario**: `HomeDemoScenario.defaultWishers` (5 wishers)

**Available Scenarios**:

| Scenario | Description |
|----------|-------------|
| `noWishers` | Empty list |
| `fewWishers` | 2 wishers (mix with/without images) |
| `defaultWishers` | 5 wishers |
| `manyWishers` | 50 wishers |
| `brokenImages` | 3 wishers with invalid image URLs |
| `failure` | Empty list with fetch error |

Demo uses picsum.photos for sample profile images. Demo router initial route is `/home` with no transitions.

## Testing

### Unit Tests

**File**: `test/unit_tests/screens/home/home_view_model_test.dart` — **16 tests**

**Coverage**: `fetchWishers()` success/failure, image preloading, error state, repository listener forwarding, navigation methods, `dispose()` cleanup.

### UI Tests

**File**: `test/ui_tests/screens/home/home_screen_test.dart` — **6 tests**

**Coverage**: Wishers list rendering, loading state display, error state display, navigation callbacks, empty state.

## Key Design Decisions

### 1. Repository Listener Pattern
`HomeViewModel` listens to `WisherRepository` changes and forwards them via its own `notifyListeners()`. This means the screen only needs to observe `HomeViewModel` and is decoupled from the repository's notification lifecycle.

### 2. Image Preloading After Fetch
Images are preloaded in `fetchWishers()` immediately after the wisher list is returned. This ensures profile pictures are cached before the `WishersList` component renders, avoiding placeholder flash.

### 3. App Lifecycle Refresh
`HomeScreen` implements `WidgetsBindingObserver` and calls `fetchWishers()` when the app transitions to `AppLifecycleState.resumed`. This keeps the list fresh if the user adds a wisher from a different entry point or resumes after a long background.

## Error Handling

| Scenario | Behavior | User Experience |
|----------|----------|-----------------|
| Fetch success | `wisherError = null`, list populated | Wishers rendered |
| Fetch failure | `wisherError` set, list empty | Error state displayed |
| Image preload failure | Silent — images fall back to initials | Placeholder shown instead of photo |

## Future Enhancements

### Phase 2
- Pagination for large wisher lists
- Pull-to-refresh gesture
- "Coming Up" section with upcoming wish dates

### Phase 3
- Search and filter
- Wisher sorting (alphabetical, recent, upcoming)

---

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

**Public API** (`ProfileViewmodelContract`):
```dart
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

# Add Wisher Feature

## Overview

The **Add Wisher** feature is a two-screen flow that lets an authenticated user create a new wisher. The landing screen offers a choice of entry method; the details screen collects the wisher's name and optional profile picture, then persists the record to Supabase.

## Feature Scope

### What It Does
- Presents two options: add from contacts (placeholder) or add manually
- Collects first name, last name, and an optional profile picture
- Validates input in real time with inline error feedback
- Uploads the profile picture to Supabase Storage before creating the wisher record
- Creates the wisher record via `WisherRepository`
- Shows a success overlay with the new wisher's name and photo

### What It Doesn't Do (Out of Scope)
- Import wishers from the device's contacts (button is shown but disabled)
- Edit existing wishers
- Assign wishes to a wisher during creation
- Bulk wisher import

## Architecture

### MVVM Structure

```
presentation (Screens) → state management (ViewModels) → data (WisherRepository, AuthRepository, ImageRepository)
```

### File Organization

```
lib/features/add_wisher/
├── add_wisher_landing/
│   ├── add_wisher_landing_screen.dart
│   ├── add_wisher_landing_view_model.dart
│   └── components/
│       ├── add_wisher_landing_header.dart
│       ├── add_wisher_landing_description.dart
│       └── add_wisher_landing_buttons.dart
├── add_wisher_details/
│   ├── add_wisher_details_screen.dart
│   ├── add_wisher_details_view_model.dart
│   └── components/
│       ├── add_wisher_details_header.dart
│       ├── add_wisher_details_inputs.dart
│       └── add_wisher_details_button.dart
└── demo/
    ├── add_wisher_demo.dart
    ├── add_wisher_demo_providers.dart
    └── add_wisher_demo_router.dart

test/
├── unit_tests/screens/add_wisher/
│   ├── add_wisher_landing/add_wisher_landing_view_model_test.dart
│   └── add_wisher_details/add_wisher_details_view_model_test.dart
└── ui_tests/screens/add_wisher/
    ├── add_wisher_landing/add_wisher_landing_screen_test.dart
    └── add_wisher_details/add_wisher_details_screen_test.dart
```

## Components

### AddWisherLandingScreen

**File**: `lib/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart`

**Responsibility**: Entry point for the add-wisher flow; presents method choices.

**Key Features**:
- "Add from Contacts" button is rendered but disabled (TODO)
- "Add Manually" button navigates to the details screen
- Uses `AddWisherLandingViewModel` (currently a placeholder with no state)

### AddWisherLandingViewModel

**File**: `lib/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart`

Extends `ChangeNotifier`, implements `AddWisherLandingViewModelContract`. Currently has no business logic — navigation to the details screen is handled directly in the screen component.

---

### AddWisherDetailsScreen

**File**: `lib/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart`

**Responsibility**: Full-screen form for entering wisher details.

**Key Features**:
- Image picker circle to select a profile picture
- First name and last name text inputs
- Inline error alert for validation failures
- Save button — disabled unless the form is valid

**Constructor**:
```dart
AddWisherDetailsScreen({required this.viewModel, super.key});
```

### AddWisherDetailsViewModel

**File**: `lib/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart`

**Responsibility**: Validates form fields, uploads the image, creates the wisher.

**Public API** (`AddWisherDetailsViewModelContract`):
```dart
void updateFirstName(String firstName);
void updateLastName(String lastName);
void updateImage(File? imageFile);
File? get imageFile;
bool get hasAlert;
AddWisherDetailsError? get error;
void clearError();
bool get isFormValid;
Future<void> tapSaveButton(BuildContext context);
```

**Error Types**:
```dart
enum AddWisherDetailsErrorType {
  none,
  firstNameRequired,
  lastNameRequired,
  bothNamesRequired,
  invalidImage,
  unknown,
}
```

**How It Works**:
1. Each name update calls `_validateForm()` which computes granular error state and notifies listeners only when the error type changes
2. `isFormValid` is true only when both first and last names are non-empty after trimming
3. On `tapSaveButton()`:
   - Validates the form; returns early if invalid
   - Resolves the current user ID from `AuthRepository` (falls back to Supabase SDK)
   - If an image file is set, uploads it via `ImageRepository.uploadImage()` to the `profile-pictures` bucket; surfaces `AddWisherDetailsErrorType.invalidImage` on `ImageValidationException`
   - Calls `WisherRepository.createWisher()` with name, user ID, and optional profile picture URL
   - On success: preloads the uploaded image URL, shows a success overlay with the wisher's name and local image preview, then pops the screen
   - On failure: shows a generic error overlay

## Navigation

### Route Definitions

```dart
Routes.addWisher        → '/add-wisher'         (landing)
Routes.addWisherDetails → 'details'              (nested under addWisher → '/add-wisher/details')
```

### Navigation Flow

```
HomeScreen (FAB)
    ↓ slideUpWithParallaxTransition
AddWisherLandingScreen
    ↓ "Add Manually" → slideInRightTransition
AddWisherDetailsScreen
    ↓ success → pops back to AddWisherLandingScreen
    ↓ (landing also pops) → back to HomeScreen
```

### Back Navigation
The details screen uses `context.pop()` after a successful save, returning the user to the landing screen. From there the landing screen can be dismissed back to home.

## Data Flow

```
User enters name fields
    ↓
AddWisherDetailsViewModel._validateForm()
    ↓
isFormValid == true
    ↓ tapSaveButton()
AuthRepository.currentUserId → userId
    ↓ (if image selected)
ImageRepository.uploadImage() → profilePictureUrl
    ↓
WisherRepository.createWisher(userId, firstName, lastName, profilePictureUrl)
    ↓ success
ImageRepository.preloadImages([profilePictureUrl])
LoadingController.showSuccess(wisherName)
    ↓ user acknowledges
context.pop() → back to landing
```

## Demo

**File**: `lib/features/add_wisher/demo/`

**Default Scenario**: `AddWisherDemoScenario.success`

**Available Scenarios**:

| Scenario | Description |
|----------|-------------|
| `success` | `WisherRepository.createWisher()` succeeds after 2s |
| `error` | `WisherRepository.createWisher()` returns error after 2s |
| `loading` | Indefinite loading (tests loading state) |

**Demo Providers**:
- Mock `AuthRepository` with `userId: 'demo-user'`
- Mock `WisherRepository` configured by scenario
- Mock `ImageRepository` with a sample profile picture URL
- 5 pre-populated demo wishers (mix with/without images) for context

**Demo Router Initial Route**: `/add-wisher` (landing screen)

## Testing

### Unit Tests

| File | Tests |
|------|-------|
| `unit_tests/screens/add_wisher/add_wisher_landing/add_wisher_landing_view_model_test.dart` | 3 |
| `unit_tests/screens/add_wisher/add_wisher_details/add_wisher_details_view_model_test.dart` | 52 |

**Coverage**: Validation for all error types, `isFormValid` edge cases, image file management, `tapSaveButton()` success/failure paths, image upload failure handling, missing user ID handling, listener notification efficiency.

### UI Tests

| File | Tests |
|------|-------|
| `ui_tests/screens/add_wisher/add_wisher_landing/add_wisher_landing_screen_test.dart` | 7 |
| `ui_tests/screens/add_wisher/add_wisher_details/add_wisher_details_screen_test.dart` | 10 |

**Coverage**: Button rendering and disabled state, header display, input fields, error alert visibility, save button enabled/disabled based on form validity.

## Error Handling

| Scenario | Behavior | User Experience |
|----------|----------|-----------------|
| First name empty | `firstNameRequired` error | Inline error message |
| Last name empty | `lastNameRequired` error | Inline error message |
| Both names empty | `bothNamesRequired` error | Inline error message |
| Invalid image file | `invalidImage` error | Error overlay with specific message |
| No authenticated user | `unknown` error | Generic error overlay |
| API / repository error | `unknown` error | Generic error overlay |
| Image upload failure (non-validation) | Silent — continues without photo | Wisher created without profile picture |

## Key Design Decisions

### 1. Granular Error Types per Field
The ViewModel distinguishes between `firstNameRequired`, `lastNameRequired`, and `bothNamesRequired` rather than a single "names required" error. This lets the UI show precisely which field needs attention.

### 2. Notify Only on Error Type Change
`_validateForm()` compares the new error to the previous error before calling `notifyListeners()`. This avoids spurious rebuilds on every keystroke when the error state hasn't actually changed.

### 3. Silent Image Upload Failure
If `ImageRepository.uploadImage()` returns `null` (non-exception failure), the ViewModel logs a warning but proceeds with wisher creation without a profile picture. The wisher is more important than the photo; the user can update it later.

### 4. User ID Resolution
`tapSaveButton()` first checks `AuthRepository.currentUserId`, then falls back to `Supabase.instance.client.auth.currentUser?.id`. This makes the ViewModel testable with mock repositories while remaining robust in production.

### 5. Image Preloading on Success
After `createWisher()` succeeds, the new profile picture URL is preloaded via `ImageRepository.preloadImages()`. This ensures the home screen displays the photo immediately when the user navigates back — without a network fetch.

## Future Enhancements

### Phase 2: Contacts Import
- Enable "Add from Contacts" button with device permission flow
- Map contact fields to wisher first/last name
- Allow selecting multiple contacts for bulk creation

### Phase 3: Extended Wisher Details
- Birthday and gift occasion dates during creation
- Notes and relationship tags
- Initial wish item entry as part of the create flow

---

**Last Updated**: April 2026  
**Related Documentation**: See [TESTING_STANDARDS.md](./TESTING_STANDARDS.md), [AGENTS.md](./AGENTS.md)
