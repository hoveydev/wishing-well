# Logging Standards and Guidelines

This document outlines the logging system for the Wishing Well Flutter app, including features, usage patterns, and best practices.

## Overview

The app uses a custom `AppLogger` utility built on top of the `logging` package. It provides structured, secure, and readable logging with automatic sensitive data sanitization.

### Location
- **Implementation**: `lib/utils/app_logger.dart`
- **Dependencies**: `logging: ^1.2.0` (in `pubspec.yaml`)

## Features

### 1. **Structured Log Levels**
| Level | Emoji | Use Case |
|-------|-------|----------|
| DEBUG | 🔍 | Detailed diagnostic information during development |
| INFO | 💡 | General app events (user actions, navigation, state changes) |
| WARN | ⚠️ | Potentially problematic situations that aren't errors |
| ERROR | ❌ | Error conditions that need investigation |

### 2. **Context-Aware Logging**
Include source context for easier debugging and log filtering:
```dart
AppLogger.info('User logged in', context: 'AuthRepository.login');
```

### 3. **Automatic Sensitive Data Sanitization**
The logger automatically redacts sensitive patterns:
- JWT tokens
- API keys
- Bearer tokens
- Passwords
- Secrets and private keys

### 4. **Third-Party Library Integration**
Captures and formats logs from third-party libraries (e.g., Supabase) while:
- Filtering verbose debug logs
- Sanitizing sensitive data
- Visually distinguishing from app logs

### 5. **Production Ready**
- Debug logs automatically suppressed in release builds
- Infrastructure for crash reporting integration (Sentry, Firebase Crashlytics)
- Excluded from code coverage requirements

## Log Output Format

```
HH:MM:SS 🚨 LEVEL [Context] Message
```

### Examples

```
17:25:27 💡 INFO  [AppConfig.validate] All environment variables present
17:25:27 🔍 DEBUG supabase › Initialize Supabase v2.12.0
17:25:27 ⚠️ WARN  [LoginViewModel] Login failed: Invalid email format
17:25:27 ❌ ERROR [PaymentService.processPayment] Failed to charge card
         ⚠ CardDeclinedException: Insufficient funds
         → #0 PaymentService.processPayment (package:wishing_well/...)
           #1 CheckoutScreen._handleSubmit (package:wishing_well/...)
           ... +3
```

### Format Breakdown

| Component | Description |
|-----------|-------------|
| `17:25:27` | Timestamp (HH:MM:SS) |
| `💡` | Log level emoji |
| `INFO` | Log level label |
| `[Context]` | Optional source context |
| `Message` | The log message |
| `⚠` | Error indicator (for errors) |
| `→` | App code in stack trace |
| `supabase ›` | Third-party library indicator |

## Usage

### Initialization

Initialize the logger in `main.dart` before `runApp()`:

```dart
import 'package:wishing_well/utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();
  // ... rest of initialization
  runApp(MyApp());
}
```

### Basic Logging

```dart
import 'package:wishing_well/utils/app_logger.dart';

// Debug - for development diagnostics
AppLogger.debug('Variable value: $variable', context: 'ClassName.method');

// Info - for app events
AppLogger.info('User navigated to home screen', context: 'HomeScreen');

// Warning - for potential issues
AppLogger.warning('API response took 5 seconds', context: 'ApiClient');

// Error - for failures
AppLogger.error(
  'Failed to fetch user data',
  context: 'UserRepository.fetchUser',
  error: exception,
  stackTrace: stackTrace,
);
```

### Safe Logging for Sensitive Data

Use `safe()` when logging data that might contain sensitive information:

```dart
// The message will be automatically sanitized
AppLogger.safe('API response: $responseData', context: 'ApiClient');

// Specify log level (defaults to INFO)
AppLogger.safe(
  'User input: $userInput',
  context: 'FormHandler',
  level: LogLevel.debug,
);
```

### Error Handling Pattern

```dart
try {
  final result = await someOperation();
  AppLogger.info('Operation succeeded', context: 'MyClass.operation');
} on Exception catch (e, stackTrace) {
  AppLogger.error(
    'Operation failed',
    context: 'MyClass.operation',
    error: e,
    stackTrace: stackTrace,
  );
  // Handle error...
}
```

## Security: Automatic Sanitization

The logger automatically redacts common sensitive patterns:

### What Gets Redacted

| Pattern | Example | Redacted To |
|---------|---------|-------------|
| JWT tokens | `eyJhbGciOiJIUzI1NiIs...` | `[REDACTED]` |
| API keys | `api_key=abc123...` | `api_key=[REDACTED]` |
| Bearer tokens | `Bearer xyz789...` | `Bearer [REDACTED]` |
| Passwords | `password=secret123` | `password=[REDACTED]` |
| Secrets | `secret=private_key...` | `secret=[REDACTED]` |

### When Sanitization Happens

- **All log messages** are sanitized before output
- **Error objects** are sanitized when logged
- **Third-party library logs** are sanitized (e.g., Supabase API keys)

### Best Practice

```dart
// ❌ BAD - Could expose sensitive data in the raw message
AppLogger.info('Login response: ${response.body}');

// ✅ GOOD - Use safe() for potentially sensitive data
AppLogger.safe('Login response: ${response.body}');

// ✅ BETTER - Log only what you need
AppLogger.info('User ${user.id} logged in successfully');
```

## Architecture

### Class Structure

