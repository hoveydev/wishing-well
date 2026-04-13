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
| Wishers not yet populated | Searches empty cached list, finds nothing | Shows "Wisher not found" message |

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
**Related Documentation**: See [TESTING_STANDARDS.md](../TESTING_STANDARDS.md), [AGENTS.md](../AGENTS.md)

---

