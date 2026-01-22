# AGENTS.md

This file provides guidelines for AI agents working on this Flutter/Dart codebase.

## Project Overview
Flutter app using Provider for state management, Supabase for backend, and go_router for navigation.

## Build, Lint, and Test Commands

### Essential Commands
- `flutter test` - Run entire test suite
- `flutter test test/path/to/test_file.dart` - Run a single test file
- `flutter test test/path/to/test_file.dart --name="test name"` - Run specific test by name
- `flutter test --coverage` - Run tests with coverage report
- `dart format .` - Format all Dart files
- `dart analyze --fatal-infos` - Run static analysis (fails on warnings)
- `flutter gen-l10n` - Generate localization files after modifying app_en.arb

### Coverage Reporting
- `./scripts/test_coverage.sh` - Full coverage workflow (excludes l10n, main.dart, app_config.dart)
- Pre-commit hook enforces 95% coverage threshold (see git_hooks.dart:100)

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
- Unit tests in test/unit_tests/ using standard flutter_test
- UI widget tests in test/ui_tests/
- Organize tests with group() blocks
- Use descriptive test names: `test('description', () {...})`
- Use testWidgets for widget testing with WidgetTester
- Mock repositories from testing_resources/mocks/
- Helpers in testing_resources/helpers/ (e.g., createTestWidget())
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

### Git Hooks
- Pre-commit hook runs format, analyze, and test with coverage
- Install hooks by running `dart run git_hooks.dart`
- Coverage threshold: 95% (git_hooks.dart:100)
- Exclusions in git_hooks.dart:164-170 (l10n, generated, main.dart, app_config.dart)