```
AppLogger
├── init()                    # Initialize logging system
├── debug(message, context)   # Debug-level logging
├── info(message, context)    # Info-level logging
├── warning(message, context) # Warning-level logging
├── error(message, context, error, stackTrace)  # Error-level logging
├── safe(message, context, level)  # Sanitized logging
└── Private methods
    ├── _printFormattedLog()  # Format and output
    ├── _sanitize()           # Redact sensitive data
    ├── _shortenLoggerName()  # Simplify third-party names
    ├── _simplifyStackLine()  # Clean stack traces
    └── _formatTimestamp()    # Time formatting
```

### Log Flow

```
AppLogger.info('Message', context: 'Source')
    ↓
_logger.info('[Source] Message')
    ↓
logging.Logger.root.onRecord.listen()
    ↓
_SANITIZE(message)  ← Redact sensitive data
    ↓
_printFormattedLog()  ← Format with timestamp, emoji, level
    ↓
debugPrint()  ← Output to Flutter console
```

### Third-Party Log Filtering

Third-party libraries (Supabase, GoRouter, etc.) often emit verbose logs:

```dart
// Filtered out (FINEST/FINER from third-party)
if (kDebugMode &&
    record.level < logging.Level.FINE &&
    !record.loggerName.startsWith('WishingWell')) {
  return;  // Skip verbose third-party logs
}
```

## Code Coverage Exclusion

`AppLogger` is excluded from code coverage requirements as it's infrastructure, not business logic.

### Exclusion Configuration

The following files must be kept in sync:

**`git_hooks.dart`** (pre-commit hook):
```dart
const excludePatterns = [
  // ...
  'app_logger.dart', // Logging utility - infrastructure, not business logic
];
```

**`scripts/test_coverage.sh`**:
```bash
EXCLUDES=(
  # ...
  "app_logger.dart"
)
```

### Why No Tests?

1. **Infrastructure, not business logic** - Logging is a debug tool
2. **Testing side effects** - Would test Flutter's `debugPrint`, not our code
3. **Low value, high maintenance** - Tests would be brittle and catch few bugs
4. **Security is isolated** - Sanitization is a pure function, easy to test if needed

## Best Practices

### 1. Always Include Context

Context helps identify where logs originate during debugging:

```dart
// ❌ BAD - No context
AppLogger.info('User logged in');

// ✅ GOOD - Clear context
AppLogger.info('User logged in', context: 'AuthRepository.login');
```

### 2. Use Appropriate Log Levels

```dart
// DEBUG: Diagnostic info during development
AppLogger.debug('Cache hit for key: $key');

// INFO: Important app events
AppLogger.info('User completed onboarding');

// WARNING: Unexpected but recoverable situations
AppLogger.warning('Retry attempt 3 of 5 for API call');

// ERROR: Failures requiring attention
AppLogger.error('Payment processing failed', error: e);
```

### 3. Log Meaningful Information

```dart
// ❌ BAD - Not useful
AppLogger.debug('Button pressed');

// ✅ GOOD - Actionable information
AppLogger.debug('Submit button pressed, validating form', context: 'LoginForm');
```

### 4. Include Error Details

```dart
// ❌ BAD - Loses error context
try {
  await riskyOperation();
} catch (e) {
  AppLogger.error('Operation failed');
}

// ✅ GOOD - Preserves error and stack trace
try {
  await riskyOperation();
} catch (e, stackTrace) {
  AppLogger.error(
    'Operation failed',
    context: 'MyClass.riskyOperation',
    error: e,
    stackTrace: stackTrace,
  );
}
```

### 5. Use safe() for External Data

```dart
// External data might contain sensitive information
AppLogger.safe('API response: $response');
AppLogger.safe('User input: $formData');
```

## Troubleshooting

### Logs Not Appearing

1. **Check initialization** - Ensure `AppLogger.init()` is called in `main.dart`
2. **Check build mode** - Debug logs are suppressed in release builds
3. **Check log level** - Some levels might be filtered

### Sensitive Data Still Appearing

1. **Use `safe()`** for external/untrusted data
2. **Report the pattern** - Add new regex patterns to `_sanitize()` if needed
3. **Check raw data** - Some patterns might not match the sanitization regex

### Too Many Third-Party Logs

Third-party verbose logs are automatically filtered. If you need more control:

```dart
// In AppLogger.init(), adjust the filter:
if (kDebugMode &&
    record.level < logging.Level.FINE &&  // Adjust this threshold
    !record.loggerName.startsWith('WishingWell')) {
  return;
}
```

### Colors Not Working

ANSI color codes are stripped by Flutter's `flutter run` tooling. This is a limitation of Flutter's development environment, not the logger. The emoji-based visual indicators work in all environments.

## Future Enhancements

### Planned Features

1. **File Logging** - Write logs to a file for later analysis
2. **Crash Reporting** - Integration with Sentry or Firebase Crashlytics
3. **Log Buffering** - Buffer recent logs for crash context
4. **Remote Logging** - Send logs to a remote service in production

### Adding Crash Reporting

Uncomment and configure in `app_logger.dart`:

```dart
// In production builds, send severe logs to crash reporting
if (record.level >= logging.Level.SEVERE && !kDebugMode) {
  // Sentry.captureException(
  //   record.error ?? Exception(record.message),
  //   stackTrace: record.stackTrace,
  // );
}
```

## Related Documentation

- [AGENTS.md](./AGENTS.md) - General project guidelines
- [TESTING_STANDARDS.md](./TESTING_STANDARDS.md) - Testing patterns
- `git_hooks.dart` - Coverage exclusion configuration
- `scripts/test_coverage.sh` - Coverage reporting script
