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
│   └── screens/                  # Full screen tests
├── testing_resources/            # Test utilities and helpers
│   ├── helpers/                  # Test helpers and base classes
│   └── mocks/                    # Mock implementations
└── init_test.dart               # Coverage include file
```

### File Naming Conventions
- **Unit Tests**: `{feature}_view_model_test.dart`, `{utility}_test.dart`
- **UI Tests**: `{component}_test.dart`, `{screen}_test.dart`
- **Mock Files**: `mock_{repository}_repository.dart`

## Test Structure Standards

### 1. Standard Test Imports
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart'; // For UI tests
import 'package:wishing_well/...'; // Feature-specific imports
import '../../testing_resources/helpers/test_helpers.dart'; // Standard helpers
import '../../testing_resources/mocks/...'; // Required mocks
```

### 2. Test Group Organization
```dart
void main() {
  group('FeatureName', () {
    group(TestGroups.initialState, () {
      // Test initial state
    });
    
    group(TestGroups.validation, () {
      // Test validation logic
    });
    
    group(TestGroups.interaction, () {
      // Test user interactions
    });
    
    group(TestGroups.behavior, () {
      // Test component behavior and properties
    });
    
    group(TestGroups.errorHandling, () {
      // Test error scenarios
    });
  });
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

## Standard Test Patterns

### ViewModel Tests
```dart
void main() {
  late MockRepository repository;
  late ViewModel viewModel;

  setUp(() {
    repository = MockRepository();
    viewModel = ViewModel(repository: repository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group(TestGroups.initialState, () {
    test('property has initial value', () {
      expect(viewModel.property, expectedValue);
    });
  });

  group(TestGroups.validation, () {
    test('validation condition', () {
      // Setup
      viewModel.updateField(invalidValue);
      
      // Verify
      expect(viewModel.hasError, true);
      expect(viewModel.error.type, ErrorType.expected);
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

## Helper Functions

### Standard Test Helpers
```dart
// In test_helpers.dart
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

  static void expectWidgetOnce(Type type) {
    expect(find.byType(type), findsOneWidget);
  }
}
```

### Standard Widget Creation
```dart
// For simple components
Widget createComponentTestWidget(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  home: Screen(children: [child]),
);

// For screens with localization
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

## Coverage Requirements

- **Target**: 95% coverage threshold
- **Exclusions**: l10n files, generated files, main.dart, app_config.dart
- **Focus**: Business logic, ViewModels, and critical UI components

## Best Practices

1. **Keep Tests Simple**: Avoid complex logic in tests
2. **Use Meaningful Test Data**: Avoid magic numbers and strings
3. **Test Edge Cases**: Don't just test the happy path
4. **Mock External Dependencies**: Use mocks for repositories and services
5. **Dispose Resources**: Always dispose ViewModels and controllers in tearDown
6. **Verify No Exceptions**: Check for null exceptions in UI tests
7. **Use Standard Finders**: Prefer find.text(), find.byType() over complex selectors
8. **Group Related Tests**: Use logical groupings with TestGroups constants