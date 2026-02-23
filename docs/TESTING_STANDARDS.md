# Testing Standards and Guidelines

This document outlines the standardized testing patterns and conventions to ensure consistency, efficiency, and maintainability across the Flutter app test suite.

## Test Organization

### Directory Structure
```
test/
├── unit_tests/                    # Pure unit tests (no widgets)
│   ├── app/                      # App-level utilities and singletons
│   ├── config/                   # Configuration and dependency injection
│   ├── data/                     # Data layer (models, repositories)
│   ├── screens/                  # ViewModel tests
│   └── utils/                    # Utility function tests
├── ui_tests/                     # Widget and integration tests
│   ├── components/               # Reusable UI components
│   │   ├── app_alert/
│   │   ├── app_bar/
│   │   ├── button/
│   │   ├── checklist/
│   │   ├── inline_alert/
│   │   ├── input/
│   │   ├── logo/
│   │   ├── spacer/
│   │   ├── throbber/
│   │   └── wishers/
│   └── screens/                  # Full screen tests
│       ├── add_wisher/
│       ├── confirmation/
│       ├── create_account/
│       ├── forgot_password/
│       ├── home/
│       ├── loading_overlay/
│       ├── login/
│       ├── profile_screen/
│       └── reset_password/
├── init_test.dart               # Coverage include file
└── ../testing_resources/        # Test utilities and helpers (outside test/ directory)
    ├── helpers/                  # Test helpers and base classes
    │   ├── test_helpers.dart
    │   ├── test_base.dart
    │   ├── viewmodel_test_base.dart
    │   └── create_test_widget.dart
    ├── mocks/                    # Mock implementations
    │   ├── repositories/
    │   ├── routing/
    │   └── deep_link/
    └── services/                 # Service mocks
```

### File Naming Conventions
- **Unit Tests**: `{feature}_view_model_test.dart`, `{utility}_test.dart`
- **UI Tests**: `{component}_test.dart`, `{screen}_test.dart`, `{component}_refactored_test.dart` (for refactored tests)
- **Mock Files**: `mock_{repository}_repository.dart`, `mock_{service}.dart`, `mock_{feature}.dart`

### Special Test File Patterns
- **Refactored Tests**: `{component}_refactored_test.dart` - Used for improved test implementations
- **Component Group Tests**: `{components}_test.dart` - Used for testing multiple related components
- **Integration Tests**: `{feature}_components_test.dart` - Used for component integration within features

## Test Structure Standards

