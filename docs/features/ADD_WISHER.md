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
