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

