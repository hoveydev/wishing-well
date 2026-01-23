# WishingWell

A Flutter application for managing wishes and goals with a clean, testable architecture.

## Architecture Overview

WishingWell follows the **MVVM (Model-View-ViewModel)** architecture pattern with clear separation of concerns:

### Architecture Layers

1. **Presentation Layer (UI)**
   - Screens: Flutter widgets that display UI and receive ViewModels via constructor injection
   - Components: Reusable UI widgets organized by type (button, input, spacer, etc.)
   - No business logic - purely UI presentation

2. **View Model Layer**
   - Extends `ChangeNotifier` for reactive state management
   - Implements a Contract interface for clear API definition
   - Manages state, validation, and user interactions
   - Communicates with repositories for data operations

3. **Data Layer**
   - **Repository Pattern**: Abstract repository interfaces define data contracts
   - Concrete implementations (e.g., `AuthRepositoryRemote`) handle API calls
   - Uses sealed `Result<T>` class for type-safe operation outcomes
   - Clean separation between data access and business logic

### Key Patterns

- **Dependency Injection**: Provider pattern configured in `lib/config/dependencies.dart`
- **Error Handling**: Sealed classes (`AuthError<T>`, `Result<T>`) for type-safe errors
- **State Management**: Provider with ChangeNotifier pattern
- **Navigation**: go_router for declarative routing
- **Localization**: flutter_localizations with ARB files

### Project Structure

```
lib/
├── components/          # Reusable UI components
│   ├── button/         # Button components (primary, icon, label)
│   ├── input/          # Input field components
│   ├── spacer/         # Spacing components
│   └── screen/         # Screen wrapper components
├── config/             # Dependency injection and app configuration
│   └── dependencies.dart
├── data/              # Data layer
│   └── repositories/   # Repository implementations
│       └── auth/       # Authentication repository
├── l10n/              # Localization files
├── routing/            # Navigation configuration
│   └── routes.dart    # Route definitions
├── screens/           # Screen widgets and ViewModels
│   ├── login/
│   ├── create_account/
│   ├── forgot_password/
│   └── ...
└── utils/             # Utility classes
    ├── app_config.dart       # Environment configuration
    ├── auth_error.dart      # Error sealed classes
    ├── input_validators.dart # Validation utilities
    ├── password_validator.dart # Password validation
    ├── loading_controller.dart # Loading overlay controller
    └── result.dart         # Result sealed class

test/
├── ui_tests/          # Widget tests
├── unit_tests/        # Unit tests
└── testing_resources/ # Test helpers and mocks
    ├── helpers/       # Test utility functions
    └── mocks/         # Mock implementations
```

## Development Setup

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Supabase account (for backend)

### Installation

1. Clone the repository
2. Install dependencies:
   ```console
   $ flutter pub get
   ```

3. Set up environment variables:
   - Copy `.env.development` or `.env.test` to configure your environment
   - Required variables: `SUPABASE_URL`, `SUPABASE_SECRET`, `ACCOUNT_CONFIRM_URL`, `PASSWORD_RESET_URL`

4. Run the app:
   ```console
   $ flutter run
   ```

## Helpful Commands

### Localized Strings

This project uses the `flutter_localizations` package for app localizations and requires a couple easy steps to add and generate new strings.

1. Add your string variable and value to `lib/l10n/app_en.arb`
2. Add a property object using the `@` keyword followed by the variable defined
3. That object should contain a `description` property where you should define the purpose and use of the string
4. Run `flutter gen-l10n` to generate the necessary localization files*
```console
$ flutter gen-l10n
```

**you will be unable to use the new localization variable without running this script*

### UI/Unit Testing

Run the full test suite with coverage and generate an HTML report using the convenience script:

```console
$ ./scripts/test_coverage.sh
```

This script automatically:
- Runs all tests with coverage enabled
- Excludes generated files (l10n, app_config.dart, main.dart) from coverage
- Generates an HTML coverage report
- Opens the report in your default browser

Coverage thresholds and exclusions can be configured in `git_hooks.dart`.

### Code Quality

Check code formatting and run static analysis:

```console
# Format all Dart files
$ dart format .

# Run static analysis (fails on warnings)
$ dart analyze --fatal-infos
```

These checks also run automatically on every commit via pre-commit hook.

Install git hooks:
```console
$ dart run git_hooks.dart
```

### Test Status

All tests are passing after the comprehensive code review changes! The test suite includes:

- **Unit Tests**: 36 test files covering business logic, ViewModels, utilities, and repositories
- **Widget Tests**: 23 test files covering UI components and screens
- **Test Coverage**: 95%+ coverage maintained with comprehensive test suite
- **Password Validator Tests**: New test file added for the shared `PasswordValidator<T>` utility

**Fixes Applied**:
- Added `AppConfig.initialize()` to test setup for `AuthRepositoryRemote` tests
- Fixed directory rename from `respositories/` to `repositories/` across all imports

These checks also run automatically on every commit via the pre-commit hook.

Install git hooks:
```console
$ dart run git_hooks.dart
```

## Testing

The project maintains **95%+ test coverage** with comprehensive unit and widget tests.

### Test Organization
- **Unit Tests**: Test business logic, ViewModels, and utilities in `test/unit_tests/`
- **Widget Tests**: Test UI components and screens in `test/ui_tests/`
- **Test Helpers**: Reusable test utilities in `testing_resources/`

### Mocking
- Use `MockAuthRepository` for repository testing
- Test helpers provide `createTestWidget()` for widget test setup
- All dependencies mocked for isolated testing

## Code Style

The project enforces strict code style through:
- **lint**: `dart analyze --fatal-infos` (fails on warnings)
- **format**: `dart format .` (auto-formats on commit)
- **const constructors**: Used extensively for performance
- **Single quotes**: Enforced for all strings
- **80 character line limit**: Enforced by linter

See `analysis_options.yaml` for complete lint rules.

## Contributing

1. Follow the established MVVM architecture pattern
2. Add tests for new features (maintain 95%+ coverage)
3. Use package imports (never relative imports)
4. Run pre-commit checks before pushing
5. Follow the naming conventions outlined in AGENTS.md

## Deployment

### Build for iOS
```console
$ flutter build ios
```

### Build for Android
```console
$ flutter build apk
# or
$ flutter build appbundle
```

## License

[Add your license here]