### 1. Standard Test Imports
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart'; // For UI tests
import 'package:wishing_well/...'; // Feature-specific imports
import '../../../testing_resources/helpers/test_helpers.dart'; // Standard helpers
import '../../../testing_resources/mocks/...'; // Required mocks
```

### 2. Test Group Organization
```dart
void main() {
  group('ComponentName', () {
    // OR use TestGroups constants (see note below)
    group('Rendering', () {
      // Test rendering behavior
    });
    
    group('Interaction', () {
      // Test user interactions
    });
    
    group('Behavior', () {
      // Test component behavior and properties
    });
    
    group('Error Handling', () {
      // Test error scenarios
    });
  });
}
```

### Available TestGroups Constants
```dart
// From testing_resources/helpers/test_helpers.dart
abstract class TestGroups {
  static const String component = 'Component';
  static const String rendering = 'Rendering';
  static const String interaction = 'Interaction';
  static const String behavior = 'Behavior';
  static const String errorHandling = 'Error Handling';
  static const String initialState = 'Initial State';
  static const String stateChanges = 'State Changes';
  static const String validation = 'Validation';
  static const String accessibility = 'Accessibility';
}
```

### 3. Standard Test Naming
- **Descriptive**: Describe what is being tested and the expected behavior
- **Consistent**: Use "renders correctly", "calls callback when tapped", "sets error when"
- **Specific**: Include the specific condition being tested

Examples:
```dart
test('hasAlert returns false initially');
test('empty email sets noEmail error');
test('Primary Label button renders correctly');
test('calls onAddFromContacts when primary button is tapped');
```

### ⚠️ **Top-Level Group Naming Convention**
**🎯 CRITICAL**: Top-level group names should be **component-specific**:

```dart
// ✅ CORRECT - Component-specific naming
group('AppButton', () {           // Tests AppButton component
group('AddWisherButtons', () {      // Tests AddWisherButtons component
group('LoginViewModel', () {        // Tests LoginViewModel

// ❌ AVOID - Generic or constant-based top-level naming
group('Component', () {            // Too generic
group(TestGroups.component, () {      // IDE resolution issues (see above)
```

**Rule**: Top-level group = exact component/class name being tested

## Standard Test Patterns

### ViewModel Tests
```dart
void main() {
  late MockAuthRepository repository;
  late LoginViewModel viewModel;

  setUp(() {
    repository = MockAuthRepository();
    viewModel = LoginViewModel(authRepository: repository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group(TestGroups.initialState, () {
    test('hasAlert returns false when no error', () {
      expect(viewModel.hasAlert, false);
    });

    test('authError is LoginErrorType.none initially', () {
      final error = viewModel.authError;
      expect(error, isA<UIAuthError>());
      expect((error as UIAuthError).type, LoginErrorType.none);
    });
  });

  group(TestGroups.validation, () {
    test('updateEmailField with empty email sets noEmail error', () {
      viewModel.updatePasswordField('password');
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.noEmail);
    });

    test('updateEmailField with valid email clears error', () {
      viewModel.updateEmailField('');
      expect(viewModel.hasAlert, true);
      viewModel.updateEmailField('test@example.com');
      expect(viewModel.hasAlert, false);
      final error = viewModel.authError as UIAuthError;
      expect(error.type, LoginErrorType.none);
    });
  });
}
```

### Component Tests
```dart
void main() {
  group('ComponentName', () {
    group(TestGroups.rendering, () {
      testWidgets('renders correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createComponentTestWidget(
          Component(param: value),
        ));
        await TestHelpers.pumpAndSettle(tester);

        // Verify basic rendering
        expect(find.byType(Component), findsOneWidget);
        TestHelpers.expectTextOnce('Expected Text');
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls callback when tapped', (WidgetTester tester) async {
        var wasCalled = false;
        
        await tester.pumpWidget(createComponentTestWidget(
          Component(
            onTap: () => wasCalled = true,
          ),
        ));
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.byType(Component));
        expect(wasCalled, isTrue);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct visual properties', (WidgetTester tester) async {
        await tester.pumpWidget(createComponentTestWidget(
          Component(param: value),
        ));
        await TestHelpers.pumpAndSettle(tester);

        final widget = tester.widget<Component>(find.byType(Component));
        expect(widget.property, expectedValue);
      });
    });
  });
}
```

### Component Tests Using Base Classes
```dart
// Using ComponentTestBase for consistency
class MyComponentTest extends ComponentTestBase {
  @override
  Widget getWidgetUnderTest() => MyComponent(param: value);
}

void main() {
  final test = MyComponentTest();
  
  group('MyComponent', () {
    group(TestGroups.rendering, () {
      testWidgets('renders correctly', (WidgetTester tester) async {
        test.renderingTest(tester);
        TestHelpers.expectTextOnce('Expected Text');
      });
    });
  });
}
```

### Screen Tests
```dart
void main() {
  group('ScreenName', () {
    group(TestGroups.rendering, () {
      testWidgets('renders with all required elements', (WidgetTester tester) async {
        final viewModel = ScreenViewModel();
        
        await tester.pumpWidget(createScreenTestWidget(
          child: Screen(viewModel: viewModel),
        ));
        await TestHelpers.pumpAndSettle(tester);

        // Verify screen elements
        TestHelpers.expectTextOnce('Screen Title');
        expect(find.byType(RequiredComponent), findsOneWidget);
        
        viewModel.dispose();
      });
    });
  });
}
```

### Screen Tests Using Base Classes
```dart
// Using ScreenTestBase for consistency
class MyScreenTest extends ScreenTestBase {
  @override
  Widget getScreenUnderTest() {
    final viewModel = ScreenViewModel();
    return Screen(viewModel: viewModel);
  }
}

void main() {
  final test = MyScreenTest();
  
  group('MyScreen', () {
    group(TestGroups.rendering, () {
      testWidgets('renders correctly', (WidgetTester tester) async {
        test.renderingTest(tester);
        TestHelpers.expectTextOnce('Screen Title');
      });
    });
    
    group(TestGroups.interaction, () {
      testWidgets('handles button tap', (WidgetTester tester) async {
        await test.interactionTest(
          tester,
          interactionTarget: find.byType(SomeButton),
          performInteraction: (tester) async {
            await TestHelpers.tapAndSettle(tester, find.byType(SomeButton));
          },
          verifyResult: () {
            // Add verification logic
          },
        );
      });
    });
  });
}
```

## Helper Functions

### Standard Test Helpers
```dart
// In testing_resources/helpers/test_helpers.dart
class TestHelpers {
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  static Future<void> enterTextAndSettle(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  static Future<void> tapAndSettle(
    WidgetTester tester,
    Finder finder,
  ) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  static void expectTextOnce(String text) {
    expect(find.text(text), findsOneWidget);
  }

  static void expectTextTimes(String text, int count) {
    expect(find.text(text), findsNWidgets(count));
  }

  static void expectWidgetOnce(Type type) {
    expect(find.byType(type), findsOneWidget);
  }
}

/// Common finder patterns for frequently used widgets
class CommonFinders {
  static Finder findByText(String text) => find.text(text);
  static Finder findByType(Type type) => find.byType(type);
  static Finder findByWidgetPredicate(bool Function(Widget) predicate) =>
      find.byWidgetPredicate(predicate);
  static Finder findByKey(Key key) => find.byKey(key);
}
```

### Standard Widget Creation
```dart
// From testing_resources/helpers/test_helpers.dart

// For simple components
Widget createComponentTestWidget(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  home: Screen(children: [child]),
);

// For components requiring localization
Widget createScreenComponentTestWidget(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Screen(children: [child]),
);

// For screens with localization and loading state
Widget createScreenTestWidget({
  required Widget child,
  LoadingController? loadingController,
}) {
  final controller = loadingController ?? LoadingController();
  
  return ChangeNotifierProvider<LoadingController>.value(
    value: controller,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}
```

## Testing Principles

### 1. AAA Pattern (Arrange, Act, Assert)
```dart
test('example test', () {
  // Arrange
  final expectedValue = 'expected';
  viewModel.setValue('input');

  // Act
  final result = viewModel.processValue();

  // Assert
  expect(result, expectedValue);
});
```

### 2. One Behavior Per Test
Each test should verify one specific behavior or condition.

### 3. Test Independence
Tests should not depend on each other and should be able to run in any order.

### 4. Descriptive Test Names
Test names should clearly describe what is being tested and what the expected outcome is.

### 5. Use Standard Helpers
Always use the provided helper functions for common operations to maintain consistency.

### ⚠️ **IDE Compatibility Requirements**
**🛠️ Flutter Test Framework Known Issue - Top-Level Group Names**:

**Issue**: TestGroups constants may cause IDE debug console issues when used for **top-level group names**

**Solution**: Use **component-specific literal strings** for top-level groups (which follows best practices anyway)

```dart
// ✅ CORRECT - Component-specific top-level names
group('AppButton', () {              // Tests AppButton component  
group('AddWisherButtons', () {        // Tests AddWisherButtons component
group('LoginViewModel', () {           // Tests LoginViewModel class

// ✅ CORRECT - TestGroups constants for sub-groups
group(TestGroups.rendering, () {         // ✅ Works fine in sub-groups
group(TestGroups.interaction, () {        // ✅ Works fine in sub-groups  
group(TestGroups.behavior, () {          // ✅ Works fine in sub-groups

// ❌ AVOID - Generic or component-agnostic top-level names
group('Component', () {               // Too generic anyway  
group(TestGroups.component, () {         // May cause IDE issues
```

**Helper Usage**: Standard helpers ensure IDE compatibility and consistent test behavior
**Test Discovery**: Proper group naming ensures tests are discoverable via `--name` parameter

**Constants Usage**:
- ✅ **Sub-groups**: TestGroups constants work perfectly for nested groups
- ✅ **Test logic**: TestHelpers methods and other constants work fine
- ⚠️ **Top-level only**: Use component-specific literal names for main groups

## Redundancy Guidelines

### Consolidate When:
- Multiple tests test the same basic rendering with minor variations
- Similar interaction patterns can be parameterized
- Setup code is duplicated across tests

### Separate When:
- Testing different error conditions or edge cases
- Testing different user interaction flows
- Testing different visual states or themes

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run with Coverage
```bash
flutter test --coverage
```

### Run Specific Test File
```bash
flutter test test/path/to/test_file.dart
```

### Run Tests by Name
```bash
flutter test --name="test name pattern"
```

### Run Specific Group
```bash
flutter test --name="GroupName"
```

### Quality Analysis
```bash
./scripts/analyze_tests.sh        # Analyze test quality and consistency
dart run git_hooks.dart pre-commit  # Run pre-commit quality checks
./scripts/test_coverage.sh        # Full coverage workflow with exclusions
```

## Testing Infrastructure Components

### Base Test Classes
- **ComponentTestBase**: Standardized base for component tests with rendering test
- **ScreenTestBase**: Standardized base for screen tests with rendering and interaction patterns
- Located in `testing_resources/helpers/test_base.dart`

### Mock Repository Services
- **MockAuthRepository**: Complete auth repository mock with Result<T> pattern
- **MockRouter**: Navigation mock for testing routing behavior
- **MockDeepLinkSource**: Deep linking functionality mock
- Located in `testing_resources/mocks/`

### Test Utilities
- **TestHelpers**: Common testing operations (pumpAndSettle, tapAndSettle, etc.)
- **CommonFinders**: Standardized finder patterns
- **TestGroups**: Centralized test group naming constants
- Located in `testing_resources/helpers/test_helpers.dart`

## Coverage Requirements

- **Target**: 95% coverage threshold
- **Exclusions**: l10n files, generated files, main.dart, app_config.dart, app_logger.dart, data_sources/
- **Focus**: Business logic, ViewModels, and critical UI components
- **Enforcement**: Pre-commit git hook enforces 95% threshold automatically
- **Analysis**: Use `./scripts/test_coverage.sh` for comprehensive coverage workflow

## Repository and DataSource Architecture

### Overview
The project uses a **DataSource + Repository** pattern to separate Supabase API calls from business logic:

```
lib/data/
├── repositories/
│   ├── wisher/
│   │   ├── wisher_repository.dart          # Abstract contract
│   │   └── wisher_repository_impl.dart     # Business logic (TESTED)
│   └── auth/
│       ├── auth_repository.dart            # Abstract contract
│       └── auth_repository_impl.dart       # Business logic (TESTED)
│
└── data_sources/                           # Supabase wrappers (EXCLUDED)
    ├── wisher/
    │   ├── wisher_data_source.dart         # Abstract contract
    │   └── wisher_data_source_supabase.dart # Supabase calls (EXCLUDED)
    └── auth/
        ├── auth_data_source.dart           # Abstract contract
        └── auth_data_source_supabase.dart  # Supabase calls (EXCLUDED)
```

### What Gets Tested

| Layer | Coverage | Reason |
|-------|----------|--------|
| `*_repository.dart` (abstract) | Excluded | Interface definitions only |
| `*_repository_impl.dart` | **Tested** | Business logic, state management, error handling |
| `*_data_source.dart` (abstract) | Excluded | Interface definitions only |
| `*_data_source_supabase.dart` | **Excluded** | Thin Supabase wrapper - tested by Supabase |

### DataSource Pattern

DataSources return simple `Map<String, dynamic>` or `List<Map<String, dynamic>>` instead of complex Supabase types, making them trivial to mock:

```dart
// Abstract DataSource
abstract class WisherDataSource {
  Future<List<Map<String, dynamic>>> fetchWishers();
  Future<Map<String, dynamic>> createWisher({...});
  Future<Map<String, dynamic>> updateWisher({...});
  Future<void> deleteWisher(String wisherId);
}

// Mock for testing (in testing_resources/mocks/data_sources/)
class MockWisherDataSource implements WisherDataSource {
  List<Map<String, dynamic>>? fetchWishersResult;
  Exception? fetchWishersError;

  @override
  Future<List<Map<String, dynamic>>> fetchWishers() async {
    if (fetchWishersError != null) throw fetchWishersError!;
    return fetchWishersResult ?? [];
  }
  // ... other mock methods
}
```

### Repository Implementation Test Pattern

```dart
void main() {
  group('WisherRepositoryImpl', () {
    late MockWisherDataSource mockDataSource;
    late WisherRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockWisherDataSource();
      repository = WisherRepositoryImpl(dataSource: mockDataSource);
    });

    tearDown(() {
      repository.dispose();
    });

    group(TestGroups.initialState, () {
      test('wishers returns empty list initially', () {
        expect(repository.wishers, isEmpty);
      });
    });

    group('FetchWishers', () {
      test('returns Ok and populates wishers on success', () async {
        mockDataSource.fetchWishersResult = [
          {'id': '1', 'first_name': 'Alice', ...},
        ];

        final result = await repository.fetchWishers();

        expect(result, isA<Ok>());
        expect(repository.wishers.length, 1);
      });

      test('returns Error on data source exception', () async {
        mockDataSource.fetchWishersError = Exception('Network error');

        final result = await repository.fetchWishers();

        expect(result, isA<Error>());
      });
    });
  });
}
```

### When to Create a New Repository

1. **Create the abstract Repository** (`lib/data/repositories/{feature}/{feature}_repository.dart`)
2. **Create the abstract DataSource** (`lib/data/data_sources/{feature}/{feature}_data_source.dart`)
3. **Create the Supabase DataSource** (`lib/data/data_sources/{feature}/{feature}_data_source_supabase.dart`)
4. **Create the Repository Implementation** (`lib/data/repositories/{feature}/{feature}_repository_impl.dart`)
5. **Create the Mock DataSource** (`testing_resources/mocks/data_sources/mock_{feature}_data_source.dart`)
6. **Create Repository Implementation Tests** (`test/unit_tests/data/repositories/{feature}/{feature}_repository_impl_test.dart`)
7. **Update dependencies.dart** to wire up the new providers

## Mock Repository Patterns

### AuthRepository Mock Pattern
```dart
// From testing_resources/mocks/repositories/mock_auth_repository.dart
class MockAuthRepository extends AuthRepository {
  MockAuthRepository({
    Result<void>? logoutResult,
    Result<void>? loginResult,
    Result<void>? createAccountResult,
    Result<void>? sendPasswordResetRequestResult,
    Result<void>? resetUserPasswordResult,
  }) : logoutResult = logoutResult ?? const Result.ok(null),
       loginResult = loginResult ?? const Result.ok(null),
       // ... other parameters

  final Result<void> logoutResult;
  final Result<void> loginResult;
  // ... other result fields

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    if (loginResult is Ok) {
      _isAuthenticated = true;
    }
    notifyListeners();
    return loginResult;
  }
  // ... other method implementations
}
```

## Best Practices

1. **Keep Tests Simple**: Avoid complex logic in tests
2. **Use Meaningful Test Data**: Avoid magic numbers and strings
3. **Test Edge Cases**: Don't just test the happy path
4. **Mock External Dependencies**: Use mocks for repositories and services following established patterns
5. **Dispose Resources**: Always dispose ViewModels and controllers in tearDown
6. **Verify No Exceptions**: Check for null exceptions in UI tests
7. **Use Standard Finders**: Prefer find.text(), find.byType() over complex selectors
8. **Group Related Tests**: Use logical groupings with TestGroups constants
9. **Use Result<T> Pattern**: Mock repositories should return Result<T> types to match implementation
10. **Follow Project Architecture**: Tests should mirror the MVVM+Repository pattern used in the codebase

---

## 🛠️ **TROUBLESHOOTING GUIDE**

### **Common Issues and Solutions**

#### **Issue: "No tests match regular expression" in IDE Debug Console**
**Symptoms**:
- IDE debug console shows error about test regex matching
- Tests work in command line but not in IDE
- Error mentions TestGroups constants

**Root Cause**: Flutter test framework has issues resolving static constants as **top-level group names only**.

**Solution**:
```dart
// ❌ AVOID - Issues with top-level groups only
group(TestGroups.component, () {        // Problem here
group(TestGroups.rendering, () {        // Problem here

// ✅ USE - Component-specific top-level names  
group('AppButton', () {              // ✅ Always works
group('AddWisherButtons', () {        // ✅ Always works

// ✅ SAFE - TestGroups constants work fine in sub-groups
group(TestGroups.rendering, () {         // ✅ Sub-groups are fine
group(TestGroups.interaction, () {        // ✅ Sub-groups are fine
group(TestGroups.behavior, () {          // ✅ Sub-groups are fine
```

#### **Issue: Tests Not Discoverable via --name parameter**
**Symptoms**:
- `flutter test --name="Component"` finds no tests
- Top-level group names not resolving

**Solution**: Use component-specific literal string group names as shown above.

#### **Issue: Multiple pumpWidget calls warning**
**Symptoms**:
- Analysis script shows multiple `await tester.pumpWidget()` calls
- Inconsistent test setup patterns

**Solution**:
```dart
// ❌ AVOID
await tester.pumpWidget(MaterialApp(...));

// ✅ USE  
await tester.pumpWidget(createScreenComponentTestWidget(child));
await TestHelpers.pumpAndSettle(tester);
```

#### **Issue: "Replace MaterialApp setup with createTestWidget helper"**
**Symptoms**:
- Analysis script flags manual MaterialApp setups
- Inconsistent test structure

**Solution**: Use appropriate helper:
- `createScreenComponentTestWidget()` for components
- `createScreenTestWidget()` for screens

#### **Issue: Test duplication or fragmentation**
**Symptoms**:
- Multiple files testing same component
- Redundant test coverage
- Maintenance overhead

**Solution**: Follow "One Component, One Test File" principle:
- Each component has one dedicated test file
- Integration tests in separate files
- No duplicate functionality testing

### **Quick Fix Commands**
```bash
# Fix common issues:
flutter clean && flutter pub get    # Clear cache and reinstall dependencies
dart analyze .                    # Rebuild analysis index
flutter test --name="Component"   # Test specific group
flutter test --name="AddWisherButtons"  # Test component-specific group
```

### **Diagnostic Commands**
```bash
# Identify group resolution issues:
flutter test --name="TestGroups.component"  # Should return no results if problematic

# Verify component-specific groups work:
flutter test --name="AppButton"         # Should find AppButton tests
flutter test --name="AddWisherButtons"  # Should find AddWisherButtons tests
```

### **When to Open an Issue**
If you encounter test framework issues:
1. Check if it's documented here
2. Try command line to verify tests work
3. Check for TestGroups constant usage in group names
4. Ensure proper helper function usage
5. Verify one-component-per-file structure