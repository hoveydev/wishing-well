# AGENTS.md

This file provides guidelines for AI agents working on this Flutter/Dart codebase.

## Project Overview
Flutter app using Provider for state management, Supabase for backend, and go_router for navigation.

## Build, Lint, and Test Commands

### Essential Commands
- `flutter test` - Run entire test suite
- `flutter test lib/testing/path/to/test_file.dart` - Run a single test file
- `flutter test lib/testing/path/to/test_file.dart --name="test name"` - Run specific test by name
- `flutter test --coverage` - Run tests with coverage report
- `dart format .` - Format all Dart files
- `dart analyze --fatal-infos` - Run static analysis (fails on warnings)
- `flutter gen-l10n` - Generate localization files after modifying app_en.arb

### Coverage Reporting
- `./scripts/test_coverage.sh` - Full coverage workflow (excludes l10n, main.dart, app_config.dart)
- Pre-commit hook enforces 95% coverage threshold (see git_hooks.dart:14)

## Code Style Guidelines

### Imports
- Always use package imports: `import 'package:wishing_well/...'` (never relative imports)
- Group imports: Dart SDK imports first, then package imports

### Formatting (enforced by analysis_options.yaml)
- Use single quotes for strings (`prefer_single_quotes`)
- Keep lines under 80 characters (`lines_longer_than_80_chars`)
- Use const constructors where possible (`prefer_const_constructors`, `prefer_const_declarations`)
- Prefer expression function bodies for simple functions (`prefer_expression_function_bodies`)
- Place required named parameters first (`always_put_required_named_parameters_first`)
- Use final for local variables (`prefer_final_locals`)
- Sort constructors first in classes (`sort_constructors_first`)

### Widget Construction
- Avoid unnecessary containers (`avoid_unnecessary_containers`)
- Use SizedBox for whitespace instead of Container (`sized_box_for_whitespace`)
- Prefer `const` widget constructors

### Colors and Fonts
When styling UI elements, always use the established theme system instead of hardcoded values:

**Colors:**
- Use `AppColorScheme` extension for semantic colors: `Theme.of(context).extension<AppColorScheme>()`
- Available colors: `primary`, `success`, `warning`, `error`, `background`, `surfaceGray`, `borderGray`
- Example:
  ```dart
  // ❌ WRONG: Hardcoded colors
  final color = Colors.red;
  final backgroundColor = const Color(0xFFEEEEEE);
  
  // ✅ CORRECT: Use AppColorScheme extension
  final colorScheme = Theme.of(context).extension<AppColorScheme>();
  final color = colorScheme?.error;
  final backgroundColor = colorScheme?.background;
  ```

**Fonts/Text:**
- Use `Theme.of(context).textTheme` for text styles
- Available styles: `titleLarge`, `titleMedium`, `titleSmall`, `bodyLarge`, `bodyMedium`, `bodySmall`, `labelLarge`, etc.
- Note: The primary color is the default for text, so you typically don't need to specify it
- Example:
  ```dart
  // ✅ CORRECT: Use textTheme directly (primary is default)
  final textTheme = Theme.of(context).textTheme;
  final style = textTheme.titleMedium;
  
  // Only use copyWith when you need to override the primary color:
  final styleWithColor = textTheme.titleMedium?.copyWith(
    color: colorScheme?.error,  // Override with different color
  );
  
  // ❌ WRONG: Unnecessarily specifying primary (it's the default)
  final style = textTheme.titleMedium?.copyWith(
    color: colorScheme?.primary,  // Not needed - primary is default
  );
  ```

**Icons:**
- Use `AppIconSize` class for icon sizes: `const AppIconSize().large`, `.medium`, `.xlarge`, etc.
- Available sizes: `xsmall` (10), `small` (14), `medium` (18), `large` (24), `xlarge` (60), `xxlarge` (64)
- Example:
  ```dart
  // ❌ WRONG: Hardcoded icon size
  const Icon(Icons.error, size: 64);
  
  // ✅ CORRECT: Use AppIconSize
  const Icon(Icons.error, size: const AppIconSize().xxlarge);
  ```

### Naming Conventions
- Classes/Enums: PascalCase (e.g., `LoginViewModel`, `LoginErrorType`)
- Methods/Variables: camelCase (e.g., `updateEmailField`, `_authRepository`)
- Private members: Prefix with underscore (e.g., `_email`, `_validatePassword`)
- Files/Directories: snake_case (e.g., `home_screen.dart`, `create_account/`)

### Architecture Patterns

**MVVM with ViewModels:**
- Screens receive ViewModel via constructor: `const HomeScreen({required this.viewmodel, super.key})`
- ViewModels extend ChangeNotifier and implement a Contract interface
- Define contract as abstract class with public methods/properties
- Private fields use underscore prefix, public methods expose via interface

**Repository Pattern:**
- Abstract repository class defines interface in lib/data/
- Concrete implementations (e.g., AuthRepositoryRemote) extend abstract class
- Use Result<T> sealed class for operation outcomes:
  - `Result.ok(value)` for success
  - `Result.error(Exception)` for failure

**Component Organization:**
- Reusable components in lib/components/ by type (button, input, spacer, etc.)
- Each component type has a base file and type-specific implementations
- Components use named constructors (e.g., `AppButton.icon()`, `AppButton.label()`)

### Error Handling
- Use AuthError<T> sealed class with type-specific implementations
- UIAuthError for validation errors, SupabaseAuthError for API errors
- Prioritize UI validation errors over API errors in display
- Use LoadingController for async operation state management
- Check context.mounted before navigation after async operations

### State Management
- ViewModels extend ChangeNotifier
- Use notifyListeners() when state changes
- Controllers (TextEditingController, FocusNode) disposed in viewModel/screen dispose

### Testing
- Unit tests in lib/testing/unit_tests/ using standard flutter_test
- UI widget tests in lib/testing/ui_tests/
- Organize tests with group() blocks
- Use descriptive test names: `test('description', () {...})`
- Use testWidgets for widget testing with WidgetTester
- Mock repositories from lib/test_helpers/mocks/
- Helpers in lib/test_helpers/helpers/ (e.g., createTestWidget())
- Tear down viewModels in tearDown() blocks

### Routing
- Routes enum in lib/routing/routes.dart defines all app paths
- Use go_router for navigation: `context.pushNamed(Routes.home.name)`
- Use context.push() for navigation with paths: `context.push(Routes.profile.path)`

### Localization
- Add strings to lib/l10n/app_en.arb with @ descriptions
- Run `flutter gen-l10n` after adding new strings
- Import: `import 'package:wishing_well/l10n/app_localizations.dart'`
- Access via: `AppLocalizations.of(context).stringKey`

### Performance Best Practices
- Use const widgets where possible
- Dispose controllers and focus nodes
- Avoid building unnecessary widget trees
- Use unawaited for fire-and-forget async operations

### Accessibility (Large Text Support)
The app supports system accessibility text scaling. When adding or modifying UI elements, consider how they behave at large text sizes:

**Fixed Height Containers:**
- Avoid fixed-height containers that can't accommodate scaled text
- If fixed height is required, ensure it's generous enough (e.g., 120px instead of 80px for lists)
- Consider using `MediaQuery.textScalerOf(context).scale()` for dynamic sizing

**Text Overflow Handling:**
- Always add `overflow: TextOverflow.ellipsis` to potentially long text in constrained spaces
- Wrap secondary/optional text in `Flexible` widgets to allow shrinking
- Example pattern:
  ```dart
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('Section Title', style: textTheme.titleLarge),
      Flexible(
        child: Text(
          'View All',
          style: textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  ),
  ```

**Buttons:**
- Primary buttons use `minimumSize` property for accessibility scaling
- When creating custom buttons, consider using `ButtonFeedbackStyle.primary()` which supports `minimumSize` parameter

**AppBar Titles:**
- AppBar handles its own layout internally - don't use `Flexible` directly on title
- Use `TextOverflow.ellipsis` and `maxLines: 1` on title text instead

**Lists with Items:**
- Ensure container height can accommodate scaled text alongside fixed-size elements (avatars, icons)
- Consider adding `mainAxisSize: MainAxisSize.min` to columns to prevent overflow

### Git Hooks
- Pre-commit hook runs format, analyze, and test with coverage
- Install hooks by running `dart run git_hooks.dart`
- Coverage threshold: 95% (git_hooks.dart:14)
- Exclusions configured in git_hooks.dart (l10n, generated, main.dart, app_config.dart, app_logger.dart)

### Logging
- Use `AppLogger` for all logging (import `package:wishing_well/utils/app_logger.dart`)
- Always include context: `AppLogger.info('Message', context: 'ClassName.method')`
- Use appropriate levels: `debug()`, `info()`, `warning()`, `error()`
- For sensitive/external data, use `AppLogger.safe('Message with $data')`
- Logger is excluded from coverage as infrastructure code
- See [LOGGING.md](./LOGGING.md) for detailed patterns and best practices

## Detailed Documentation

For more detailed information, see:

- [LOGGING.md](./LOGGING.md) - Logging system, patterns, and best practices
- [ADD_COMPONENT_SCRIPT.md](./ADD_COMPONENT_SCRIPT.md) - Comprehensive component creation guide
- [COMPONENT_REGISTRY_GUIDE.md](./COMPONENT_REGISTRY_GUIDE.md) - Component demo registry system
- [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) - Detailed testing patterns and standards
